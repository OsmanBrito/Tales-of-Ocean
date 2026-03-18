extends Control

const TRAVEL_MAP_PATH := "res://data/world/travel_map.json"
const BATTLE_SCENE_PATH := "res://scenes/combat/battle_scene.tscn"
const OCEAN_SUPPLIES_MAX := 100
const OCEAN_SHIP_MAX := 100
const OCEAN_EVENT_CHANCE := 0.22
const OCEAN_EVENT_LOG_LIMIT := 4
const SEA_ENCOUNTER_POINT_LIMIT := 3
const SEA_ENCOUNTER_INTERACT_RADIUS := 56.0
const SEA_ENCOUNTER_HINT_RADIUS := 180.0
const SEA_ENCOUNTER_SPAWN_RADIUS_MIN := 150.0
const SEA_ENCOUNTER_SPAWN_RADIUS_MAX := 290.0
const SEA_ENCOUNTER_TTL_MIN := 3
const SEA_ENCOUNTER_TTL_MAX := 5
const WORLD_WIDTH := 2600.0
const WORLD_HEIGHT := 1080.0
const MAP_VIEW_RECT := Rect2(94.0, 44.0, 992.0, 982.0)
const MAP_CENTER := Vector2(590.0, 535.0)
const CAMERA_SMOOTH := 5.2
const SHIP_BASE_SPEED := 228.0
const SHIP_ACCELERATION := 4.4
const SHIP_FRICTION := 3.8
const SAIL_STEP_DISTANCE := 92.0
const DOCK_RADIUS := 56.0
const DOCK_HINT_RADIUS := 150.0
const RIVER_WIDTH := 48.0
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
const DESTINATION_LAYOUT_OVERRIDES := {
	"lisboa": {
		"map_position": Vector2(1334.0, 666.0),
		"dock_position": Vector2(1202.0, 690.0),
		"label_offset": Vector2(-40.0, -54.0)
	},
	"porto": {
		"map_position": Vector2(1324.0, 382.0),
		"dock_position": Vector2(1198.0, 392.0),
		"label_offset": Vector2(-36.0, -58.0)
	},
	"sagres": {
		"map_position": Vector2(1152.0, 894.0),
		"dock_position": Vector2(1112.0, 916.0),
		"label_offset": Vector2(-28.0, -54.0)
	},
	"tomar": {
		"map_position": Vector2(1518.0, 560.0),
		"dock_position": Vector2(1490.0, 584.0),
		"label_offset": Vector2(-34.0, -58.0)
	},
	"ceuta": {
		"map_position": Vector2(1798.0, 936.0),
		"dock_position": Vector2(1760.0, 914.0),
		"label_offset": Vector2(-28.0, -56.0)
	},
	"ilha_bruma": {
		"map_position": Vector2(980.0, 944.0),
		"dock_position": Vector2(980.0, 944.0),
		"label_offset": Vector2(-52.0, -54.0)
	},
	"ilha_sargaco": {
		"map_position": Vector2(1210.0, 970.0),
		"dock_position": Vector2(1210.0, 970.0),
		"label_offset": Vector2(-58.0, -54.0)
	},
	"terra_vera_cruz": {
		"map_position": Vector2(242.0, 612.0),
		"dock_position": Vector2(456.0, 650.0),
		"label_offset": Vector2(-68.0, -62.0)
	}
}
const PORTUGAL_LAND_POINTS := [
	Vector2(1278.0, 132.0),
	Vector2(1420.0, 124.0),
	Vector2(1540.0, 164.0),
	Vector2(1636.0, 248.0),
	Vector2(1660.0, 346.0),
	Vector2(1684.0, 460.0),
	Vector2(1636.0, 566.0),
	Vector2(1600.0, 666.0),
	Vector2(1546.0, 760.0),
	Vector2(1460.0, 856.0),
	Vector2(1360.0, 926.0),
	Vector2(1256.0, 950.0),
	Vector2(1180.0, 914.0),
	Vector2(1150.0, 838.0),
	Vector2(1192.0, 738.0),
	Vector2(1226.0, 668.0),
	Vector2(1244.0, 582.0),
	Vector2(1234.0, 474.0),
	Vector2(1246.0, 386.0),
	Vector2(1234.0, 280.0),
	Vector2(1250.0, 192.0)
]
const ANDALUZ_POINTS := [
	Vector2(1574.0, 826.0),
	Vector2(1708.0, 784.0),
	Vector2(1862.0, 790.0),
	Vector2(1918.0, 848.0),
	Vector2(1902.0, 900.0),
	Vector2(1788.0, 910.0),
	Vector2(1656.0, 904.0),
	Vector2(1580.0, 872.0)
]
const MAGREBE_POINTS := [
	Vector2(1584.0, 930.0),
	Vector2(1720.0, 916.0),
	Vector2(1878.0, 922.0),
	Vector2(1930.0, 972.0),
	Vector2(1930.0, 1000.0),
	Vector2(1576.0, 1000.0)
]
const VERA_CRUZ_POINTS := [
	Vector2(64.0, 468.0),
	Vector2(182.0, 436.0),
	Vector2(330.0, 470.0),
	Vector2(420.0, 542.0),
	Vector2(398.0, 632.0),
	Vector2(300.0, 724.0),
	Vector2(154.0, 758.0),
	Vector2(54.0, 694.0),
	Vector2(28.0, 586.0)
]
const TEJO_RIVER_POINTS := [
	Vector2(1298.0, 684.0),
	Vector2(1378.0, 648.0),
	Vector2(1444.0, 620.0),
	Vector2(1490.0, 596.0),
	Vector2(1522.0, 580.0)
]
const COASTAL_ROUTE_IDS := [
	"rota_lisboa_porto",
	"rota_lisboa_sagres",
	"rota_porto_sagres",
	"rota_lisboa_tomar",
	"rota_porto_tomar",
	"rota_sagres_tomar"
]
const ATLANTIC_ROUTE_IDS := [
	"rota_sagres_bruma",
	"rota_bruma_sargaco",
	"rota_sagres_vera_cruz"
]
const STRAIT_ROUTE_IDS := [
	"rota_sagres_ceuta",
	"rota_sargaco_ceuta"
]

@onready var status_label: Label = %StatusLabel
@onready var detail_label: Label = %DetailLabel
@onready var close_button: Button = %CloseButton
@onready var help_label: Label = %HelpLabel
@onready var sea_panel: PanelContainer = $SeaPanel
@onready var sea_stats_label: Label = %SeaStatsLabel
@onready var sea_event_label: Label = %SeaEventLabel
@onready var title_label: Label = %TitleLabel
@onready var legend_label: Label = %LegendLabel

var destinations: Dictionary = {}
var routes: Array = []
var routes_by_id: Dictionary = {}
var current_node_id: String = "lisboa"
var ship_position: Vector2 = Vector2(1202.0, 690.0)
var ship_velocity: Vector2 = Vector2.ZERO
var ship_heading: Vector2 = Vector2(-1.0, 0.0)
var camera_position: Vector2 = Vector2.ZERO
var travel_state: Dictionary = {}
var nearest_destination_id: String = ""
var nearest_encounter_point_id: String = ""
var status_message: String = ""
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var sailed_step_buffer: float = 0.0
var draw_tick: float = 0.0


func _ready() -> void:
	rng.randomize()
	_load_map_data()
	_apply_world_layout()
	_apply_theme()
	title_label.text = "Carta do Reino e do Mar Oceano"
	legend_label.text = "Legenda\nAzul: porto presente\nDourado: terra conhecida para aportar\nLinhas: derrotas mestras; agora o mar corre livre sob a vossa quilha"
	GameState.set_current_scene_path(GameState.PORTUGAL_MAP_SCENE)
	current_node_id = GameState.get_overworld_current_node_id()
	if not destinations.has(current_node_id):
		current_node_id = "lisboa"
		GameState.set_overworld_current_node(current_node_id)

	ship_position = _get_destination_dock_position(current_node_id)
	camera_position = ship_position
	travel_state = _normalize_travel_state(GameState.get_overworld_travel_state())
	var last_battle_outcome: String = GameState.consume_last_battle_outcome()
	if not travel_state.is_empty():
		var travel_changed: bool = _ensure_travel_state_defaults()
		ship_position = _vector_from_dict(travel_state.get("ship_position", _to_point_dict(ship_position)))
		camera_position = ship_position
		nearest_destination_id = str(travel_state.get("nearest_destination_id", ""))
		sailed_step_buffer = float(travel_state.get("sailed_step_buffer", 0.0))
		if last_battle_outcome == "victory" and bool(travel_state.get("paused_for_battle", false)):
			var cleared_encounter_title: String = _get_active_encounter_label()
			_remove_active_encounter_point()
			travel_state["paused_for_battle"] = false
			travel_state["active_encounter_point_id"] = ""
			travel_state["last_event"] = "%s foi desbaratado. A derrota prossegue." % (cleared_encounter_title if not cleared_encounter_title.is_empty() else "O recontro no mar")
			travel_changed = true
		if travel_changed:
			GameState.set_overworld_travel_state(travel_state)
	else:
		status_message = "A nau repousa junto de %s. Largai com WASD." % _get_destination_name(current_node_id)

	MusicManager.play_overworld_music()
	_update_navigation_state(0.0, false)
	_update_close_button()
	_update_help_label()
	_update_detail_label()
	_update_sea_panel()
	queue_redraw()


func _process(delta: float) -> void:
	draw_tick += delta
	_update_navigation_state(delta, true)
	queue_redraw()


func _draw() -> void:
	_draw_parchment_frame()
	_draw_globe_grid()
	_draw_landmasses()
	_draw_routes()
	_draw_destinations()
	_draw_encounter_points()
	_draw_ship()
	_draw_map_title()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_E:
			if _try_dock_nearest_destination():
				accept_event()
				return
			if _try_start_nearest_encounter_point():
				accept_event()
				return
		if event.keycode in [KEY_ESCAPE, KEY_M]:
			if _is_sailing_active():
				return
			_return_to_origin_scene()
			accept_event()


func _load_map_data() -> void:
	destinations.clear()
	routes.clear()
	routes_by_id.clear()

	var parsed: Variant = GameState.load_json_data(TRAVEL_MAP_PATH)
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Expected dictionary in %s" % TRAVEL_MAP_PATH)
		return

	for raw_destination in parsed.get("destinations", []):
		var destination: Dictionary = raw_destination.duplicate(true)
		destinations[str(destination.get("id", ""))] = destination

	for raw_route in parsed.get("routes", []):
		var route: Dictionary = raw_route.duplicate(true)
		routes.append(route)
		routes_by_id[str(route.get("id", ""))] = route


func _apply_world_layout() -> void:
	for destination_id in destinations.keys():
		var destination: Dictionary = destinations[destination_id]
		var override_data: Dictionary = DESTINATION_LAYOUT_OVERRIDES.get(destination_id, {})
		if not override_data.is_empty():
			destination["map_position"] = _to_point_dict(override_data.get("map_position", _vector_from_dict(destination.get("map_position", {}))))
			destination["dock_position"] = _to_point_dict(override_data.get("dock_position", _vector_from_dict(destination.get("map_position", {}))))
			destination["label_offset"] = _to_point_dict(override_data.get("label_offset", Vector2(-34.0, -54.0)))
		elif not destination.has("dock_position"):
			destination["dock_position"] = destination.get("map_position", {"x": 0.0, "y": 0.0})
			destination["label_offset"] = _to_point_dict(Vector2(-34.0, -54.0))
		destinations[destination_id] = destination


func _normalize_travel_state(raw_state: Dictionary) -> Dictionary:
	if raw_state.is_empty():
		return {}
	if str(raw_state.get("mode", "")) == "free_navigation":
		var cloned: Dictionary = raw_state.duplicate(true)
		if not cloned.has("encounter_points"):
			cloned["encounter_points"] = []
		if not cloned.has("encounter_point_counter"):
			cloned["encounter_point_counter"] = 0
		if not cloned.has("active_encounter_point_id"):
			cloned["active_encounter_point_id"] = ""
		return cloned

	var converted := {
		"mode": "free_navigation",
		"ship_position": raw_state.get("ship_position", _to_point_dict(_get_destination_dock_position(current_node_id))),
		"paused_for_battle": bool(raw_state.get("paused_for_battle", false)),
		"encounter_bonus": float(raw_state.get("encounter_bonus", 0.0)),
		"sailed_step_buffer": 0.0,
		"nearest_destination_id": "",
		"origin_node_id": str(raw_state.get("origin_node_id", current_node_id)),
		"origin_scene": str(raw_state.get("origin_scene", GameState.get_overworld_origin_scene())),
		"encounter_points": raw_state.get("encounter_points", []),
		"encounter_point_counter": int(raw_state.get("encounter_point_counter", 0)),
		"active_encounter_point_id": str(raw_state.get("active_encounter_point_id", "")),
		"ocean": raw_state.get("ocean", GameState.get_ocean_state()),
		"last_event": "A nau retoma derrota livre em mar aberto."
	}
	if (converted.get("ocean", {})).is_empty():
		converted["ocean"] = _build_default_ocean_state()
	GameState.set_overworld_travel_state(converted)
	return converted


func _apply_theme() -> void:
	for panel_name in ["StatusPanel", "LegendPanel", "SeaPanel"]:
		var panel: PanelContainer = get_node_or_null(NodePath(panel_name))
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


func _update_navigation_state(delta: float, process_motion: bool) -> void:
	if process_motion:
		_update_ship_navigation(delta)
	_update_camera(delta if process_motion else 0.0)
	nearest_destination_id = _find_nearest_destination_id()
	nearest_encounter_point_id = _find_nearest_encounter_point_id()
	_update_status_copy()
	_update_close_button()
	_update_help_label()
	_update_detail_label()
	_update_sea_panel()


func _update_ship_navigation(delta: float) -> void:
	if bool(travel_state.get("paused_for_battle", false)):
		ship_velocity = Vector2.ZERO
		return

	var input_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vector.length() > 0.01 and travel_state.is_empty():
		_begin_free_navigation()

	var zone_id: String = _get_navigation_zone_id(ship_position)
	var zone_speed: float = _get_navigation_zone_speed(zone_id)
	var wind_speed: float = _get_ocean_speed_factor()
	var desired_velocity: Vector2 = input_vector.normalized() * SHIP_BASE_SPEED * zone_speed * wind_speed if input_vector.length() > 0.01 else Vector2.ZERO
	var easing: float = SHIP_ACCELERATION if desired_velocity != Vector2.ZERO else SHIP_FRICTION
	ship_velocity = ship_velocity.lerp(desired_velocity, clampf(delta * easing, 0.0, 1.0))
	if ship_velocity.length() < 3.0:
		ship_velocity = Vector2.ZERO
	if ship_velocity.length() > 0.01:
		ship_heading = ship_velocity.normalized()

	if travel_state.is_empty():
		return
	if ship_velocity == Vector2.ZERO:
		_store_navigation_state()
		return

	var moved: Vector2 = _move_ship_with_water_collision(ship_velocity * delta)
	var moved_distance: float = moved.length()
	if moved_distance <= 0.01:
		ship_velocity = ship_velocity * 0.35
		_store_navigation_state()
		return

	sailed_step_buffer += moved_distance
	while sailed_step_buffer >= SAIL_STEP_DISTANCE:
		sailed_step_buffer -= SAIL_STEP_DISTANCE
		if _apply_sailing_step():
			return

	_store_navigation_state()


func _begin_free_navigation() -> void:
	var ocean: Dictionary = GameState.get_ocean_state()
	if ocean.is_empty():
		ocean = _build_default_ocean_state()
	ocean["days"] = 0
	ocean["event_log"] = []
	_roll_wind(ocean, true)
	travel_state = {
		"mode": "free_navigation",
		"ship_position": _to_point_dict(ship_position),
		"paused_for_battle": false,
		"encounter_bonus": 0.0,
		"encounter_points": [],
		"encounter_point_counter": 0,
		"active_encounter_point_id": "",
		"sailed_step_buffer": sailed_step_buffer,
		"nearest_destination_id": "",
		"origin_node_id": current_node_id,
		"origin_scene": GameState.get_overworld_origin_scene(),
		"ocean": ocean,
		"last_event": "Largastes de %s e tomastes o mar." % _get_destination_name(current_node_id)
	}
	GameState.set_ocean_state(ocean)
	GameState.set_overworld_travel_state(travel_state)


func _move_ship_with_water_collision(delta_motion: Vector2) -> Vector2:
	var origin: Vector2 = ship_position
	var candidate: Vector2 = _clamp_world_position(ship_position + delta_motion)
	if _is_navigable_water(candidate):
		ship_position = candidate
		return ship_position - origin

	var horizontal: Vector2 = _clamp_world_position(ship_position + Vector2(delta_motion.x, 0.0))
	if _is_navigable_water(horizontal):
		ship_position = horizontal

	var vertical: Vector2 = _clamp_world_position(ship_position + Vector2(0.0, delta_motion.y))
	if _is_navigable_water(vertical):
		ship_position = vertical

	return ship_position - origin


func _clamp_world_position(position_value: Vector2) -> Vector2:
	var clamped := position_value
	clamped.x = wrapf(clamped.x, 0.0, WORLD_WIDTH)
	clamped.y = clampf(clamped.y, 86.0, WORLD_HEIGHT - 70.0)
	return clamped


func _apply_sailing_step() -> bool:
	if travel_state.is_empty():
		return false

	var zone_id: String = _get_navigation_zone_id(ship_position)
	var ocean: Dictionary = travel_state.get("ocean", {})
	if ocean.is_empty():
		ocean = _build_default_ocean_state()

	ocean["days"] = int(ocean.get("days", 0)) + 1
	var supplies: int = int(ocean.get("supplies", 0))
	var wind_id: String = str(ocean.get("wind", "manso"))
	var zone_supply_cost: int = 1 if zone_id in ["mar_largo", "poente", "estreito"] else 0
	var extra_use: int = 1 if wind_id in ["temporal", "contrario"] and zone_supply_cost > 0 else 0
	supplies = max(0, supplies - zone_supply_cost - extra_use)
	ocean["supplies"] = supplies

	if supplies == 0 and zone_supply_cost > 0:
		ocean["ship"] = max(0, int(ocean.get("ship", OCEAN_SHIP_MAX)) - 2)
		if int(ocean.get("days", 0)) % 2 == 0:
			_push_ocean_event(ocean, "Mantimentos em falta: a tripulacao amofina e o casco geme.")

	if rng.randf() < _get_zone_event_chance(zone_id):
		var event_text: String = _trigger_ocean_event(ocean)
		if not event_text.is_empty():
			_push_ocean_event(ocean, event_text)

	_cull_encounter_points()
	_maybe_spawn_encounter_point(zone_id)
	travel_state["ocean"] = ocean
	GameState.set_ocean_state(ocean)
	if int(ocean.get("ship", 0)) <= 0:
		_force_return_to_origin("A nau abre costado e mal se sustem. Convem tornar a porto seguro.")
		return true

	return false


func _maybe_spawn_encounter_point(zone_id: String) -> void:
	if travel_state.is_empty():
		return
	if bool(travel_state.get("paused_for_battle", false)):
		return
	var encounter_table: Array = _build_zone_encounter_table(zone_id)
	if encounter_table.is_empty():
		return

	var existing_points: Array = travel_state.get("encounter_points", [])
	if existing_points.size() >= SEA_ENCOUNTER_POINT_LIMIT:
		return
	var encounter_bonus: float = float(travel_state.get("encounter_bonus", 0.0))
	var encounter_chance: float = _get_zone_encounter_chance(zone_id) + encounter_bonus
	if rng.randf() > encounter_chance:
		return

	var point_spawn: Dictionary = _find_encounter_spawn_point(zone_id, existing_points)
	if not bool(point_spawn.get("ok", false)):
		return

	var encounter_index: int = rng.randi_range(0, encounter_table.size() - 1)
	var encounter: Dictionary = encounter_table[encounter_index].duplicate(true)
	var ocean: Dictionary = travel_state.get("ocean", {})
	var day_now: int = int(ocean.get("days", 0))
	var encounter_point_counter: int = int(travel_state.get("encounter_point_counter", 0)) + 1
	var encounter_point_id := "sea_point_%03d" % encounter_point_counter
	var encounter_point := {
		"id": encounter_point_id,
		"label": str(encounter.get("battle_title", "Velas hostis")),
		"position": point_spawn.get("position", _to_point_dict(ship_position)),
		"radius": SEA_ENCOUNTER_INTERACT_RADIUS,
		"zone_id": zone_id,
		"expires_day": day_now + rng.randi_range(SEA_ENCOUNTER_TTL_MIN, SEA_ENCOUNTER_TTL_MAX),
		"battle": encounter
	}
	existing_points.append(encounter_point)
	travel_state["encounter_points"] = existing_points
	travel_state["encounter_point_counter"] = encounter_point_counter
	travel_state["encounter_bonus"] = 0.0
	_push_ocean_event(ocean, "Velas suspeitas foram avistadas no %s. Podeis afronta-las ou desviar-vos." % _get_zone_label(zone_id).to_lower())
	travel_state["ocean"] = ocean
	GameState.set_ocean_state(ocean)
	GameState.set_overworld_travel_state(travel_state)


func _cull_encounter_points() -> void:
	if travel_state.is_empty():
		return
	var ocean: Dictionary = travel_state.get("ocean", {})
	var day_now: int = int(ocean.get("days", 0))
	var kept_points: Array = []
	var active_id: String = str(travel_state.get("active_encounter_point_id", ""))
	var changed: bool = false
	for raw_point in travel_state.get("encounter_points", []):
		var encounter_point: Dictionary = raw_point
		if encounter_point.is_empty():
			changed = true
			continue
		if str(encounter_point.get("id", "")) == active_id:
			kept_points.append(encounter_point)
			continue
		if day_now > int(encounter_point.get("expires_day", day_now + 1)):
			changed = true
			continue
		kept_points.append(encounter_point)
	if changed:
		travel_state["encounter_points"] = kept_points


func _find_encounter_spawn_point(zone_id: String, existing_points: Array) -> Dictionary:
	for _attempt in range(20):
		var base_heading: Vector2 = ship_heading.normalized() if ship_heading.length() > 0.01 else Vector2.LEFT.rotated(rng.randf_range(-PI, PI))
		var spread: float = rng.randf_range(-0.95, 0.95)
		if zone_id == "rio":
			spread = rng.randf_range(-0.55, 0.55)
		var travel_direction := base_heading.rotated(spread)
		var candidate: Vector2 = _clamp_world_position(
			ship_position + travel_direction * rng.randf_range(SEA_ENCOUNTER_SPAWN_RADIUS_MIN, SEA_ENCOUNTER_SPAWN_RADIUS_MAX)
		)
		if _can_place_encounter_point(candidate, zone_id, existing_points):
			return {"ok": true, "position": _to_point_dict(candidate)}
	return {"ok": false}


func _can_place_encounter_point(candidate: Vector2, zone_id: String, existing_points: Array) -> bool:
	if not _is_navigable_water(candidate):
		return false
	if _get_navigation_zone_id(candidate) != zone_id:
		return false
	for destination_id in destinations.keys():
		if _distance_between_world_points(candidate, _get_destination_dock_position(destination_id)) < DOCK_HINT_RADIUS * 0.82:
			return false
	for raw_point in existing_points:
		var encounter_point: Dictionary = raw_point
		if _distance_between_world_points(candidate, _vector_from_dict(encounter_point.get("position", {}))) < 150.0:
			return false
	return true


func _build_zone_encounter_table(zone_id: String) -> Array:
	var route_ids: Array = []
	match zone_id:
		"rio":
			route_ids = ["rota_lisboa_tomar", "rota_porto_tomar", "rota_sagres_tomar"]
		"estreito":
			route_ids = STRAIT_ROUTE_IDS
		"mar_largo":
			route_ids = ["rota_sagres_bruma", "rota_bruma_sargaco"]
		"poente":
			route_ids = ["rota_sagres_vera_cruz"]
		_:
			route_ids = COASTAL_ROUTE_IDS

	var encounters: Array = []
	for route_id in route_ids:
		var route: Dictionary = routes_by_id.get(route_id, {})
		for raw_encounter in route.get("encounters", []):
			encounters.append(raw_encounter)
	return encounters


func _get_zone_encounter_chance(zone_id: String) -> float:
	match zone_id:
		"rio":
			return 0.08
		"estreito":
			return 0.16
		"mar_largo":
			return 0.13
		"poente":
			return 0.18
		_:
			return 0.11


func _update_camera(delta: float) -> void:
	var target: Vector2 = ship_position if _is_sailing_active() else _get_destination_dock_position(current_node_id)
	if delta <= 0.0:
		camera_position = target
		return
	camera_position.x = _approach_wrapped(camera_position.x, target.x, clampf(delta * CAMERA_SMOOTH, 0.0, 1.0))
	camera_position.y = lerpf(camera_position.y, target.y, clampf(delta * CAMERA_SMOOTH, 0.0, 1.0))


func _approach_wrapped(current_x: float, target_x: float, weight: float) -> float:
	var delta_x: float = _wrapped_delta_x(target_x - current_x)
	return wrapf(current_x + (delta_x * weight), 0.0, WORLD_WIDTH)


func _wrapped_delta_x(delta_x: float) -> float:
	if delta_x > WORLD_WIDTH * 0.5:
		return delta_x - WORLD_WIDTH
	if delta_x < -WORLD_WIDTH * 0.5:
		return delta_x + WORLD_WIDTH
	return delta_x


func _is_sailing_active() -> bool:
	return not travel_state.is_empty()


func _try_dock_nearest_destination() -> bool:
	if nearest_destination_id.is_empty():
		return false
	if not _destination_unlocked(destinations.get(nearest_destination_id, {})):
		return false
	if _distance_to_destination_dock(nearest_destination_id) > DOCK_RADIUS:
		return false
	_arrive_destination(nearest_destination_id)
	return true


func _try_start_nearest_encounter_point() -> bool:
	if not _is_sailing_active():
		return false
	if nearest_encounter_point_id.is_empty():
		return false
	var encounter_point: Dictionary = _get_encounter_point(nearest_encounter_point_id)
	if encounter_point.is_empty():
		return false
	if _distance_to_encounter_point(nearest_encounter_point_id) > SEA_ENCOUNTER_INTERACT_RADIUS:
		return false
	_start_encounter_point(encounter_point)
	return true


func _start_encounter_point(encounter_point: Dictionary) -> void:
	var encounter: Dictionary = encounter_point.get("battle", {}).duplicate(true)
	encounter["return_scene"] = GameState.PORTUGAL_MAP_SCENE
	encounter["return_button_text"] = "Retomar derrota"
	encounter["defeat_return_scene"] = str(travel_state.get("origin_scene", GameState.get_overworld_origin_scene()))
	encounter["overworld_encounter"] = true
	encounter["origin_node_id"] = str(travel_state.get("origin_node_id", current_node_id))
	encounter["encounter_point_id"] = str(encounter_point.get("id", ""))

	travel_state["paused_for_battle"] = true
	travel_state["active_encounter_point_id"] = str(encounter_point.get("id", ""))
	travel_state["last_event"] = "Aproastes %s e a peleja vai comecar." % str(encounter_point.get("label", "as velas hostis")).to_lower()
	GameState.set_overworld_travel_state(travel_state)
	GameState.current_battle_context = encounter
	get_tree().change_scene_to_file(BATTLE_SCENE_PATH)


func _arrive_destination(destination_id: String) -> void:
	var destination: Dictionary = destinations.get(destination_id, {})
	var destination_scene: String = str(destination.get("scene", GameState.get_overworld_origin_scene()))
	var ocean: Dictionary = travel_state.get("ocean", GameState.get_ocean_state())
	if not ocean.is_empty():
		GameState.set_ocean_state(ocean)
	current_node_id = destination_id
	ship_position = _get_destination_dock_position(destination_id)
	ship_velocity = Vector2.ZERO
	sailed_step_buffer = 0.0
	GameState.set_overworld_current_node(destination_id)
	GameState.set_overworld_origin_scene(destination_scene)
	GameState.clear_overworld_travel_state()
	travel_state = {}
	status_message = "Aportastes a %s." % _get_destination_name(destination_id)
	get_tree().change_scene_to_file(destination_scene)


func _return_to_origin_scene() -> void:
	var origin_scene: String = GameState.get_overworld_origin_scene()
	get_tree().change_scene_to_file(origin_scene)


func _update_status_copy() -> void:
	if bool(travel_state.get("paused_for_battle", false)):
		status_label.text = "A derrota suspende-se por combate. Depois da peleja, o rumo ha-de retomar-se."
		return

	if _is_sailing_active():
		var zone_id: String = _get_navigation_zone_id(ship_position)
		var encounter_distance: float = _distance_to_encounter_point(nearest_encounter_point_id)
		if not nearest_encounter_point_id.is_empty() and encounter_distance <= SEA_ENCOUNTER_INTERACT_RADIUS:
			status_label.text = "Velas hostis ao alcance. Prima E para afrontar, ou afastai-vos e deixai-as ficar para tras."
			return
		if not nearest_encounter_point_id.is_empty() and encounter_distance <= SEA_ENCOUNTER_HINT_RADIUS:
			status_label.text = "Avistais %s. Podeis aproar a esse ponto ou passar ao largo." % _get_encounter_point_label(nearest_encounter_point_id)
			return
		if not nearest_destination_id.is_empty() and _distance_to_destination_dock(nearest_destination_id) <= DOCK_HINT_RADIUS:
			status_label.text = "Avistais %s. Prima E para aportar quando vos achegardes bastante." % _get_destination_name(nearest_destination_id)
		else:
			status_label.text = "A nau corre o %s. O mundo desliza sob a carta conforme o vosso rumo." % _get_zone_label(zone_id)
		return

	status_label.text = status_message if not status_message.is_empty() else "A nau repousa junto de %s. Largai com WASD." % _get_destination_name(current_node_id)


func _update_detail_label() -> void:
	var encounter_distance: float = _distance_to_encounter_point(nearest_encounter_point_id)
	if _is_sailing_active() and not nearest_encounter_point_id.is_empty() and encounter_distance <= SEA_ENCOUNTER_HINT_RADIUS:
		var encounter_point: Dictionary = _get_encounter_point(nearest_encounter_point_id)
		var days_left: int = max(0, int(encounter_point.get("expires_day", 0)) - int(travel_state.get("ocean", {}).get("days", 0)))
		var encounter_lines: Array[String] = [
			_get_encounter_point_label(nearest_encounter_point_id),
			"Recontro opcional no %s." % _get_zone_label(str(encounter_point.get("zone_id", _get_navigation_zone_id(ship_position)))).to_lower()
		]
		if encounter_distance <= SEA_ENCOUNTER_INTERACT_RADIUS:
			encounter_lines.append("Prima E para pelejar, ou governai para longe se nao quereis meter-vos em sangue.")
		else:
			encounter_lines.append("Aproai se quereis peleja; contornai o sinal se preferis seguir viagem.")
		if days_left > 0:
			encounter_lines.append("Estas velas podem sumir com a mudanca da mare em %d dia(s)." % days_left)
		detail_label.text = "\n".join(encounter_lines)
		return

	var focus_destination_id: String = nearest_destination_id if not nearest_destination_id.is_empty() else current_node_id
	var destination: Dictionary = destinations.get(focus_destination_id, {})
	if destination.is_empty():
		detail_label.text = "A carta aguarda porto ou derrota."
		return

	var lines: Array[String] = [
		str(destination.get("name", focus_destination_id.capitalize())),
		str(destination.get("description", ""))
	]
	if _is_sailing_active():
		lines.append("Zona de mar: %s" % _get_zone_label(_get_navigation_zone_id(ship_position)))
		if _distance_to_destination_dock(focus_destination_id) <= DOCK_HINT_RADIUS and _destination_unlocked(destination):
			lines.append("Aproai com tento e prima E para aportar.")
		else:
			lines.append("A carta desliza em roda da nau; mantende a derrota com WASD.")
	else:
		lines.append("Largai com WASD para entrar em mar aberto.")
		if focus_destination_id == current_node_id:
			lines.append("Esc ou M tornam ao lugar presente.")
	if focus_destination_id == "tomar":
		lines.append("Tomar jaz no interior, ao cabo do Tejo; nao mais boia perdida em mar aberto.")
	detail_label.text = "\n".join(lines)


func _update_help_label() -> void:
	if _is_sailing_active():
		help_label.text = "WASD governa a nau | E aporta ou afronta um ponto hostil quando junto dele | Se nao quereis combate, passai ao largo."
	else:
		help_label.text = "WASD larga do porto | Esc ou M tornam ao lugar presente | A carta segue a vossa nau em roda, como mundo que corre."


func _update_close_button() -> void:
	if _is_sailing_active():
		close_button.disabled = true
		close_button.text = "No mar"
		return
	close_button.disabled = false
	close_button.text = "Tornar a %s" % _get_destination_name(current_node_id)


func _draw_parchment_frame() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.08, 0.16, 0.24))
	draw_rect(MAP_VIEW_RECT, Color(0.9, 0.84, 0.7))
	draw_rect(MAP_VIEW_RECT.grow(26.0), Color(0.75, 0.63, 0.39, 0.18), false, 4.0)
	draw_rect(MAP_VIEW_RECT, Color(0.11, 0.2, 0.29, 0.82))


func _draw_globe_grid() -> void:
	var meridian_color := Color(0.86, 0.8, 0.64, 0.09)
	var parallel_color := Color(0.86, 0.8, 0.64, 0.07)
	for line_index in range(-4, 5):
		var meridian_points := PackedVector2Array()
		var world_x: float = camera_position.x + float(line_index) * 180.0
		for step in range(15):
			var t: float = float(step) / 14.0
			var world_y: float = lerpf(96.0, WORLD_HEIGHT - 78.0, t)
			var bulge: float = (1.0 - pow(absf(t * 2.0 - 1.0), 1.7)) * float(line_index) * 10.0
			meridian_points.append(_world_to_screen(Vector2(world_x + bulge, world_y)))
		draw_polyline(meridian_points, meridian_color, 1.0, false)
	for band_index in range(1, 6):
		var parallel_points := PackedVector2Array()
		var world_y_band: float = lerpf(132.0, WORLD_HEIGHT - 118.0, float(band_index) / 6.0)
		for step in range(-1, 12):
			var world_x_band: float = camera_position.x + float(step) * 120.0
			var arch: float = sin(float(step) * 0.38) * 7.0
			parallel_points.append(_world_to_screen(Vector2(world_x_band, world_y_band + arch)))
		draw_polyline(parallel_points, parallel_color, 1.0, false)


func _draw_landmasses() -> void:
	_draw_land_polygon(PORTUGAL_LAND_POINTS, Color(0.73, 0.67, 0.54), Color(0.45, 0.34, 0.21))
	_draw_land_polygon(ANDALUZ_POINTS, Color(0.72, 0.66, 0.53), Color(0.45, 0.34, 0.21))
	_draw_land_polygon(MAGREBE_POINTS, Color(0.68, 0.6, 0.47), Color(0.45, 0.34, 0.21))
	_draw_land_polygon(VERA_CRUZ_POINTS, Color(0.62, 0.71, 0.5), Color(0.31, 0.39, 0.22))
	_draw_river_line(TEJO_RIVER_POINTS, Color(0.23, 0.46, 0.62))
	_draw_island(Vector2(980.0, 944.0), Vector2(82.0, 44.0), Color(0.75, 0.71, 0.58))
	_draw_island(Vector2(1210.0, 970.0), Vector2(96.0, 52.0), Color(0.76, 0.72, 0.56))

	var compass_center := Vector2(920.0, 176.0)
	draw_circle(compass_center, 62.0, Color(0.12, 0.15, 0.18, 0.42))
	draw_arc(compass_center, 62.0, 0.0, TAU, 28, Color(0.9, 0.8, 0.56), 3.0)
	draw_line(compass_center + Vector2(0.0, -48.0), compass_center + Vector2(0.0, 48.0), Color(0.94, 0.87, 0.65), 3.0)
	draw_line(compass_center + Vector2(-48.0, 0.0), compass_center + Vector2(48.0, 0.0), Color(0.94, 0.87, 0.65), 3.0)
	draw_string(ThemeDB.fallback_font, compass_center + Vector2(-8.0, -58.0), "N", HORIZONTAL_ALIGNMENT_LEFT, -1, 28, Color(0.96, 0.92, 0.78))


func _draw_land_polygon(points: Array, fill_color: Color, edge_color: Color) -> void:
	for wrap_shift in [-WORLD_WIDTH, 0.0, WORLD_WIDTH]:
		var screen_points := PackedVector2Array()
		for raw_point in points:
			var point: Vector2 = raw_point
			screen_points.append(_world_to_screen(point + Vector2(wrap_shift, 0.0)))
		draw_colored_polygon(screen_points, fill_color)
		draw_polyline(screen_points, edge_color, 4.0, true)


func _draw_river_line(points: Array, color: Color) -> void:
	for wrap_shift in [-WORLD_WIDTH, 0.0, WORLD_WIDTH]:
		var screen_points := PackedVector2Array()
		for raw_point in points:
			var point: Vector2 = raw_point
			screen_points.append(_world_to_screen(point + Vector2(wrap_shift, 0.0)))
		draw_polyline(screen_points, color, 6.0, false)


func _draw_island(center: Vector2, island_size: Vector2, fill_color: Color) -> void:
	for wrap_shift in [-WORLD_WIDTH, 0.0, WORLD_WIDTH]:
		var screen_center: Vector2 = _world_to_screen(center + Vector2(wrap_shift, 0.0))
		var ellipse_points: PackedVector2Array = _build_ellipse_points(screen_center, island_size * 0.5, 28)
		draw_colored_polygon(ellipse_points, fill_color)
		draw_arc(screen_center, island_size.x * 0.5, 0.0, TAU, 20, Color(0.42, 0.34, 0.2), 2.0)


func _build_ellipse_points(center: Vector2, radii: Vector2, steps: int) -> PackedVector2Array:
	var points := PackedVector2Array()
	for step in range(steps):
		var angle: float = (float(step) / float(steps)) * TAU
		points.append(center + Vector2(cos(angle) * radii.x, sin(angle) * radii.y))
	return points


func _draw_routes() -> void:
	var route_color := Color(0.86, 0.78, 0.56, 0.2)
	for raw_route in routes:
		var route: Dictionary = raw_route
		var from_id: String = str(route.get("from", ""))
		var to_id: String = str(route.get("to", ""))
		if not destinations.has(from_id) or not destinations.has(to_id):
			continue
		var points: PackedVector2Array = _build_route_curve(from_id, to_id, str(route.get("id", "")))
		draw_polyline(points, route_color, 2.0, false)


func _build_route_curve(from_id: String, to_id: String, route_id: String) -> PackedVector2Array:
	var from_world: Vector2 = _get_destination_dock_position(from_id)
	var to_world: Vector2 = _get_destination_dock_position(to_id)
	to_world.x = _unwrap_x_near(to_world.x, from_world.x)

	var mid_world := (from_world + to_world) * 0.5
	var control_offset := Vector2.ZERO
	if route_id in STRAIT_ROUTE_IDS:
		control_offset = Vector2(0.0, 40.0)
	elif route_id == "rota_sagres_vera_cruz":
		control_offset = Vector2(0.0, 120.0)
	elif route_id in ["rota_sagres_bruma", "rota_bruma_sargaco"]:
		control_offset = Vector2(0.0, 72.0)
	elif route_id in ["rota_lisboa_tomar", "rota_porto_tomar", "rota_sagres_tomar"]:
		control_offset = Vector2(18.0, -44.0)
	else:
		control_offset = Vector2(0.0, 28.0)

	var control_world: Vector2 = mid_world + control_offset
	var points := PackedVector2Array()
	for step in range(17):
		var t: float = float(step) / 16.0
		var omt: float = 1.0 - t
		var curve_point: Vector2 = omt * omt * from_world + 2.0 * omt * t * control_world + t * t * to_world
		points.append(_world_to_screen(curve_point))
	return points


func _unwrap_x_near(target_x: float, reference_x: float) -> float:
	var best_x: float = target_x
	var best_distance: float = absf(target_x - reference_x)
	for candidate in [target_x - WORLD_WIDTH, target_x + WORLD_WIDTH]:
		var distance: float = absf(candidate - reference_x)
		if distance < best_distance:
			best_distance = distance
			best_x = candidate
	return best_x


func _draw_destinations() -> void:
	for destination_id in destinations.keys():
		var destination: Dictionary = destinations[destination_id]
		var screen_position: Vector2 = _world_to_screen(_get_destination_position(destination_id))
		var ring_color: Color = Color(0.43, 0.3, 0.18)
		if _destination_unlocked(destination):
			ring_color = Color(0.82, 0.68, 0.33)
		if destination_id == current_node_id and not _is_sailing_active():
			ring_color = Color(0.24, 0.62, 0.75)
		if destination_id == nearest_destination_id and _distance_to_destination_dock(destination_id) <= DOCK_HINT_RADIUS:
			ring_color = Color(0.93, 0.86, 0.54)
		draw_circle(screen_position, 10.0, ring_color)
		draw_circle(screen_position, 18.0, Color(ring_color.r, ring_color.g, ring_color.b, 0.2))

		var label_offset: Vector2 = _vector_from_dict(destination.get("label_offset", {"x": -34.0, "y": -54.0}))
		var label_position: Vector2 = screen_position + label_offset
		draw_string(ThemeDB.fallback_font, label_position, str(destination.get("name", destination_id.capitalize())), HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color(0.2, 0.15, 0.11))
		if _distance_to_destination_dock(destination_id) <= DOCK_HINT_RADIUS and _destination_unlocked(destination):
			draw_string(ThemeDB.fallback_font, label_position + Vector2(0.0, 20.0), "E aportar", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color(0.9, 0.82, 0.56))


func _draw_encounter_points() -> void:
	if travel_state.is_empty():
		return
	var index: int = 0
	for raw_point in travel_state.get("encounter_points", []):
		var encounter_point: Dictionary = raw_point
		var world_position: Vector2 = _vector_from_dict(encounter_point.get("position", {}))
		var screen_position: Vector2 = _world_to_screen(world_position)
		var phase: float = draw_tick * 4.1 + float(index) * 0.8
		var pulse: float = 0.75 + sin(phase) * 0.18
		var main_color := Color(0.84, 0.29, 0.22)
		var glow_color := Color(0.97, 0.82, 0.35, 0.34)
		draw_circle(screen_position + Vector2(0.0, 14.0), 12.0, Color(0.0, 0.0, 0.0, 0.18))
		draw_circle(screen_position, 18.0 * pulse, glow_color)
		var diamond := PackedVector2Array([
			screen_position + Vector2(0.0, -14.0),
			screen_position + Vector2(14.0, 0.0),
			screen_position + Vector2(0.0, 14.0),
			screen_position + Vector2(-14.0, 0.0)
		])
		draw_colored_polygon(diamond, main_color)
		draw_polyline(diamond, Color(0.99, 0.89, 0.74), 2.0, true)
		draw_line(screen_position + Vector2(-8.0, -7.0), screen_position + Vector2(7.0, 8.0), Color.WHITE, 2.0)
		draw_line(screen_position + Vector2(8.0, -7.0), screen_position + Vector2(-7.0, 8.0), Color.WHITE, 2.0)

		var point_id: String = str(encounter_point.get("id", ""))
		var distance: float = _distance_to_encounter_point(point_id)
		if distance <= SEA_ENCOUNTER_HINT_RADIUS:
			var label_position := screen_position + Vector2(-48.0, -22.0)
			draw_string(ThemeDB.fallback_font, label_position, "Recontro", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(0.2, 0.13, 0.1))
			if distance <= SEA_ENCOUNTER_INTERACT_RADIUS:
				draw_string(ThemeDB.fallback_font, label_position + Vector2(0.0, 18.0), "E afrontar", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color(0.94, 0.84, 0.54))
		index += 1


func _draw_ship() -> void:
	var ship_screen: Vector2 = _world_to_screen(ship_position)
	var heading: Vector2 = ship_heading.normalized() if ship_heading.length() > 0.01 else Vector2(-1.0, 0.0)
	var normal := Vector2(-heading.y, heading.x)
	var bob: float = sin(draw_tick * 3.2) * 2.0
	var tilt: float = heading.y * 3.0

	var stern: Vector2 = ship_screen - heading * 14.0 + Vector2(0.0, bob)
	var prow: Vector2 = ship_screen + heading * 16.0 + Vector2(0.0, bob)
	var left_side: Vector2 = ship_screen + normal * 10.0 + Vector2(0.0, bob)
	var right_side: Vector2 = ship_screen - normal * 10.0 + Vector2(0.0, bob)
	var hull := PackedVector2Array([
		stern + normal * 4.0,
		left_side,
		prow,
		right_side,
		stern - normal * 4.0
	])
	draw_colored_polygon(hull, Color(0.28, 0.19, 0.11))
	draw_polyline(hull, Color(0.42, 0.3, 0.18), 2.0, true)

	var mast_base: Vector2 = ship_screen + Vector2(0.0, 10.0 + bob)
	var mast_top: Vector2 = ship_screen + Vector2(0.0, -18.0 + bob)
	draw_line(mast_base, mast_top, Color(0.33, 0.22, 0.14), 3.0)
	var sail := PackedVector2Array([
		mast_top + Vector2(0.0, 4.0),
		ship_screen + Vector2(0.0, 14.0 + bob),
		ship_screen - heading * 20.0 + normal * (4.0 + tilt)
	])
	draw_colored_polygon(sail, Color(0.96, 0.94, 0.84))
	draw_polyline(sail, Color(0.69, 0.61, 0.43), 1.5, true)

	var wake_from: Vector2 = stern
	var wake_to: Vector2 = stern - heading * 20.0
	draw_line(wake_from, wake_to, Color(0.86, 0.94, 1.0, 0.34), 3.0)


func _draw_map_title() -> void:
	draw_string(ThemeDB.fallback_font, Vector2(184.0, 118.0), "Carta do Reino e do Mar Oceano", HORIZONTAL_ALIGNMENT_LEFT, -1, 38, Color(0.26, 0.2, 0.12))
	draw_string(ThemeDB.fallback_font, Vector2(186.0, 150.0), "A carta corre convosco: o poente abre-se, o estreito aperta, e o mundo vai em roda.", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color(0.31, 0.24, 0.18))


func _world_to_screen(world_point: Vector2) -> Vector2:
	var delta_x: float = _wrapped_delta_x(world_point.x - camera_position.x)
	var delta_y: float = world_point.y - camera_position.y
	return MAP_CENTER + Vector2(delta_x, delta_y)


func _is_navigable_water(world_point: Vector2) -> bool:
	var point := Vector2(wrapf(world_point.x, 0.0, WORLD_WIDTH), world_point.y)
	if point.y < 70.0 or point.y > WORLD_HEIGHT - 54.0:
		return false
	if _point_near_polyline(point, TEJO_RIVER_POINTS, RIVER_WIDTH):
		return true
	if Geometry2D.is_point_in_polygon(point, PackedVector2Array(PORTUGAL_LAND_POINTS)):
		return false
	if Geometry2D.is_point_in_polygon(point, PackedVector2Array(ANDALUZ_POINTS)):
		return false
	if Geometry2D.is_point_in_polygon(point, PackedVector2Array(MAGREBE_POINTS)):
		return false
	if Geometry2D.is_point_in_polygon(point, PackedVector2Array(VERA_CRUZ_POINTS)):
		return false
	return true


func _point_near_polyline(point: Vector2, points: Array, width: float) -> bool:
	if points.size() < 2:
		return false
	for index in range(points.size() - 1):
		var segment_from: Vector2 = points[index]
		var segment_to: Vector2 = points[index + 1]
		if Geometry2D.get_closest_point_to_segment(point, segment_from, segment_to).distance_to(point) <= width:
			return true
	return false


func _find_nearest_destination_id() -> String:
	var nearest_id: String = ""
	var best_distance: float = INF
	for destination_id in destinations.keys():
		var destination: Dictionary = destinations[destination_id]
		if not _destination_unlocked(destination):
			continue
		var distance: float = _distance_to_destination_dock(destination_id)
		if distance < best_distance:
			best_distance = distance
			nearest_id = destination_id
	return nearest_id


func _find_nearest_encounter_point_id() -> String:
	if travel_state.is_empty():
		return ""
	var nearest_id: String = ""
	var best_distance: float = INF
	for raw_point in travel_state.get("encounter_points", []):
		var encounter_point: Dictionary = raw_point
		var encounter_id: String = str(encounter_point.get("id", ""))
		if encounter_id.is_empty():
			continue
		var distance: float = _distance_to_world_point(_vector_from_dict(encounter_point.get("position", {})))
		if distance < best_distance:
			best_distance = distance
			nearest_id = encounter_id
	return nearest_id


func _get_encounter_point(point_id: String) -> Dictionary:
	if travel_state.is_empty() or point_id.is_empty():
		return {}
	for raw_point in travel_state.get("encounter_points", []):
		var encounter_point: Dictionary = raw_point
		if str(encounter_point.get("id", "")) == point_id:
			return encounter_point
	return {}


func _distance_to_encounter_point(point_id: String) -> float:
	var encounter_point: Dictionary = _get_encounter_point(point_id)
	if encounter_point.is_empty():
		return INF
	return _distance_to_world_point(_vector_from_dict(encounter_point.get("position", {})))


func _distance_to_world_point(world_position: Vector2) -> float:
	return _distance_between_world_points(ship_position, world_position)


func _distance_between_world_points(from_position: Vector2, to_position: Vector2) -> float:
	var delta_x: float = absf(_wrapped_delta_x(to_position.x - from_position.x))
	var delta_y: float = to_position.y - from_position.y
	return Vector2(delta_x, delta_y).length()


func _get_encounter_point_label(point_id: String) -> String:
	return str(_get_encounter_point(point_id).get("label", "Recontro no mar"))


func _get_active_encounter_label() -> String:
	return _get_encounter_point_label(str(travel_state.get("active_encounter_point_id", "")))


func _remove_active_encounter_point() -> void:
	var active_id: String = str(travel_state.get("active_encounter_point_id", ""))
	if active_id.is_empty():
		return
	var kept_points: Array = []
	for raw_point in travel_state.get("encounter_points", []):
		var encounter_point: Dictionary = raw_point
		if str(encounter_point.get("id", "")) == active_id:
			continue
		kept_points.append(encounter_point)
	travel_state["encounter_points"] = kept_points


func _distance_to_destination_dock(destination_id: String) -> float:
	var dock_position: Vector2 = _get_destination_dock_position(destination_id)
	var delta_x: float = absf(_wrapped_delta_x(dock_position.x - ship_position.x))
	var delta_y: float = dock_position.y - ship_position.y
	return Vector2(delta_x, delta_y).length()


func _get_navigation_zone_id(position_value: Vector2) -> String:
	var position_x: float = wrapf(position_value.x, 0.0, WORLD_WIDTH)
	if _point_near_polyline(position_value, TEJO_RIVER_POINTS, RIVER_WIDTH):
		return "rio"
	if position_x < 520.0:
		return "poente"
	if position_x < 1300.0 and position_value.y > 880.0:
		return "mar_largo"
	if position_x > 1670.0 and position_value.y > 850.0:
		return "estreito"
	return "costa"


func _get_zone_label(zone_id: String) -> String:
	match zone_id:
		"rio":
			return "Rio do Tejo"
		"mar_largo":
			return "Mar largo das ilhas"
		"estreito":
			return "Mar do Estreito"
		"poente":
			return "Poente de Vera Cruz"
		_:
			return "Costa do Reino"


func _get_navigation_zone_speed(zone_id: String) -> float:
	match zone_id:
		"rio":
			return 0.72
		"mar_largo":
			return 0.86
		"estreito":
			return 0.92
		"poente":
			return 0.8
		_:
			return 1.0


func _get_zone_event_chance(zone_id: String) -> float:
	match zone_id:
		"rio":
			return 0.08
		"mar_largo":
			return OCEAN_EVENT_CHANCE * 0.85
		"estreito":
			return OCEAN_EVENT_CHANCE * 1.0
		"poente":
			return OCEAN_EVENT_CHANCE * 1.1
		_:
			return OCEAN_EVENT_CHANCE * 0.5


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


func _get_destination_name(destination_id: String) -> String:
	return str(destinations.get(destination_id, {}).get("name", destination_id.capitalize()))


func _get_destination_position(destination_id: String) -> Vector2:
	return _vector_from_dict(destinations.get(destination_id, {}).get("map_position", {}))


func _get_destination_dock_position(destination_id: String) -> Vector2:
	var destination: Dictionary = destinations.get(destination_id, {})
	if destination.has("dock_position"):
		return _vector_from_dict(destination.get("dock_position", {}))
	return _vector_from_dict(destination.get("map_position", {}))


func _vector_from_dict(value: Dictionary) -> Vector2:
	return Vector2(float(value.get("x", 0.0)), float(value.get("y", 0.0)))


func _to_point_dict(value: Vector2) -> Dictionary:
	return {"x": value.x, "y": value.y}


func _store_navigation_state() -> void:
	if travel_state.is_empty():
		return
	travel_state["ship_position"] = _to_point_dict(ship_position)
	travel_state["nearest_destination_id"] = nearest_destination_id
	travel_state["sailed_step_buffer"] = sailed_step_buffer
	GameState.set_overworld_travel_state(travel_state)


func _ensure_travel_state_defaults() -> bool:
	if travel_state.is_empty():
		return false
	var changed: bool = false
	if not travel_state.has("encounter_points"):
		travel_state["encounter_points"] = []
		changed = true
	if not travel_state.has("encounter_point_counter"):
		travel_state["encounter_point_counter"] = 0
		changed = true
	if not travel_state.has("active_encounter_point_id"):
		travel_state["active_encounter_point_id"] = ""
		changed = true
	return changed


func _build_default_ocean_state() -> Dictionary:
	return {
		"supplies": OCEAN_SUPPLIES_MAX,
		"supplies_max": OCEAN_SUPPLIES_MAX,
		"ship": OCEAN_SHIP_MAX,
		"ship_max": OCEAN_SHIP_MAX,
		"wind": "manso",
		"wind_label": "Manso",
		"wind_speed": 1.0,
		"days": 0,
		"last_event": "A nau repousa em porto seguro.",
		"event_log": []
	}


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
	var ship_factor: float = lerpf(0.58, 1.0, ship_ratio)
	var supply_factor: float = 0.84 if int(ocean.get("supplies", 0)) <= 0 else 1.0
	return wind_factor * ship_factor * supply_factor


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
	ship_velocity = Vector2.ZERO
	sailed_step_buffer = 0.0
	GameState.clear_overworld_travel_state()
	status_message = reason
	get_tree().change_scene_to_file(origin_scene)


func _update_sea_panel() -> void:
	if sea_panel == null:
		return
	if travel_state.is_empty():
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
	var zone_id: String = _get_navigation_zone_id(ship_position)
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

	sea_stats_label.text = "Zona: %s\nMantimentos: %d/%d\nEstado da Nau: %s (%d%%)\nVento: %s\nDias no mar: %d" % [
		_get_zone_label(zone_id),
		supplies,
		supplies_max,
		ship_state,
		int(round(ship_ratio * 100.0)),
		wind_label,
		days
	]
	sea_event_label.text = str(ocean.get("last_event", "Sem travessia longa em curso."))


func _on_close_button_pressed() -> void:
	if _is_sailing_active():
		return
	_return_to_origin_scene()
