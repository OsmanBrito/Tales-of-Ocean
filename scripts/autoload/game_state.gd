extends Node

signal state_changed
signal inventory_changed
signal quest_updated(quest_id: String, status: String)

const COMPANIONS_PATH := "res://data/companions.json"
const ITEMS_PATH := "res://data/items.json"
const SKILLS_PATH := "res://data/skills.json"
const PASSIVES_PATH := "res://data/passives.json"
const ENEMIES_PATH := "res://data/enemies.json"
const QUESTS_PATH := "res://data/quests.json"
const ACTIVE_SKILL_LIMIT: int = 10
const PASSIVE_SKILL_LIMIT: int = 10
const PORTUGAL_MAP_SCENE := "res://scenes/world/portugal_map.tscn"

var companion_defs: Dictionary = {}
var item_defs: Dictionary = {}
var skill_defs: Dictionary = {}
var passive_defs: Dictionary = {}
var enemy_defs: Dictionary = {}
var quest_defs: Dictionary = {}

var party: Dictionary = {}
var party_order: Array = []
var inventory: Array = []
var gold: int = 0
var quest_states: Dictionary = {}
var world_state: Dictionary = {}
var current_battle_context: Dictionary = {}
var last_battle_outcome: String = ""


func _ready() -> void:
	load_static_data()
	reset_new_game()


func load_static_data() -> void:
	companion_defs = _load_table(COMPANIONS_PATH)
	item_defs = _load_table(ITEMS_PATH)
	skill_defs = _load_table(SKILLS_PATH)
	passive_defs = _load_table(PASSIVES_PATH)
	enemy_defs = _load_table(ENEMIES_PATH)
	quest_defs = _load_table(QUESTS_PATH)


func reset_new_game() -> void:
	party = {"pembah": _build_pembah()}
	party_order = ["pembah"]
	inventory = [
		{"id": "health_potion", "quantity": 2},
		{"id": "battle_bread", "quantity": 3},
		{"id": "spirit_elixir", "quantity": 1}
	]
	gold = 75
	quest_states = {
		"first_voyage": "not_started",
		"porto_alliance": "not_started",
		"luz_de_sagres": "not_started",
		"roda_de_tomar": "not_started",
		"porta_de_ceuta": "not_started",
		"terra_de_vera_cruz": "not_started"
	}
	world_state = {
		"current_scene": "res://scenes/world/lisboa.tscn",
		"scene_positions": {
			"lisboa": {"x": 240.0, "y": 520.0},
			"porto": {"x": 300.0, "y": 640.0},
			"sagres": {"x": 280.0, "y": 640.0},
			"tomar": {"x": 880.0, "y": 760.0},
			"ceuta": {"x": 320.0, "y": 710.0},
			"ilha_bruma": {"x": 860.0, "y": 520.0},
			"ilha_sargaco": {"x": 860.0, "y": 520.0},
			"terra_vera_cruz": {"x": 860.0, "y": 520.0}
		},
		"ocean_state": _build_default_ocean_state(),
		"overworld_current_node_id": "lisboa",
		"overworld_origin_scene": "res://scenes/world/lisboa.tscn",
		"overworld_travel_state": {},
		"pending_scene_spawns": {},
		"battle_tutorial_seen": false,
		"bandit_defeated": false,
		"lisboa_boss_defeated": false,
		"captain_dialogue_seen": false,
		"porto_duelist_defeated": false,
		"porto_mourisco_defeated": false,
		"porto_boss_defeated": false,
		"joao_recruited": false,
		"sagres_corsair_defeated": false,
		"sagres_bombard_defeated": false,
		"sagres_boss_defeated": false,
		"tomar_claustro_purged": false,
		"tomar_nabao_purged": false,
		"tomar_boss_defeated": false,
		"ceuta_marina_secured": false,
		"ceuta_alcacova_secured": false,
		"ceuta_boss_defeated": false,
		"vera_cruz_boss_defeated": false
	}
	current_battle_context = {}
	last_battle_outcome = ""
	_emit_all()


func load_json_data(path: String) -> Variant:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Could not read data file: %s" % path)
		return null

	return JSON.parse_string(file.get_as_text())


func _load_table(path: String) -> Dictionary:
	var parsed: Variant = load_json_data(path)
	if typeof(parsed) != TYPE_ARRAY:
		push_error("Expected array in %s" % path)
		return {}

	var table: Dictionary = {}
	for entry in parsed:
		table[entry["id"]] = entry
	return table


func get_player() -> Dictionary:
	return party["pembah"]


func _build_pembah() -> Dictionary:
	var player: Dictionary = {
		"id": "pembah",
		"name": "Pembah",
		"role": "Navegador",
		"level": 1,
		"xp": 0,
		"base_max_hp": 120,
		"max_hp": 120,
		"hp": 120,
		"base_max_sp": 40,
		"max_sp": 40,
		"sp": 40,
		"base_atk": 18,
		"atk": 18,
		"base_def": 8,
		"def": 8,
		"base_spd": 10,
		"spd": 10,
		"base_move_range": 2,
		"move_range": 2,
		"base_attack_range": 1,
		"attack_range": 1,
		"water_stride": true,
		"defending": false,
		"schools_mastered": [
			"Escola da Barra de Lisboa"
		],
		"learned_skills": [
			"golpe_navegante"
		],
		"equipped_skills": [
			"golpe_navegante",
		],
		"learned_passives": [],
		"equipped_passives": [],
		"skills": [
			"golpe_navegante"
		]
	}
	player["passives"] = []
	return _recalculate_player_stats(player, false)


func get_active_skill_limit() -> int:
	return ACTIVE_SKILL_LIMIT


func get_passive_skill_limit() -> int:
	return PASSIVE_SKILL_LIMIT


func get_player_xp_progress() -> Dictionary:
	var player: Dictionary = get_player()
	var level: int = int(player.get("level", 1))
	var current_floor: int = _xp_required_for_level(level)
	var next_goal: int = _xp_required_for_level(level + 1)
	var total_xp: int = int(player.get("xp", 0))
	return {
		"current": total_xp - current_floor,
		"needed": next_goal - current_floor,
		"total": total_xp
	}


func get_player_known_schools() -> Array[String]:
	var schools: Array[String] = []
	for raw_school in get_player().get("schools_mastered", []):
		schools.append(str(raw_school))
	return schools


func get_player_learned_skills() -> Array[String]:
	var skills: Array[String] = []
	for raw_skill_id in get_player().get("learned_skills", []):
		skills.append(str(raw_skill_id))
	return skills


func get_player_equipped_skills() -> Array[String]:
	var skills: Array[String] = []
	for raw_skill_id in get_player().get("equipped_skills", []):
		skills.append(str(raw_skill_id))
	return skills


func get_member_xp_progress(member_id: String) -> Dictionary:
	if member_id == "pembah":
		return get_player_xp_progress()
	var member: Dictionary = get_companion(member_id)
	if member.is_empty():
		return {"current": 0, "needed": 0, "total": 0}
	var level: int = int(member.get("level", 1))
	var current_floor: int = _xp_required_for_level(level)
	var next_goal: int = _xp_required_for_level(level + 1)
	var total_xp: int = int(member.get("xp", 0))
	return {
		"current": total_xp - current_floor,
		"needed": next_goal - current_floor,
		"total": total_xp
	}


func get_member_learned_skills(member_id: String) -> Array[String]:
	if member_id == "pembah":
		return get_player_learned_skills()
	var member: Dictionary = get_companion(member_id)
	return _to_string_array(member.get("learned_skills", member.get("skills", [])))


func get_member_equipped_skills(member_id: String) -> Array[String]:
	if member_id == "pembah":
		return get_player_equipped_skills()
	var member: Dictionary = get_companion(member_id)
	return _to_string_array(member.get("equipped_skills", member.get("skills", [])))


func get_player_learned_passives() -> Array[String]:
	var passives: Array[String] = []
	for raw_passive_id in get_player().get("learned_passives", []):
		passives.append(str(raw_passive_id))
	return passives


func get_player_equipped_passives() -> Array[String]:
	var passives: Array[String] = []
	for raw_passive_id in get_player().get("equipped_passives", []):
		passives.append(str(raw_passive_id))
	return passives


func get_item_quantity(item_id: String) -> int:
	for raw_stack in inventory:
		var stack: Dictionary = raw_stack
		if stack.get("id", "") == item_id:
			return int(stack.get("quantity", 0))
	return 0


func can_buy_item(item_id: String, price: int, quantity: int = 1) -> Dictionary:
	var item: Dictionary = item_defs.get(item_id, {})
	if item.is_empty():
		return {"ok": false, "reason": "Esse artigo nao consta de qualquer armazem."}
	if quantity <= 0:
		return {"ok": false, "reason": "A quantidade pedida nao tem valia."}

	var total_price: int = max(0, price) * quantity
	if gold < total_price:
		return {"ok": false, "reason": "Faltam-vos %d de oiro." % (total_price - gold)}

	var item_type: String = str(item.get("type", ""))
	if item_type == "manual_skill":
		var skill_id: String = str(item.get("teach_skill", ""))
		if get_player_learned_skills().has(skill_id):
			return {"ok": false, "reason": "Pembah ja conhece essa arte."}
		if get_item_quantity(item_id) > 0:
			return {"ok": false, "reason": "Ja tendes esse manual no bornal."}
	elif item_type == "manual_passive":
		var passive_id: String = str(item.get("teach_passive", ""))
		if get_player_learned_passives().has(passive_id):
			return {"ok": false, "reason": "Pembah ja assimilou essa passiva."}
		if get_item_quantity(item_id) > 0:
			return {"ok": false, "reason": "Ja tendes esse manual no bornal."}
	elif item_type == "ocean_supply":
		var ocean: Dictionary = _ensure_ocean_state()
		if int(ocean.get("supplies", 0)) >= int(ocean.get("supplies_max", 0)):
			return {"ok": false, "reason": "Os poroes ja estao bem abastecidos."}
	elif item_type == "ocean_repair":
		var ocean: Dictionary = _ensure_ocean_state()
		if int(ocean.get("ship", 0)) >= int(ocean.get("ship_max", 0)):
			return {"ok": false, "reason": "O casco ja esta firme e seguro."}

	return {"ok": true, "reason": "Podeis comprar %s." % item.get("name", item_id)}


func buy_item(item_id: String, price: int, quantity: int = 1) -> Dictionary:
	var check: Dictionary = can_buy_item(item_id, price, quantity)
	if not bool(check.get("ok", false)):
		return check

	var item: Dictionary = item_defs.get(item_id, {})
	var total_price: int = max(0, price) * quantity
	var item_type: String = str(item.get("type", ""))
	if item_type == "ocean_supply" or item_type == "ocean_repair":
		var ocean: Dictionary = _ensure_ocean_state()
		if item_type == "ocean_supply":
			var gain: int = int(item.get("supplies_gain", 0)) * quantity
			var supplies_max: int = int(ocean.get("supplies_max", 0))
			ocean["supplies"] = min(supplies_max, int(ocean.get("supplies", 0)) + gain)
			ocean["last_event"] = "Mantimentos renovados em terra."
			_set_ocean_state(ocean)
			gold -= total_price
			state_changed.emit()
			return {"ok": true, "reason": "Reabastecestes a nau por %d de oiro." % total_price}
		if item_type == "ocean_repair":
			var repair: int = int(item.get("ship_gain", 0)) * quantity
			var ship_max: int = int(ocean.get("ship_max", 0))
			ocean["ship"] = min(ship_max, int(ocean.get("ship", 0)) + repair)
			ocean["last_event"] = "Calafeto e madeira firme reforcam o casco."
			_set_ocean_state(ocean)
			gold -= total_price
			state_changed.emit()
			return {"ok": true, "reason": "Reparastes o casco por %d de oiro." % total_price}

	gold -= total_price
	add_item(item_id, quantity)
	state_changed.emit()
	return {"ok": true, "reason": "Comprastes %s por %d de oiro." % [item.get("name", item_id), total_price]}


func get_service_name(service_id: String) -> String:
	match service_id:
		"rest_house":
			return "Ceia e Descanso"
		"rest_hearty":
			return "Mesa Farta"
		"refill_supplies":
			return "Reabastecer Mantimentos"
		"repair_ship":
			return "Reparar Casco"
		"full_refit":
			return "Refazer Nau e Provisoes"
		_:
			return service_id.capitalize()


func can_use_service(service_id: String, price: int) -> Dictionary:
	if price < 0:
		return {"ok": false, "reason": "Esse servico traz conta mal escrita."}
	if gold < price:
		return {"ok": false, "reason": "Faltam-vos %d de oiro." % (price - gold)}

	var ocean: Dictionary = _ensure_ocean_state()
	match service_id:
		"rest_house", "rest_hearty":
			var everyone_ready: bool = true
			for member_id in party_order:
				if not party.has(member_id):
					continue
				var member: Dictionary = party[member_id]
				if int(member.get("hp", 0)) < int(member.get("max_hp", 0)) or int(member.get("sp", 0)) < int(member.get("max_sp", 0)):
					everyone_ready = false
					break
			if everyone_ready:
				return {"ok": false, "reason": "A companhia ja descansa em boa forma."}
		"refill_supplies":
			if int(ocean.get("supplies", 0)) >= int(ocean.get("supplies_max", 0)):
				return {"ok": false, "reason": "Os poroes ja vao cheios."}
		"repair_ship":
			if int(ocean.get("ship", 0)) >= int(ocean.get("ship_max", 0)):
				return {"ok": false, "reason": "O casco ja se acha firme."}
		"full_refit":
			if int(ocean.get("ship", 0)) >= int(ocean.get("ship_max", 0)) and int(ocean.get("supplies", 0)) >= int(ocean.get("supplies_max", 0)):
				return {"ok": false, "reason": "Nada ha que refazer na nau."}
		_:
			return {"ok": false, "reason": "Ninguem na cidade presta esse servico."}

	return {"ok": true, "reason": "Podeis pagar %s." % get_service_name(service_id)}


func use_service(service_id: String, price: int) -> Dictionary:
	var check: Dictionary = can_use_service(service_id, price)
	if not bool(check.get("ok", false)):
		return check

	var ocean: Dictionary = _ensure_ocean_state()
	gold -= price
	match service_id:
		"rest_house":
			heal_party(9999, 9999)
			return {"ok": true, "reason": "Ceastes e dormistes sob tecto seguro. A companhia amanhece refeita."}
		"rest_hearty":
			heal_party(9999, 9999)
			var player: Dictionary = get_player()
			player["hp"] = min(int(player.get("max_hp", 0)), int(player.get("hp", 0)) + 8)
			party["pembah"] = player
			state_changed.emit()
			return {"ok": true, "reason": "A mesa foi generosa e o espirito torna-se mais leve."}
		"refill_supplies":
			ocean["supplies"] = int(ocean.get("supplies_max", 100))
			ocean["last_event"] = "Mantimentos tomados em terra."
			_set_ocean_state(ocean)
			state_changed.emit()
			return {"ok": true, "reason": "Os poroes vao cheios e a nau pode tornar ao largo."}
		"repair_ship":
			ocean["ship"] = int(ocean.get("ship_max", 100))
			ocean["last_event"] = "Calafates e carpinteiros deixaram o casco como novo."
			_set_ocean_state(ocean)
			state_changed.emit()
			return {"ok": true, "reason": "O casco foi reforcado de proa a popa."}
		"full_refit":
			ocean["ship"] = int(ocean.get("ship_max", 100))
			ocean["supplies"] = int(ocean.get("supplies_max", 100))
			ocean["last_event"] = "A nau sai do estaleiro refeita e bem provida."
			_set_ocean_state(ocean)
			state_changed.emit()
			return {"ok": true, "reason": "A nau foi refeita e reabastecida por inteiro."}
		_:
			return {"ok": false, "reason": "Esse servico esfumou-se antes da conta."}


func can_learn_manual(item_id: String) -> Dictionary:
	var item: Dictionary = item_defs.get(item_id, {})
	if item.is_empty():
		return {"ok": false, "reason": "Esse volume nao existe no bornal."}

	var item_type: String = str(item.get("type", ""))
	if item_type != "manual_skill" and item_type != "manual_passive":
		return {"ok": false, "reason": "Esse objecto nao ensina qualquer doutrina."}
	if get_item_quantity(item_id) <= 0:
		return {"ok": false, "reason": "Nao tendes esse manual em vosso poder."}

	var player: Dictionary = get_player()
	var min_level: int = int(item.get("min_level", 1))
	if int(player.get("level", 1)) < min_level:
		return {"ok": false, "reason": "Pembah deve chegar a Nv.%d para estudar este volume." % min_level}

	if item_type == "manual_skill":
		var skill_id: String = str(item.get("teach_skill", ""))
		if get_player_learned_skills().has(skill_id):
			return {"ok": false, "reason": "Essa arte ja foi aprendida."}
	else:
		var passive_id: String = str(item.get("teach_passive", ""))
		if get_player_learned_passives().has(passive_id):
			return {"ok": false, "reason": "Essa passiva ja foi assimilada."}

	return {"ok": true, "reason": "Podeis estudar este volume."}


func learn_manual(item_id: String) -> Dictionary:
	var check: Dictionary = can_learn_manual(item_id)
	if not bool(check.get("ok", false)):
		return check

	var item: Dictionary = item_defs.get(item_id, {})
	var player: Dictionary = get_player()
	var school_name: String = str(item.get("school", ""))
	var auto_equipped: bool = false
	var learned_name: String = item.get("name", "Manual")

	if str(item.get("type", "")) == "manual_skill":
		var skill_id: String = str(item.get("teach_skill", ""))
		var learned_skills: Array[String] = get_player_learned_skills()
		learned_skills.append(skill_id)
		player["learned_skills"] = learned_skills
		learned_name = skill_defs.get(skill_id, {}).get("name", learned_name)

		var equipped_skills: Array[String] = get_player_equipped_skills()
		if equipped_skills.size() < ACTIVE_SKILL_LIMIT:
			equipped_skills.append(skill_id)
			player["equipped_skills"] = equipped_skills
			player["skills"] = equipped_skills.duplicate(true)
			auto_equipped = true
	else:
		var passive_id: String = str(item.get("teach_passive", ""))
		var learned_passives: Array[String] = get_player_learned_passives()
		learned_passives.append(passive_id)
		player["learned_passives"] = learned_passives
		learned_name = passive_defs.get(passive_id, {}).get("name", learned_name)

		var equipped_passives: Array[String] = get_player_equipped_passives()
		if equipped_passives.size() < PASSIVE_SKILL_LIMIT:
			equipped_passives.append(passive_id)
			player["equipped_passives"] = equipped_passives
			auto_equipped = true

	if not school_name.is_empty():
		var schools: Array[String] = []
		for raw_school in player.get("schools_mastered", []):
			schools.append(str(raw_school))
		if not schools.has(school_name):
			schools.append(school_name)
		player["schools_mastered"] = schools

	consume_item(item_id)
	player = _normalize_player_data(player)
	party["pembah"] = player
	state_changed.emit()

	var message: String = "Pembah aprende %s." % learned_name
	if auto_equipped:
		message += " Fica desde logo aparelhada."
	else:
		message += " Podeis equipa-la no ecra de Personagem."
	return {"ok": true, "reason": message}


func toggle_player_skill_equip(skill_id: String) -> Dictionary:
	var learned_skills: Array[String] = get_player_learned_skills()
	if not learned_skills.has(skill_id):
		return {"ok": false, "reason": "Essa arte ainda nao foi aprendida."}

	var player: Dictionary = get_player()
	var equipped_skills: Array[String] = get_player_equipped_skills()
	var skill_name: String = skill_defs.get(skill_id, {}).get("name", skill_id)
	if equipped_skills.has(skill_id):
		equipped_skills.erase(skill_id)
		player["equipped_skills"] = equipped_skills
		player["skills"] = equipped_skills.duplicate(true)
		party["pembah"] = _normalize_player_data(player)
		state_changed.emit()
		return {"ok": true, "reason": "%s foi retirada da aparelhagem de combate." % skill_name}

	if equipped_skills.size() >= ACTIVE_SKILL_LIMIT:
		return {"ok": false, "reason": "Ja equipastes %d artes." % ACTIVE_SKILL_LIMIT}

	equipped_skills.append(skill_id)
	player["equipped_skills"] = equipped_skills
	player["skills"] = equipped_skills.duplicate(true)
	party["pembah"] = _normalize_player_data(player)
	state_changed.emit()
	return {"ok": true, "reason": "%s foi aparelhada para o combate." % skill_name}


func toggle_player_passive_equip(passive_id: String) -> Dictionary:
	var learned_passives: Array[String] = get_player_learned_passives()
	if not learned_passives.has(passive_id):
		return {"ok": false, "reason": "Essa passiva ainda nao foi aprendida."}

	var player: Dictionary = get_player()
	var equipped_passives: Array[String] = get_player_equipped_passives()
	var passive_name: String = passive_defs.get(passive_id, {}).get("name", passive_id)
	if equipped_passives.has(passive_id):
		equipped_passives.erase(passive_id)
		player["equipped_passives"] = equipped_passives
		party["pembah"] = _normalize_player_data(player)
		state_changed.emit()
		return {"ok": true, "reason": "%s deixa de guiar o vosso rumo." % passive_name}

	if equipped_passives.size() >= PASSIVE_SKILL_LIMIT:
		return {"ok": false, "reason": "Ja equipastes %d passivas." % PASSIVE_SKILL_LIMIT}

	equipped_passives.append(passive_id)
	player["equipped_passives"] = equipped_passives
	party["pembah"] = _normalize_player_data(player)
	state_changed.emit()
	return {"ok": true, "reason": "%s passa a guiar Pembah." % passive_name}


func toggle_member_skill_equip(member_id: String, skill_id: String) -> Dictionary:
	if member_id == "pembah":
		return toggle_player_skill_equip(skill_id)

	var companion: Dictionary = get_companion(member_id)
	if companion.is_empty():
		return {"ok": false, "reason": "Nao ha companheiro para aparelhar."}

	var companion_name: String = str(companion.get("name", member_id))
	var learned_skills: Array[String] = _to_string_array(companion.get("learned_skills", companion.get("skills", [])))
	if not learned_skills.has(skill_id):
		return {"ok": false, "reason": "%s nao conhece essa arte." % companion_name}

	var equipped_skills: Array[String] = _to_string_array(companion.get("equipped_skills", companion.get("skills", [])))
	var skill_name: String = str(skill_defs.get(skill_id, {}).get("name", skill_id))
	if equipped_skills.has(skill_id):
		equipped_skills.erase(skill_id)
		companion["equipped_skills"] = equipped_skills
		companion["skills"] = equipped_skills.duplicate(true)
		party[member_id] = companion
		state_changed.emit()
		return {"ok": true, "reason": "%s baixa %s." % [companion_name, skill_name]}

	if equipped_skills.size() >= ACTIVE_SKILL_LIMIT:
		return {"ok": false, "reason": "%s nao pode levar mais artes." % companion_name}

	equipped_skills.append(skill_id)
	companion["equipped_skills"] = equipped_skills
	companion["skills"] = equipped_skills.duplicate(true)
	party[member_id] = companion
	state_changed.emit()
	return {"ok": true, "reason": "%s passa a levar %s." % [companion_name, skill_name]}


func award_player_xp(amount: int) -> void:
	if amount <= 0:
		return

	var player: Dictionary = get_player()
	player["xp"] = int(player.get("xp", 0)) + amount
	party["pembah"] = _normalize_player_data(player)


func _xp_required_for_level(level: int) -> int:
	if level <= 1:
		return 0

	var total: int = 0
	for current_level in range(1, level):
		total += 80 + current_level * 40
	return total


func _level_for_xp(xp_amount: int) -> int:
	var level: int = 1
	while xp_amount >= _xp_required_for_level(level + 1):
		level += 1
	return level


func _sum_passive_bonuses(passive_ids: Array[String]) -> Dictionary:
	var bonuses: Dictionary = {
		"max_hp": 0,
		"max_sp": 0,
		"atk": 0,
		"def": 0,
		"spd": 0,
		"move_range": 0,
		"attack_range": 0
	}
	for passive_id in passive_ids:
		var passive: Dictionary = passive_defs.get(passive_id, {})
		var passive_bonuses: Dictionary = passive.get("bonuses", {})
		for bonus_name in passive_bonuses.keys():
			bonuses[bonus_name] = int(bonuses.get(bonus_name, 0)) + int(passive_bonuses[bonus_name])
	return bonuses


func _normalize_player_data(player: Dictionary) -> Dictionary:
	var template: Dictionary = _build_pembah()
	for key in template.keys():
		if not player.has(key):
			player[key] = template[key]

	if not player.has("learned_skills"):
		player["learned_skills"] = player.get("skills", template.get("learned_skills", [])).duplicate(true)
	if not player.has("equipped_skills"):
		player["equipped_skills"] = player.get("skills", template.get("equipped_skills", [])).duplicate(true)
	if not player.has("learned_passives"):
		player["learned_passives"] = []
	if not player.has("equipped_passives"):
		player["equipped_passives"] = []
	if not player.has("schools_mastered"):
		player["schools_mastered"] = template.get("schools_mastered", []).duplicate(true)

	var learned_skills: Array[String] = []
	for raw_skill_id in player.get("learned_skills", []):
		var skill_id: String = str(raw_skill_id)
		if not skill_id.is_empty() and not learned_skills.has(skill_id):
			learned_skills.append(skill_id)
	for raw_skill_id in player.get("skills", []):
		var skill_id: String = str(raw_skill_id)
		if not skill_id.is_empty() and not learned_skills.has(skill_id):
			learned_skills.append(skill_id)
	player["learned_skills"] = learned_skills

	var equipped_skills: Array[String] = []
	for raw_skill_id in player.get("equipped_skills", []):
		var skill_id: String = str(raw_skill_id)
		if learned_skills.has(skill_id) and not equipped_skills.has(skill_id):
			equipped_skills.append(skill_id)
	if equipped_skills.is_empty():
		for skill_id in learned_skills:
			if equipped_skills.size() >= ACTIVE_SKILL_LIMIT:
				break
			equipped_skills.append(skill_id)
	player["equipped_skills"] = equipped_skills.slice(0, ACTIVE_SKILL_LIMIT)
	player["skills"] = player["equipped_skills"].duplicate(true)

	var learned_passives: Array[String] = []
	for raw_passive_id in player.get("learned_passives", []):
		var passive_id: String = str(raw_passive_id)
		if not passive_id.is_empty() and not learned_passives.has(passive_id):
			learned_passives.append(passive_id)
	player["learned_passives"] = learned_passives

	var equipped_passives: Array[String] = []
	for raw_passive_id in player.get("equipped_passives", []):
		var passive_id: String = str(raw_passive_id)
		if learned_passives.has(passive_id) and not equipped_passives.has(passive_id):
			equipped_passives.append(passive_id)
	player["equipped_passives"] = equipped_passives.slice(0, PASSIVE_SKILL_LIMIT)
	player["passives"] = player["equipped_passives"].duplicate(true)

	var schools_mastered: Array[String] = []
	for raw_school in player.get("schools_mastered", []):
		var school_name: String = str(raw_school)
		if not school_name.is_empty() and not schools_mastered.has(school_name):
			schools_mastered.append(school_name)
	player["schools_mastered"] = schools_mastered

	return _recalculate_player_stats(player, true)


func _normalize_companion_data(companion: Dictionary) -> Dictionary:
	var learned_skills: Array[String] = _to_string_array(companion.get("learned_skills", companion.get("skills", [])))
	if learned_skills.is_empty():
		learned_skills = _to_string_array(companion.get("skills", []))
	companion["learned_skills"] = learned_skills

	var equipped_skills: Array[String] = _to_string_array(companion.get("equipped_skills", companion.get("skills", [])))
	if equipped_skills.is_empty():
		equipped_skills = learned_skills.duplicate(true)
	else:
		var filtered: Array[String] = []
		for skill_id in equipped_skills:
			if learned_skills.has(skill_id) and not filtered.has(skill_id):
				filtered.append(skill_id)
		equipped_skills = filtered

	companion["equipped_skills"] = equipped_skills.slice(0, ACTIVE_SKILL_LIMIT)
	companion["skills"] = companion["equipped_skills"].duplicate(true)
	companion["defending"] = companion.get("defending", false)
	return companion


func _recalculate_player_stats(player: Dictionary, preserve_progress: bool) -> Dictionary:
	var previous_max_hp: int = int(player.get("max_hp", player.get("base_max_hp", 120)))
	var previous_max_sp: int = int(player.get("max_sp", player.get("base_max_sp", 40)))
	var previous_hp: int = int(player.get("hp", previous_max_hp))
	var previous_sp: int = int(player.get("sp", previous_max_sp))

	var level: int = _level_for_xp(int(player.get("xp", 0)))
	player["level"] = level

	var passive_bonuses: Dictionary = _sum_passive_bonuses(_to_string_array(player.get("equipped_passives", [])))
	var level_step: int = max(0, level - 1)
	player["max_hp"] = int(player.get("base_max_hp", 120)) + level_step * 14 + int(passive_bonuses.get("max_hp", 0))
	player["max_sp"] = int(player.get("base_max_sp", 40)) + level_step * 6 + int(passive_bonuses.get("max_sp", 0))
	player["atk"] = int(player.get("base_atk", 18)) + level_step * 2 + int(passive_bonuses.get("atk", 0))
	player["def"] = int(player.get("base_def", 8)) + int(floor(level_step / 2.0)) + int(passive_bonuses.get("def", 0))
	player["spd"] = int(player.get("base_spd", 10)) + int(floor(level_step / 3.0)) + int(passive_bonuses.get("spd", 0))
	player["move_range"] = int(player.get("base_move_range", 2)) + int(passive_bonuses.get("move_range", 0))
	player["attack_range"] = int(player.get("base_attack_range", 1)) + int(passive_bonuses.get("attack_range", 0))

	if preserve_progress:
		player["hp"] = clampi(previous_hp + max(0, player["max_hp"] - previous_max_hp), 0, player["max_hp"])
		player["sp"] = clampi(previous_sp + max(0, player["max_sp"] - previous_max_sp), 0, player["max_sp"])
	else:
		player["hp"] = player["max_hp"]
		player["sp"] = player["max_sp"]

	return player


func _to_string_array(raw_values: Variant) -> Array[String]:
	var values: Array[String] = []
	if typeof(raw_values) != TYPE_ARRAY:
		return values
	for raw_value in raw_values:
		var value: String = str(raw_value)
		if not value.is_empty():
			values.append(value)
	return values


func get_party_members() -> Array:
	var members: Array = []
	for member_id in party_order:
		if party.has(member_id):
			members.append(party[member_id])
	return members


func get_party_names() -> Array[String]:
	var names: Array[String] = []
	for member in get_party_members():
		names.append(member.get("name", ""))
	return names


func has_companion(companion_id: String) -> bool:
	return party.has(companion_id)


func get_companion(companion_id: String) -> Dictionary:
	return party.get(companion_id, {})


func recruit_companion(companion_id: String) -> void:
	if has_companion(companion_id):
		return

	var template: Dictionary = companion_defs.get(companion_id, {})
	if template.is_empty():
		return

	var companion: Dictionary = template.duplicate(true)
	companion["hp"] = companion.get("max_hp", 0)
	companion["sp"] = companion.get("max_sp", 0)
	companion["defending"] = false
	companion["learned_skills"] = _to_string_array(companion.get("skills", []))
	companion["equipped_skills"] = companion["learned_skills"].slice(0, ACTIVE_SKILL_LIMIT)
	companion["skills"] = companion["equipped_skills"].duplicate(true)
	party[companion_id] = companion
	party_order.append(companion_id)
	if companion_id == "joao":
		world_state["joao_recruited"] = true
	state_changed.emit()


func set_current_scene_path(scene_path: String) -> void:
	world_state["current_scene"] = scene_path


func get_current_scene_path() -> String:
	return world_state.get("current_scene", "res://scenes/world/lisboa.tscn")


func update_scene_position(scene_id: String, position: Vector2) -> void:
	var scene_positions: Dictionary = world_state.get("scene_positions", {})
	scene_positions[scene_id] = {"x": position.x, "y": position.y}
	world_state["scene_positions"] = scene_positions


func set_pending_scene_spawn(scene_id: String, position: Vector2) -> void:
	if scene_id.is_empty():
		return
	var pending_spawns: Dictionary = world_state.get("pending_scene_spawns", {})
	pending_spawns[scene_id] = {"x": position.x, "y": position.y}
	world_state["pending_scene_spawns"] = pending_spawns


func consume_pending_scene_spawn(scene_id: String) -> Dictionary:
	if scene_id.is_empty():
		return {}
	var pending_spawns: Dictionary = world_state.get("pending_scene_spawns", {})
	if not pending_spawns.has(scene_id):
		return {}
	var spawn_data: Dictionary = pending_spawns.get(scene_id, {})
	pending_spawns.erase(scene_id)
	world_state["pending_scene_spawns"] = pending_spawns
	return spawn_data


func get_ocean_state() -> Dictionary:
	return world_state.get("ocean_state", {})


func _set_ocean_state(state: Dictionary) -> void:
	world_state["ocean_state"] = state


func set_ocean_state(state: Dictionary) -> void:
	_set_ocean_state(state)
	state_changed.emit()


func set_overworld_current_node(node_id: String) -> void:
	if node_id.is_empty():
		return
	world_state["overworld_current_node_id"] = node_id


func get_overworld_current_node_id() -> String:
	return str(world_state.get("overworld_current_node_id", "lisboa"))


func set_overworld_origin_scene(scene_path: String) -> void:
	if scene_path.is_empty():
		return
	world_state["overworld_origin_scene"] = scene_path


func get_overworld_origin_scene() -> String:
	return str(world_state.get("overworld_origin_scene", "res://scenes/world/lisboa.tscn"))


func set_overworld_travel_state(travel_state: Dictionary) -> void:
	world_state["overworld_travel_state"] = travel_state.duplicate(true)


func get_overworld_travel_state() -> Dictionary:
	return world_state.get("overworld_travel_state", {}).duplicate(true)


func clear_overworld_travel_state() -> void:
	world_state["overworld_travel_state"] = {}


func is_overworld_travel_active() -> bool:
	return not get_overworld_travel_state().is_empty()


func register_battle_outcome(outcome: String) -> void:
	last_battle_outcome = outcome


func consume_last_battle_outcome() -> String:
	var outcome: String = last_battle_outcome
	last_battle_outcome = ""
	return outcome


func get_scene_position(scene_id: String, default_value: Vector2) -> Vector2:
	var scene_positions: Dictionary = world_state.get("scene_positions", {})
	var value: Dictionary = scene_positions.get(scene_id, {"x": default_value.x, "y": default_value.y})
	return Vector2(value.get("x", default_value.x), value.get("y", default_value.y))


func get_quest_state(quest_id: String) -> String:
	return quest_states.get(quest_id, "not_started")


func set_quest_state(quest_id: String, status: String) -> void:
	quest_states[quest_id] = status
	quest_updated.emit(quest_id, status)
	state_changed.emit()


func start_quest(quest_id: String) -> void:
	set_quest_state(quest_id, "active")


func get_flag(flag_name: String, default_value = null) -> Variant:
	return world_state.get(flag_name, default_value)


func set_flag(flag_name: String, value: Variant) -> void:
	world_state[flag_name] = value
	state_changed.emit()


func get_quest_journal_text(quest_id: String) -> String:
	var quest: Dictionary = quest_defs.get(quest_id, {})
	var journal: Dictionary = quest.get("journal", {})
	var status: String = get_quest_state(quest_id)
	return journal.get(status, quest.get("description", ""))


func apply_actions(actions: Array) -> void:
	for raw_action in actions:
		var action: Dictionary = raw_action
		var action_type: String = action.get("type", "")
		match action_type:
			"start_quest":
				start_quest(action.get("quest_id", ""))
			"complete_quest":
				complete_quest(action.get("quest_id", ""))
			"set_quest_state":
				set_quest_state(action.get("quest_id", ""), action.get("status", ""))
			"set_flag":
				set_flag(action.get("flag", ""), action.get("value"))
			"add_item":
				add_item(action.get("item_id", ""), int(action.get("quantity", 1)))
			"add_gold":
				gold += int(action.get("amount", 0))
				state_changed.emit()
			"recruit_companion":
				recruit_companion(action.get("companion_id", ""))
			"heal_party":
				heal_party()
			"use_service":
				use_service(str(action.get("service_id", "")), int(action.get("price", 0)))


func _get_battle_enemy_ids(context: Dictionary) -> Array[String]:
	var enemy_ids: Array[String] = []
	if context.has("enemy_ids"):
		for raw_enemy_id in context.get("enemy_ids", []):
			enemy_ids.append(str(raw_enemy_id))
	elif not str(context.get("enemy_id", "")).is_empty():
		enemy_ids.append(str(context.get("enemy_id", "")))
	return enemy_ids


func finish_battle_victory(context: Dictionary) -> void:
	var enemy_ids: Array[String] = _get_battle_enemy_ids(context)
	if enemy_ids.is_empty():
		return

	var total_gold: int = 0
	var total_xp: int = 0
	for enemy_id in enemy_ids:
		var enemy: Dictionary = enemy_defs.get(enemy_id, {})
		if enemy.is_empty():
			continue
		total_gold += int(enemy.get("gold_reward", 0))
		total_xp += int(enemy.get("xp_reward", 0))

	gold += total_gold
	award_player_xp(total_xp)
	heal_party(12, 5)

	apply_actions(context.get("victory_actions", []))
	state_changed.emit()


func complete_quest(quest_id: String) -> void:
	var quest: Dictionary = quest_defs.get(quest_id, {})
	if quest.is_empty():
		return

	award_player_xp(int(quest.get("reward_xp", 0)))
	gold += quest.get("reward_gold", 0)
	add_item(quest.get("reward_item", ""), 1)
	for raw_item_id in quest.get("reward_items", []):
		add_item(str(raw_item_id), 1)
	set_quest_state(quest_id, "completed")


func add_item(item_id: String, quantity: int) -> void:
	if item_id.is_empty() or quantity <= 0:
		return

	for stack in inventory:
		if stack["id"] == item_id:
			stack["quantity"] += quantity
			inventory_changed.emit()
			return

	inventory.append({"id": item_id, "quantity": quantity})
	inventory_changed.emit()


func consume_item(item_id: String) -> bool:
	for i in range(inventory.size()):
		var stack: Dictionary = inventory[i]
		if stack["id"] == item_id and stack["quantity"] > 0:
			stack["quantity"] -= 1
			if stack["quantity"] <= 0:
				inventory.remove_at(i)
			else:
				inventory[i] = stack
			inventory_changed.emit()
			return true
	return false


func heal_party(hp_amount: int = 9999, sp_amount: int = 9999) -> void:
	for member_id in party_order:
		if not party.has(member_id):
			continue

		var member: Dictionary = party[member_id]
		member["hp"] = clampi(member.get("hp", 0) + hp_amount, 0, member.get("max_hp", 0))
		member["sp"] = clampi(member.get("sp", 0) + sp_amount, 0, member.get("max_sp", 0))
		member["defending"] = false
		party[member_id] = member

	state_changed.emit()


func to_save_data() -> Dictionary:
	return {
		"party": party,
		"party_order": party_order,
		"inventory": inventory,
		"gold": gold,
		"quest_states": quest_states,
		"world_state": world_state
	}


func load_from_save_data(data: Dictionary) -> void:
	party = data.get("party", {})
	party_order = data.get("party_order", ["pembah"])
	inventory = data.get("inventory", [])
	gold = data.get("gold", 0)
	quest_states = data.get("quest_states", {})
	world_state = data.get("world_state", {})
	current_battle_context = {}
	last_battle_outcome = ""
	_ensure_runtime_defaults()
	_emit_all()


func _emit_all() -> void:
	inventory_changed.emit()
	state_changed.emit()


func _merge_member_defaults(template: Dictionary, member: Dictionary) -> Dictionary:
	var merged: Dictionary = template.duplicate(true)
	for key in member.keys():
		if key == "skills":
			continue
		merged[key] = member[key]

	var merged_skills: Array = template.get("skills", []).duplicate(true)
	for raw_skill_id in member.get("skills", []):
		if not merged_skills.has(raw_skill_id):
			merged_skills.append(raw_skill_id)
	merged["skills"] = merged_skills
	merged["defending"] = merged.get("defending", false)
	return merged


func _ensure_runtime_defaults() -> void:
	if party.is_empty():
		party = {"pembah": _build_pembah()}
	elif party.has("pembah"):
		party["pembah"] = _normalize_player_data(_merge_member_defaults(_build_pembah(), party["pembah"]))
	if party_order.is_empty():
		party_order = ["pembah"]
	if party.has("joao") and not party_order.has("joao"):
		party_order.append("joao")
	if party.has("joao"):
		party["joao"] = _normalize_companion_data(_merge_member_defaults(companion_defs.get("joao", {}), party["joao"]))
	if not quest_states.has("first_voyage"):
		quest_states["first_voyage"] = "not_started"
	if not quest_states.has("porto_alliance"):
		quest_states["porto_alliance"] = "not_started"
	if not quest_states.has("luz_de_sagres"):
		quest_states["luz_de_sagres"] = "not_started"
	if not quest_states.has("roda_de_tomar"):
		quest_states["roda_de_tomar"] = "not_started"
	if not quest_states.has("porta_de_ceuta"):
		quest_states["porta_de_ceuta"] = "not_started"
	if not quest_states.has("terra_de_vera_cruz"):
		quest_states["terra_de_vera_cruz"] = "not_started"
	if not world_state.has("current_scene"):
		world_state["current_scene"] = "res://scenes/world/lisboa.tscn"
	if not world_state.has("scene_positions"):
		world_state["scene_positions"] = {}
	if not world_state.has("ocean_state"):
		world_state["ocean_state"] = _build_default_ocean_state()
	if not world_state.has("overworld_current_node_id"):
		world_state["overworld_current_node_id"] = "lisboa"
	if not world_state.has("overworld_origin_scene"):
		world_state["overworld_origin_scene"] = "res://scenes/world/lisboa.tscn"
	if not world_state.has("battle_tutorial_seen"):
		world_state["battle_tutorial_seen"] = false
	if not world_state.has("overworld_travel_state"):
		world_state["overworld_travel_state"] = {}
	if not world_state.has("pending_scene_spawns"):
		world_state["pending_scene_spawns"] = {}

	var scene_positions: Dictionary = world_state.get("scene_positions", {})
	if not scene_positions.has("lisboa"):
		scene_positions["lisboa"] = {"x": 240.0, "y": 520.0}
	if not scene_positions.has("lisboa_rossio"):
		scene_positions["lisboa_rossio"] = {"x": 280.0, "y": 640.0}
	if not scene_positions.has("lisboa_se"):
		scene_positions["lisboa_se"] = {"x": 300.0, "y": 620.0}
	if not scene_positions.has("lisboa_estaleiro"):
		scene_positions["lisboa_estaleiro"] = {"x": 260.0, "y": 700.0}
	if not scene_positions.has("lisboa_porta_oriental"):
		scene_positions["lisboa_porta_oriental"] = {"x": 260.0, "y": 620.0}
	if not scene_positions.has("mata_de_alvalade"):
		scene_positions["mata_de_alvalade"] = {"x": 240.0, "y": 740.0}
	if not scene_positions.has("porto"):
		scene_positions["porto"] = {"x": 300.0, "y": 640.0}
	if not scene_positions.has("sagres"):
		scene_positions["sagres"] = {"x": 280.0, "y": 640.0}
	if not scene_positions.has("tomar"):
		scene_positions["tomar"] = {"x": 880.0, "y": 760.0}
	if not scene_positions.has("ceuta"):
		scene_positions["ceuta"] = {"x": 320.0, "y": 710.0}
	if not scene_positions.has("ilha_bruma"):
		scene_positions["ilha_bruma"] = {"x": 860.0, "y": 520.0}
	if not scene_positions.has("ilha_sargaco"):
		scene_positions["ilha_sargaco"] = {"x": 860.0, "y": 520.0}
	if not scene_positions.has("terra_vera_cruz"):
		scene_positions["terra_vera_cruz"] = {"x": 860.0, "y": 520.0}
	if not world_state.has("bandit_defeated"):
		world_state["bandit_defeated"] = false
	if not world_state.has("lisboa_boss_defeated"):
		world_state["lisboa_boss_defeated"] = false
	if not world_state.has("porto_duelist_defeated"):
		world_state["porto_duelist_defeated"] = false
	if not world_state.has("porto_mourisco_defeated"):
		world_state["porto_mourisco_defeated"] = false
	if not world_state.has("porto_boss_defeated"):
		world_state["porto_boss_defeated"] = false
	if not world_state.has("sagres_corsair_defeated"):
		world_state["sagres_corsair_defeated"] = false
	if not world_state.has("sagres_bombard_defeated"):
		world_state["sagres_bombard_defeated"] = false
	if not world_state.has("sagres_boss_defeated"):
		world_state["sagres_boss_defeated"] = false
	if not world_state.has("tomar_claustro_purged"):
		world_state["tomar_claustro_purged"] = false
	if not world_state.has("tomar_nabao_purged"):
		world_state["tomar_nabao_purged"] = false
	if not world_state.has("tomar_boss_defeated"):
		world_state["tomar_boss_defeated"] = false
	if not world_state.has("ceuta_marina_secured"):
		world_state["ceuta_marina_secured"] = false
	if not world_state.has("ceuta_alcacova_secured"):
		world_state["ceuta_alcacova_secured"] = false
	if not world_state.has("ceuta_boss_defeated"):
		world_state["ceuta_boss_defeated"] = false
	if not world_state.has("vera_cruz_boss_defeated"):
		world_state["vera_cruz_boss_defeated"] = false
	if not world_state.has("joao_recruited"):
		world_state["joao_recruited"] = party.has("joao")
	world_state["scene_positions"] = scene_positions


func _ensure_ocean_state() -> Dictionary:
	var ocean: Dictionary = world_state.get("ocean_state", {})
	if ocean.is_empty():
		ocean = _build_default_ocean_state()
		world_state["ocean_state"] = ocean
	return ocean


func _build_default_ocean_state() -> Dictionary:
	return {
		"supplies": 100,
		"supplies_max": 100,
		"ship": 100,
		"ship_max": 100,
		"wind": "manso",
		"wind_label": "Manso",
		"wind_speed": 1.0,
		"days": 0,
		"last_event": "A nau repousa em porto seguro.",
		"event_log": []
	}
