extends "res://scripts/world/lisboa_district_scene.gd"

const LISBOA_WORLD_BOUNDS := Rect2(0.0, 0.0, 3200.0, 1760.0)
const LISBOA_NAVIGATION_BOUNDS := Rect2(180.0, 320.0, 2840.0, 1220.0)
const LISBOA_COLLISION_RADIUS := 18.0
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


func _ready() -> void:
	super._ready()
	_configure_lisboa_navigation()
	_configure_lisboa_camera()


func _get_district_size() -> Vector2:
	return LISBOA_WORLD_BOUNDS.size


func _configure_lisboa_navigation() -> void:
	if player == null or not player.has_method("configure_navigation"):
		return
	player.call("configure_navigation", LISBOA_NAVIGATION_BOUNDS, _get_lisboa_walkable_polygons(), LISBOA_COLLISION_RADIUS)
	if player.has_method("is_position_walkable") and not bool(player.call("is_position_walkable", player.position)):
		player.position = default_spawn_position


func _configure_lisboa_camera() -> void:
	var camera: Camera2D = get_node_or_null("Player/Camera2D")
	if camera == null:
		return
	camera.enabled = true
	camera.limit_left = int(LISBOA_WORLD_BOUNDS.position.x)
	camera.limit_top = int(LISBOA_WORLD_BOUNDS.position.y)
	camera.limit_right = int(LISBOA_WORLD_BOUNDS.end.x)
	camera.limit_bottom = int(LISBOA_WORLD_BOUNDS.end.y)
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 6.5
	camera.limit_smoothed = true
	camera.force_update_scroll()


func _get_lisboa_walkable_polygons() -> Array:
	return [
		PackedVector2Array([
			Vector2(190.0, 430.0), Vector2(1150.0, 430.0), Vector2(1380.0, 650.0), Vector2(360.0, 680.0)
		]),
		PackedVector2Array([
			Vector2(980.0, 520.0), Vector2(2120.0, 520.0), Vector2(2330.0, 770.0), Vector2(1150.0, 790.0)
		]),
		PackedVector2Array([
			Vector2(1970.0, 610.0), Vector2(3030.0, 610.0), Vector2(3140.0, 840.0), Vector2(2140.0, 860.0)
		]),
		PackedVector2Array([
			Vector2(200.0, 820.0), Vector2(900.0, 820.0), Vector2(1110.0, 1040.0), Vector2(370.0, 1080.0)
		]),
		PackedVector2Array([
			Vector2(860.0, 880.0), Vector2(2100.0, 880.0), Vector2(2330.0, 1190.0), Vector2(1050.0, 1220.0)
		]),
		PackedVector2Array([
			Vector2(1900.0, 1010.0), Vector2(3060.0, 1010.0), Vector2(3160.0, 1350.0), Vector2(2030.0, 1370.0)
		]),
		PackedVector2Array([
			Vector2(180.0, 1080.0), Vector2(760.0, 1080.0), Vector2(920.0, 1320.0), Vector2(250.0, 1380.0)
		])
	]


func _draw_world() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
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
		_draw_zone_label(Vector2(1036.0, 212.0), "Ribeira de Lisboa")
		_draw_zone_label(Vector2(1114.0, 852.0), "Mercado da Ribeira")
		_draw_zone_label(Vector2(238.0, 548.0), "Cais do Norte")
		_draw_zone_label(Vector2(2282.0, 714.0), "Subida da Se")
		return

	var quay_tiles: Texture2D = _get_lisboa_quay_tiles()
	var buildings: Texture2D = _get_lisboa_buildings()
	var props: Texture2D = _get_lisboa_props()
	var ships: Texture2D = _get_lisboa_ships()
	var crowd: Texture2D = _get_lisboa_crowd()
	if quay_tiles != null or buildings != null or props != null or ships != null or crowd != null:
		_draw_world_modular_base()
		_draw_lisboa_modular_layers(quay_tiles, props, buildings, ships, crowd)
		_draw_zone_label(Vector2(612.0, 152.0), "Ribeira de Lisboa")
		_draw_zone_label(Vector2(642.0, 516.0), "Casa de Pasto e Roteiros")
		_draw_zone_label(Vector2(172.0, 470.0), "Cais do Norte")
		return

	var backdrop: Texture2D = _get_lisboa_backdrop()
	if backdrop != null:
		_draw_cover_texture(backdrop, Rect2(Vector2.ZERO, Vector2(1920.0, 1080.0)))
		draw_rect(Rect2(Vector2.ZERO, Vector2(1920.0, 1080.0)), Color(0.96, 0.9, 0.74, 0.1))
		_draw_zone_label(Vector2(536.0, 226.0), "Ribeira de Lisboa")
		_draw_zone_label(Vector2(1018.0, 588.0), "Casa de Pasto e Roteiros")
		_draw_zone_label(Vector2(226.0, 520.0), "Cais do Norte")
		return

	_draw_world_procedural()


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
	_draw_district_sky(Color(0.84, 0.9, 0.96), Color(0.97, 0.9, 0.76, 0.16))
	draw_circle(Vector2(2220.0, 166.0), 210.0, Color(1.0, 0.95, 0.76, 0.08))
	draw_rect(Rect2(0.0, 178.0, district_size.x, 72.0), Color(1.0, 0.96, 0.82, 0.05))
	draw_rect(Rect2(0.0, 0.0, district_size.x, 108.0), Color(0.99, 0.95, 0.86, 0.04))
	_draw_district_water(Rect2(0.0, 240.0, 760.0, district_size.y - 240.0), Color(0.12, 0.34, 0.46), Color(0.86, 0.95, 0.98, 0.22))
	_draw_district_water(Rect2(0.0, 1160.0, 520.0, district_size.y - 1160.0), Color(0.11, 0.31, 0.42), Color(0.84, 0.94, 0.97, 0.12))
	_draw_cobbled_plane([
		Vector2(188.0, 430.0), Vector2(1128.0, 430.0), Vector2(1366.0, 648.0), Vector2(366.0, 678.0)
	], Color(0.79, 0.72, 0.61), Color(0.6, 0.49, 0.35), 10, 20)
	_draw_cobbled_plane([
		Vector2(998.0, 520.0), Vector2(2120.0, 520.0), Vector2(2360.0, 772.0), Vector2(1178.0, 792.0)
	], Color(0.76, 0.69, 0.58), Color(0.58, 0.47, 0.34), 10, 22)
	_draw_cobbled_plane([
		Vector2(1980.0, 610.0), Vector2(3020.0, 610.0), Vector2(3140.0, 838.0), Vector2(2146.0, 860.0)
	], Color(0.73, 0.66, 0.55), Color(0.56, 0.45, 0.32), 8, 20)
	_draw_cobbled_plane([
		Vector2(204.0, 826.0), Vector2(896.0, 826.0), Vector2(1100.0, 1042.0), Vector2(372.0, 1082.0)
	], Color(0.71, 0.64, 0.54), Color(0.53, 0.43, 0.31), 8, 14)
	_draw_cobbled_plane([
		Vector2(884.0, 882.0), Vector2(2104.0, 882.0), Vector2(2342.0, 1192.0), Vector2(1060.0, 1222.0)
	], Color(0.68, 0.61, 0.51), Color(0.5, 0.4, 0.29), 8, 18)
	_draw_cobbled_plane([
		Vector2(1910.0, 1012.0), Vector2(3058.0, 1012.0), Vector2(3158.0, 1348.0), Vector2(2034.0, 1372.0)
	], Color(0.66, 0.59, 0.49), Color(0.48, 0.38, 0.28), 9, 18)
	_draw_cobbled_plane([
		Vector2(184.0, 1084.0), Vector2(760.0, 1084.0), Vector2(922.0, 1320.0), Vector2(252.0, 1378.0)
	], Color(0.69, 0.61, 0.5), Color(0.5, 0.4, 0.29), 7, 12)
	draw_rect(Rect2(0.0, district_size.y - 240.0, district_size.x, 240.0), Color(0.44, 0.36, 0.29, 0.28))
	draw_rect(Rect2(0.0, 1260.0, district_size.x, 80.0), Color(1.0, 0.9, 0.78, 0.03))


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
		{"index": 10, "position": Vector2(946.0, 236.0), "scale": 0.92, "alpha": 0.82},
		{"index": 21, "position": Vector2(128.0, 430.0), "scale": 1.05, "alpha": 0.94},
		{"index": 24, "position": Vector2(1358.0, 576.0), "scale": 0.9, "alpha": 0.9},
		{"index": 27, "position": Vector2(132.0, 516.0), "scale": 0.95, "alpha": 0.98},
		{"index": 28, "position": Vector2(522.0, 544.0), "scale": 1.0, "alpha": 0.98},
		{"index": 31, "position": Vector2(160.0, 734.0), "scale": 0.9, "alpha": 0.9},
		{"index": 32, "position": Vector2(760.0, 792.0), "scale": 0.82, "alpha": 0.88},
		{"index": 28, "position": Vector2(1682.0, 600.0), "scale": 1.0, "alpha": 0.98},
		{"index": 24, "position": Vector2(2228.0, 692.0), "scale": 0.92, "alpha": 0.92},
		{"index": 10, "position": Vector2(2406.0, 566.0), "scale": 0.98, "alpha": 0.84},
		{"index": 31, "position": Vector2(2408.0, 1144.0), "scale": 0.9, "alpha": 0.88},
		{"index": 32, "position": Vector2(1940.0, 1084.0), "scale": 0.84, "alpha": 0.86}
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
		{"index": 5, "position": Vector2(256.0, 214.0), "scale": 1.0, "alpha": 0.98},
		{"index": 8, "position": Vector2(1040.0, 176.0), "scale": 1.0, "alpha": 0.99},
		{"index": 9, "position": Vector2(1366.0, 210.0), "scale": 0.9, "alpha": 0.98},
		{"index": 10, "position": Vector2(248.0, 558.0), "scale": 0.86, "alpha": 0.96},
		{"index": 11, "position": Vector2(676.0, 360.0), "scale": 0.88, "alpha": 0.96},
		{"index": 6, "position": Vector2(1090.0, 386.0), "scale": 0.86, "alpha": 0.97},
		{"index": 13, "position": Vector2(1314.0, 402.0), "scale": 0.86, "alpha": 0.97},
		{"index": 11, "position": Vector2(1762.0, 472.0), "scale": 0.9, "alpha": 0.97},
		{"index": 6, "position": Vector2(2096.0, 430.0), "scale": 0.86, "alpha": 0.97},
		{"index": 13, "position": Vector2(2442.0, 456.0), "scale": 0.88, "alpha": 0.97},
		{"index": 8, "position": Vector2(2696.0, 360.0), "scale": 0.94, "alpha": 0.98},
		{"index": 10, "position": Vector2(2202.0, 860.0), "scale": 0.84, "alpha": 0.94}
	]
	for raw_placement in placements:
		var placement: Dictionary = raw_placement
		_draw_lisboa_iso_component(
			buildings,
			"buildings",
			int(placement.get("index", -1)),
			placement.get("position", Vector2.ZERO),
			float(placement.get("scale", 1.0)),
			float(placement.get("alpha", 1.0))
		)

	var rossio_pos: Vector2 = _get_lisboa_interactable_position("to_rossio", Vector2(1324.0, 646.0))
	var se_pos: Vector2 = _get_lisboa_interactable_position("to_se", Vector2(1176.0, 598.0))
	var estaleiro_pos: Vector2 = _get_lisboa_interactable_position("to_estaleiro", Vector2(270.0, 792.0))
	_draw_lisboa_iso_component_anchored(buildings, "buildings", 0, rossio_pos + Vector2(66.0, -8.0), 0.86, Vector2(0.5, 1.0), 0.98)
	_draw_lisboa_iso_component_anchored(buildings, "buildings", 6, se_pos + Vector2(26.0, 18.0), 0.8, Vector2(0.5, 1.0), 0.97)
	_draw_lisboa_iso_component_anchored(buildings, "buildings", 10, estaleiro_pos + Vector2(190.0, 28.0), 0.9, Vector2(0.5, 1.0), 0.95)


func _draw_lisboa_iso_v2_passage_layer(passages: Texture2D) -> void:
	if passages == null:
		return
	var roteiros_pos: Vector2 = _get_lisboa_interactable_position("casa_dos_roteiros", Vector2(820.0, 438.0))
	var caravela_pos: Vector2 = _get_lisboa_interactable_position("caravela_do_norte", Vector2(246.0, 406.0))
	var rossio_pos: Vector2 = _get_lisboa_interactable_position("to_rossio", Vector2(1324.0, 646.0))
	var se_pos: Vector2 = _get_lisboa_interactable_position("to_se", Vector2(1176.0, 598.0))
	var estaleiro_pos: Vector2 = _get_lisboa_interactable_position("to_estaleiro", Vector2(270.0, 792.0))
	var placements: Array = [
		{"index": 10, "anchor_position": caravela_pos + Vector2(168.0, 118.0), "scale": 0.72, "alpha": 0.88},
		{"index": 9, "anchor_position": roteiros_pos + Vector2(154.0, 54.0), "scale": 0.72, "alpha": 0.93},
		{"index": 18, "anchor_position": se_pos + Vector2(54.0, 42.0), "scale": 0.8, "alpha": 0.97},
		{"index": 16, "anchor_position": rossio_pos + Vector2(74.0, 38.0), "scale": 0.82, "alpha": 0.98},
		{"index": 15, "anchor_position": estaleiro_pos + Vector2(142.0, 14.0), "scale": 0.84, "alpha": 0.95},
		{"index": 13, "anchor_position": Vector2(1840.0, 944.0), "scale": 0.76, "alpha": 0.9},
		{"index": 11, "anchor_position": Vector2(2060.0, 820.0), "scale": 0.74, "alpha": 0.9}
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
		{"index": 1, "position": Vector2(18.0, 236.0), "scale": 0.58, "alpha": 0.98, "bob": 3.2, "phase": 0.0},
		{"index": 0, "position": Vector2(292.0, 250.0), "scale": 0.62, "alpha": 0.96, "bob": 2.6, "phase": 0.6},
		{"index": 3, "position": Vector2(42.0, 458.0), "scale": 0.72, "alpha": 0.9, "bob": 1.8, "phase": 1.2},
		{"index": 4, "position": Vector2(114.0, 792.0), "scale": 0.92, "alpha": 0.84, "bob": 0.9, "phase": 2.0}
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
		{"index": 22, "position": Vector2(198.0, 718.0), "scale": 0.62, "alpha": 0.94},
		{"index": 23, "position": Vector2(856.0, 650.0 - cloth_wave * 0.25), "scale": 0.72, "alpha": 0.93},
		{"index": 24, "position": Vector2(1146.0, 600.0 + cloth_wave * 0.35), "scale": 0.74, "alpha": 0.98},
		{"index": 8, "position": Vector2(1542.0, 466.0), "scale": 0.56, "alpha": 0.9},
		{"index": 13, "position": Vector2(566.0, 714.0), "scale": 0.66, "alpha": 0.9},
		{"index": 21, "position": Vector2(1358.0, 812.0), "scale": 0.82, "alpha": 0.86},
		{"index": 24, "position": Vector2(1698.0, 928.0 + cloth_wave * 0.25), "scale": 0.72, "alpha": 0.96},
		{"index": 23, "position": Vector2(1976.0, 904.0 - cloth_wave * 0.2), "scale": 0.7, "alpha": 0.94},
		{"index": 22, "position": Vector2(2340.0, 1086.0), "scale": 0.62, "alpha": 0.9},
		{"index": 8, "position": Vector2(2664.0, 858.0), "scale": 0.56, "alpha": 0.88},
		{"index": 13, "position": Vector2(2870.0, 1214.0), "scale": 0.74, "alpha": 0.9}
	]
	for raw_placement in placements:
		var placement: Dictionary = raw_placement
		_draw_lisboa_iso_component(
			props,
			"harbor_props",
			int(placement.get("index", -1)),
			placement.get("position", Vector2.ZERO),
			float(placement.get("scale", 1.0)),
			float(placement.get("alpha", 1.0))
		)

	var casa_pasto_pos: Vector2 = _get_lisboa_interactable_position("casa_de_pasto_da_ribeira", Vector2(522.0, 678.0))
	var roteiros_pos: Vector2 = _get_lisboa_interactable_position("casa_dos_roteiros", Vector2(820.0, 438.0))
	var caravela_pos: Vector2 = _get_lisboa_interactable_position("caravela_do_norte", Vector2(246.0, 406.0))
	_draw_lisboa_iso_component_anchored(props, "harbor_props", 24, casa_pasto_pos + Vector2(58.0, 98.0 + cloth_wave * 0.18), 0.62, Vector2(0.5, 1.0), 0.99)
	_draw_lisboa_iso_component_anchored(props, "harbor_props", 23, roteiros_pos + Vector2(58.0, 112.0 - cloth_wave * 0.1), 0.58, Vector2(0.5, 1.0), 0.97)
	_draw_lisboa_iso_component_anchored(props, "harbor_props", 22, Vector2(320.0, 872.0), 0.56, Vector2(0.5, 1.0), 0.94)
	_draw_lisboa_iso_component_anchored(props, "harbor_props", 3, caravela_pos + Vector2(220.0, 108.0), 0.36, Vector2(0.0, 1.0), 0.9)


func _draw_lisboa_iso_v2_crowd_layer(crowd: Texture2D) -> void:
	if crowd == null:
		return
	var placements: Array = [
		{"index": 0, "position": Vector2(296.0, 356.0), "scale": 0.28, "phase": 0.0},
		{"index": 4, "position": Vector2(1200.0, 708.0), "scale": 0.25, "phase": 0.8},
		{"index": 5, "position": Vector2(1142.0, 648.0), "scale": 0.24, "phase": 1.3},
		{"index": 6, "position": Vector2(728.0, 636.0), "scale": 0.24, "phase": 1.8},
		{"index": 7, "position": Vector2(1440.0, 700.0), "scale": 0.25, "phase": 2.2},
		{"index": 8, "position": Vector2(800.0, 402.0), "scale": 0.22, "phase": 2.8},
		{"index": 9, "position": Vector2(388.0, 672.0), "scale": 0.21, "phase": 3.4},
		{"index": 10, "position": Vector2(942.0, 724.0), "scale": 0.21, "phase": 4.0},
		{"index": 11, "position": Vector2(542.0, 718.0), "scale": 0.2, "phase": 4.6},
		{"index": 4, "position": Vector2(1770.0, 998.0), "scale": 0.24, "phase": 5.1},
		{"index": 6, "position": Vector2(2128.0, 716.0), "scale": 0.24, "phase": 5.6},
		{"index": 8, "position": Vector2(2480.0, 772.0), "scale": 0.22, "phase": 6.0},
		{"index": 10, "position": Vector2(2580.0, 1126.0), "scale": 0.21, "phase": 6.5}
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

	var duarte_pos: Vector2 = _get_lisboa_interactable_position("capitao_duarte", Vector2(566.0, 350.0))
	var tome_pos: Vector2 = _get_lisboa_interactable_position("velho_tome", Vector2(736.0, 654.0))
	var casa_pasto_pos: Vector2 = _get_lisboa_interactable_position("casa_de_pasto_da_ribeira", Vector2(522.0, 678.0))
	var roteiros_pos: Vector2 = _get_lisboa_interactable_position("casa_dos_roteiros", Vector2(820.0, 438.0))
	var rossio_pos: Vector2 = _get_lisboa_interactable_position("to_rossio", Vector2(1324.0, 646.0))
	var se_pos: Vector2 = _get_lisboa_interactable_position("to_se", Vector2(1176.0, 598.0))
	var pulse: float = sin(district_time * 2.2) * 1.6
	_draw_lisboa_iso_component_anchored(crowd, "crowd", 11, duarte_pos + Vector2(-46.0, 18.0 + pulse), 0.26, Vector2(0.5, 1.0), 0.99)
	_draw_lisboa_iso_component_anchored(crowd, "crowd", 9, tome_pos + Vector2(32.0, 18.0 - pulse), 0.25, Vector2(0.5, 1.0), 0.99)
	_draw_lisboa_iso_component_anchored(crowd, "crowd", 10, casa_pasto_pos + Vector2(-28.0, 20.0 + pulse * 0.7), 0.24, Vector2(0.5, 1.0), 0.99)
	_draw_lisboa_iso_component_anchored(crowd, "crowd", 7, roteiros_pos + Vector2(34.0, 20.0 - pulse * 0.7), 0.24, Vector2(0.5, 1.0), 0.99)
	_draw_lisboa_iso_component_anchored(crowd, "crowd", 1, rossio_pos + Vector2(-42.0, 20.0 + pulse * 0.5), 0.23, Vector2(0.5, 1.0), 0.98)
	_draw_lisboa_iso_component_anchored(crowd, "crowd", 6, se_pos + Vector2(40.0, 18.0 - pulse * 0.5), 0.23, Vector2(0.5, 1.0), 0.98)


func _draw_lisboa_iso_v2_crowd_extra_layer(crowd_extra: Texture2D) -> void:
	if crowd_extra == null:
		return
	var casa_pasto_pos: Vector2 = _get_lisboa_interactable_position("casa_de_pasto_da_ribeira", Vector2(522.0, 678.0))
	var roteiros_pos: Vector2 = _get_lisboa_interactable_position("casa_dos_roteiros", Vector2(820.0, 438.0))
	var caravela_pos: Vector2 = _get_lisboa_interactable_position("caravela_do_norte", Vector2(246.0, 406.0))
	var rossio_pos: Vector2 = _get_lisboa_interactable_position("to_rossio", Vector2(1324.0, 646.0))
	var se_pos: Vector2 = _get_lisboa_interactable_position("to_se", Vector2(1176.0, 598.0))
	var duarte_pos: Vector2 = _get_lisboa_interactable_position("capitao_duarte", Vector2(566.0, 350.0))
	var tome_pos: Vector2 = _get_lisboa_interactable_position("velho_tome", Vector2(736.0, 654.0))
	var pulse: float = sin(district_time * 1.8) * 1.4
	var placements: Array = [
		{"index": 4, "anchor_position": duarte_pos + Vector2(106.0, 12.0 + pulse * 0.3), "scale": 0.18, "alpha": 0.97},
		{"index": 7, "anchor_position": roteiros_pos + Vector2(132.0, 28.0 - pulse * 0.2), "scale": 0.18, "alpha": 0.97},
		{"index": 8, "anchor_position": se_pos + Vector2(-104.0, 22.0 + pulse * 0.25), "scale": 0.17, "alpha": 0.97},
		{"index": 9, "anchor_position": rossio_pos + Vector2(-114.0, 18.0 - pulse * 0.2), "scale": 0.17, "alpha": 0.97},
		{"index": 11, "anchor_position": casa_pasto_pos + Vector2(118.0, 28.0 + pulse * 0.3), "scale": 0.19, "alpha": 0.97},
		{"index": 14, "anchor_position": tome_pos + Vector2(104.0, 20.0 - pulse * 0.3), "scale": 0.18, "alpha": 0.97},
		{"index": 18, "anchor_position": caravela_pos + Vector2(210.0, 118.0 + pulse * 0.2), "scale": 0.17, "alpha": 0.94},
		{"index": 12, "anchor_position": Vector2(2060.0, 1044.0 + pulse * 0.2), "scale": 0.18, "alpha": 0.96},
		{"index": 13, "anchor_position": Vector2(2440.0, 1160.0 - pulse * 0.25), "scale": 0.18, "alpha": 0.96}
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


func _draw_cover_texture(texture: Texture2D, rect: Rect2) -> void:
	var tex_size: Vector2 = texture.get_size()
	if tex_size.x <= 0.0 or tex_size.y <= 0.0:
		draw_texture_rect(texture, rect, false)
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

	draw_texture_rect_region(texture, rect, source_rect, Color.WHITE, false, false)
