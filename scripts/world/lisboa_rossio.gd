extends "res://scripts/world/lisboa_district_scene.gd"


func _draw_world() -> void:
	_draw_district_sky(Color(0.89, 0.92, 0.97), Color(0.97, 0.89, 0.78, 0.15))
	_draw_cobbled_plane([
		Vector2(162.0, 388.0), Vector2(1448.0, 388.0), Vector2(1604.0, 566.0), Vector2(318.0, 566.0)
	], Color(0.76, 0.69, 0.58), Color(0.59, 0.48, 0.35), 12, 24)
	_draw_cobbled_plane([
		Vector2(456.0, 594.0), Vector2(1606.0, 594.0), Vector2(1770.0, 760.0), Vector2(620.0, 760.0)
	], Color(0.73, 0.66, 0.55), Color(0.56, 0.45, 0.33), 8, 18)

	_draw_iso_building(Rect2(1032.0, 286.0, 210.0, 126.0), Color(0.72, 0.64, 0.52), Color(0.55, 0.41, 0.27), Color(0.34, 0.24, 0.17), Color(0.24, 0.15, 0.1), Color(0.91, 0.87, 0.78), 3, 2, 1.1)
	_draw_iso_building(Rect2(1260.0, 338.0, 146.0, 108.0), Color(0.69, 0.6, 0.49), Color(0.54, 0.4, 0.25), Color(0.34, 0.24, 0.17), Color(0.24, 0.15, 0.1), Color(0.91, 0.87, 0.78), 2, 2)
	_draw_iso_building(Rect2(326.0, 314.0, 158.0, 118.0), Color(0.73, 0.66, 0.55), Color(0.56, 0.42, 0.28), Color(0.34, 0.24, 0.17), Color(0.24, 0.15, 0.1), Color(0.91, 0.87, 0.78), 2, 2)

	_draw_iso_stall(Rect2(576.0, 598.0, 136.0, 82.0), Color(0.61, 0.33, 0.18), Color(0.43, 0.29, 0.17), Color(0.92, 0.8, 0.54))
	_draw_iso_stall(Rect2(770.0, 620.0, 134.0, 80.0), Color(0.19, 0.45, 0.55), Color(0.43, 0.29, 0.17), Color(0.91, 0.8, 0.56))
	_draw_iso_stall(Rect2(952.0, 610.0, 128.0, 78.0), Color(0.52, 0.42, 0.16), Color(0.43, 0.29, 0.17), Color(0.93, 0.84, 0.58))
	_draw_crate_stack(Vector2(1230.0, 520.0), 3)
	_draw_barrel(Vector2(1158.0, 514.0), 16.0, 30.0)
	_draw_tree_cluster(Vector2(1546.0, 720.0), 0.88)
	_draw_tree_cluster(Vector2(1666.0, 760.0), 0.74)

	_draw_zone_label(Vector2(1038.0, 260.0), "Rossio e Armazens")
	_draw_zone_label(Vector2(630.0, 566.0), "Bancas do Mercado")
