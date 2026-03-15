extends "res://scripts/world/world_scene.gd"


func _draw_world() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(1920.0, 1080.0)), Color(0.06, 0.18, 0.18))
	_draw_water_band(Rect2(Vector2.ZERO, Vector2(1920.0, 1080.0)), Color(0.07, 0.2, 0.24), Color(0.2, 0.34, 0.36))
	_draw_tiled_ground(Rect2(Vector2(360.0, 220.0), Vector2(1200.0, 640.0)), 48.0, Color(0.22, 0.44, 0.28), Color(0.18, 0.4, 0.24))
	_draw_path(Rect2(Vector2(740.0, 520.0), Vector2(420.0, 90.0)), Color(0.54, 0.46, 0.3), Color(0.36, 0.3, 0.2))
	_draw_house_block(Rect2(Vector2(980.0, 420.0), Vector2(220.0, 170.0)), Color(0.76, 0.7, 0.58), Color(0.42, 0.28, 0.18), Color(0.3, 0.2, 0.14))
	_draw_stall(Rect2(Vector2(740.0, 380.0), Vector2(180.0, 150.0)), Color(0.86, 0.82, 0.66), Color(0.4, 0.3, 0.2))
	_draw_tree(Vector2(520.0, 380.0), Color(0.32, 0.2, 0.12), Color(0.18, 0.5, 0.28))
	_draw_tree(Vector2(620.0, 540.0), Color(0.32, 0.2, 0.12), Color(0.2, 0.54, 0.3))
	_draw_tree(Vector2(1380.0, 520.0), Color(0.32, 0.2, 0.12), Color(0.18, 0.46, 0.26))
	_draw_ship(Rect2(Vector2(300.0, 640.0), Vector2(220.0, 150.0)), Color(0.34, 0.22, 0.12), Color(0.94, 0.9, 0.82))
