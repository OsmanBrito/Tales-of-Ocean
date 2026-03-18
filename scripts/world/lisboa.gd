extends "res://scripts/world/lisboa_district_scene.gd"


func _draw_world() -> void:
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
