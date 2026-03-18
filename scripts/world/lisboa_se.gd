extends "res://scripts/world/lisboa_district_scene.gd"


func _draw_world() -> void:
	_draw_district_sky(Color(0.87, 0.91, 0.96), Color(0.96, 0.88, 0.76, 0.16))
	_draw_cobbled_plane([
		Vector2(220.0, 422.0), Vector2(1230.0, 422.0), Vector2(1374.0, 574.0), Vector2(364.0, 574.0)
	], Color(0.76, 0.69, 0.58), Color(0.59, 0.48, 0.35), 10, 18)
	_draw_cobbled_plane([
		Vector2(866.0, 594.0), Vector2(1570.0, 594.0), Vector2(1690.0, 726.0), Vector2(986.0, 726.0)
	], Color(0.73, 0.66, 0.55), Color(0.56, 0.45, 0.33), 6, 12)

	_draw_iso_building(Rect2(530.0, 228.0, 252.0, 168.0), Color(0.82, 0.77, 0.69), Color(0.59, 0.44, 0.29), Color(0.35, 0.25, 0.17), Color(0.24, 0.15, 0.1), Color(0.93, 0.9, 0.82), 3, 2, 1.18)
	_draw_iso_building(Rect2(804.0, 256.0, 70.0, 188.0), Color(0.79, 0.74, 0.66), Color(0.55, 0.41, 0.27), Color(0.35, 0.25, 0.17), Color(0.24, 0.15, 0.1), Color(0.92, 0.88, 0.8), 1, 3)
	_draw_iso_building(Rect2(1008.0, 356.0, 158.0, 110.0), Color(0.71, 0.63, 0.51), Color(0.54, 0.4, 0.26), Color(0.34, 0.24, 0.17), Color(0.24, 0.15, 0.1), Color(0.91, 0.87, 0.78), 2, 2)
	_draw_iso_building(Rect2(1188.0, 390.0, 124.0, 94.0), Color(0.68, 0.6, 0.49), Color(0.52, 0.39, 0.25), Color(0.34, 0.24, 0.17), Color(0.24, 0.15, 0.1), Color(0.91, 0.87, 0.78), 2, 2)
	_draw_banner(Vector2(1096.0, 372.0), Color(0.17, 0.48, 0.34))
	_draw_tree_cluster(Vector2(1416.0, 714.0), 0.84)
	_draw_tree_cluster(Vector2(1512.0, 748.0), 0.74)
	_draw_barrel(Vector2(1276.0, 540.0), 16.0, 30.0)
	_draw_crate_stack(Vector2(1138.0, 530.0), 2)

	_draw_zone_label(Vector2(546.0, 204.0), "Se de Lisboa")
	_draw_zone_label(Vector2(1020.0, 330.0), "Botica e Rua dos Clerigos")
