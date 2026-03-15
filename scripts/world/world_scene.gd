extends Node2D

const TRAVEL_MAP_PATH := "res://data/world/travel_map.json"

@export_file("*.json") var world_data_path: String = ""
@export var scene_id: String = ""
@export var default_spawn_position: Vector2 = Vector2(240.0, 520.0)
@export_file("*.tscn") var scene_path: String = ""

@onready var player: Node2D = $Player
@onready var prompt_label: Label = %PromptLabel
@onready var quest_label: Label = %QuestLabel
@onready var stats_label: Label = %StatsLabel
@onready var dialogue_panel: PanelContainer = %DialoguePanel
@onready var dialogue_text: RichTextLabel = %DialogueText
@onready var primary_button: Button = %PrimaryButton
@onready var secondary_button: Button = %SecondaryButton
@onready var inventory_panel: PanelContainer = %InventoryPanel
@onready var inventory_text: RichTextLabel = %InventoryText
@onready var character_panel: PanelContainer = %CharacterPanel
@onready var character_filter_row = get_node_or_null("CanvasLayer/CharacterPanel/CharacterVBox/CharacterFilterRow")
@onready var build_school_filter: OptionButton = %BuildSchoolFilter
@onready var build_quality_filter: OptionButton = %BuildQualityFilter
@onready var build_state_filter: OptionButton = %BuildStateFilter
@onready var manual_state_filter: OptionButton = %ManualStateFilter
@onready var character_summary_text: RichTextLabel = %CharacterSummaryText
@onready var character_build_list: VBoxContainer = %CharacterBuildList
@onready var character_manual_list: VBoxContainer = %CharacterManualList
@onready var character_content = get_node_or_null("CanvasLayer/CharacterPanel/CharacterVBox/CharacterScroll/CharacterContent")
@onready var character_inventory_text: RichTextLabel = %CharacterInventoryText
@onready var character_footer_label: Label = %CharacterFooterLabel
@onready var shop_panel: PanelContainer = %ShopPanel
@onready var shop_title_label: Label = %ShopTitleLabel
@onready var shop_status_label: Label = %ShopStatusLabel
@onready var shop_list: VBoxContainer = %ShopList
@onready var travel_panel: PanelContainer = %TravelPanel
@onready var travel_status_label: Label = %TravelStatusLabel
@onready var travel_list: VBoxContainer = %TravelList
@onready var pause_panel: PanelContainer = %PausePanel
@onready var pause_label: Label = %PauseLabel

var interactables: Array = []
var dialogues: Dictionary = {}
var shops: Dictionary = {}
var active_dialogue_actions: Array = []
var travel_destinations: Array = []
var character_status_message: String = ""
var shop_status_message: String = ""
var current_shop_id: String = ""
var character_school_filter_value: String = "all"
var character_quality_filter_value: String = "all"
var character_build_filter_value: String = "all"
var character_manual_filter_value: String = "all"
var character_focus_id: String = "pembah"
var character_focus_select
var companion_column
var companion_summary_text
var companion_skill_list


func _ready() -> void:
	_load_world_data()
	_load_travel_map()
	GameState.set_current_scene_path(scene_path)
	GameState.set_overworld_current_node(scene_id)
	GameState.set_overworld_origin_scene(scene_path)
	MusicManager.play_world_music(scene_id)
	player.position = GameState.get_scene_position(scene_id, default_spawn_position)
	GameState.state_changed.connect(_refresh_ui)
	GameState.inventory_changed.connect(_refresh_inventory)
	_ensure_character_focus_selector()
	_ensure_companion_panel()
	_setup_character_filters()
	_refresh_ui()
	_refresh_inventory()
	_refresh_shop_panel()


func _exit_tree() -> void:
	GameState.update_scene_position(scene_id, player.position)


func _process(_delta: float) -> void:
	GameState.update_scene_position(scene_id, player.position)
	_update_prompt()


func _draw() -> void:
	_draw_world()
	_draw_interactables()


func _draw_world() -> void:
	pass


func _draw_tiled_ground(area: Rect2, tile_size: float, color_a: Color, color_b: Color) -> void:
	var rows: int = int(ceil(area.size.y / tile_size))
	var cols: int = int(ceil(area.size.x / tile_size))
	for row in range(rows):
		for col in range(cols):
			var tile_color: Color = color_a if (row + col) % 2 == 0 else color_b
			var position := area.position + Vector2(col * tile_size, row * tile_size)
			draw_rect(Rect2(position, Vector2(tile_size, tile_size)), tile_color)


func _draw_water_band(area: Rect2, base_color: Color, foam_color: Color) -> void:
	draw_rect(area, base_color)
	var wave_gap := 34.0
	var y := area.position.y + 18.0
	while y < area.end.y:
		var x := area.position.x + 24.0
		while x < area.end.x - 20.0:
			draw_arc(Vector2(x, y), 11.0, PI * 0.08, PI * 0.92, 8, foam_color, 2.0)
			x += wave_gap
		y += 28.0


func _draw_path(area: Rect2, base_color: Color, edge_color: Color) -> void:
	draw_rect(area, base_color)
	draw_line(area.position, Vector2(area.end.x, area.position.y), edge_color, 3.0)
	draw_line(Vector2(area.position.x, area.end.y), area.end, edge_color, 3.0)


func _draw_house_block(area: Rect2, wall_color: Color, roof_color: Color, door_color: Color) -> void:
	draw_rect(area, wall_color)
	var roof := PackedVector2Array([
		Vector2(area.position.x - 18.0, area.position.y + 24.0),
		Vector2(area.position.x + area.size.x * 0.5, area.position.y - 18.0),
		Vector2(area.end.x + 18.0, area.position.y + 24.0),
		Vector2(area.end.x, area.position.y + 50.0),
		Vector2(area.position.x, area.position.y + 50.0)
	])
	draw_colored_polygon(roof, roof_color)
	var door_size := Vector2(34.0, 52.0)
	var door_pos := Vector2(area.position.x + area.size.x * 0.5 - door_size.x * 0.5, area.end.y - door_size.y)
	draw_rect(Rect2(door_pos, door_size), door_color)
	var window_color := wall_color.lightened(0.28)
	draw_rect(Rect2(area.position + Vector2(28.0, 64.0), Vector2(24.0, 22.0)), window_color)
	draw_rect(Rect2(area.end - Vector2(52.0, -64.0), Vector2(24.0, 22.0)), window_color)


func _draw_tree(position: Vector2, trunk_color: Color, leaf_color: Color) -> void:
	draw_rect(Rect2(position + Vector2(-8.0, 12.0), Vector2(16.0, 26.0)), trunk_color)
	draw_circle(position, 24.0, leaf_color)
	draw_circle(position + Vector2(-18.0, 10.0), 18.0, leaf_color.darkened(0.08))
	draw_circle(position + Vector2(18.0, 8.0), 16.0, leaf_color.lightened(0.05))


func _draw_ship(area: Rect2, hull_color: Color, sail_color: Color) -> void:
	var hull := PackedVector2Array([
		Vector2(area.position.x + 16.0, area.end.y - 12.0),
		Vector2(area.end.x - 16.0, area.end.y - 12.0),
		Vector2(area.end.x - 44.0, area.end.y + 18.0),
		Vector2(area.position.x + 44.0, area.end.y + 18.0)
	])
	draw_colored_polygon(hull, hull_color)
	draw_line(Vector2(area.position.x + area.size.x * 0.5, area.position.y + 10.0), Vector2(area.position.x + area.size.x * 0.5, area.end.y - 10.0), Color("402610"), 4.0)
	var sail := PackedVector2Array([
		Vector2(area.position.x + area.size.x * 0.5, area.position.y + 14.0),
		Vector2(area.position.x + area.size.x * 0.5, area.position.y + 92.0),
		Vector2(area.position.x + 22.0, area.position.y + 62.0)
	])
	draw_colored_polygon(sail, sail_color)
	var sail_two := PackedVector2Array([
		Vector2(area.position.x + area.size.x * 0.5, area.position.y + 24.0),
		Vector2(area.position.x + area.size.x * 0.5, area.position.y + 84.0),
		Vector2(area.end.x - 22.0, area.position.y + 56.0)
	])
	draw_colored_polygon(sail_two, sail_color.darkened(0.04))


func _draw_stall(area: Rect2, cloth_color: Color, wood_color: Color) -> void:
	draw_rect(Rect2(area.position + Vector2(14.0, 26.0), Vector2(area.size.x - 28.0, area.size.y - 30.0)), wood_color)
	var roof := PackedVector2Array([
		Vector2(area.position.x, area.position.y + 18.0),
		Vector2(area.end.x, area.position.y + 18.0),
		Vector2(area.end.x - 18.0, area.position.y - 10.0),
		Vector2(area.position.x + 18.0, area.position.y - 10.0)
	])
	draw_colored_polygon(roof, cloth_color)
	draw_line(area.position + Vector2(14.0, 18.0), area.position + Vector2(14.0, area.size.y), wood_color.darkened(0.2), 4.0)
	draw_line(Vector2(area.end.x - 14.0, area.position.y + 18.0), Vector2(area.end.x - 14.0, area.position.y + area.size.y), wood_color.darkened(0.2), 4.0)


func _draw_interactables() -> void:
	for raw_interactable in interactables:
		var interactable: Dictionary = raw_interactable
		if not _is_interactable_available(interactable):
			continue

		var position: Vector2 = _vector_from_dict(interactable.get("position", {}))
		var label: String = interactable.get("label", "")
		var draw_radius: float = float(interactable.get("draw_radius", 22.0))
		var color: Color = Color(interactable.get("color", "ffffff"))
		draw_circle(position + Vector2(0.0, 18.0), draw_radius * 0.65, Color(0, 0, 0, 0.18))
		var interactable_type: String = interactable.get("type", "dialogue")
		if interactable_type == "encounter":
			var diamond := PackedVector2Array([
				position + Vector2(0.0, -draw_radius),
				position + Vector2(draw_radius * 0.9, 0.0),
				position + Vector2(0.0, draw_radius),
				position + Vector2(-draw_radius * 0.9, 0.0)
			])
			draw_colored_polygon(diamond, color)
			draw_line(position + Vector2(-8.0, 0.0), position + Vector2(8.0, 0.0), Color.WHITE, 2.0)
			draw_line(position + Vector2(0.0, -8.0), position + Vector2(0.0, 8.0), Color.WHITE, 2.0)
		else:
			draw_rect(Rect2(position + Vector2(-12.0, -draw_radius), Vector2(24.0, draw_radius * 1.6)), color)
			draw_rect(Rect2(position + Vector2(-4.0, draw_radius * 0.55), Vector2(8.0, 18.0)), color.darkened(0.25))
			draw_circle(position + Vector2(0.0, -draw_radius), 10.0, color.lightened(0.12))
		var plate_size := Vector2(max(120.0, label.length() * 9.4), 28.0)
		var plate_rect := Rect2(position + Vector2(-plate_size.x * 0.5, -draw_radius - 44.0), plate_size)
		draw_rect(plate_rect, Color(0.05, 0.12, 0.2, 0.72))
		draw_rect(Rect2(plate_rect.position, Vector2(plate_rect.size.x, 2.0)), color.lightened(0.18))
		draw_string(
			ThemeDB.fallback_font,
			position + Vector2(-plate_size.x * 0.44, -draw_radius - 22.0),
			label,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			20,
			Color.WHITE
		)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and not dialogue_panel.visible and not inventory_panel.visible and not character_panel.visible and not pause_panel.visible and not travel_panel.visible and not shop_panel.visible:
		_try_interaction()
	if event.is_action_pressed("open_inventory"):
		inventory_panel.visible = not inventory_panel.visible
		dialogue_panel.visible = false
		travel_panel.visible = false
		pause_panel.visible = false
		character_panel.visible = false
		shop_panel.visible = false
	if event.is_action_pressed("open_character"):
		_toggle_character_panel()
	if event.is_action_pressed("open_map"):
		_toggle_travel_panel()
	if event.is_action_pressed("pause"):
		pause_panel.visible = not pause_panel.visible
		inventory_panel.visible = false
		character_panel.visible = false
		travel_panel.visible = false
		dialogue_panel.visible = false
		shop_panel.visible = false


func _load_world_data() -> void:
	interactables.clear()
	dialogues.clear()
	shops.clear()

	var parsed: Variant = GameState.load_json_data(world_data_path)
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Expected dictionary in %s" % world_data_path)
		return

	for raw_interactable in parsed.get("interactables", []):
		interactables.append(raw_interactable)

	for raw_dialogue in parsed.get("dialogues", []):
		var dialogue: Dictionary = raw_dialogue
		dialogues[dialogue["id"]] = dialogue

	for raw_shop in parsed.get("shops", []):
		var shop: Dictionary = raw_shop
		shops[shop["id"]] = shop


func _load_travel_map() -> void:
	travel_destinations.clear()

	var parsed: Variant = GameState.load_json_data(TRAVEL_MAP_PATH)
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Expected dictionary in %s" % TRAVEL_MAP_PATH)
		return

	for raw_destination in parsed.get("destinations", []):
		travel_destinations.append(raw_destination)


func _vector_from_dict(value: Dictionary) -> Vector2:
	return Vector2(float(value.get("x", 0.0)), float(value.get("y", 0.0)))


func _find_nearest_interactable() -> Dictionary:
	var nearest: Dictionary = {}
	var nearest_distance: float = INF

	for raw_interactable in interactables:
		var interactable: Dictionary = raw_interactable
		if not _is_interactable_available(interactable):
			continue

		var position: Vector2 = _vector_from_dict(interactable.get("position", {}))
		var radius: float = float(interactable.get("radius", 90.0))
		var distance: float = player.position.distance_to(position)
		if distance <= radius and distance < nearest_distance:
			nearest = interactable
			nearest_distance = distance

	return nearest


func _is_interactable_available(interactable: Dictionary) -> bool:
	var conditions: Dictionary = interactable.get("conditions", {})
	return _conditions_match(conditions)


func _conditions_match(conditions: Dictionary) -> bool:
	if conditions.is_empty():
		return true

	var quest_conditions: Dictionary = conditions.get("quest_state", {})
	for quest_id in quest_conditions.keys():
		var expected: Variant = quest_conditions[quest_id]
		var current_status: String = GameState.get_quest_state(str(quest_id))
		if typeof(expected) == TYPE_ARRAY:
			if not expected.has(current_status):
				return false
		elif current_status != str(expected):
			return false

	var flag_conditions: Dictionary = conditions.get("world_flags", {})
	for flag_name in flag_conditions.keys():
		if GameState.get_flag(str(flag_name), null) != flag_conditions[flag_name]:
			return false

	return true


func _update_prompt() -> void:
	if travel_panel.visible:
		prompt_label.text = "Mapa de viagem aberto  |  M fechar  |  Escolhe o destino"
		return
	if shop_panel.visible:
		prompt_label.text = "Mercado aberto  |  Esgotai o oiro com tento  |  Fechar no painel"
		return
	if character_panel.visible:
		var focus_id: String = _get_focus_member_id()
		var focus_name: String = "Pembah"
		if focus_id != "pembah":
			focus_name = str(GameState.get_companion(focus_id).get("name", focus_id))
		prompt_label.text = "Personagem aberta  |  C fechar  |  Ordenai as artes de %s" % focus_name
		return
	if inventory_panel.visible:
		prompt_label.text = "Inventario aberto  |  I fechar  |  Consultai os bens e provisoes"
		return

	var interactable: Dictionary = _find_nearest_interactable()
	if not interactable.is_empty():
		prompt_label.text = interactable.get("prompt", "Carrega E para interagir.")
	else:
		prompt_label.text = "WASD mover  |  E interagir  |  C personagem  |  M carta de Portugal  |  I inventario  |  ESC pausa"


func _try_interaction() -> void:
	var interactable: Dictionary = _find_nearest_interactable()
	if interactable.is_empty():
		return

	var interactable_type: String = interactable.get("type", "dialogue")
	match interactable_type:
		"dialogue":
			var dialogue_id: String = _resolve_dialogue_id(interactable)
			_open_dialogue(dialogue_id)
		"shop":
			_open_shop(str(interactable.get("shop_id", "")))
		"encounter":
			_start_battle(interactable.get("battle", {}))


func _resolve_dialogue_id(interactable: Dictionary) -> String:
	var dialogue_map: Dictionary = interactable.get("dialogues_by_quest_state", {})
	for quest_id in dialogue_map.keys():
		var state_map: Dictionary = dialogue_map[quest_id]
		var quest_status: String = GameState.get_quest_state(str(quest_id))
		if state_map.has(quest_status):
			return state_map[quest_status]

	return interactable.get("default_dialogue_id", "")


func _open_dialogue(dialogue_id: String) -> void:
	var dialogue: Dictionary = dialogues.get(dialogue_id, {})
	if dialogue.is_empty():
		return

	dialogue_panel.visible = true
	inventory_panel.visible = false
	character_panel.visible = false
	travel_panel.visible = false
	pause_panel.visible = false
	shop_panel.visible = false

	var speaker: String = dialogue.get("speaker", "")
	var text: String = dialogue.get("text", "")
	if speaker.is_empty():
		dialogue_text.text = text
	else:
		dialogue_text.text = "[b]%s[/b]\n%s" % [speaker, text]

	active_dialogue_actions = dialogue.get("actions", [])
	primary_button.visible = active_dialogue_actions.size() > 0
	primary_button.text = dialogue.get("primary_label", "Continuar")
	secondary_button.text = dialogue.get("secondary_label", "Fechar")
	if not primary_button.visible:
		secondary_button.text = dialogue.get("secondary_label", "Prosseguir")


func _start_battle(battle_data: Dictionary) -> void:
	GameState.current_battle_context = battle_data.duplicate(true)
	get_tree().change_scene_to_file("res://scenes/combat/battle_scene.tscn")


func _toggle_travel_panel() -> void:
	_open_overworld_map()


func _open_overworld_map() -> void:
	dialogue_panel.visible = false
	inventory_panel.visible = false
	character_panel.visible = false
	travel_panel.visible = false
	pause_panel.visible = false
	shop_panel.visible = false
	GameState.set_overworld_origin_scene(scene_path)
	GameState.set_overworld_current_node(scene_id)
	get_tree().change_scene_to_file(GameState.PORTUGAL_MAP_SCENE)


func _toggle_character_panel() -> void:
	character_panel.visible = not character_panel.visible
	if character_panel.visible:
		dialogue_panel.visible = false
		inventory_panel.visible = false
		travel_panel.visible = false
		pause_panel.visible = false
		shop_panel.visible = false
		if character_status_message.is_empty():
			character_status_message = "Ordenai as artes, passivas e manuais da vossa companhia."
		_refresh_character_panel()


func _open_shop(shop_id: String) -> void:
	var shop: Dictionary = shops.get(shop_id, {})
	if shop.is_empty():
		return

	current_shop_id = shop_id
	shop_status_message = ""
	shop_panel.visible = true
	dialogue_panel.visible = false
	inventory_panel.visible = false
	character_panel.visible = false
	travel_panel.visible = false
	pause_panel.visible = false
	if shop_status_message.is_empty():
		shop_status_message = "Mercai com tento e guardai o oiro para os livros mais raros."
	_refresh_shop_panel()


func _refresh_travel_map() -> void:
	for child in travel_list.get_children():
		child.queue_free()

	var current_scene_path: String = scene_path
	travel_status_label.text = "Roteiro conhecido a partir de %s." % scene_id.capitalize()

	for raw_destination in travel_destinations:
		var destination: Dictionary = raw_destination
		var button: Button = Button.new()
		var destination_scene: String = destination.get("scene", "")
		var destination_name: String = destination.get("name", "Destino")
		var description: String = destination.get("description", "")
		var unlocked: bool = _conditions_match(destination.get("conditions", {}))

		button.custom_minimum_size = Vector2(0.0, 70.0)
		if destination_scene == current_scene_path:
			button.disabled = true
			button.text = "%s\n(Local presente)" % destination_name
		elif not unlocked:
			button.disabled = true
			button.text = "%s\nAinda vedado." % destination_name
		else:
			button.text = "%s\n%s" % [destination_name, description]
			button.pressed.connect(_on_travel_destination_pressed.bind(destination_scene))

		travel_list.add_child(button)


func _on_travel_destination_pressed(destination_scene: String) -> void:
	travel_panel.visible = false
	get_tree().change_scene_to_file(destination_scene)


func _run_actions(actions: Array) -> void:
	for raw_action in actions:
		var action: Dictionary = raw_action
		var action_type: String = action.get("type", "")
		match action_type:
			"start_battle":
				_start_battle(action.get("battle", {}))
				return
			"change_scene":
				get_tree().change_scene_to_file(action.get("scene", ""))
				return
			"open_overworld_map":
				_open_overworld_map()
				return
			_:
				GameState.apply_actions([action])

	_refresh_ui()
	_refresh_inventory()
	_refresh_shop_panel()


func _focus_quest_id() -> String:
	var priorities: Dictionary = {
		"active": 0,
		"ready_to_turn_in": 1,
		"not_started": 2,
		"completed": 3
	}
	var best_quest_id: String = ""
	var best_rank: int = 99

	for raw_quest_id in GameState.quest_defs.keys():
		var quest_id: String = str(raw_quest_id)
		var status: String = GameState.get_quest_state(quest_id)
		var rank: int = priorities.get(status, 4)
		if rank < best_rank:
			best_rank = rank
			best_quest_id = quest_id

	return best_quest_id


func _refresh_ui() -> void:
	var player_data: Dictionary = GameState.get_player()
	var party_names: String = ", ".join(GameState.get_party_names())
	var xp_progress: Dictionary = GameState.get_player_xp_progress()
	stats_label.text = "Pembah  Nv.%d  XP %d/%d  Saude %d/%d  Espirito %d/%d  Oiro %d\nCompanhia: %s" % [
		player_data["level"],
		xp_progress.get("current", 0),
		xp_progress.get("needed", 0),
		player_data["hp"],
		player_data["max_hp"],
		player_data["sp"],
		player_data["max_sp"],
		GameState.gold,
		party_names
	]

	var quest_id: String = _focus_quest_id()
	if quest_id.is_empty():
		quest_label.text = "Feito principal: nenhum encargo activo."
	else:
		quest_label.text = GameState.get_quest_journal_text(quest_id)

	_refresh_character_panel()
	_refresh_shop_panel()
	queue_redraw()


func _refresh_inventory() -> void:
	var lines: Array = [
		"[b]Inventario[/b]",
		"Oiro: %d" % GameState.gold,
		""
	]

	var grouped: Dictionary = {}
	for raw_stack in GameState.inventory:
		var stack: Dictionary = raw_stack
		var item_id: String = str(stack.get("id", ""))
		var item: Dictionary = GameState.item_defs.get(item_id, {})
		var item_type: String = str(item.get("type", "misc"))
		if not grouped.has(item_type):
			grouped[item_type] = []
		grouped[item_type].append({"item": item, "stack": stack})

	var type_order: Array = [
		"consumable",
		"accessory",
		"ocean_supply",
		"ocean_repair",
		"manual_skill",
		"manual_passive",
		"misc"
	]
	var type_labels: Dictionary = {
		"consumable": "Consumiveis",
		"accessory": "Acessorios",
		"ocean_supply": "Mantimentos de Mar",
		"ocean_repair": "Reparos de Casco",
		"manual_skill": "Manuais de Arte",
		"manual_passive": "Manuais de Passiva",
		"misc": "Outros"
	}

	var has_items: bool = false
	for item_type in type_order:
		if not grouped.has(item_type):
			continue
		var entries: Array = grouped[item_type]
		if entries.is_empty():
			continue
		has_items = true
		lines.append("[b]%s[/b]" % type_labels.get(item_type, "Outros"))
		for entry in entries:
			var item: Dictionary = entry.get("item", {})
			var stack: Dictionary = entry.get("stack", {})
			lines.append("- %s x%d" % [item.get("name", stack.get("id", "")), stack.get("quantity", 0)])
		lines.append("")

	if not has_items:
		lines.append("Vazio")
	lines.append("Os manuais podem ser estudados no ecra de Personagem.")
	inventory_text.text = "\n".join(lines)
	_refresh_character_panel()
	_refresh_shop_panel()


func _ensure_character_focus_selector() -> void:
	if character_filter_row == null:
		return
	var existing = character_filter_row.get_node_or_null("CharacterFocus")
	if existing == null:
		existing = OptionButton.new()
		existing.name = "CharacterFocus"
		existing.custom_minimum_size = Vector2(180.0, 0.0)
		character_filter_row.add_child(existing)
		character_filter_row.move_child(existing, 0)
		existing.item_selected.connect(_on_character_focus_item_selected)
	character_focus_select = existing


func _ensure_companion_panel() -> void:
	if character_content == null:
		return
	var existing = character_content.get_node_or_null("CompanionColumn")
	if existing == null:
		existing = VBoxContainer.new()
		existing.name = "CompanionColumn"
		existing.custom_minimum_size = Vector2(280.0, 0.0)
		existing.add_theme_constant_override("separation", 8)

		var title = Label.new()
		title.text = "Companheiro"
		title.add_theme_font_size_override("font_size", 20)
		existing.add_child(title)

		var summary := RichTextLabel.new()
		summary.name = "CompanionSummary"
		summary.bbcode_enabled = true
		summary.fit_content = true
		summary.scroll_active = false
		summary.custom_minimum_size = Vector2(260.0, 0.0)
		existing.add_child(summary)

		var list := VBoxContainer.new()
		list.name = "CompanionSkills"
		list.add_theme_constant_override("separation", 8)
		existing.add_child(list)

		character_content.add_child(existing)
	if companion_summary_text == null:
		companion_summary_text = existing.get_node_or_null("CompanionSummary")
	if companion_skill_list == null:
		companion_skill_list = existing.get_node_or_null("CompanionSkills")
	companion_column = existing


func _refresh_character_focus_options() -> void:
	if character_focus_select == null:
		return
	var focus_options: Array = [
		{"label": "Pembah", "value": "pembah"}
	]
	if GameState.has_companion("joao"):
		focus_options.append({"label": "Joao Tempestade", "value": "joao"})
	if character_focus_id != "pembah" and not GameState.has_companion(character_focus_id):
		character_focus_id = "pembah"
	_rebuild_option_button(character_focus_select, focus_options, character_focus_id)


func _on_character_focus_item_selected(index: int) -> void:
	if character_focus_select == null:
		return
	character_focus_id = str(character_focus_select.get_item_metadata(index))
	character_status_message = ""
	_refresh_character_panel()


func _get_focus_member_id() -> String:
	if character_focus_id != "pembah" and not GameState.has_companion(character_focus_id):
		return "pembah"
	return character_focus_id


func _refresh_companion_panel() -> void:
	if companion_column == null or companion_summary_text == null or companion_skill_list == null:
		return

	for child in companion_skill_list.get_children():
		child.queue_free()

	if not GameState.has_companion("joao"):
		companion_summary_text.text = "[b]Sem companheiro[/b]\nNenhum aliado segue a vossa nau."
		return

	var companion: Dictionary = GameState.get_companion("joao")
	var xp_progress: Dictionary = GameState.get_member_xp_progress("joao")
	var equipped_skills: Array = GameState.get_member_equipped_skills("joao")
	var learned_skills: Array = GameState.get_member_learned_skills("joao")

	var summary_lines: Array = [
		"[b]%s[/b]" % companion.get("name", "Companheiro"),
		"%s" % companion.get("role", "Companheiro"),
		"",
		"Nv.%d  |  XP %d/%d" % [
			companion.get("level", 1),
			xp_progress.get("current", 0),
			xp_progress.get("needed", 0)
		],
		"Saude %d/%d" % [companion.get("hp", 0), companion.get("max_hp", 0)],
		"Espirito %d/%d" % [companion.get("sp", 0), companion.get("max_sp", 0)],
		"ATQ %d  |  DEF %d  |  VEL %d" % [
			companion.get("atk", 0),
			companion.get("def", 0),
			companion.get("spd", 0)
		],
		"Artes equipadas: %d/%d" % [equipped_skills.size(), GameState.get_active_skill_limit()]
	]
	companion_summary_text.text = "\n".join(summary_lines)

	var title = Label.new()
	title.text = "Artes do companheiro"
	title.add_theme_font_size_override("font_size", 18)
	companion_skill_list.add_child(title)

	for skill_id in learned_skills:
		var skill: Dictionary = GameState.skill_defs.get(skill_id, {})
		if skill.is_empty():
			continue

		var button: Button = Button.new()
		button.custom_minimum_size = Vector2(0.0, 52.0)
		var equipped_text: String = "Retirar" if equipped_skills.has(skill_id) else "Equipar"
		var status_marker: String = _status_marker_for_skill(skill)
		button.text = "%s: %s%s\n%s | %s" % [
			equipped_text,
			skill.get("name", skill_id),
			status_marker,
			skill.get("school", "Arte sem escola"),
			_quality_name(str(skill.get("quality", "white")))
		]
		button.tooltip_text = skill.get("description", "")
		_apply_rarity_button_theme(button, str(skill.get("quality", "white")))
		button.pressed.connect(_on_character_skill_button_pressed.bind(skill_id, "joao"))
		companion_skill_list.add_child(button)


func _setup_character_filters() -> void:
	_refresh_character_filters()


func _refresh_character_filters() -> void:
	_refresh_character_focus_options()
	var school_options: Array = [{"label": "Todas as escolas", "value": "all"}]
	for school_name in _collect_character_school_options():
		school_options.append({"label": school_name, "value": school_name})
	_rebuild_option_button(build_school_filter, school_options, character_school_filter_value)

	_rebuild_option_button(build_quality_filter, [
		{"label": "Todas as qualidades", "value": "all"},
		{"label": "Branco", "value": "white"},
		{"label": "Verde", "value": "green"},
		{"label": "Azul", "value": "blue"},
		{"label": "Roxo", "value": "purple"},
		{"label": "Dourado", "value": "gold"},
		{"label": "Vermelho", "value": "red"}
	], character_quality_filter_value)

	_rebuild_option_button(build_state_filter, [
		{"label": "Tudo o que sabe", "value": "all"},
		{"label": "So equipadas", "value": "equipped"},
		{"label": "Por equipar", "value": "unequipped"}
	], character_build_filter_value)

	_rebuild_option_button(manual_state_filter, [
		{"label": "Todos os manuais", "value": "all"},
		{"label": "So estudaveis", "value": "studyable"},
		{"label": "Acima do nivel", "value": "above_level"}
	], character_manual_filter_value)
	manual_state_filter.disabled = _get_focus_member_id() != "pembah"


func _collect_character_school_options() -> Array:
	var schools: Array = []
	var focus_id: String = _get_focus_member_id()
	if focus_id == "pembah":
		for school_name in GameState.get_player_known_schools():
			if not schools.has(school_name):
				schools.append(school_name)

		for skill_id in GameState.get_player_learned_skills():
			var school_name: String = str(GameState.skill_defs.get(skill_id, {}).get("school", ""))
			if not school_name.is_empty() and not schools.has(school_name):
				schools.append(school_name)

		for passive_id in GameState.get_player_learned_passives():
			var school_name: String = str(GameState.passive_defs.get(passive_id, {}).get("school", ""))
			if not school_name.is_empty() and not schools.has(school_name):
				schools.append(school_name)

		for raw_stack in GameState.inventory:
			var stack: Dictionary = raw_stack
			var item: Dictionary = GameState.item_defs.get(stack.get("id", ""), {})
			var school_name: String = str(item.get("school", ""))
			if not school_name.is_empty() and not schools.has(school_name):
				schools.append(school_name)
	else:
		for skill_id in GameState.get_member_learned_skills(focus_id):
			var school_name: String = str(GameState.skill_defs.get(skill_id, {}).get("school", ""))
			if not school_name.is_empty() and not schools.has(school_name):
				schools.append(school_name)

	schools.sort()
	return schools


func _rebuild_option_button(button: OptionButton, options: Array, selected_value: String) -> void:
	button.clear()
	var selected_index: int = 0
	for option_index in range(options.size()):
		var option: Dictionary = options[option_index]
		button.add_item(str(option.get("label", "")))
		button.set_item_metadata(option_index, option.get("value", "all"))
		if str(option.get("value", "all")) == selected_value:
			selected_index = option_index
	button.select(selected_index)


func _refresh_character_panel() -> void:
	_refresh_character_filters()

	var focus_id: String = _get_focus_member_id()
	var is_player: bool = focus_id == "pembah"
	var focus_data: Dictionary = GameState.get_player() if is_player else GameState.get_companion(focus_id)
	var xp_progress: Dictionary = GameState.get_member_xp_progress(focus_id)
	var equipped_skills: Array = GameState.get_member_equipped_skills(focus_id)
	var learned_skills: Array = GameState.get_member_learned_skills(focus_id)
	var equipped_passives: Array = GameState.get_player_equipped_passives() if is_player else []
	var learned_passives: Array = GameState.get_player_learned_passives() if is_player else []
	var schools: Array = []
	if is_player:
		schools = GameState.get_player_known_schools()
	else:
		for skill_id in learned_skills:
			var school_name: String = str(GameState.skill_defs.get(skill_id, {}).get("school", ""))
			if not school_name.is_empty() and not schools.has(school_name):
				schools.append(school_name)
		schools.sort()

	var summary_lines: Array = [
		"[b]%s[/b]" % focus_data.get("name", "Companheiro"),
		"%s" % focus_data.get("role", "Companheiro"),
		"",
		"Nv.%d  |  XP %d/%d" % [
			focus_data.get("level", 1),
			xp_progress.get("current", 0),
			xp_progress.get("needed", 0)
		],
		"Saude %d/%d" % [focus_data.get("hp", 0), focus_data.get("max_hp", 0)],
		"Espirito %d/%d" % [focus_data.get("sp", 0), focus_data.get("max_sp", 0)],
		"ATQ %d  |  DEF %d  |  VEL %d" % [
			focus_data.get("atk", 0),
			focus_data.get("def", 0),
			focus_data.get("spd", 0)
		],
		"Passo %d  |  Alcance %d" % [
			focus_data.get("move_range", 0),
			focus_data.get("attack_range", 0)
		],
		"",
		"Artes equipadas: %d/%d" % [equipped_skills.size(), GameState.get_active_skill_limit()],
		"Passivas equipadas: %d/%d" % [equipped_passives.size(), GameState.get_passive_skill_limit()],
		"",
		"Escolas conhecidas:",
		", ".join(schools) if not schools.is_empty() else "Nenhuma"
	]
	character_summary_text.text = "\n".join(summary_lines)

	for child in character_build_list.get_children():
		child.queue_free()
	_add_character_section(character_build_list, "Artes de Combate")
	var shown_skills: int = 0
	for skill_id in learned_skills:
		var skill: Dictionary = GameState.skill_defs.get(skill_id, {})
		if skill.is_empty():
			continue
		if not _matches_character_entry(str(skill.get("school", "")), str(skill.get("quality", "white")), equipped_skills.has(skill_id)):
			continue

		var button: Button = Button.new()
		button.custom_minimum_size = Vector2(0.0, 62.0)
		var equipped_text: String = "Retirar" if equipped_skills.has(skill_id) else "Equipar"
		var status_marker: String = _status_marker_for_skill(skill)
		button.text = "%s: %s\n%s | %s" % [
			equipped_text,
			"%s%s" % [skill.get("name", skill_id), status_marker],
			skill.get("school", "Arte sem escola"),
			_quality_name(str(skill.get("quality", "white")))
		]
		button.tooltip_text = skill.get("description", "")
		_apply_rarity_button_theme(button, str(skill.get("quality", "white")))
		button.pressed.connect(_on_character_skill_button_pressed.bind(skill_id, focus_id))
		character_build_list.add_child(button)
		shown_skills += 1
	if learned_skills.is_empty():
		_add_character_hint(character_build_list, "Ainda nao conheceis artes para aparelhar.")
	elif shown_skills == 0:
		_add_character_hint(character_build_list, "Nenhuma arte casa com os filtros presentes.")

	_add_character_section(character_build_list, "Passivas")
	var shown_passives: int = 0
	if not is_player:
		_add_character_hint(character_build_list, "Este companheiro nao segue passivas de escola.")
	else:
		for passive_id in learned_passives:
			var passive: Dictionary = GameState.passive_defs.get(passive_id, {})
			if passive.is_empty():
				continue
			if not _matches_character_entry(str(passive.get("school", "")), str(passive.get("quality", "white")), equipped_passives.has(passive_id)):
				continue

			var button: Button = Button.new()
			button.custom_minimum_size = Vector2(0.0, 62.0)
			var passive_text: String = "Retirar" if equipped_passives.has(passive_id) else "Equipar"
			button.text = "%s: %s\n%s | %s" % [
				passive_text,
				passive.get("name", passive_id),
				passive.get("school", "Escola velada"),
				_quality_name(str(passive.get("quality", "white")))
			]
			button.tooltip_text = passive.get("description", "")
			_apply_rarity_button_theme(button, str(passive.get("quality", "white")))
			button.pressed.connect(_on_character_passive_button_pressed.bind(passive_id))
			character_build_list.add_child(button)
			shown_passives += 1
		if learned_passives.is_empty():
			_add_character_hint(character_build_list, "Ainda nao assimilastes passivas de escola.")
		elif shown_passives == 0:
			_add_character_hint(character_build_list, "Nenhuma passiva casa com os filtros presentes.")

	for child in character_manual_list.get_children():
		child.queue_free()
	_add_character_section(character_manual_list, "Livros e Pergaminhos")
	var has_manuals: bool = false
	var shown_manuals: int = 0
	if not is_player:
		_add_character_hint(character_manual_list, "Os companheiros nao estudam manuais.")
	else:
		for raw_stack in GameState.inventory:
			var stack: Dictionary = raw_stack
			var item_id: String = str(stack.get("id", ""))
			var item: Dictionary = GameState.item_defs.get(item_id, {})
			var item_type: String = str(item.get("type", ""))
			if item_type != "manual_skill" and item_type != "manual_passive":
				continue

			has_manuals = true
			var check: Dictionary = GameState.can_learn_manual(item_id)
			if not _matches_manual_entry(item, check):
				continue

			var button: Button = Button.new()
			button.custom_minimum_size = Vector2(0.0, 72.0)
			var manual_status_marker: String = ""
			if item_type == "manual_skill":
				var manual_skill_id: String = str(item.get("teach_skill", ""))
				var manual_skill: Dictionary = GameState.skill_defs.get(manual_skill_id, {})
				manual_status_marker = _status_marker_for_skill(manual_skill)
			button.text = "Estudar: %s x%d\n%s | %s | Nv.%d" % [
				"%s%s" % [item.get("name", item_id), manual_status_marker],
				stack.get("quantity", 0),
				item.get("school", "Escola oculta"),
				_quality_name(str(item.get("quality", "white"))),
				int(item.get("min_level", 1))
			]
			button.tooltip_text = "%s\n%s" % [
				item.get("description", ""),
				check.get("reason", "")
			]
			_apply_rarity_button_theme(button, str(item.get("quality", "white")))
			button.disabled = not bool(check.get("ok", false))
			if not button.disabled:
				button.pressed.connect(_on_study_manual_button_pressed.bind(item_id))
			character_manual_list.add_child(button)
			shown_manuals += 1
		if not has_manuals:
			_add_character_hint(character_manual_list, "Nao tendes livros nem pergaminhos de escola.")
		elif shown_manuals == 0:
			_add_character_hint(character_manual_list, "Nenhum manual casa com o crivo actual.")

	_refresh_companion_panel()

	var inventory_lines: Array = ["[b]Bornal[/b]"]
	for raw_stack in GameState.inventory:
		var stack: Dictionary = raw_stack
		var item: Dictionary = GameState.item_defs.get(stack.get("id", ""), {})
		var item_type: String = str(item.get("type", ""))
		if item_type == "manual_skill" or item_type == "manual_passive":
			continue
		inventory_lines.append("%s x%d" % [item.get("name", stack.get("id", "")), stack.get("quantity", 0)])
	if inventory_lines.size() == 1:
		inventory_lines.append("Vazio")
	character_inventory_text.text = "\n".join(inventory_lines)
	if not character_status_message.is_empty():
		character_footer_label.text = character_status_message
	elif is_player:
		character_footer_label.text = "C fecha. Podeis filtrar por escola, qualidade e prontidao de estudo."
	else:
		character_footer_label.text = "C fecha. Podeis filtrar as artes do companheiro."


func _matches_character_entry(school_name: String, quality_id: String, is_equipped: bool) -> bool:
	if character_school_filter_value != "all" and school_name != character_school_filter_value:
		return false
	if character_quality_filter_value != "all" and quality_id != character_quality_filter_value:
		return false
	if character_build_filter_value == "equipped" and not is_equipped:
		return false
	if character_build_filter_value == "unequipped" and is_equipped:
		return false
	return true


func _matches_manual_entry(item: Dictionary, learn_check: Dictionary) -> bool:
	var school_name: String = str(item.get("school", ""))
	var quality_id: String = str(item.get("quality", "white"))
	if character_school_filter_value != "all" and school_name != character_school_filter_value:
		return false
	if character_quality_filter_value != "all" and quality_id != character_quality_filter_value:
		return false

	match character_manual_filter_value:
		"studyable":
			return bool(learn_check.get("ok", false))
		"above_level":
			return int(GameState.get_player().get("level", 1)) < int(item.get("min_level", 1))
		_:
			return true


func _add_character_section(container: VBoxContainer, title: String) -> void:
	var label: Label = Label.new()
	label.add_theme_font_size_override("font_size", 20)
	label.text = title
	container.add_child(label)


func _add_character_hint(container: VBoxContainer, text: String) -> void:
	var label: Label = Label.new()
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.text = text
	container.add_child(label)


func _quality_name(quality_id: String) -> String:
	match quality_id:
		"green":
			return "Verde"
		"blue":
			return "Azul"
		"purple":
			return "Roxo"
		"gold":
			return "Dourado"
		"red":
			return "Vermelho"
		_:
			return "Branco"


func _quality_color(quality_id: String) -> Color:
	match quality_id:
		"white":
			return Color(0.32, 0.32, 0.3, 0.92)
		"green":
			return Color(0.18, 0.32, 0.22, 0.92)
		"blue":
			return Color(0.18, 0.28, 0.42, 0.92)
		"purple":
			return Color(0.3, 0.22, 0.42, 0.92)
		"gold":
			return Color(0.42, 0.34, 0.2, 0.92)
		"red":
			return Color(0.42, 0.2, 0.2, 0.92)
		_:
			return Color(0.2, 0.22, 0.24, 0.92)


func _status_marker_for_skill(skill: Dictionary) -> String:
	var status_effect: Dictionary = skill.get("status_effect", {})
	if status_effect.is_empty():
		return ""
	match str(status_effect.get("id", "")):
		"bleed":
			return " [B]"
		"stun":
			return " [S]"
		_:
			return ""


func _apply_rarity_button_theme(button: Button, quality_id: String) -> void:
	if quality_id.is_empty():
		return

	var base: Color = _quality_color(quality_id)
	var border: Color = base.lightened(0.2)
	button.add_theme_stylebox_override("normal", _make_shop_button_style(base, border))
	button.add_theme_stylebox_override("hover", _make_shop_button_style(base.lightened(0.08), border.lightened(0.08)))
	button.add_theme_stylebox_override("pressed", _make_shop_button_style(base.darkened(0.1), border.lightened(0.16)))
	button.add_theme_stylebox_override("disabled", _make_shop_button_style(base.darkened(0.35), base.darkened(0.1)))
	button.add_theme_color_override("font_color", Color("f8f3e4"))
	button.add_theme_color_override("font_hover_color", Color("fff7e3"))
	button.add_theme_color_override("font_pressed_color", Color("fff1c8"))
	button.add_theme_color_override("font_disabled_color", Color(0.62, 0.62, 0.62))


func _make_shop_button_style(fill: Color, border: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = 16
	style.corner_radius_top_right = 16
	style.corner_radius_bottom_right = 16
	style.corner_radius_bottom_left = 16
	style.content_margin_left = 12
	style.content_margin_top = 10
	style.content_margin_right = 12
	style.content_margin_bottom = 10
	return style


func _refresh_shop_panel() -> void:
	if shop_list == null:
		return

	for child in shop_list.get_children():
		child.queue_free()

	if current_shop_id.is_empty():
		shop_title_label.text = "Mercado"
		shop_status_label.text = "Nenhuma banca aberta."
		return

	var shop: Dictionary = shops.get(current_shop_id, {})
	if shop.is_empty():
		shop_title_label.text = "Mercado"
		shop_status_label.text = "A banca escolhida nao abriu porta."
		return

	shop_title_label.text = str(shop.get("name", "Mercado"))
	var greeting: String = str(shop.get("greeting", ""))
	shop_status_label.text = shop_status_message if not shop_status_message.is_empty() else greeting

	var shown_entries: int = 0
	for raw_entry in shop.get("entries", []):
		var entry: Dictionary = raw_entry
		if not _conditions_match(entry.get("conditions", {})):
			continue

		var item_id: String = str(entry.get("item_id", ""))
		var item: Dictionary = GameState.item_defs.get(item_id, {})
		if item.is_empty():
			continue

		var price: int = int(entry.get("price", int(item.get("value", 0))))
		var check: Dictionary = GameState.can_buy_item(item_id, price)
		var button: Button = Button.new()
		button.custom_minimum_size = Vector2(0.0, 72.0)
		button.text = "%s\n%d de oiro | %s" % [
			item.get("name", item_id),
			price,
			item.get("school", item.get("type", "mercadoria"))
		]
		var quality_id: String = str(item.get("quality", ""))
		_apply_rarity_button_theme(button, quality_id)
		button.tooltip_text = "%s\n%s" % [item.get("description", ""), check.get("reason", "")]
		button.disabled = not bool(check.get("ok", false))
		if not button.disabled:
			button.pressed.connect(_on_shop_item_pressed.bind(item_id, price))
		shop_list.add_child(button)
		shown_entries += 1

	if shown_entries == 0:
		var label: Label = Label.new()
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.text = "Nada tendes aqui para comprar, ou ainda nao vos foi aberto esse genero."
		shop_list.add_child(label)


func _on_shop_item_pressed(item_id: String, price: int) -> void:
	var result: Dictionary = GameState.buy_item(item_id, price)
	shop_status_message = str(result.get("reason", ""))
	_refresh_shop_panel()
	_refresh_inventory()


func _on_shop_close_button_pressed() -> void:
	shop_panel.visible = false


func _on_build_school_filter_item_selected(index: int) -> void:
	character_school_filter_value = str(build_school_filter.get_item_metadata(index))
	_refresh_character_panel()


func _on_build_quality_filter_item_selected(index: int) -> void:
	character_quality_filter_value = str(build_quality_filter.get_item_metadata(index))
	_refresh_character_panel()


func _on_build_state_filter_item_selected(index: int) -> void:
	character_build_filter_value = str(build_state_filter.get_item_metadata(index))
	_refresh_character_panel()


func _on_manual_state_filter_item_selected(index: int) -> void:
	character_manual_filter_value = str(manual_state_filter.get_item_metadata(index))
	_refresh_character_panel()


func _on_character_skill_button_pressed(skill_id: String, member_id: String) -> void:
	var result: Dictionary = GameState.toggle_member_skill_equip(member_id, skill_id)
	character_status_message = str(result.get("reason", ""))
	_refresh_character_panel()


func _on_character_passive_button_pressed(passive_id: String) -> void:
	var result: Dictionary = GameState.toggle_player_passive_equip(passive_id)
	character_status_message = str(result.get("reason", ""))
	_refresh_character_panel()


func _on_study_manual_button_pressed(item_id: String) -> void:
	var result: Dictionary = GameState.learn_manual(item_id)
	character_status_message = str(result.get("reason", ""))
	_refresh_character_panel()


func _on_character_close_button_pressed() -> void:
	character_panel.visible = false


func _on_primary_button_pressed() -> void:
	dialogue_panel.visible = false
	_run_actions(active_dialogue_actions)


func _on_secondary_button_pressed() -> void:
	dialogue_panel.visible = false


func _on_travel_close_button_pressed() -> void:
	travel_panel.visible = false


func _on_save_button_pressed() -> void:
	var saved: bool = SaveSystem.save_game()
	pause_label.text = "Menu de Pausa\n%s" % ("Jogo gravado no espaco 1." if saved else "Falhou a gravacao.")


func _on_load_button_pressed() -> void:
	var loaded: bool = SaveSystem.load_game()
	if loaded:
		player.position = GameState.get_scene_position(scene_id, default_spawn_position)
		_refresh_ui()
		_refresh_inventory()
		_refresh_shop_panel()
	pause_label.text = "Menu de Pausa\n%s" % ("Jogo carregado do espaco 1." if loaded else "Nao ha gravacao em memoria.")


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
