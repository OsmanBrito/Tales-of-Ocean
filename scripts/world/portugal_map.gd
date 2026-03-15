extends Control

const TRAVEL_MAP_PATH := "res://data/world/travel_map.json"
const BATTLE_SCENE_PATH := "res://scenes/combat/battle_scene.tscn"
const OCEAN_SUPPLIES_MAX := 100
const OCEAN_SHIP_MAX := 100
const OCEAN_EVENT_CHANCE := 0.22
const OCEAN_EVENT_LOG_LIMIT := 4
const OCEAN_WIND_TABLE := [
	{"id": "bonanca", "label": "Bonanca", "speed": 1.12, "weight": 0.22},
	{"id": "manso", "label": "Manso", "speed": 1.0, "weight": 0.34},
	{"id": "rijo", "label": "Rijo", "speed": 0.9, "weight": 0.2},
	{"id": "contrario", "label": "Contrario", "speed": 0.75, "weight": 0.16},
	{"id": "temporal", "label": "Temporal", "speed": 0.6, "weight": 0.08}
]
const OCEAN_EVENT_TABLE := [
	{"id": "vento_favoravel", "weight": 0.16},
	{"id": "vento_contrario", "weight": 0.12},
	{"id": "mar_bravo", "weight": 0.14},
	{"id": "pesca_farta", "weight": 0.14},
	{"id": "agua_podre", "weight": 0.14},
	{"id": "reparos_rapidos", "weight": 0.14},
	{"id": "vela_suspeita", "weight": 0.16}
]

@onready var destination_layer: Control = %DestinationLayer
@onready var status_label: Label = %StatusLabel
@onready var detail_label: Label = %DetailLabel
@onready var close_button: Button = %CloseButton
@onready var help_label: Label = %HelpLabel
@onready var sea_panel: PanelContainer = %SeaPanel
@onready var sea_stats_label: Label = %SeaStatsLabel
@onready var sea_event_label: Label = %SeaEventLabel

var destinations: Dictionary = {}
var routes: Array = []
var routes_by_id: Dictionary = {}
var adjacency: Dictionary = {}
var destination_buttons: Dictionary = {}
var current_node_id: String = "lisboa"
var ship_position: Vector2 = Vector2(430.0, 664.0)
var travel_state: Dictionary = {}
var hovered_destination_id: String = ""
var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()
	_load_map_data()
	_apply_theme()
	GameState.set_current_scene_path(GameState.PORTUGAL_MAP_SCENE)
	current_node_id = GameState.get_overworld_current_node_id()
	if not destinations.has(current_node_id):
		current_node_id = "lisboa"
		GameState.set_overworld_current_node(current_node_id)
	ship_position = _get_destination_position(current_node_id)
	status_label.text = "A nau aguarda ordem ao largo de %s." % destinations.get(current_node_id, {}).get("name", current_node_id.capitalize())

	travel_state = GameState.get_overworld_travel_state()
	var last_battle_outcome: String = GameState.consume_last_battle_outcome()
	if not travel_state.is_empty():
		ship_position = _vector_from_dict(travel_state.get("ship_position", {}))
		if last_battle_outcome == "victory" and bool(travel_state.get("paused_for_battle", false)):
			travel_state["paused_for_battle"] = false
			GameState.set_overworld_travel_state(travel_state)
			status_label.text = "Os corsarios foram batidos. A nau retoma a derrota."
	MusicManager.play_overworld_music()
	_update_detail_label()
	_rebuild_destination_buttons()
	_update_help_label()
	_update_sea_panel()
	queue_redraw()


func _process(delta: float) -> void:
	if travel_state.is_empty() or bool(travel_state.get("paused_for_battle", false)):
		return
	_advance_travel(delta)


func _draw() -> void:
	_draw_background()
	_draw_routes()
	_draw_destinations()
	_draw_ship()


func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey):
		return
	if not event.pressed or event.echo:
		return
	if event.keycode in [KEY_ESCAPE, KEY_M]:
		if not travel_state.is_empty():
			return
		_return_to_origin_scene()


func _apply_theme() -> void:
	for panel_name in ["StatusPanel", "LegendPanel", "SeaPanel"]:
		var panel: PanelContainer = get_node_or_null("%s" % panel_name)
		if panel == null:
			continue
		var style := StyleBoxFlat.new()
		style.bg_color = Color(0.1, 0.13, 0.16, 0.92)
		style.border_color = Color(0.84, 0.7, 0.39, 0.94)
		style.border_width_left = 2
		style.border_width_top = 2
		style.border_width_right = 2
		style.border_width_bottom = 2
		style.corner_radius_top_left = 18
		style.corner_radius_top_right = 18
		style.corner_radius_bottom_right = 18
		style.corner_radius_bottom_left = 18
		style.content_margin_left = 14
		style.content_margin_top = 12
		style.content_margin_right = 14
		style.content_margin_bottom = 12
		panel.add_theme_stylebox_override("panel", style)

	for label_name in ["TitleLabel", "StatusLabel", "DetailLabel", "HelpLabel", "LegendLabel", "SeaTitleLabel", "SeaStatsLabel", "SeaEventLabel"]:
		var label: Label = get_node_or_null("%%%s" % label_name)
		if label == null:
			continue
		label.add_theme_color_override("font_color", Color("f3e5c4"))
		label.add_theme_color_override("font_outline_color", Color(0.05, 0.07, 0.1, 0.82))
		label.add_theme_constant_override("outline_size", 1)

	close_button.add_theme_color_override("font_color", Color("f7ecd0"))


func _load_map_data() -> void:
	destinations.clear()
	routes.clear()
	routes_by_id.clear()
	adjacency.clear()

	var parsed: Variant = GameState.load_json_data(TRAVEL_MAP_PATH)
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Expected dictionary in %s" % TRAVEL_MAP_PATH)
		return

	for raw_destination in parsed.get("destinations", []):
		var destination: Dictionary = raw_destination
		destinations[str(destination.get("id", ""))] = destination

	for raw_route in parsed.get("routes", []):
		var route: Dictionary = raw_route
		routes.append(route)
		routes_by_id[str(route.get("id", ""))] = route
		var from_id: String = str(route.get("from", ""))
		var to_id: String = str(route.get("to", ""))
		if not adjacency.has(from_id):
			adjacency[from_id] = []
		if not adjacency.has(to_id):
			adjacency[to_id] = []
		adjacency[from_id].append(route.get("id", ""))
		adjacency[to_id].append(route.get("id", ""))


func _draw_background() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.08, 0.16, 0.24))
	draw_rect(Rect2(120.0, 70.0, 940.0, 930.0), Color(0.9, 0.84, 0.7))
	draw_rect(Rect2(94.0, 44.0, 992.0, 982.0), Color(0.75, 0.63, 0.39, 0.18), false, 4.0)

	var land := PackedVector2Array([
		Vector2(378.0, 132.0),
		Vector2(520.0, 124.0),
		Vector2(640.0, 164.0),
		Vector2(736.0, 248.0),
		Vector2(760.0, 346.0),
		Vector2(784.0, 460.0),
		Vector2(736.0, 566.0),
		Vector2(700.0, 666.0),
		Vector2(646.0, 760.0),
		Vector2(560.0, 856.0),
		Vector2(460.0, 926.0),
		Vector2(356.0, 950.0),
		Vector2(280.0, 914.0),
		Vector2(250.0, 838.0),
		Vector2(292.0, 738.0),
		Vector2(326.0, 668.0),
		Vector2(344.0, 582.0),
		Vector2(334.0, 474.0),
		Vector2(346.0, 386.0),
		Vector2(334.0, 280.0),
		Vector2(350.0, 192.0)
	])
	draw_colored_polygon(land, Color(0.73, 0.67, 0.54))
	draw_polyline(land, Color(0.45, 0.34, 0.21), 4.0, true)

	var andaluz := PackedVector2Array([
		Vector2(674.0, 826.0),
		Vector2(808.0, 784.0),
		Vector2(962.0, 790.0),
		Vector2(1018.0, 848.0),
		Vector2(1002.0, 900.0),
		Vector2(888.0, 910.0),
		Vector2(756.0, 904.0),
		Vector2(680.0, 872.0)
	])
	draw_colored_polygon(andaluz, Color(0.72, 0.66, 0.53))
	draw_polyline(andaluz, Color(0.45, 0.34, 0.21), 4.0, true)

	var magrebe := PackedVector2Array([
		Vector2(684.0, 930.0),
		Vector2(820.0, 916.0),
		Vector2(978.0, 922.0),
		Vector2(1030.0, 972.0),
		Vector2(1030.0, 1000.0),
		Vector2(676.0, 1000.0)
	])
	draw_colored_polygon(magrebe, Color(0.68, 0.6, 0.47))
	draw_polyline(magrebe, Color(0.45, 0.34, 0.21), 4.0, true)

	var river := PackedVector2Array([
		Vector2(416.0, 664.0),
		Vector2(498.0, 628.0),
		Vector2(558.0, 602.0),
		Vector2(604.0, 580.0),
		Vector2(632.0, 564.0)
	])
	draw_polyline(river, Color(0.23, 0.46, 0.62), 5.0, false)
	draw_line(Vector2(712.0, 908.0), Vector2(972.0, 918.0), Color(0.18, 0.33, 0.47), 6.0)

	var compass_center := Vector2(920.0, 176.0)
	draw_circle(compass_center, 62.0, Color(0.12, 0.15, 0.18, 0.42))
	draw_arc(compass_center, 62.0, 0.0, TAU, 28, Color(0.9, 0.8, 0.56), 3.0)
	draw_line(compass_center + Vector2(0.0, -48.0), compass_center + Vector2(0.0, 48.0), Color(0.94, 0.87, 0.65), 3.0)
	draw_line(compass_center + Vector2(-48.0, 0.0), compass_center + Vector2(48.0, 0.0), Color(0.94, 0.87, 0.65), 3.0)
	draw_string(ThemeDB.fallback_font, compass_center + Vector2(-8.0, -58.0), "N", HORIZONTAL_ALIGNMENT_LEFT, -1, 28, Color(0.96, 0.92, 0.78))
	draw_string(ThemeDB.fallback_font, Vector2(184.0, 118.0), "Carta do Reino e do Estreito", HORIZONTAL_ALIGNMENT_LEFT, -1, 38, Color(0.26, 0.2, 0.12))
	draw_string(ThemeDB.fallback_font, Vector2(186.0, 150.0), "Do Porto a Ceuta, largai com tento: o mar alto cobra erro e coragem.", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color(0.31, 0.24, 0.18))


func _draw_routes() -> void:
	for raw_route in routes:
		var route: Dictionary = raw_route
		var points: PackedVector2Array = _points_from_route(route)
		if points.size() < 2:
			continue

		var from_id: String = str(route.get("from", ""))
		var to_id: String = str(route.get("to", ""))
		var from_unlocked: bool = _destination_unlocked(destinations.get(from_id, {}))
		var to_unlocked: bool = _destination_unlocked(destinations.get(to_id, {}))
		var route_color: Color = Color(0.34, 0.47, 0.55, 0.55)
		if from_unlocked and to_unlocked:
			route_color = Color(0.84, 0.72, 0.38, 0.86)
		draw_polyline(points, route_color, 4.0, false)

		if not travel_state.is_empty():
			var active_route_ids: Array = travel_state.get("route_ids", [])
			if active_route_ids.has(route.get("id", "")):
				draw_polyline(points, Color(0.96, 0.88, 0.58, 0.95), 6.0, false)


func _draw_destinations() -> void:
	for destination_id in destinations.keys():
		var destination: Dictionary = destinations[destination_id]
		var position: Vector2 = _get_destination_position(destination_id)
		var color: Color = Color(0.43, 0.3, 0.18)
		if _destination_unlocked(destination):
			color = Color(0.81, 0.66, 0.32)
		if destination_id == current_node_id:
			color = Color(0.24, 0.62, 0.75)
		draw_circle(position, 11.0, color)
		draw_circle(position, 19.0, Color(color.r, color.g, color.b, 0.18))


func _draw_ship() -> void:
	var hull := PackedVector2Array([
		ship_position + Vector2(-16.0, 12.0),
		ship_position + Vector2(16.0, 12.0),
		ship_position + Vector2(10.0, 24.0),
		ship_position + Vector2(-10.0, 24.0)
	])
	draw_colored_polygon(hull, Color(0.28, 0.19, 0.11))
	draw_line(ship_position + Vector2(0.0, 12.0), ship_position + Vector2(0.0, -14.0), Color(0.33, 0.22, 0.14), 3.0)
	var sail := PackedVector2Array([
		ship_position + Vector2(0.0, -10.0),
		ship_position + Vector2(0.0, 10.0),
		ship_position + Vector2(-18.0, 2.0)
	])
	draw_colored_polygon(sail, Color(0.96, 0.94, 0.84))


func _rebuild_destination_buttons() -> void:
	for child in destination_layer.get_children():
		child.queue_free()
	destination_buttons.clear()

	for destination_id in destinations.keys():
		var destination: Dictionary = destinations[destination_id]
		var button := Button.new()
		button.custom_minimum_size = Vector2(132.0, 46.0)
		button.text = str(destination.get("name", "Destino"))
		button.position = _get_destination_position(destination_id) + Vector2(-66.0, -58.0)
		button.disabled = travel_state.size() > 0
		var unlocked: bool = _destination_unlocked(destination)
		if destination_id == current_node_id:
			button.disabled = true
			button.text += "\n(Aqui)"
		elif not unlocked:
			button.disabled = true
			button.text += "\n(Vedado)"
		elif _find_route_chain(current_node_id, destination_id).is_empty():
			button.disabled = true
			button.text += "\n(Sem rota)"
		else:
			button.pressed.connect(_on_destination_button_pressed.bind(destination_id))
		button.mouse_entered.connect(_on_destination_hovered.bind(destination_id))
		button.mouse_exited.connect(_on_destination_unhovered.bind(destination_id))
		destination_layer.add_child(button)
		destination_buttons[destination_id] = button


func _destination_unlocked(destination: Dictionary) -> bool:
	return _conditions_match(destination.get("conditions", {}))


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


func _find_route_chain(from_id: String, to_id: String) -> Array[String]:
	if from_id == to_id:
		return []
	if not adjacency.has(from_id) or not adjacency.has(to_id):
		return []

	var frontier: Array[String] = [from_id]
	var visited: Dictionary = {from_id: true}
	var parent_node: Dictionary = {}
	var parent_route: Dictionary = {}

	while not frontier.is_empty():
		var current_id: String = frontier.pop_front()
		if current_id == to_id:
			break
		for raw_route_id in adjacency.get(current_id, []):
			var route_id: String = str(raw_route_id)
			var route: Dictionary = routes_by_id.get(route_id, {})
			if route.is_empty():
				continue
			var next_id: String = ""
			if str(route.get("from", "")) == current_id:
				next_id = str(route.get("to", ""))
			elif str(route.get("to", "")) == current_id:
				next_id = str(route.get("from", ""))
			if next_id.is_empty():
				continue
			if visited.has(next_id):
				continue
			if not _destination_unlocked(destinations.get(next_id, {})):
				continue
			visited[next_id] = true
			parent_node[next_id] = current_id
			parent_route[next_id] = route_id
			frontier.append(next_id)

	if not visited.has(to_id):
		return []

	var chain: Array[String] = []
	var cursor: String = to_id
	while cursor != from_id:
		chain.push_front(str(parent_route.get(cursor, "")))
		cursor = str(parent_node.get(cursor, from_id))
	return chain


func _begin_travel(destination_id: String) -> void:
	var route_chain: Array[String] = _find_route_chain(current_node_id, destination_id)
	if route_chain.is_empty():
		status_label.text = "Nao se conhece ainda rota segura para esse destino."
		return

	var origin_scene: String = GameState.get_overworld_origin_scene()
	var origin_node_id: String = current_node_id
	var path_points: Array[Dictionary] = []
	var encounter_tables: Array = []
	var encounter_chance_total: float = 0.0
	var speed_multiplier: float = 1.0
	var travel_kind: String = ""
	var route_descriptions: Array[String] = []
	var current_chain_node_id: String = current_node_id
	for route_id in route_chain:
		var route: Dictionary = routes_by_id.get(route_id, {})
		var reversed: bool = str(route.get("to", "")) == current_chain_node_id
		var route_points: Array = route.get("points", []).duplicate(true)
		if reversed:
			route_points.reverse()
		for i in range(route_points.size()):
			if not path_points.is_empty() and i == 0:
				continue
			path_points.append(route_points[i])
		for raw_encounter in route.get("encounters", []):
			encounter_tables.append(raw_encounter)
		encounter_chance_total += float(route.get("encounter_chance", 0.0))
		speed_multiplier = min(speed_multiplier, float(route.get("speed_multiplier", 1.0)))
		if travel_kind.is_empty() and str(route.get("travel_kind", "")).is_empty() == false:
			travel_kind = str(route.get("travel_kind", ""))
		var route_description: String = str(route.get("description", ""))
		if not route_description.is_empty() and not route_descriptions.has(route_description):
			route_descriptions.append(route_description)
		current_chain_node_id = str(route.get("from", "")) if reversed else str(route.get("to", ""))

	travel_state = {
		"origin_scene": origin_scene,
		"origin_node_id": origin_node_id,
		"destination_id": destination_id,
		"destination_scene": destinations.get(destination_id, {}).get("scene", origin_scene),
		"route_ids": route_chain,
		"path_points": path_points,
		"route_index": 1,
		"ship_position": path_points[0],
		"encounter_table": encounter_tables,
		"encounter_chance": encounter_chance_total / max(1, route_chain.size()),
		"encounter_bonus": 0.0,
		"speed_multiplier": speed_multiplier,
		"travel_kind": travel_kind,
		"route_descriptions": route_descriptions,
		"steps_taken": 0,
		"paused_for_battle": false
	}
	ship_position = _vector_from_dict(path_points[0])
	_prepare_ocean_for_departure()
	GameState.set_overworld_travel_state(travel_state)
	status_label.text = "Largastes de %s rumo a %s." % [
		destinations.get(origin_node_id, {}).get("name", origin_node_id.capitalize()),
		destinations.get(destination_id, {}).get("name", destination_id.capitalize())
	]
	if travel_kind == "mar_alto":
		status_label.text += " Travessia de mar alto."
	hovered_destination_id = destination_id
	_update_detail_label()
	_rebuild_destination_buttons()
	_update_help_label()
	_update_sea_panel()
	queue_redraw()


func _advance_travel(delta: float) -> void:
	var path_points: Array = travel_state.get("path_points", [])
	var route_index: int = int(travel_state.get("route_index", 0))
	if route_index >= path_points.size():
		_arrive_destination()
		return

	var target_position: Vector2 = _vector_from_dict(path_points[route_index])
	var travel_speed: float = 150.0 * float(travel_state.get("speed_multiplier", 1.0))
	if str(travel_state.get("travel_kind", "")) == "mar_alto":
		_ensure_ocean_state()
		travel_speed *= _get_ocean_speed_factor()
	ship_position = ship_position.move_toward(target_position, travel_speed * delta)
	travel_state["ship_position"] = {"x": ship_position.x, "y": ship_position.y}
	GameState.set_overworld_travel_state(travel_state)
	queue_redraw()

	if ship_position.distance_to(target_position) > 1.0:
		return

	ship_position = target_position
	travel_state["ship_position"] = {"x": ship_position.x, "y": ship_position.y}
	travel_state["route_index"] = route_index + 1
	travel_state["steps_taken"] = int(travel_state.get("steps_taken", 0)) + 1
	GameState.set_overworld_travel_state(travel_state)

	if int(travel_state.get("route_index", 0)) >= path_points.size():
		_arrive_destination()
		return

	if str(travel_state.get("travel_kind", "")) == "mar_alto":
		if _apply_ocean_step():
			return

	if _maybe_trigger_encounter():
		return

	status_label.text = "A nau segue a derrota de %s." % destinations.get(str(travel_state.get("destination_id", "")), {}).get("name", "destino")
	_update_sea_panel()
	queue_redraw()


func _maybe_trigger_encounter() -> bool:
	if int(travel_state.get("steps_taken", 0)) < 2:
		return false
	var encounter_table: Array = travel_state.get("encounter_table", [])
	if encounter_table.is_empty():
		return false
	var encounter_chance: float = float(travel_state.get("encounter_chance", 0.0)) + float(travel_state.get("encounter_bonus", 0.0))
	travel_state["encounter_bonus"] = 0.0
	if rng.randf() > encounter_chance:
		return false

	var encounter_index: int = rng.randi_range(0, encounter_table.size() - 1)
	var encounter: Dictionary = encounter_table[encounter_index].duplicate(true)
	encounter["return_scene"] = GameState.PORTUGAL_MAP_SCENE
	encounter["return_button_text"] = "Retomar derrota"
	encounter["defeat_return_scene"] = str(travel_state.get("origin_scene", "res://scenes/world/lisboa.tscn"))
	encounter["overworld_encounter"] = true
	encounter["origin_node_id"] = str(travel_state.get("origin_node_id", current_node_id))

	travel_state["paused_for_battle"] = true
	GameState.set_overworld_travel_state(travel_state)
	GameState.current_battle_context = encounter
	get_tree().change_scene_to_file(BATTLE_SCENE_PATH)
	return true


func _arrive_destination() -> void:
	var destination_id: String = str(travel_state.get("destination_id", current_node_id))
	var destination_scene: String = str(travel_state.get("destination_scene", GameState.get_overworld_origin_scene()))
	var ocean: Dictionary = travel_state.get("ocean", {})
	if not ocean.is_empty():
		GameState.set_ocean_state(ocean)
	current_node_id = destination_id
	GameState.set_overworld_current_node(destination_id)
	GameState.set_overworld_origin_scene(destination_scene)
	GameState.clear_overworld_travel_state()
	travel_state = {}
	status_label.text = "Aportastes a %s." % destinations.get(destination_id, {}).get("name", destination_id.capitalize())
	_update_sea_panel()
	queue_redraw()
	get_tree().change_scene_to_file(destination_scene)


func _return_to_origin_scene() -> void:
	var origin_scene: String = GameState.get_overworld_origin_scene()
	get_tree().change_scene_to_file(origin_scene)


func _update_detail_label() -> void:
	var destination_id: String = hovered_destination_id if not hovered_destination_id.is_empty() else current_node_id
	var destination: Dictionary = destinations.get(destination_id, {})
	if destination.is_empty():
		detail_label.text = "A carta aguarda destino."
		return

	var lines: Array[String] = [
		str(destination.get("name", destination_id.capitalize())),
		str(destination.get("description", ""))
	]
	if destination_id == current_node_id and travel_state.is_empty():
		lines.append("Porto presente. Escolhei outro ancoradouro para largar.")
	elif not _destination_unlocked(destination):
		lines.append("Ainda nao tendes carta ou feito bastante para demandar este rumo.")
	elif travel_state.is_empty():
		var route_chain: Array[String] = _find_route_chain(current_node_id, destination_id)
		if route_chain.is_empty():
			lines.append("Nao se conhece ainda rota segura para este destino.")
		else:
			lines.append("Rotas: %s" % " -> ".join(_route_labels(route_chain)))
			var descriptions: Array[String] = _route_descriptions(route_chain)
			for description in descriptions:
				lines.append(description)
			if _route_chain_has_kind(route_chain, "mar_alto"):
				lines.append("Travessia de mar alto: ha mais risco de corso, emboscada e fogo no costado.")
			else:
				lines.append("Recontros de corso e salteio podem surgir em viagem.")
	else:
		lines.append("A viagem esta em curso. Mantende rumo e tento.")
		if str(travel_state.get("travel_kind", "")) == "mar_alto":
			lines.append("Mar alto: a rota e mais longa, mais lenta e mais dada a corso pesado.")
	detail_label.text = "\n".join(lines)


func _update_help_label() -> void:
	if travel_state.is_empty():
		help_label.text = "Escolhei um porto na carta ou carregai Esc/M para tornar ao local presente."
		close_button.text = "Tornar a %s" % destinations.get(current_node_id, {}).get("name", current_node_id.capitalize())
		close_button.disabled = false
		_update_sea_panel()
		return
	if str(travel_state.get("travel_kind", "")) == "mar_alto":
		help_label.text = "A nau segue em mar alto. O levante, o corso e o fogo de bordo fazem esta travessia mais dura."
	else:
		help_label.text = "A nau segue a derrota. Em viagem podem surgir corsarios, salteadores e outros homens de mau viver."
	close_button.disabled = true
	_update_sea_panel()


func _ensure_ocean_state() -> void:
	if str(travel_state.get("travel_kind", "")) != "mar_alto":
		return
	var ocean: Dictionary = travel_state.get("ocean", {})
	if ocean.is_empty():
		ocean = GameState.get_ocean_state()
		if ocean.is_empty():
			ocean = _build_default_ocean_state()
			GameState.set_ocean_state(ocean)
		travel_state["ocean"] = ocean
		GameState.set_overworld_travel_state(travel_state)


func _prepare_ocean_for_departure() -> void:
	if str(travel_state.get("travel_kind", "")) != "mar_alto":
		return
	var ocean: Dictionary = GameState.get_ocean_state()
	if ocean.is_empty():
		ocean = _build_default_ocean_state()
	ocean["days"] = 0
	ocean["event_log"] = []
	_roll_wind(ocean, true)
	travel_state["ocean"] = ocean
	GameState.set_ocean_state(ocean)


func _build_default_ocean_state() -> Dictionary:
	var ocean := {
		"supplies": OCEAN_SUPPLIES_MAX,
		"supplies_max": OCEAN_SUPPLIES_MAX,
		"ship": OCEAN_SHIP_MAX,
		"ship_max": OCEAN_SHIP_MAX,
		"wind": "manso",
		"wind_label": "Manso",
		"wind_speed": 1.0,
		"days": 0,
		"last_event": "A nau toma o mar alto.",
		"event_log": []
	}
	_roll_wind(ocean, true)
	return ocean


func _roll_wind(ocean: Dictionary, announce: bool = false) -> void:
	var pick: float = rng.randf()
	var cumulative: float = 0.0
	var chosen: Dictionary = {}
	for entry in OCEAN_WIND_TABLE:
		cumulative += float(entry.get("weight", 0.0))
		if pick <= cumulative:
			chosen = entry
			break
	if chosen.is_empty():
		chosen = OCEAN_WIND_TABLE[OCEAN_WIND_TABLE.size() - 1]
	ocean["wind"] = str(chosen.get("id", "manso"))
	ocean["wind_label"] = str(chosen.get("label", "Manso"))
	ocean["wind_speed"] = float(chosen.get("speed", 1.0))
	if announce:
		ocean["last_event"] = "O vento vira para %s." % ocean.get("wind_label", "Manso")


func _set_wind_by_id(ocean: Dictionary, wind_id: String) -> void:
	for entry in OCEAN_WIND_TABLE:
		if str(entry.get("id", "")) == wind_id:
			ocean["wind"] = str(entry.get("id", wind_id))
			ocean["wind_label"] = str(entry.get("label", wind_id.capitalize()))
			ocean["wind_speed"] = float(entry.get("speed", 1.0))
			return


func _get_ocean_speed_factor() -> float:
	var ocean: Dictionary = travel_state.get("ocean", {})
	if ocean.is_empty():
		return 1.0
	var wind_factor: float = float(ocean.get("wind_speed", 1.0))
	var ship_max: float = float(ocean.get("ship_max", OCEAN_SHIP_MAX))
	var ship_ratio: float = 1.0 if ship_max <= 0.0 else float(ocean.get("ship", ship_max)) / ship_max
	ship_ratio = clampf(ship_ratio, 0.0, 1.0)
	var ship_factor: float = lerpf(0.6, 1.0, ship_ratio)
	var supply_factor: float = 0.85 if int(ocean.get("supplies", 0)) <= 0 else 1.0
	return wind_factor * ship_factor * supply_factor


func _apply_ocean_step() -> bool:
	var ocean: Dictionary = travel_state.get("ocean", {})
	if ocean.is_empty():
		ocean = _build_default_ocean_state()

	ocean["days"] = int(ocean.get("days", 0)) + 1
	var supplies: int = int(ocean.get("supplies", 0))
	var wind_id: String = str(ocean.get("wind", "manso"))
	var extra_use: int = 1 if wind_id in ["temporal", "contrario"] else 0
	supplies = max(0, supplies - 1 - extra_use)
	ocean["supplies"] = supplies

	if supplies == 0:
		ocean["ship"] = max(0, int(ocean.get("ship", OCEAN_SHIP_MAX)) - 2)
		if int(ocean.get("days", 0)) % 2 == 0:
			_push_ocean_event(ocean, "Mantimentos em falta: a tripulacao enfraquece e o casco sofre.")

	if rng.randf() < OCEAN_EVENT_CHANCE:
		var event_text: String = _trigger_ocean_event(ocean)
		if not event_text.is_empty():
			_push_ocean_event(ocean, event_text)

	travel_state["ocean"] = ocean
	GameState.set_overworld_travel_state(travel_state)
	GameState.set_ocean_state(ocean)

	if int(ocean.get("ship", 0)) <= 0:
		_force_return_to_origin("A nau quebra-se no mar alto. So resta arribar ao porto seguro.")
		return true

	_update_sea_panel()
	return false


func _trigger_ocean_event(ocean: Dictionary) -> String:
	var pick: float = rng.randf()
	var cumulative: float = 0.0
	var chosen_id: String = ""
	for entry in OCEAN_EVENT_TABLE:
		cumulative += float(entry.get("weight", 0.0))
		if pick <= cumulative:
			chosen_id = str(entry.get("id", ""))
			break
	if chosen_id.is_empty() and not OCEAN_EVENT_TABLE.is_empty():
		chosen_id = str(OCEAN_EVENT_TABLE[OCEAN_EVENT_TABLE.size() - 1].get("id", ""))
	return _apply_ocean_event(chosen_id, ocean)


func _apply_ocean_event(event_id: String, ocean: Dictionary) -> String:
	match event_id:
		"vento_favoravel":
			_set_wind_by_id(ocean, "bonanca")
			return "Vento de feicao: a nau ganha folego e o pano enche."
		"vento_contrario":
			_set_wind_by_id(ocean, "contrario")
			return "Vento contrario: a proa range e o rumo custa."
		"mar_bravo":
			var damage: int = rng.randi_range(6, 12)
			ocean["ship"] = max(0, int(ocean.get("ship", OCEAN_SHIP_MAX)) - damage)
			return "Mar bravo quebra a cinta: perdeis %d de casco." % damage
		"pesca_farta":
			var gain: int = rng.randi_range(8, 14)
			var supplies_max: int = int(ocean.get("supplies_max", OCEAN_SUPPLIES_MAX))
			ocean["supplies"] = min(supplies_max, int(ocean.get("supplies", 0)) + gain)
			return "Pesca farta no alto: +%d mantimentos." % gain
		"agua_podre":
			var loss: int = rng.randi_range(8, 14)
			ocean["supplies"] = max(0, int(ocean.get("supplies", 0)) - loss)
			return "Agua podre no barril: perdeis %d mantimentos." % loss
		"reparos_rapidos":
			var repair: int = rng.randi_range(6, 12)
			var ship_max: int = int(ocean.get("ship_max", OCEAN_SHIP_MAX))
			ocean["ship"] = min(ship_max, int(ocean.get("ship", ship_max)) + repair)
			return "Carpinteiros firmam as tabuas: +%d casco." % repair
		"vela_suspeita":
			travel_state["encounter_bonus"] = float(travel_state.get("encounter_bonus", 0.0)) + 0.12
			return "Vela suspeita no horizonte: mantenham as armas a mao."
		_:
			return ""


func _push_ocean_event(ocean: Dictionary, event_text: String) -> void:
	ocean["last_event"] = event_text
	var log: Array = ocean.get("event_log", [])
	log.append(event_text)
	if log.size() > OCEAN_EVENT_LOG_LIMIT:
		log = log.slice(log.size() - OCEAN_EVENT_LOG_LIMIT, log.size())
	ocean["event_log"] = log


func _force_return_to_origin(reason: String) -> void:
	var origin_scene: String = str(travel_state.get("origin_scene", GameState.get_overworld_origin_scene()))
	travel_state = {}
	GameState.clear_overworld_travel_state()
	status_label.text = reason
	_update_sea_panel()
	queue_redraw()
	get_tree().change_scene_to_file(origin_scene)


func _update_sea_panel() -> void:
	if sea_panel == null:
		return
	if travel_state.is_empty() or str(travel_state.get("travel_kind", "")) != "mar_alto":
		sea_panel.visible = false
		return

	sea_panel.visible = true
	var ocean: Dictionary = travel_state.get("ocean", {})
	if ocean.is_empty():
		ocean = _build_default_ocean_state()
		travel_state["ocean"] = ocean
		GameState.set_overworld_travel_state(travel_state)
		GameState.set_ocean_state(ocean)

	var supplies: int = int(ocean.get("supplies", 0))
	var supplies_max: int = int(ocean.get("supplies_max", OCEAN_SUPPLIES_MAX))
	var ship: int = int(ocean.get("ship", 0))
	var ship_max: int = int(ocean.get("ship_max", OCEAN_SHIP_MAX))
	var wind_label: String = str(ocean.get("wind_label", "Manso"))
	var days: int = int(ocean.get("days", 0))
	var ship_ratio: float = 1.0 if ship_max <= 0 else float(ship) / float(ship_max)
	var ship_state: String = "Firme"
	if ship_ratio < 0.25:
		ship_state = "A romper"
	elif ship_ratio < 0.45:
		ship_state = "Ferido"
	elif ship_ratio < 0.7:
		ship_state = "Cansado"
	elif ship_ratio < 0.9:
		ship_state = "Seguro"

	sea_stats_label.text = "Mantimentos: %d/%d\nEstado da Nau: %s (%d%%)\nVento: %s\nDias no mar: %d" % [
		supplies,
		supplies_max,
		ship_state,
		int(round(ship_ratio * 100.0)),
		wind_label,
		days
	]
	sea_event_label.text = str(ocean.get("last_event", "Sem travessia longa em curso."))


func _route_labels(route_chain: Array[String]) -> Array[String]:
	var labels: Array[String] = []
	for route_id in route_chain:
		var route: Dictionary = routes_by_id.get(route_id, {})
		labels.append(str(route.get("label", route_id)))
	return labels


func _route_descriptions(route_chain: Array[String]) -> Array[String]:
	var descriptions: Array[String] = []
	for route_id in route_chain:
		var route: Dictionary = routes_by_id.get(route_id, {})
		var description: String = str(route.get("description", ""))
		if not description.is_empty() and not descriptions.has(description):
			descriptions.append(description)
	return descriptions


func _route_chain_has_kind(route_chain: Array[String], kind: String) -> bool:
	for route_id in route_chain:
		var route: Dictionary = routes_by_id.get(route_id, {})
		if str(route.get("travel_kind", "")) == kind:
			return true
	return false


func _points_from_route(route: Dictionary) -> PackedVector2Array:
	var points := PackedVector2Array()
	for raw_point in route.get("points", []):
		points.append(_vector_from_dict(raw_point))
	return points


func _vector_from_dict(value: Dictionary) -> Vector2:
	return Vector2(float(value.get("x", 0.0)), float(value.get("y", 0.0)))


func _get_destination_position(destination_id: String) -> Vector2:
	var destination: Dictionary = destinations.get(destination_id, {})
	return _vector_from_dict(destination.get("map_position", {}))


func _on_destination_button_pressed(destination_id: String) -> void:
	if destination_id == current_node_id or not travel_state.is_empty():
		return
	_begin_travel(destination_id)


func _on_destination_hovered(destination_id: String) -> void:
	hovered_destination_id = destination_id
	_update_detail_label()


func _on_destination_unhovered(destination_id: String) -> void:
	if hovered_destination_id == destination_id:
		hovered_destination_id = ""
		_update_detail_label()


func _on_close_button_pressed() -> void:
	if not travel_state.is_empty():
		return
	_return_to_origin_scene()
