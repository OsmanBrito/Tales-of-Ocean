extends "res://scripts/world/lisboa_district_scene.gd"


func _draw_world() -> void:
	_draw_district_sky(Color(0.87, 0.9, 0.95), Color(0.96, 0.88, 0.76, 0.15))
	_draw_cobbled_plane([
		Vector2(162.0, 560.0), Vector2(986.0, 560.0), Vector2(1142.0, 716.0), Vector2(318.0, 716.0)
	], Color(0.74, 0.67, 0.56), Color(0.57, 0.46, 0.33), 7, 13)
	_draw_cobbled_plane([
		Vector2(980.0, 428.0), Vector2(1638.0, 428.0), Vector2(1782.0, 566.0), Vector2(1124.0, 566.0)
	], Color(0.72, 0.65, 0.54), Color(0.56, 0.45, 0.32), 5, 10)

	draw_rect(Rect2(1052.0, 264.0, 480.0, 136.0), Color(0.7, 0.62, 0.5))
	_draw_gate(Vector2(1216.0, 288.0), Vector2(118.0, 112.0), Color(0.74, 0.66, 0.54), Color(0.46, 0.33, 0.21))
	draw_rect(Rect2(1068.0, 222.0, 76.0, 178.0), Color(0.74, 0.66, 0.54))
	draw_rect(Rect2(1434.0, 210.0, 80.0, 190.0), Color(0.74, 0.66, 0.54))
	_draw_banner(Vector2(1106.0, 238.0), Color(0.61, 0.15, 0.18))
	_draw_banner(Vector2(1472.0, 226.0), Color(0.18, 0.29, 0.55))

	_draw_iso_building(Rect2(640.0, 378.0, 172.0, 108.0), Color(0.67, 0.58, 0.47), Color(0.52, 0.39, 0.25), Color(0.34, 0.24, 0.17), Color(0.24, 0.15, 0.1), Color(0.9, 0.86, 0.77), 2, 2)
	_draw_iso_building(Rect2(1468.0, 344.0, 170.0, 110.0), Color(0.69, 0.61, 0.49), Color(0.53, 0.39, 0.24), Color(0.34, 0.24, 0.17), Color(0.24, 0.15, 0.1), Color(0.9, 0.86, 0.77), 2, 2)
	_draw_crate_stack(Vector2(808.0, 522.0), 3)
	_draw_barrel(Vector2(716.0, 514.0), 16.0, 30.0)
	_draw_tree_cluster(Vector2(1688.0, 724.0), 0.82)
	_draw_tree_cluster(Vector2(1546.0, 776.0), 0.72)
	_draw_zone_label(Vector2(1180.0, 188.0), "Porta Oriental")
	_draw_zone_label(Vector2(1468.0, 320.0), "Fortim da Barra")
