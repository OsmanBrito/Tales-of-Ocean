extends "res://scripts/world/lisboa_district_scene.gd"

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
var lisboa_quay_texture: Texture2D
var lisboa_buildings_texture: Texture2D
var lisboa_props_texture: Texture2D
var lisboa_ships_texture: Texture2D
var lisboa_crowd_texture: Texture2D


func _draw_world() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
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


func _load_optional_texture(candidates: Array[String]) -> Texture2D:
	for path in candidates:
		if not ResourceLoader.exists(path):
			continue
		var resource: Resource = load(path)
		if resource is Texture2D:
			return resource
	return null


func _draw_world_modular_base() -> void:
	_draw_district_sky(Color(0.84, 0.9, 0.96), Color(0.97, 0.9, 0.76, 0.16))
	_draw_district_water(Rect2(0.0, 260.0, 742.0, 820.0), Color(0.12, 0.34, 0.46), Color(0.86, 0.95, 0.98, 0.22))
	_draw_district_water(Rect2(0.0, 738.0, 304.0, 342.0), Color(0.12, 0.31, 0.41), Color(0.86, 0.95, 0.98, 0.12))
	_draw_cobbled_plane([
		Vector2(168.0, 406.0), Vector2(976.0, 406.0), Vector2(1120.0, 554.0), Vector2(306.0, 554.0)
	], Color(0.79, 0.72, 0.61), Color(0.6, 0.49, 0.35), 9, 18)
	_draw_cobbled_plane([
		Vector2(418.0, 532.0), Vector2(1566.0, 532.0), Vector2(1734.0, 760.0), Vector2(588.0, 760.0)
	], Color(0.75, 0.68, 0.57), Color(0.57, 0.46, 0.33), 11, 22)
	_draw_cobbled_plane([
		Vector2(916.0, 206.0), Vector2(1718.0, 206.0), Vector2(1866.0, 396.0), Vector2(1060.0, 396.0)
	], Color(0.72, 0.65, 0.54), Color(0.55, 0.44, 0.31), 7, 14)
	_draw_cobbled_plane([
		Vector2(182.0, 698.0), Vector2(536.0, 698.0), Vector2(688.0, 856.0), Vector2(332.0, 856.0)
	], Color(0.7, 0.63, 0.53), Color(0.52, 0.42, 0.3), 6, 10)
	_draw_cobbled_plane([
		Vector2(604.0, 758.0), Vector2(1138.0, 758.0), Vector2(1300.0, 938.0), Vector2(766.0, 938.0)
	], Color(0.67, 0.6, 0.5), Color(0.49, 0.39, 0.28), 6, 12)
	draw_rect(Rect2(0.0, 900.0, 1920.0, 180.0), Color(0.44, 0.36, 0.29, 0.28))


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
