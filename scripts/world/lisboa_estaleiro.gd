extends "res://scripts/world/lisboa_district_scene.gd"


func _draw_world() -> void:
	_draw_district_sky(Color(0.85, 0.9, 0.95), Color(0.95, 0.87, 0.76, 0.14))
	_draw_district_water(Rect2(0.0, 482.0, 980.0, 598.0), Color(0.14, 0.33, 0.42), Color(0.82, 0.94, 0.97, 0.18))
	_draw_cobbled_plane([
		Vector2(356.0, 426.0), Vector2(1288.0, 426.0), Vector2(1406.0, 552.0), Vector2(474.0, 552.0)
	], Color(0.75, 0.69, 0.58), Color(0.58, 0.47, 0.34), 8, 14)
	_draw_cobbled_plane([
		Vector2(866.0, 580.0), Vector2(1620.0, 580.0), Vector2(1748.0, 712.0), Vector2(994.0, 712.0)
	], Color(0.72, 0.66, 0.55), Color(0.56, 0.45, 0.33), 6, 12)

	for pier_x in [280.0, 428.0, 600.0]:
		draw_rect(Rect2(pier_x, 552.0, 92.0, 208.0), Color(0.59, 0.44, 0.28))
		for plank in range(1, 6):
			var y: float = 564.0 + float(plank) * 32.0
			draw_line(Vector2(pier_x, y), Vector2(pier_x + 92.0, y), Color(0.35, 0.24, 0.16), 2.0)

	_draw_small_ship(Vector2(242.0, 612.0), 0.82)
	_draw_small_ship(Vector2(388.0, 704.0), 0.7)
	_draw_small_ship(Vector2(726.0, 648.0), 0.88)

	_draw_iso_building(Rect2(980.0, 290.0, 220.0, 128.0), Color(0.69, 0.6, 0.49), Color(0.52, 0.39, 0.25), Color(0.34, 0.24, 0.17), Color(0.24, 0.15, 0.1), Color(0.91, 0.87, 0.78), 3, 2)
	_draw_iso_building(Rect2(1234.0, 324.0, 150.0, 112.0), Color(0.67, 0.58, 0.47), Color(0.5, 0.37, 0.24), Color(0.34, 0.24, 0.17), Color(0.24, 0.15, 0.1), Color(0.9, 0.86, 0.77), 2, 2)
	draw_line(Vector2(904.0, 520.0), Vector2(904.0, 330.0), Color(0.43, 0.3, 0.19), 8.0)
	draw_line(Vector2(904.0, 330.0), Vector2(1042.0, 260.0), Color(0.43, 0.3, 0.19), 8.0)
	draw_line(Vector2(1018.0, 272.0), Vector2(1018.0, 380.0), Color(0.33, 0.23, 0.15), 3.0)
	draw_circle(Vector2(1018.0, 384.0), 9.0, Color(0.54, 0.41, 0.24))
	_draw_crate_stack(Vector2(1162.0, 482.0), 4)
	_draw_barrel(Vector2(1332.0, 500.0), 18.0, 34.0)
	_draw_banner(Vector2(1086.0, 318.0), Color(0.19, 0.33, 0.58))
	_draw_zone_label(Vector2(980.0, 266.0), "Estaleiro da Junqueira")
