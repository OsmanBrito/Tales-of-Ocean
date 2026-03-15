extends "res://scripts/world/world_scene.gd"


func _draw_world() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(1920.0, 1080.0)), Color(0.92, 0.84, 0.7))
	_draw_water_band(Rect2(0.0, 650.0, 1920.0, 430.0), Color(0.12, 0.27, 0.34), Color(0.77, 0.88, 0.91))

	var cliff_back := PackedVector2Array([
		Vector2(0.0, 720.0),
		Vector2(260.0, 670.0),
		Vector2(540.0, 560.0),
		Vector2(830.0, 520.0),
		Vector2(1130.0, 560.0),
		Vector2(1450.0, 440.0),
		Vector2(1920.0, 330.0),
		Vector2(1920.0, 1080.0),
		Vector2(0.0, 1080.0)
	])
	draw_colored_polygon(cliff_back, Color(0.56, 0.48, 0.33))

	var cliff_front := PackedVector2Array([
		Vector2(0.0, 790.0),
		Vector2(310.0, 730.0),
		Vector2(630.0, 660.0),
		Vector2(970.0, 680.0),
		Vector2(1370.0, 730.0),
		Vector2(1920.0, 690.0),
		Vector2(1920.0, 1080.0),
		Vector2(0.0, 1080.0)
	])
	draw_colored_polygon(cliff_front, Color(0.39, 0.35, 0.26))

	draw_rect(Rect2(1018.0, 158.0, 112.0, 398.0), Color(0.86, 0.82, 0.74))
	draw_rect(Rect2(1046.0, 92.0, 56.0, 96.0), Color(0.93, 0.88, 0.8))
	draw_rect(Rect2(1038.0, 220.0, 72.0, 48.0), Color(0.63, 0.53, 0.35))
	var tower_roof := PackedVector2Array([
		Vector2(1012.0, 92.0),
		Vector2(1074.0, 24.0),
		Vector2(1136.0, 92.0)
	])
	draw_colored_polygon(tower_roof, Color(0.45, 0.33, 0.16))
	draw_circle(Vector2(1074.0, 136.0), 28.0, Color(0.96, 0.84, 0.55))
	draw_circle(Vector2(1074.0, 136.0), 50.0, Color(0.96, 0.84, 0.55, 0.3))

	_draw_path(Rect2(740.0, 560.0, 540.0, 90.0), Color(0.73, 0.64, 0.48), Color(0.54, 0.44, 0.31))
	_draw_path(Rect2(1140.0, 610.0, 320.0, 78.0), Color(0.74, 0.66, 0.49), Color(0.56, 0.45, 0.3))

	_draw_house_block(Rect2(1440.0, 452.0, 208.0, 132.0), Color(0.65, 0.56, 0.42), Color(0.33, 0.24, 0.15), Color(0.25, 0.17, 0.1))
	_draw_stall(Rect2(316.0, 660.0, 176.0, 114.0), Color(0.46, 0.38, 0.58), Color(0.45, 0.33, 0.21))
	_draw_tree(Vector2(550.0, 590.0), Color(0.44, 0.29, 0.14), Color(0.35, 0.52, 0.31))
	_draw_tree(Vector2(620.0, 640.0), Color(0.44, 0.29, 0.14), Color(0.3, 0.45, 0.27))

	draw_arc(Vector2(210.0, 780.0), 60.0, PI * 0.08, PI * 0.92, 18, Color(0.86, 0.93, 0.95), 4.0)
	draw_arc(Vector2(1180.0, 840.0), 86.0, PI * 0.08, PI * 0.92, 22, Color(0.86, 0.93, 0.95), 4.0)
	draw_arc(Vector2(1640.0, 880.0), 72.0, PI * 0.08, PI * 0.92, 20, Color(0.86, 0.93, 0.95), 4.0)
