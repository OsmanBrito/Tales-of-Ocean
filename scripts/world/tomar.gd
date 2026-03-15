extends "res://scripts/world/world_scene.gd"


func _draw_world() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(1920.0, 1080.0)), Color(0.9, 0.86, 0.76))
	_draw_water_band(Rect2(0.0, 760.0, 1920.0, 320.0), Color(0.17, 0.34, 0.45), Color(0.84, 0.93, 0.95))

	var embankment := PackedVector2Array([
		Vector2(0.0, 760.0),
		Vector2(280.0, 720.0),
		Vector2(620.0, 700.0),
		Vector2(980.0, 716.0),
		Vector2(1320.0, 690.0),
		Vector2(1920.0, 660.0),
		Vector2(1920.0, 1080.0),
		Vector2(0.0, 1080.0)
	])
	draw_colored_polygon(embankment, Color(0.55, 0.46, 0.31))

	_draw_path(Rect2(690.0, 520.0, 520.0, 92.0), Color(0.73, 0.67, 0.55), Color(0.55, 0.45, 0.33))
	_draw_path(Rect2(860.0, 608.0, 146.0, 176.0), Color(0.7, 0.64, 0.54), Color(0.52, 0.42, 0.3))
	_draw_path(Rect2(420.0, 560.0, 360.0, 80.0), Color(0.72, 0.66, 0.55), Color(0.55, 0.45, 0.33))
	_draw_path(Rect2(1180.0, 600.0, 340.0, 76.0), Color(0.72, 0.66, 0.55), Color(0.55, 0.45, 0.33))

	draw_rect(Rect2(760.0, 190.0, 360.0, 264.0), Color(0.79, 0.73, 0.62))
	draw_rect(Rect2(812.0, 242.0, 256.0, 160.0), Color(0.67, 0.6, 0.47))
	draw_circle(Vector2(940.0, 320.0), 112.0, Color(0.84, 0.79, 0.7))
	draw_circle(Vector2(940.0, 320.0), 72.0, Color(0.57, 0.48, 0.33))
	draw_circle(Vector2(940.0, 320.0), 42.0, Color(0.9, 0.86, 0.75))
	draw_arc(Vector2(940.0, 320.0), 92.0, 0.0, TAU, 48, Color(0.56, 0.44, 0.23), 5.0)
	draw_rect(Rect2(740.0, 218.0, 34.0, 208.0), Color(0.66, 0.58, 0.45))
	draw_rect(Rect2(1106.0, 218.0, 34.0, 208.0), Color(0.66, 0.58, 0.45))

	var cloister_roof := PackedVector2Array([
		Vector2(720.0, 188.0),
		Vector2(940.0, 96.0),
		Vector2(1160.0, 188.0)
	])
	draw_colored_polygon(cloister_roof, Color(0.43, 0.29, 0.18))

	for column_x in [1240.0, 1290.0, 1340.0, 1390.0]:
		draw_rect(Rect2(column_x, 222.0, 18.0, 154.0), Color(0.74, 0.68, 0.57))
	draw_rect(Rect2(1218.0, 210.0, 212.0, 24.0), Color(0.5, 0.36, 0.23))
	draw_rect(Rect2(1218.0, 366.0, 212.0, 20.0), Color(0.5, 0.36, 0.23))

	draw_rect(Rect2(180.0, 700.0, 168.0, 102.0), Color(0.63, 0.55, 0.42))
	var mill_roof := PackedVector2Array([
		Vector2(162.0, 706.0),
		Vector2(264.0, 640.0),
		Vector2(366.0, 706.0)
	])
	draw_colored_polygon(mill_roof, Color(0.39, 0.27, 0.19))
	draw_line(Vector2(264.0, 742.0), Vector2(264.0, 656.0), Color(0.38, 0.24, 0.16), 4.0)
	draw_line(Vector2(222.0, 700.0), Vector2(306.0, 742.0), Color(0.38, 0.24, 0.16), 4.0)
	draw_line(Vector2(222.0, 742.0), Vector2(306.0, 700.0), Color(0.38, 0.24, 0.16), 4.0)

	draw_rect(Rect2(760.0, 772.0, 344.0, 38.0), Color(0.58, 0.46, 0.31))
	draw_rect(Rect2(812.0, 736.0, 24.0, 74.0), Color(0.46, 0.35, 0.24))
	draw_rect(Rect2(1026.0, 736.0, 24.0, 74.0), Color(0.46, 0.35, 0.24))

	_draw_house_block(Rect2(1420.0, 486.0, 208.0, 134.0), Color(0.67, 0.6, 0.47), Color(0.38, 0.27, 0.19), Color(0.25, 0.17, 0.1))
	_draw_house_block(Rect2(1600.0, 530.0, 168.0, 114.0), Color(0.7, 0.63, 0.49), Color(0.43, 0.31, 0.2), Color(0.27, 0.17, 0.1))
	_draw_stall(Rect2(1370.0, 650.0, 188.0, 120.0), Color(0.49, 0.44, 0.62), Color(0.44, 0.31, 0.2))

	for tree_position in [Vector2(520.0, 686.0), Vector2(590.0, 656.0), Vector2(1180.0, 552.0), Vector2(1260.0, 612.0)]:
		_draw_tree(tree_position, Color(0.42, 0.28, 0.14), Color(0.29, 0.43, 0.24))
