extends "res://scripts/world/lisboa_district_scene.gd"

const LISBOA_WORLD_BOUNDS := Rect2(0.0, 0.0, 3200.0, 1760.0)
const LISBOA_NAVIGATION_BOUNDS := Rect2(180.0, 320.0, 2840.0, 1220.0)
const LISBOA_COLLISION_RADIUS := 18.0
const LISBOA_USE_HARBOR_PROTOTYPE := true
const LISBOA_PROTOTYPE_WORLD_BOUNDS := Rect2(0.0, 0.0, 2816.0, 1536.0)
const LISBOA_PROTOTYPE_NAVIGATION_BOUNDS := Rect2(0.0, 0.0, 2816.0, 1536.0)
const LISBOA_PROTOTYPE_COLLISION_RADIUS := 8.0
const LISBOA_PROTOTYPE_BACKGROUND_CANDIDATES: Array[String] = [
	"res://assets/world/QuillBot-generated-image-1 (4).png"
]
const LISBOA_ISO_META_PATH := "res://assets/world/iso/iso_asset_meta_v2.json"
const LISBOA_ISO_QUAY_CANDIDATES: Array[String] = [
	"res://assets/world/iso/lisboa_ribeira_ground_v2_iso.png"
]
const LISBOA_ISO_BUILDINGS_CANDIDATES: Array[String] = [
	"res://assets/world/iso/lisboa_ribeira_buildings_v2_iso.png"
]
const LISBOA_ISO_PROPS_CANDIDATES: Array[String] = [
	"res://assets/world/iso/lisboa_ribeira_harbor_props_v2_iso.png"
]
const LISBOA_ISO_SHIPS_CANDIDATES: Array[String] = [
	"res://assets/world/iso/lisboa_ribeira_ships_v2_iso.png"
]
const LISBOA_ISO_CROWD_CANDIDATES: Array[String] = [
	"res://assets/world/iso/lisboa_ribeira_crowd_v2_iso.png"
]
const LISBOA_ISO_CROWD_EXTRA_CANDIDATES: Array[String] = [
	"res://assets/world/iso/lisboa_ribeira_crowd_extra_v2_iso.png"
]
const LISBOA_ISO_PASSAGES_CANDIDATES: Array[String] = [
	"res://assets/world/iso/lisboa_ribeira_passages_v2_iso.png"
]
const LISBOA_KEYART_CANDIDATES: Array[String] = [
	"res://assets/world/lisboa_ribeira_keyart_v1.png",
	"res://assets/world/lisboa_backdrop.svg"
]
const LISBOA_QUAY_CANDIDATES: Array[String] = [
	"res://assets/world/extracted/quay_clean.png",
	"res://assets/world/lisboa_ribeira_quay_tiles_v1.png",
	"res://assets/world/lisboa_ribeira_tileset_v1.png"
]
const LISBOA_BUILDINGS_CANDIDATES: Array[String] = [
	"res://assets/world/extracted/buildings_clean.png",
	"res://assets/world/lisboa_ribeira_buildings_sheet_v1.png"
]
const LISBOA_PROPS_CANDIDATES: Array[String] = [
	"res://assets/world/extracted/props_clean.png",
	"res://assets/world/lisboa_ribeira_harbor_props_v1.png",
	"res://assets/world/lisboa_ribeira_props_v1.png"
]
const LISBOA_SHIPS_CANDIDATES: Array[String] = [
	"res://assets/world/extracted/ships_clean.png",
	"res://assets/world/lisboa_ribeira_ships_v1.png"
]
const LISBOA_CROWD_CANDIDATES: Array[String] = [
	"res://assets/world/extracted/crowd_clean.png",
	"res://assets/world/lisboa_ribeira_crowd_v1.png"
]

var lisboa_backdrop_texture: Texture2D
var lisboa_iso_quay_texture: Texture2D
var lisboa_iso_buildings_texture: Texture2D
var lisboa_iso_props_texture: Texture2D
var lisboa_iso_ships_texture: Texture2D
var lisboa_iso_crowd_texture: Texture2D
var lisboa_iso_crowd_extra_texture: Texture2D
var lisboa_iso_passages_texture: Texture2D
var lisboa_iso_meta_loaded: bool = false
var lisboa_iso_meta: Dictionary = {}
var lisboa_quay_texture: Texture2D
var lisboa_buildings_texture: Texture2D
var lisboa_props_texture: Texture2D
var lisboa_ships_texture: Texture2D
var lisboa_crowd_texture: Texture2D
var lisboa_prototype_texture: Texture2D


func _ready() -> void:
	super._ready()
	_configure_lisboa_navigation()
	_configure_lisboa_camera()


func _get_district_size() -> Vector2:
	return _get_lisboa_world_bounds().size


func _get_lisboa_world_bounds() -> Rect2:
	return LISBOA_PROTOTYPE_WORLD_BOUNDS if LISBOA_USE_HARBOR_PROTOTYPE else LISBOA_WORLD_BOUNDS


func _get_lisboa_navigation_bounds() -> Rect2:
	return LISBOA_PROTOTYPE_NAVIGATION_BOUNDS if LISBOA_USE_HARBOR_PROTOTYPE else LISBOA_NAVIGATION_BOUNDS


func _get_lisboa_collision_radius() -> float:
	return LISBOA_PROTOTYPE_COLLISION_RADIUS if LISBOA_USE_HARBOR_PROTOTYPE else LISBOA_COLLISION_RADIUS


func _configure_lisboa_navigation() -> void:
	if player == null or not player.has_method("configure_navigation"):
		return
	player.call("configure_navigation", _get_lisboa_navigation_bounds(), _get_lisboa_walkable_polygons(), _get_lisboa_collision_radius())
	if player.has_method("is_position_walkable") and not bool(player.call("is_position_walkable", player.position)):
		player.position = default_spawn_position


func _configure_lisboa_camera() -> void:
	var camera: Camera2D = get_node_or_null("Player/Camera2D")
	if camera == null:
		return
	var world_bounds: Rect2 = _get_lisboa_world_bounds()
	camera.enabled = true
	camera.limit_left = int(world_bounds.position.x)
	camera.limit_top = int(world_bounds.position.y)
	camera.limit_right = int(world_bounds.end.x)
	camera.limit_bottom = int(world_bounds.end.y)
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 6.5
	camera.limit_smoothed = true
	camera.force_update_scroll()


func _get_lisboa_walkable_polygons() -> Array:
	if LISBOA_USE_HARBOR_PROTOTYPE:
		return []
	return [
		PackedVector2Array([
			Vector2(232.0, 454.0), Vector2(1214.0, 454.0), Vector2(1416.0, 648.0), Vector2(348.0, 706.0)
		]),
		PackedVector2Array([
			Vector2(1186.0, 556.0), Vector2(2198.0, 556.0), Vector2(2430.0, 780.0), Vector2(1248.0, 816.0)
		]),
		PackedVector2Array([
			Vector2(2206.0, 618.0), Vector2(3030.0, 618.0), Vector2(3160.0, 858.0), Vector2(2336.0, 890.0)
		]),
		PackedVector2Array([
			Vector2(226.0, 846.0), Vector2(904.0, 846.0), Vector2(1082.0, 1036.0), Vector2(352.0, 1086.0)
		]),
		PackedVector2Array([
			Vector2(926.0, 866.0), Vector2(2020.0, 866.0), Vector2(2264.0, 1178.0), Vector2(1058.0, 1228.0)
		]),
		PackedVector2Array([
			Vector2(1936.0, 1008.0), Vector2(3060.0, 1008.0), Vector2(3160.0, 1360.0), Vector2(2044.0, 1394.0)
		]),
		PackedVector2Array([
			Vector2(542.0, 1044.0), Vector2(1276.0, 1044.0), Vector2(1490.0, 1320.0), Vector2(708.0, 1392.0)
		]),
		PackedVector2Array([
			Vector2(222.0, 1118.0), Vector2(720.0, 1118.0), Vector2(936.0, 1384.0), Vector2(316.0, 1452.0)
		])
	]


func _draw_world() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if LISBOA_USE_HARBOR_PROTOTYPE:
		var prototype_background: Texture2D = _get_lisboa_prototype_background()
		var world_bounds: Rect2 = _get_lisboa_world_bounds()
		if prototype_background != null:
			draw_texture_rect(prototype_background, world_bounds, false)
			return
		draw_rect(world_bounds, Color(0.95, 0.93, 0.88))
		return

	var iso_quay_tiles: Texture2D = _get_lisboa_iso_quay_tiles()
	var iso_buildings: Texture2D = _get_lisboa_iso_buildings()
	var iso_props: Texture2D = _get_lisboa_iso_props()
	var iso_ships: Texture2D = _get_lisboa_iso_ships()
	var iso_crowd: Texture2D = _get_lisboa_iso_crowd()
	var iso_crowd_extra: Texture2D = _get_lisboa_iso_crowd_extra()
	var iso_passages: Texture2D = _get_lisboa_iso_passages()
	if _has_lisboa_iso_v2_assets(iso_quay_tiles, iso_buildings, iso_props, iso_ships, iso_crowd):
		_draw_world_modular_base()
		_draw_lisboa_iso_v2_layers(iso_quay_tiles, iso_buildings, iso_props, iso_ships, iso_crowd, iso_crowd_extra, iso_passages)
		return

	var quay_tiles: Texture2D = _get_lisboa_quay_tiles()
	var buildings: Texture2D = _get_lisboa_buildings()
	var props: Texture2D = _get_lisboa_props()
	var ships: Texture2D = _get_lisboa_ships()
	var crowd: Texture2D = _get_lisboa_crowd()
	if quay_tiles != null or buildings != null or props != null or ships != null or crowd != null:
		_draw_world_modular_base()
		_draw_lisboa_modular_layers(quay_tiles, props, buildings, ships, crowd)
		return

	var backdrop: Texture2D = _get_lisboa_backdrop()
	if backdrop != null:
		_draw_cover_texture(backdrop, Rect2(Vector2.ZERO, Vector2(1920.0, 1080.0)))
		draw_rect(Rect2(Vector2.ZERO, Vector2(1920.0, 1080.0)), Color(0.96, 0.9, 0.74, 0.1))
		return

	_draw_world_procedural()


func _get_lisboa_prototype_background() -> Texture2D:
	if lisboa_prototype_texture != null:
		return lisboa_prototype_texture

	for path in LISBOA_PROTOTYPE_BACKGROUND_CANDIDATES:
		if not ResourceLoader.exists(path):
			continue
		var resource: Resource = load(path)
		if resource is Texture2D:
			lisboa_prototype_texture = resource
			return lisboa_prototype_texture
	return null


func _get_lisboa_backdrop() -> Texture2D:
	if lisboa_backdrop_texture != null:
		return lisboa_backdrop_texture

	for path in LISBOA_KEYART_CANDIDATES:
		if not ResourceLoader.exists(path):
			continue
		var resource: Resource = load(path)
		if resource is Texture2D:
			lisboa_backdrop_texture = resource
			texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			return lisboa_backdrop_texture
	return null


func _get_lisboa_iso_quay_tiles() -> Texture2D:
	if lisboa_iso_quay_texture != null:
		return lisboa_iso_quay_texture
	lisboa_iso_quay_texture = _load_optional_texture(LISBOA_ISO_QUAY_CANDIDATES)
	return lisboa_iso_quay_texture


func _get_lisboa_iso_buildings() -> Texture2D:
	if lisboa_iso_buildings_texture != null:
		return lisboa_iso_buildings_texture
	lisboa_iso_buildings_texture = _load_optional_texture(LISBOA_ISO_BUILDINGS_CANDIDATES)
	return lisboa_iso_buildings_texture


func _get_lisboa_iso_props() -> Texture2D:
	if lisboa_iso_props_texture != null:
		return lisboa_iso_props_texture
	lisboa_iso_props_texture = _load_optional_texture(LISBOA_ISO_PROPS_CANDIDATES)
	return lisboa_iso_props_texture


func _get_lisboa_iso_ships() -> Texture2D:
	if lisboa_iso_ships_texture != null:
		return lisboa_iso_ships_texture
	lisboa_iso_ships_texture = _load_optional_texture(LISBOA_ISO_SHIPS_CANDIDATES)
	return lisboa_iso_ships_texture


func _get_lisboa_iso_crowd() -> Texture2D:
	if lisboa_iso_crowd_texture != null:
		return lisboa_iso_crowd_texture
	lisboa_iso_crowd_texture = _load_optional_texture(LISBOA_ISO_CROWD_CANDIDATES)
	return lisboa_iso_crowd_texture


func _get_lisboa_iso_crowd_extra() -> Texture2D:
	if lisboa_iso_crowd_extra_texture != null:
		return lisboa_iso_crowd_extra_texture
	lisboa_iso_crowd_extra_texture = _load_optional_texture(LISBOA_ISO_CROWD_EXTRA_CANDIDATES)
	return lisboa_iso_crowd_extra_texture


func _get_lisboa_iso_passages() -> Texture2D:
	if lisboa_iso_passages_texture != null:
		return lisboa_iso_passages_texture
	lisboa_iso_passages_texture = _load_optional_texture(LISBOA_ISO_PASSAGES_CANDIDATES)
	return lisboa_iso_passages_texture


func _get_lisboa_quay_tiles() -> Texture2D:
	if lisboa_quay_texture != null:
		return lisboa_quay_texture
	lisboa_quay_texture = _load_optional_texture(LISBOA_QUAY_CANDIDATES)
	return lisboa_quay_texture


func _get_lisboa_buildings() -> Texture2D:
	if lisboa_buildings_texture != null:
		return lisboa_buildings_texture
	lisboa_buildings_texture = _load_optional_texture(LISBOA_BUILDINGS_CANDIDATES)
	return lisboa_buildings_texture


func _get_lisboa_props() -> Texture2D:
	if lisboa_props_texture != null:
		return lisboa_props_texture
	lisboa_props_texture = _load_optional_texture(LISBOA_PROPS_CANDIDATES)
	return lisboa_props_texture


func _get_lisboa_ships() -> Texture2D:
	if lisboa_ships_texture != null:
		return lisboa_ships_texture
	lisboa_ships_texture = _load_optional_texture(LISBOA_SHIPS_CANDIDATES)
	return lisboa_ships_texture


func _get_lisboa_crowd() -> Texture2D:
	if lisboa_crowd_texture != null:
		return lisboa_crowd_texture
	lisboa_crowd_texture = _load_optional_texture(LISBOA_CROWD_CANDIDATES)
	return lisboa_crowd_texture


func _has_lisboa_iso_v2_assets(quay_tiles: Texture2D, buildings: Texture2D, props: Texture2D, ships: Texture2D, crowd: Texture2D) -> bool:
	var has_any_texture: bool = quay_tiles != null or buildings != null or props != null or ships != null or crowd != null
	return has_any_texture and not _get_lisboa_iso_meta().is_empty()


func _get_lisboa_iso_meta() -> Dictionary:
	if lisboa_iso_meta_loaded:
		return lisboa_iso_meta

	lisboa_iso_meta_loaded = true
	if not ResourceLoader.exists(LISBOA_ISO_META_PATH):
		return lisboa_iso_meta

	var handle: FileAccess = FileAccess.open(LISBOA_ISO_META_PATH, FileAccess.READ)
	if handle == null:
		return lisboa_iso_meta

	var parsed: Variant = JSON.parse_string(handle.get_as_text())
	if parsed is Dictionary:
		lisboa_iso_meta = parsed
	return lisboa_iso_meta


func _get_lisboa_iso_box(layer_key: String, index: int) -> Rect2:
	var boxes: Array = _get_lisboa_iso_meta().get(layer_key, [])
	if index < 0 or index >= boxes.size():
		return Rect2()
	var raw_box: Dictionary = boxes[index]
	return Rect2(
		float(raw_box.get("x", 0.0)),
		float(raw_box.get("y", 0.0)),
		float(raw_box.get("w", 0.0)),
		float(raw_box.get("h", 0.0))
	)


func _get_lisboa_interactable_position(interactable_id: String, fallback: Vector2) -> Vector2:
	for raw_interactable in interactables:
		var interactable: Dictionary = raw_interactable
		if str(interactable.get("id", "")) != interactable_id:
			continue
		return _vector_from_dict(interactable.get("position", {}))
	return fallback


func _load_optional_texture(candidates: Array[String]) -> Texture2D:
	for path in candidates:
		if not ResourceLoader.exists(path):
			continue
		var resource: Resource = load(path)
		if resource is Texture2D:
			return resource
	return null


func _draw_world_modular_base() -> void:
	var district_size: Vector2 = _get_district_size()
	_draw_district_sky(Color(0.84, 0.89, 0.95), Color(0.98, 0.92, 0.79, 0.14))
	draw_circle(Vector2(2390.0, 162.0), 216.0, Color(1.0, 0.95, 0.78, 0.08))
	draw_rect(Rect2(0.0, 162.0, district_size.x, 78.0), Color(1.0, 0.96, 0.84, 0.04))
	draw_rect(Rect2(0.0, 0.0, district_size.x, 112.0), Color(0.99, 0.95, 0.86, 0.03))
	var upper_terrace := _poly([
		Vector2(782.0, 236.0), Vector2(1836.0, 236.0), Vector2(2068.0, 430.0), Vector2(982.0, 474.0)
	])
	draw_colored_polygon(upper_terrace, Color(0.79, 0.73, 0.63, 0.84))
	draw_polyline(upper_terrace, Color(0.52, 0.43, 0.32, 0.26), 2.0, true)
	var eastern_terrace := _poly([
		Vector2(1688.0, 224.0), Vector2(district_size.x, 224.0), Vector2(district_size.x, 528.0), Vector2(1960.0, 530.0)
	])
	draw_colored_polygon(eastern_terrace, Color(0.77, 0.71, 0.61, 0.86))
	draw_polyline(eastern_terrace, Color(0.5, 0.41, 0.31, 0.22), 2.0, true)
	var civic_rise := _poly([
		Vector2(1450.0, 454.0), Vector2(2142.0, 454.0), Vector2(2330.0, 612.0), Vector2(1618.0, 624.0)
	])
	draw_colored_polygon(civic_rise, Color(0.74, 0.68, 0.58, 0.8))
	draw_polyline(civic_rise, Color(0.49, 0.4, 0.31, 0.18), 2.0, true)
	_draw_district_water(Rect2(0.0, 260.0, 676.0, district_size.y - 260.0), Color(0.12, 0.34, 0.46), Color(0.86, 0.95, 0.98, 0.18))
	_draw_district_water(Rect2(0.0, 1280.0, 700.0, district_size.y - 1280.0), Color(0.11, 0.31, 0.42), Color(0.84, 0.94, 0.97, 0.1))
	_draw_cobbled_plane([
		Vector2(232.0, 454.0), Vector2(1214.0, 454.0), Vector2(1416.0, 648.0), Vector2(348.0, 706.0)
	], Color(0.77, 0.7, 0.6), Color(0.58, 0.47, 0.34), 18, 34)
	_draw_cobbled_plane([
		Vector2(1186.0, 556.0), Vector2(2198.0, 556.0), Vector2(2430.0, 780.0), Vector2(1248.0, 816.0)
	], Color(0.75, 0.68, 0.58), Color(0.56, 0.45, 0.33), 18, 34)
	_draw_cobbled_plane([
		Vector2(2206.0, 618.0), Vector2(3030.0, 618.0), Vector2(3160.0, 858.0), Vector2(2336.0, 890.0)
	], Color(0.72, 0.65, 0.55), Color(0.54, 0.43, 0.31), 12, 26)
	_draw_cobbled_plane([
		Vector2(226.0, 846.0), Vector2(904.0, 846.0), Vector2(1082.0, 1036.0), Vector2(352.0, 1086.0)
	], Color(0.72, 0.65, 0.55), Color(0.54, 0.43, 0.31), 12, 22)
	_draw_cobbled_plane([
		Vector2(926.0, 866.0), Vector2(2020.0, 866.0), Vector2(2264.0, 1178.0), Vector2(1058.0, 1228.0)
	], Color(0.7, 0.62, 0.52), Color(0.5, 0.4, 0.29), 18, 36)
	_draw_cobbled_plane([
		Vector2(1936.0, 1008.0), Vector2(3060.0, 1008.0), Vector2(3160.0, 1360.0), Vector2(2044.0, 1394.0)
	], Color(0.68, 0.6, 0.5), Color(0.48, 0.38, 0.28), 18, 34)
	_draw_cobbled_plane([
		Vector2(542.0, 1044.0), Vector2(1276.0, 1044.0), Vector2(1490.0, 1320.0), Vector2(708.0, 1392.0)
	], Color(0.69, 0.61, 0.51), Color(0.49, 0.39, 0.28), 14, 22)
	_draw_cobbled_plane([
		Vector2(222.0, 1118.0), Vector2(720.0, 1118.0), Vector2(936.0, 1384.0), Vector2(316.0, 1452.0)
	], Color(0.69, 0.61, 0.5), Color(0.49, 0.39, 0.28), 12, 16)
	draw_rect(Rect2(0.0, district_size.y - 228.0, district_size.x, 228.0), Color(0.44, 0.36, 0.29, 0.18))
	draw_rect(Rect2(0.0, 1240.0, district_size.x, 86.0), Color(1.0, 0.9, 0.78, 0.02))


func _draw_lisboa_iso_v2_layers(
	quay_tiles: Texture2D,
	buildings: Texture2D,
	props: Texture2D,
	ships: Texture2D,
	crowd: Texture2D,
	crowd_extra: Texture2D,
	passages: Texture2D
) -> void:
	_draw_lisboa_iso_v2_ship_layer(ships)
	_draw_lisboa_iso_v2_quay_layer(quay_tiles)
	_draw_lisboa_iso_v2_passage_layer(passages)
	_draw_lisboa_iso_v2_building_layer(buildings)
	_draw_lisboa_iso_v2_props_layer(props)
	_draw_lisboa_iso_v2_crowd_extra_layer(crowd_extra)
	_draw_lisboa_iso_v2_crowd_layer(crowd)


func _draw_lisboa_iso_v2_quay_layer(quay_tiles: Texture2D) -> void:
	if quay_tiles == null:
		return
	var placements: Array = [
		{"index": 27, "position": Vector2(110.0, 430.0), "scale": 1.02, "alpha": 0.98},
		{"index": 21, "position": Vector2(178.0, 566.0), "scale": 0.88, "alpha": 0.92},
		{"index": 28, "position": Vector2(948.0, 546.0), "scale": 0.98, "alpha": 0.97},
		{"index": 24, "position": Vector2(1558.0, 592.0), "scale": 0.9, "alpha": 0.94},
		{"index": 33, "position": Vector2(2148.0, 612.0), "scale": 0.94, "alpha": 0.93},
		{"index": 31, "position": Vector2(164.0, 1028.0), "scale": 0.92, "alpha": 0.9},
		{"index": 32, "position": Vector2(778.0, 998.0), "scale": 0.84, "alpha": 0.9},
		{"index": 30, "position": Vector2(1712.0, 1032.0), "scale": 0.86, "alpha": 0.88},
		{"index": 34, "position": Vector2(1996.0, 1092.0), "scale": 0.88, "alpha": 0.88},
		{"index": 37, "position": Vector2(1112.0, 1270.0), "scale": 0.84, "alpha": 0.86},
		{"index": 35, "position": Vector2(622.0, 1302.0), "scale": 0.8, "alpha": 0.9},
		{"index": 38, "position": Vector2(390.0, 1416.0), "scale": 0.74, "alpha": 0.82}
	]
	for raw_placement in placements:
		var placement: Dictionary = raw_placement
		_draw_lisboa_iso_component(
			quay_tiles,
			"ground",
			int(placement.get("index", -1)),
			placement.get("position", Vector2.ZERO),
			float(placement.get("scale", 1.0)),
			float(placement.get("alpha", 1.0))
		)


func _draw_lisboa_iso_v2_building_layer(buildings: Texture2D) -> void:
	if buildings == null:
		return
	var placements: Array = [
		{"index": 10, "anchor_position": Vector2(562.0, 642.0), "scale": 0.9, "alpha": 0.98},
		{"index": 14, "anchor_position": Vector2(834.0, 566.0), "scale": 0.78, "alpha": 0.93},
		{"index": 1, "anchor_position": Vector2(1008.0, 516.0), "scale": 0.74, "alpha": 0.9},
		{"index": 3, "anchor_position": Vector2(1236.0, 504.0), "scale": 0.78, "alpha": 0.92},
		{"index": 2, "anchor_position": Vector2(1500.0, 488.0), "scale": 0.8, "alpha": 0.9},
		{"index": 12, "anchor_position": Vector2(1850.0, 720.0), "scale": 0.86, "alpha": 0.95},
		{"index": 7, "anchor_position": Vector2(1052.0, 1002.0), "scale": 0.78, "alpha": 0.95},
		{"index": 12, "anchor_position": Vector2(1810.0, 1090.0), "scale": 0.82, "alpha": 0.96},
		{"index": 9, "anchor_position": Vector2(2254.0, 684.0), "scale": 0.88, "alpha": 0.98},
		{"index": 13, "anchor_position": Vector2(2566.0, 662.0), "scale": 0.92, "alpha": 0.98},
		{"index": 4, "anchor_position": Vector2(2790.0, 500.0), "scale": 0.86, "alpha": 0.93},
		{"index": 1, "anchor_position": Vector2(936.0, 1278.0), "scale": 0.74, "alpha": 0.94},
		{"index": 14, "anchor_position": Vector2(724.0, 1298.0), "scale": 0.8, "alpha": 0.95},
		{"index": 10, "anchor_position": Vector2(432.0, 1460.0), "scale": 0.86, "alpha": 0.95}
	]
	for raw_placement in placements:
		var placement: Dictionary = raw_placement
		_draw_lisboa_iso_component_anchored(
			buildings,
			"buildings",
			int(placement.get("index", -1)),
			placement.get("anchor_position", Vector2.ZERO),
			float(placement.get("scale", 1.0)),
			Vector2(0.5, 1.0),
			float(placement.get("alpha", 1.0))
		)

	var duarte_pos: Vector2 = _get_lisboa_interactable_position("capitao_duarte", Vector2(2220.0, 756.0))
	var tome_pos: Vector2 = _get_lisboa_interactable_position("velho_tome", Vector2(2560.0, 1164.0))
	var casa_pasto_pos: Vector2 = _get_lisboa_interactable_position("casa_de_pasto_da_ribeira", Vector2(1210.0, 1208.0))
	var roteiros_pos: Vector2 = _get_lisboa_interactable_position("casa_dos_roteiros", Vector2(1506.0, 850.0))
	var caravela_pos: Vector2 = _get_lisboa_interactable_position("caravela_do_norte", Vector2(430.0, 618.0))
	var rossio_pos: Vector2 = _get_lisboa_interactable_position("to_rossio", Vector2(1324.0, 646.0))
	var se_pos: Vector2 = _get_lisboa_interactable_position("to_se", Vector2(1176.0, 598.0))
	var estaleiro_pos: Vector2 = _get_lisboa_interactable_position("to_estaleiro", Vector2(270.0, 792.0))
	_draw_lisboa_iso_component_anchored(buildings, "buildings", 11, roteiros_pos + Vector2(18.0, 66.0), 0.92, Vector2(0.5, 1.0), 0.99)
	_draw_lisboa_iso_component_anchored(buildings, "buildings", 5, casa_pasto_pos + Vector2(20.0, 90.0), 0.98, Vector2(0.5, 1.0), 0.99)
	_draw_lisboa_iso_component_anchored(buildings, "buildings", 0, duarte_pos + Vector2(18.0, 62.0), 0.94, Vector2(0.5, 1.0), 0.99)
	_draw_lisboa_iso_component_anchored(buildings, "buildings", 10, caravela_pos + Vector2(156.0, 56.0), 0.88, Vector2(0.5, 1.0), 0.97)
	_draw_lisboa_iso_component_anchored(buildings, "buildings", 6, se_pos + Vector2(44.0, 18.0), 0.82, Vector2(0.5, 1.0), 0.98)
	_draw_lisboa_iso_component_anchored(buildings, "buildings", 4, rossio_pos + Vector2(134.0, 12.0), 0.84, Vector2(0.5, 1.0), 0.97)
	_draw_lisboa_iso_component_anchored(buildings, "buildings", 13, tome_pos + Vector2(168.0, 16.0), 0.88, Vector2(0.5, 1.0), 0.95)
	_draw_lisboa_iso_component_anchored(buildings, "buildings", 10, estaleiro_pos + Vector2(162.0, 42.0), 0.88, Vector2(0.5, 1.0), 0.96)


func _draw_lisboa_iso_v2_passage_layer(passages: Texture2D) -> void:
	if passages == null:
		return
	var duarte_pos: Vector2 = _get_lisboa_interactable_position("capitao_duarte", Vector2(2220.0, 756.0))
	var roteiros_pos: Vector2 = _get_lisboa_interactable_position("casa_dos_roteiros", Vector2(1506.0, 850.0))
	var caravela_pos: Vector2 = _get_lisboa_interactable_position("caravela_do_norte", Vector2(430.0, 618.0))
	var rossio_pos: Vector2 = _get_lisboa_interactable_position("to_rossio", Vector2(2872.0, 1046.0))
	var se_pos: Vector2 = _get_lisboa_interactable_position("to_se", Vector2(2442.0, 742.0))
	var estaleiro_pos: Vector2 = _get_lisboa_interactable_position("to_estaleiro", Vector2(474.0, 1328.0))
	var placements: Array = [
		{"index": 10, "anchor_position": caravela_pos + Vector2(224.0, 108.0), "scale": 0.72, "alpha": 0.92},
		{"index": 18, "anchor_position": roteiros_pos + Vector2(-112.0, 46.0), "scale": 0.72, "alpha": 0.92},
		{"index": 9, "anchor_position": duarte_pos + Vector2(22.0, 74.0), "scale": 0.76, "alpha": 0.98},
		{"index": 15, "anchor_position": se_pos + Vector2(74.0, 52.0), "scale": 0.8, "alpha": 0.98},
		{"index": 17, "anchor_position": rossio_pos + Vector2(88.0, 44.0), "scale": 0.82, "alpha": 0.99},
		{"index": 14, "anchor_position": estaleiro_pos + Vector2(156.0, 40.0), "scale": 0.82, "alpha": 0.96},
		{"index": 13, "anchor_position": Vector2(1776.0, 936.0), "scale": 0.72, "alpha": 0.88},
		{"index": 11, "anchor_position": Vector2(2520.0, 792.0), "scale": 0.72, "alpha": 0.9},
		{"index": 1, "anchor_position": Vector2(1128.0, 734.0), "scale": 0.68, "alpha": 0.86}
	]
	for raw_placement in placements:
		var placement: Dictionary = raw_placement
		_draw_lisboa_iso_component_anchored(
			passages,
			"passages",
			int(placement.get("index", -1)),
			placement.get("anchor_position", Vector2.ZERO),
			float(placement.get("scale", 1.0)),
			Vector2(0.5, 1.0),
			float(placement.get("alpha", 1.0))
		)


func _draw_lisboa_iso_v2_ship_layer(ships: Texture2D) -> void:
	if ships == null:
		return
	var ship_time: float = district_time * 1.15
	var placements: Array = [
		{"index": 1, "position": Vector2(18.0, 250.0), "scale": 0.64, "alpha": 0.98, "bob": 3.2, "phase": 0.0},
		{"index": 0, "position": Vector2(286.0, 286.0), "scale": 0.58, "alpha": 0.96, "bob": 2.4, "phase": 0.6},
		{"index": 17, "position": Vector2(186.0, 530.0), "scale": 0.74, "alpha": 0.92, "bob": 0.0, "phase": 0.0},
		{"index": 11, "position": Vector2(446.0, 516.0), "scale": 0.72, "alpha": 0.92, "bob": 0.0, "phase": 0.0},
		{"index": 3, "position": Vector2(82.0, 502.0), "scale": 0.82, "alpha": 0.9, "bob": 1.8, "phase": 1.2},
		{"index": 4, "position": Vector2(132.0, 612.0), "scale": 0.72, "alpha": 0.86, "bob": 1.1, "phase": 1.8},
		{"index": 6, "position": Vector2(518.0, 696.0), "scale": 0.7, "alpha": 0.88, "bob": 0.0, "phase": 0.0},
		{"index": 15, "position": Vector2(1454.0, 736.0), "scale": 0.62, "alpha": 0.84, "bob": 0.0, "phase": 0.0},
		{"index": 16, "position": Vector2(2250.0, 670.0), "scale": 0.64, "alpha": 0.84, "bob": 0.0, "phase": 0.0},
		{"index": 12, "position": Vector2(378.0, 926.0), "scale": 0.68, "alpha": 0.88, "bob": 0.0, "phase": 0.0}
	]
	for raw_placement in placements:
		var placement: Dictionary = raw_placement
		var position: Vector2 = placement.get("position", Vector2.ZERO)
		position.y += sin(ship_time + float(placement.get("phase", 0.0))) * float(placement.get("bob", 0.0))
		_draw_lisboa_iso_component(
			ships,
			"ships",
			int(placement.get("index", -1)),
			position,
			float(placement.get("scale", 1.0)),
			float(placement.get("alpha", 1.0))
		)


func _draw_lisboa_iso_v2_props_layer(props: Texture2D) -> void:
	if props == null:
		return
	var cloth_wave: float = sin(district_time * 2.0) * 6.0
	var placements: Array = [
		{"index": 8, "anchor_position": Vector2(700.0, 724.0), "scale": 0.62, "alpha": 0.92},
		{"index": 3, "anchor_position": Vector2(566.0, 690.0), "scale": 0.34, "alpha": 0.9},
		{"index": 4, "anchor_position": Vector2(488.0, 620.0), "scale": 0.38, "alpha": 0.9},
		{"index": 6, "anchor_position": Vector2(434.0, 642.0), "scale": 0.4, "alpha": 0.9},
		{"index": 11, "anchor_position": Vector2(1176.0, 842.0), "scale": 0.46, "alpha": 0.9},
		{"index": 13, "anchor_position": Vector2(1468.0, 820.0), "scale": 0.58, "alpha": 0.92},
		{"index": 24, "anchor_position": Vector2(1590.0, 904.0 + cloth_wave * 0.2), "scale": 0.74, "alpha": 0.98},
		{"index": 23, "anchor_position": Vector2(1278.0, 954.0 - cloth_wave * 0.12), "scale": 0.78, "alpha": 0.96},
		{"index": 22, "anchor_position": Vector2(1036.0, 1096.0 + cloth_wave * 0.16), "scale": 0.7, "alpha": 0.95},
		{"index": 22, "anchor_position": Vector2(862.0, 938.0 + cloth_wave * 0.12), "scale": 0.64, "alpha": 0.94},
		{"index": 23, "anchor_position": Vector2(1500.0, 1104.0 - cloth_wave * 0.12), "scale": 0.7, "alpha": 0.94},
		{"index": 24, "anchor_position": Vector2(1818.0, 1036.0 + cloth_wave * 0.18), "scale": 0.68, "alpha": 0.96},
		{"index": 8, "anchor_position": Vector2(964.0, 934.0), "scale": 0.46, "alpha": 0.88},
		{"index": 3, "anchor_position": Vector2(2036.0, 1008.0), "scale": 0.3, "alpha": 0.86},
		{"index": 21, "anchor_position": Vector2(1812.0, 1080.0), "scale": 0.76, "alpha": 0.88},
		{"index": 14, "anchor_position": Vector2(2338.0, 1128.0), "scale": 0.68, "alpha": 0.88},
		{"index": 12, "anchor_position": Vector2(2370.0, 834.0), "scale": 0.48, "alpha": 0.9},
		{"index": 19, "anchor_position": Vector2(1890.0, 1112.0), "scale": 0.42, "alpha": 0.88},
		{"index": 17, "anchor_position": Vector2(624.0, 1184.0), "scale": 0.42, "alpha": 0.86},
		{"index": 20, "anchor_position": Vector2(1402.0, 1206.0), "scale": 0.54, "alpha": 0.86}
	]
	for raw_placement in placements:
		var placement: Dictionary = raw_placement
		_draw_lisboa_iso_component_anchored(
			props,
			"harbor_props",
			int(placement.get("index", -1)),
			placement.get("anchor_position", Vector2.ZERO),
			float(placement.get("scale", 1.0)),
			Vector2(0.5, 1.0),
			float(placement.get("alpha", 1.0))
		)

	var casa_pasto_pos: Vector2 = _get_lisboa_interactable_position("casa_de_pasto_da_ribeira", Vector2(1210.0, 1208.0))
	var roteiros_pos: Vector2 = _get_lisboa_interactable_position("casa_dos_roteiros", Vector2(1506.0, 850.0))
	var caravela_pos: Vector2 = _get_lisboa_interactable_position("caravela_do_norte", Vector2(430.0, 618.0))
	_draw_lisboa_iso_component_anchored(props, "harbor_props", 23, casa_pasto_pos + Vector2(82.0, 98.0 + cloth_wave * 0.14), 0.62, Vector2(0.5, 1.0), 0.98)
	_draw_lisboa_iso_component_anchored(props, "harbor_props", 13, roteiros_pos + Vector2(62.0, 98.0), 0.56, Vector2(0.5, 1.0), 0.98)
	_draw_lisboa_iso_component_anchored(props, "harbor_props", 11, roteiros_pos + Vector2(-92.0, 72.0), 0.42, Vector2(0.5, 1.0), 0.94)
	_draw_lisboa_iso_component_anchored(props, "harbor_props", 8, caravela_pos + Vector2(252.0, 112.0), 0.48, Vector2(0.5, 1.0), 0.9)
	_draw_lisboa_iso_component_anchored(props, "harbor_props", 0, caravela_pos + Vector2(152.0, 114.0), 0.4, Vector2(0.5, 1.0), 0.88)


func _draw_lisboa_iso_v2_crowd_layer(crowd: Texture2D) -> void:
	if crowd == null:
		return
	var placements: Array = [
		{"index": 0, "position": Vector2(638.0, 700.0), "scale": 0.16, "phase": 0.0},
		{"index": 1, "position": Vector2(432.0, 712.0), "scale": 0.15, "phase": 0.5},
		{"index": 4, "position": Vector2(1110.0, 726.0), "scale": 0.16, "phase": 0.9},
		{"index": 6, "position": Vector2(1448.0, 862.0), "scale": 0.15, "phase": 1.4},
		{"index": 7, "position": Vector2(1336.0, 1008.0), "scale": 0.16, "phase": 2.0},
		{"index": 8, "position": Vector2(1892.0, 918.0), "scale": 0.145, "phase": 2.7},
		{"index": 9, "position": Vector2(2474.0, 1124.0), "scale": 0.145, "phase": 3.4},
		{"index": 10, "position": Vector2(2812.0, 1078.0), "scale": 0.145, "phase": 4.1},
		{"index": 11, "position": Vector2(860.0, 1164.0), "scale": 0.145, "phase": 4.8},
		{"index": 5, "position": Vector2(1684.0, 960.0), "scale": 0.15, "phase": 5.5},
		{"index": 3, "position": Vector2(1778.0, 1084.0), "scale": 0.145, "phase": 6.0}
	]
	for raw_placement in placements:
		var placement: Dictionary = raw_placement
		var position: Vector2 = placement.get("position", Vector2.ZERO)
		position.y += sin(district_time * 2.4 + float(placement.get("phase", 0.0))) * 2.2
		_draw_lisboa_iso_component(
			crowd,
			"crowd",
			int(placement.get("index", -1)),
			position,
			float(placement.get("scale", 1.0)),
			0.98
		)

	var duarte_pos: Vector2 = _get_lisboa_interactable_position("capitao_duarte", Vector2(2220.0, 756.0))
	var tome_pos: Vector2 = _get_lisboa_interactable_position("velho_tome", Vector2(2560.0, 1164.0))
	var casa_pasto_pos: Vector2 = _get_lisboa_interactable_position("casa_de_pasto_da_ribeira", Vector2(1210.0, 1208.0))
	var roteiros_pos: Vector2 = _get_lisboa_interactable_position("casa_dos_roteiros", Vector2(1506.0, 850.0))
	var rossio_pos: Vector2 = _get_lisboa_interactable_position("to_rossio", Vector2(2872.0, 1046.0))
	var se_pos: Vector2 = _get_lisboa_interactable_position("to_se", Vector2(2442.0, 742.0))
	var pulse: float = sin(district_time * 2.2) * 1.6
	_draw_lisboa_iso_component_anchored(crowd, "crowd", 11, duarte_pos + Vector2(-44.0, 18.0 + pulse), 0.17, Vector2(0.5, 1.0), 0.99)
	_draw_lisboa_iso_component_anchored(crowd, "crowd", 9, tome_pos + Vector2(32.0, 18.0 - pulse), 0.165, Vector2(0.5, 1.0), 0.99)
	_draw_lisboa_iso_component_anchored(crowd, "crowd", 10, casa_pasto_pos + Vector2(-26.0, 22.0 + pulse * 0.7), 0.16, Vector2(0.5, 1.0), 0.99)
	_draw_lisboa_iso_component_anchored(crowd, "crowd", 7, roteiros_pos + Vector2(34.0, 22.0 - pulse * 0.7), 0.16, Vector2(0.5, 1.0), 0.99)
	_draw_lisboa_iso_component_anchored(crowd, "crowd", 1, rossio_pos + Vector2(-42.0, 22.0 + pulse * 0.5), 0.15, Vector2(0.5, 1.0), 0.98)
	_draw_lisboa_iso_component_anchored(crowd, "crowd", 6, se_pos + Vector2(42.0, 20.0 - pulse * 0.5), 0.15, Vector2(0.5, 1.0), 0.98)


func _draw_lisboa_iso_v2_crowd_extra_layer(crowd_extra: Texture2D) -> void:
	if crowd_extra == null:
		return
	var casa_pasto_pos: Vector2 = _get_lisboa_interactable_position("casa_de_pasto_da_ribeira", Vector2(1210.0, 1208.0))
	var roteiros_pos: Vector2 = _get_lisboa_interactable_position("casa_dos_roteiros", Vector2(1506.0, 850.0))
	var caravela_pos: Vector2 = _get_lisboa_interactable_position("caravela_do_norte", Vector2(430.0, 618.0))
	var rossio_pos: Vector2 = _get_lisboa_interactable_position("to_rossio", Vector2(2872.0, 1046.0))
	var se_pos: Vector2 = _get_lisboa_interactable_position("to_se", Vector2(2442.0, 742.0))
	var duarte_pos: Vector2 = _get_lisboa_interactable_position("capitao_duarte", Vector2(2220.0, 756.0))
	var tome_pos: Vector2 = _get_lisboa_interactable_position("velho_tome", Vector2(2560.0, 1164.0))
	var pulse: float = sin(district_time * 1.8) * 1.4
	var placements: Array = [
		{"index": 4, "anchor_position": duarte_pos + Vector2(94.0, 12.0 + pulse * 0.3), "scale": 0.1, "alpha": 0.97},
		{"index": 7, "anchor_position": roteiros_pos + Vector2(118.0, 28.0 - pulse * 0.2), "scale": 0.1, "alpha": 0.97},
		{"index": 8, "anchor_position": se_pos + Vector2(-104.0, 22.0 + pulse * 0.25), "scale": 0.095, "alpha": 0.97},
		{"index": 9, "anchor_position": rossio_pos + Vector2(-114.0, 18.0 - pulse * 0.2), "scale": 0.095, "alpha": 0.97},
		{"index": 11, "anchor_position": casa_pasto_pos + Vector2(106.0, 24.0 + pulse * 0.3), "scale": 0.11, "alpha": 0.97},
		{"index": 14, "anchor_position": tome_pos + Vector2(96.0, 20.0 - pulse * 0.3), "scale": 0.1, "alpha": 0.97},
		{"index": 18, "anchor_position": caravela_pos + Vector2(176.0, 108.0 + pulse * 0.2), "scale": 0.095, "alpha": 0.94},
		{"index": 12, "anchor_position": Vector2(2012.0, 1128.0 + pulse * 0.2), "scale": 0.1, "alpha": 0.96},
		{"index": 13, "anchor_position": Vector2(2338.0, 1194.0 - pulse * 0.25), "scale": 0.1, "alpha": 0.96},
		{"index": 0, "anchor_position": Vector2(1186.0, 920.0 + pulse * 0.16), "scale": 0.095, "alpha": 0.94},
		{"index": 2, "anchor_position": Vector2(1736.0, 1008.0 - pulse * 0.14), "scale": 0.095, "alpha": 0.94}
	]
	for raw_placement in placements:
		var placement: Dictionary = raw_placement
		_draw_lisboa_iso_component_anchored(
			crowd_extra,
			"crowd_extra",
			int(placement.get("index", -1)),
			placement.get("anchor_position", Vector2.ZERO),
			float(placement.get("scale", 1.0)),
			Vector2(0.5, 1.0),
			float(placement.get("alpha", 1.0))
		)


func _draw_lisboa_iso_component(texture: Texture2D, layer_key: String, index: int, position: Vector2, scale_value: float, alpha: float = 1.0) -> void:
	var source_rect: Rect2 = _get_lisboa_iso_box(layer_key, index)
	if texture == null or source_rect.size.x <= 0.0 or source_rect.size.y <= 0.0:
		return
	var dest_rect := Rect2(position, source_rect.size * scale_value)
	_draw_stamp(texture, source_rect, dest_rect, Color(1.0, 1.0, 1.0, alpha))


func _draw_lisboa_iso_component_anchored(texture: Texture2D, layer_key: String, index: int, anchor_position: Vector2, scale_value: float, anchor: Vector2 = Vector2(0.5, 1.0), alpha: float = 1.0) -> void:
	var source_rect: Rect2 = _get_lisboa_iso_box(layer_key, index)
	if texture == null or source_rect.size.x <= 0.0 or source_rect.size.y <= 0.0:
		return
	var size: Vector2 = source_rect.size * scale_value
	var top_left: Vector2 = anchor_position - Vector2(size.x * anchor.x, size.y * anchor.y)
	_draw_stamp(texture, source_rect, Rect2(top_left, size), Color(1.0, 1.0, 1.0, alpha))


func _draw_lisboa_modular_layers(quay_tiles: Texture2D, props: Texture2D, buildings: Texture2D, ships: Texture2D, crowd: Texture2D) -> void:
	_draw_lisboa_quay_layer(quay_tiles)
	_draw_lisboa_building_layer(buildings)
	_draw_lisboa_ship_layer(ships)
	_draw_lisboa_props_layer(props)
	_draw_lisboa_crowd_layer(crowd)


func _draw_lisboa_quay_layer(quay_tiles: Texture2D) -> void:
	if quay_tiles == null:
		return
	var stamps: Array = [
		{"source": Rect2(44.0, 62.0, 560.0, 136.0), "dest": Rect2(98.0, 396.0, 522.0, 126.0), "alpha": 0.98},
		{"source": Rect2(610.0, 70.0, 392.0, 126.0), "dest": Rect2(988.0, 214.0, 470.0, 152.0), "alpha": 0.97},
		{"source": Rect2(978.0, 78.0, 516.0, 122.0), "dest": Rect2(1362.0, 248.0, 432.0, 118.0), "alpha": 0.95},
		{"source": Rect2(48.0, 206.0, 302.0, 126.0), "dest": Rect2(208.0, 702.0, 212.0, 98.0), "alpha": 0.93},
		{"source": Rect2(502.0, 228.0, 680.0, 164.0), "dest": Rect2(522.0, 538.0, 718.0, 170.0), "alpha": 0.96},
		{"source": Rect2(1186.0, 230.0, 320.0, 168.0), "dest": Rect2(1370.0, 568.0, 348.0, 176.0), "alpha": 0.95},
		{"source": Rect2(18.0, 466.0, 610.0, 176.0), "dest": Rect2(166.0, 520.0, 468.0, 150.0), "alpha": 0.96},
		{"source": Rect2(308.0, 666.0, 364.0, 146.0), "dest": Rect2(854.0, 790.0, 320.0, 126.0), "alpha": 0.88}
	]
	for raw_stamp in stamps:
		var stamp: Dictionary = raw_stamp
		var source_rect: Rect2 = stamp["source"]
		var dest_rect: Rect2 = stamp["dest"]
		_draw_stamp(quay_tiles, source_rect, dest_rect, Color(1.0, 1.0, 1.0, float(stamp.get("alpha", 1.0))))


func _draw_lisboa_building_layer(buildings: Texture2D) -> void:
	if buildings == null:
		return
	var stamps: Array = [
		{"source": Rect2(66.0, 118.0, 404.0, 320.0), "dest": Rect2(344.0, 176.0, 426.0, 296.0), "alpha": 0.98},
		{"source": Rect2(482.0, 96.0, 564.0, 392.0), "dest": Rect2(1048.0, 146.0, 512.0, 348.0), "alpha": 0.99},
		{"source": Rect2(956.0, 120.0, 498.0, 336.0), "dest": Rect2(1382.0, 188.0, 404.0, 292.0), "alpha": 0.96},
		{"source": Rect2(80.0, 388.0, 328.0, 258.0), "dest": Rect2(268.0, 574.0, 246.0, 188.0), "alpha": 0.97},
		{"source": Rect2(388.0, 400.0, 348.0, 242.0), "dest": Rect2(704.0, 352.0, 286.0, 188.0), "alpha": 0.96},
		{"source": Rect2(736.0, 404.0, 286.0, 458.0), "dest": Rect2(1056.0, 390.0, 228.0, 372.0), "alpha": 0.98},
		{"source": Rect2(1002.0, 398.0, 456.0, 476.0), "dest": Rect2(1298.0, 392.0, 328.0, 372.0), "alpha": 0.98},
		{"source": Rect2(20.0, 642.0, 278.0, 248.0), "dest": Rect2(152.0, 740.0, 186.0, 150.0), "alpha": 0.92},
		{"source": Rect2(258.0, 618.0, 534.0, 300.0), "dest": Rect2(496.0, 520.0, 452.0, 242.0), "alpha": 0.95}
	]
	for raw_stamp in stamps:
		var stamp: Dictionary = raw_stamp
		var source_rect: Rect2 = stamp["source"]
		var dest_rect: Rect2 = stamp["dest"]
		_draw_stamp(buildings, source_rect, dest_rect, Color(1.0, 1.0, 1.0, float(stamp.get("alpha", 1.0))))


func _draw_lisboa_ship_layer(ships: Texture2D) -> void:
	if ships == null:
		return
	var ship_time: float = district_time * 1.15
	var stamps: Array = [
		{"source": Rect2(8.0, 472.0, 448.0, 188.0), "dest": Rect2(26.0, 438.0, 278.0, 116.0), "alpha": 0.88, "bob": 2.6, "phase": 0.2},
		{"source": Rect2(264.0, 150.0, 604.0, 560.0), "dest": Rect2(46.0, 246.0, 484.0, 394.0), "alpha": 0.98, "bob": 3.4, "phase": 0.0},
		{"source": Rect2(764.0, 170.0, 628.0, 558.0), "dest": Rect2(278.0, 268.0, 486.0, 378.0), "alpha": 0.97, "bob": 3.0, "phase": 0.9},
		{"source": Rect2(1100.0, 570.0, 420.0, 268.0), "dest": Rect2(126.0, 770.0, 260.0, 164.0), "alpha": 0.9, "bob": 1.0, "phase": 2.1}
	]
	for raw_stamp in stamps:
		var stamp: Dictionary = raw_stamp
		var source_rect: Rect2 = stamp["source"]
		var dest: Rect2 = stamp["dest"]
		dest.position.y += sin(ship_time + float(stamp.get("phase", 0.0))) * float(stamp.get("bob", 0.0))
		_draw_stamp(ships, source_rect, dest, Color(1.0, 1.0, 1.0, float(stamp.get("alpha", 1.0))))


func _draw_lisboa_props_layer(props: Texture2D) -> void:
	if props == null:
		return
	var cloth_wave: float = sin(district_time * 2.0) * 6.0
	var stamps: Array = [
		{"source": Rect2(0.0, 196.0, 252.0, 170.0), "dest": Rect2(738.0, 418.0, 146.0, 104.0), "alpha": 0.94},
		{"source": Rect2(0.0, 520.0, 250.0, 194.0), "dest": Rect2(154.0, 736.0, 176.0, 128.0), "alpha": 0.92},
		{"source": Rect2(212.0, 610.0, 340.0, 272.0), "dest": Rect2(284.0, 612.0 + cloth_wave, 250.0, 184.0), "alpha": 0.98},
		{"source": Rect2(558.0, 620.0, 392.0, 266.0), "dest": Rect2(880.0, 648.0 - cloth_wave * 0.25, 256.0, 176.0), "alpha": 0.95},
		{"source": Rect2(900.0, 610.0, 544.0, 280.0), "dest": Rect2(1176.0, 602.0 + cloth_wave * 0.35, 336.0, 196.0), "alpha": 0.98},
		{"source": Rect2(248.0, 198.0, 560.0, 188.0), "dest": Rect2(548.0, 702.0, 316.0, 106.0), "alpha": 0.88},
		{"source": Rect2(1184.0, 0.0, 352.0, 246.0), "dest": Rect2(1586.0, 476.0, 168.0, 120.0), "alpha": 0.9},
		{"source": Rect2(932.0, 850.0, 286.0, 112.0), "dest": Rect2(1366.0, 804.0, 182.0, 70.0), "alpha": 0.84}
	]
	for raw_stamp in stamps:
		var stamp: Dictionary = raw_stamp
		var source_rect: Rect2 = stamp["source"]
		var dest_rect: Rect2 = stamp["dest"]
		_draw_stamp(props, source_rect, dest_rect, Color(1.0, 1.0, 1.0, float(stamp.get("alpha", 1.0))))


func _draw_lisboa_crowd_layer(crowd: Texture2D) -> void:
	if crowd == null:
		return
	var people: Array = [
		{"source": Rect2(110.0, 154.0, 110.0, 152.0), "dest": Rect2(304.0, 354.0, 48.0, 68.0), "phase": 0.0},
		{"source": Rect2(268.0, 152.0, 176.0, 170.0), "dest": Rect2(1212.0, 706.0, 56.0, 74.0), "phase": 0.8},
		{"source": Rect2(470.0, 144.0, 86.0, 152.0), "dest": Rect2(1164.0, 650.0, 44.0, 68.0), "phase": 1.3},
		{"source": Rect2(650.0, 152.0, 82.0, 152.0), "dest": Rect2(740.0, 638.0, 42.0, 68.0), "phase": 1.8},
		{"source": Rect2(790.0, 138.0, 120.0, 176.0), "dest": Rect2(1454.0, 702.0, 48.0, 74.0), "phase": 2.2},
		{"source": Rect2(1002.0, 156.0, 126.0, 152.0), "dest": Rect2(812.0, 404.0, 54.0, 64.0), "phase": 2.9},
		{"source": Rect2(1164.0, 406.0, 188.0, 128.0), "dest": Rect2(396.0, 674.0, 72.0, 54.0), "phase": 3.4},
		{"source": Rect2(924.0, 426.0, 104.0, 110.0), "dest": Rect2(948.0, 724.0, 48.0, 52.0), "phase": 4.1},
		{"source": Rect2(490.0, 440.0, 90.0, 96.0), "dest": Rect2(554.0, 718.0, 42.0, 48.0), "phase": 4.7}
	]
	for raw_person in people:
		var person: Dictionary = raw_person
		var source_rect: Rect2 = person["source"]
		var dest: Rect2 = person["dest"]
		dest.position.y += sin(district_time * 2.4 + float(person.get("phase", 0.0))) * 2.5
		_draw_stamp(crowd, source_rect, dest, Color(1.0, 1.0, 1.0, 0.98))


func _draw_stamp(texture: Texture2D, source_rect: Rect2, dest_rect: Rect2, modulate: Color) -> void:
	if texture == null:
		return
	var clamped_source := Rect2(source_rect.position, source_rect.size)
	var tex_size: Vector2 = texture.get_size()
	clamped_source.position.x = clampf(clamped_source.position.x, 0.0, tex_size.x - 1.0)
	clamped_source.position.y = clampf(clamped_source.position.y, 0.0, tex_size.y - 1.0)
	clamped_source.size.x = clampf(clamped_source.size.x, 1.0, tex_size.x - clamped_source.position.x)
	clamped_source.size.y = clampf(clamped_source.size.y, 1.0, tex_size.y - clamped_source.position.y)
	draw_texture_rect_region(texture, dest_rect, clamped_source, modulate, false, false)


func _draw_world_procedural() -> void:
	_draw_district_sky(Color(0.86, 0.91, 0.96), Color(0.96, 0.88, 0.76, 0.16))
	_draw_district_water(Rect2(0.0, 320.0, 690.0, 760.0), Color(0.14, 0.33, 0.43), Color(0.84, 0.94, 0.97, 0.18))
	_draw_cobbled_plane([
		Vector2(178.0, 422.0), Vector2(904.0, 422.0), Vector2(1010.0, 532.0), Vector2(284.0, 532.0)
	], Color(0.76, 0.69, 0.58), Color(0.59, 0.48, 0.35), 10, 16)
	_draw_cobbled_plane([
		Vector2(590.0, 566.0), Vector2(1372.0, 566.0), Vector2(1474.0, 680.0), Vector2(692.0, 680.0)
	], Color(0.72, 0.66, 0.55), Color(0.56, 0.45, 0.33), 9, 14)

	for pier_x in [242.0, 372.0, 516.0]:
		draw_rect(Rect2(pier_x, 532.0, 78.0, 164.0), Color(0.6, 0.45, 0.29))
		for plank in range(1, 5):
			var y: float = 544.0 + float(plank) * 28.0
			draw_line(Vector2(pier_x, y), Vector2(pier_x + 78.0, y), Color(0.34, 0.24, 0.16), 2.0)

	_draw_small_ship(Vector2(236.0, 364.0), 1.0)
	_draw_small_ship(Vector2(420.0, 430.0), 0.76)
	_draw_small_ship(Vector2(176.0, 728.0), 0.7)

	_draw_iso_building(Rect2(472.0, 250.0, 220.0, 134.0), Color(0.81, 0.75, 0.64), Color(0.59, 0.45, 0.3), Color(0.37, 0.26, 0.18), Color(0.27, 0.17, 0.11), Color(0.94, 0.9, 0.8), 3, 2, 1.2)
	_draw_iso_building(Rect2(742.0, 304.0, 164.0, 110.0), Color(0.74, 0.66, 0.54), Color(0.53, 0.4, 0.26), Color(0.34, 0.24, 0.17), Color(0.24, 0.15, 0.1), Color(0.92, 0.88, 0.78), 2, 2)
	_draw_iso_building(Rect2(444.0, 586.0, 154.0, 110.0), Color(0.69, 0.6, 0.48), Color(0.56, 0.42, 0.27), Color(0.34, 0.24, 0.17), Color(0.24, 0.15, 0.1), Color(0.91, 0.87, 0.78), 2, 2)
	_draw_iso_stall(Rect2(690.0, 618.0, 132.0, 82.0), Color(0.58, 0.33, 0.2), Color(0.43, 0.29, 0.17), Color(0.93, 0.82, 0.55))
	_draw_tree_cluster(Vector2(1228.0, 716.0), 0.92)
	_draw_tree_cluster(Vector2(1324.0, 752.0), 0.76)
	_draw_crate_stack(Vector2(862.0, 446.0), 2)
	_draw_barrel(Vector2(612.0, 720.0), 16.0, 30.0)
	_draw_banner(Vector2(564.0, 270.0), Color(0.63, 0.15, 0.18))
	_draw_banner(Vector2(810.0, 322.0), Color(0.16, 0.32, 0.56))

	_draw_zone_label(Vector2(512.0, 226.0), "Ribeira de Lisboa")
	_draw_zone_label(Vector2(742.0, 582.0), "Casa de Pasto e Roteiros")
	_draw_zone_label(Vector2(202.0, 498.0), "Cais do Norte")


func _draw_cover_texture(texture: Texture2D, rect: Rect2, modulate: Color = Color.WHITE) -> void:
	var tex_size: Vector2 = texture.get_size()
	if tex_size.x <= 0.0 or tex_size.y <= 0.0:
		draw_texture_rect(texture, rect, false, modulate)
		return

	var target_ratio: float = rect.size.x / rect.size.y
	var source_ratio: float = tex_size.x / tex_size.y
	var source_rect := Rect2(Vector2.ZERO, tex_size)
	if source_ratio > target_ratio:
		var new_width: float = tex_size.y * target_ratio
		source_rect.position.x = (tex_size.x - new_width) * 0.5
		source_rect.size.x = new_width
	else:
		var new_height: float = tex_size.x / target_ratio
		source_rect.position.y = (tex_size.y - new_height) * 0.5
		source_rect.size.y = new_height

	draw_texture_rect_region(texture, rect, source_rect, modulate, false, false)
