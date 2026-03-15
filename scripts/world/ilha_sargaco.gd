extends "res://scripts/world/world_scene.gd"


func _draw_world() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(1920.0, 1080.0)), Color(0.08, 0.18, 0.26))
	_draw_water_band(Rect2(Vector2.ZERO, Vector2(1920.0, 1080.0)), Color(0.09, 0.22, 0.3), Color(0.22, 0.36, 0.48))
	_draw_tiled_ground(Rect2(Vector2(420.0, 260.0), Vector2(1080.0, 560.0)), 48.0, Color(0.76, 0.7, 0.56), Color(0.72, 0.66, 0.52))
	_draw_path(Rect2(Vector2(760.0, 520.0), Vector2(380.0, 90.0)), Color(0.62, 0.52, 0.36), Color(0.44, 0.34, 0.24))
	_draw_house_block(Rect2(Vector2(980.0, 430.0), Vector2(200.0, 160.0)), Color(0.8, 0.72, 0.6), Color(0.42, 0.28, 0.18), Color(0.3, 0.22, 0.16))
	_draw_stall(Rect2(Vector2(760.0, 380.0), Vector2(170.0, 140.0)), Color(0.86, 0.78, 0.64), Color(0.4, 0.3, 0.2))
	_draw_tree(Vector2(560.0, 420.0), Color(0.36, 0.22, 0.14), Color(0.3, 0.46, 0.3))
	_draw_tree(Vector2(640.0, 560.0), Color(0.36, 0.22, 0.14), Color(0.32, 0.48, 0.32))
	_draw_ship(Rect2(Vector2(300.0, 640.0), Vector2(200.0, 140.0)), Color(0.34, 0.22, 0.12), Color(0.94, 0.9, 0.82))
