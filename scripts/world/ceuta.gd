extends "res://scripts/world/world_scene.gd"


func _draw_world() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(1920.0, 1080.0)), Color(0.93, 0.85, 0.7))
	_draw_water_band(Rect2(0.0, 650.0, 1920.0, 430.0), Color(0.14, 0.28, 0.36), Color(0.8, 0.9, 0.93))

	var cliff := PackedVector2Array([
		Vector2(0.0, 764.0),
		Vector2(240.0, 726.0),
		Vector2(520.0, 706.0),
		Vector2(860.0, 714.0),
		Vector2(1240.0, 690.0),
		Vector2(1600.0, 650.0),
		Vector2(1920.0, 630.0),
		Vector2(1920.0, 1080.0),
		Vector2(0.0, 1080.0)
	])
	draw_colored_polygon(cliff, Color(0.61, 0.49, 0.34))

	_draw_path(Rect2(560.0, 522.0, 614.0, 94.0), Color(0.76, 0.69, 0.56), Color(0.55, 0.45, 0.31))
	_draw_path(Rect2(1120.0, 606.0, 300.0, 82.0), Color(0.73, 0.66, 0.53), Color(0.54, 0.43, 0.29))

	draw_rect(Rect2(520.0, 218.0, 820.0, 236.0), Color(0.73, 0.67, 0.56))
	draw_rect(Rect2(520.0, 192.0, 820.0, 34.0), Color(0.55, 0.41, 0.25))
	draw_rect(Rect2(520.0, 454.0, 820.0, 32.0), Color(0.55, 0.41, 0.25))
	for tower_x in [548.0, 1268.0]:
		draw_rect(Rect2(tower_x, 136.0, 72.0, 350.0), Color(0.68, 0.61, 0.49))
		var tower_roof := PackedVector2Array([
			Vector2(tower_x - 10.0, 136.0),
			Vector2(tower_x + 36.0, 82.0),
			Vector2(tower_x + 82.0, 136.0)
		])
		draw_colored_polygon(tower_roof, Color(0.42, 0.28, 0.19))

	draw_rect(Rect2(872.0, 316.0, 116.0, 170.0), Color(0.42, 0.29, 0.18))
	draw_rect(Rect2(908.0, 352.0, 42.0, 134.0), Color(0.22, 0.14, 0.08))

	draw_rect(Rect2(1350.0, 504.0, 220.0, 142.0), Color(0.7, 0.61, 0.47))
	var roof_one := PackedVector2Array([
		Vector2(1332.0, 516.0),
		Vector2(1460.0, 446.0),
		Vector2(1588.0, 516.0)
	])
	draw_colored_polygon(roof_one, Color(0.47, 0.32, 0.2))
	draw_rect(Rect2(1510.0, 290.0, 164.0, 106.0), Color(0.77, 0.71, 0.59))
	var roof_two := PackedVector2Array([
		Vector2(1498.0, 304.0),
		Vector2(1592.0, 242.0),
		Vector2(1686.0, 304.0)
	])
	draw_colored_polygon(roof_two, Color(0.39, 0.27, 0.18))

	_draw_stall(Rect2(1188.0, 646.0, 174.0, 118.0), Color(0.43, 0.46, 0.63), Color(0.44, 0.31, 0.2))
	_draw_ship(Rect2(170.0, 716.0, 264.0, 132.0), Color(0.35, 0.24, 0.14), Color(0.9, 0.87, 0.79))
	_draw_ship(Rect2(1480.0, 766.0, 250.0, 124.0), Color(0.33, 0.22, 0.13), Color(0.93, 0.9, 0.82))

	for palm_position in [Vector2(360.0, 646.0), Vector2(438.0, 612.0), Vector2(1110.0, 560.0)]:
		draw_rect(Rect2(palm_position + Vector2(-6.0, 12.0), Vector2(12.0, 36.0)), Color(0.5, 0.34, 0.16))
		draw_circle(palm_position, 18.0, Color(0.32, 0.48, 0.23))
		draw_circle(palm_position + Vector2(-18.0, 4.0), 14.0, Color(0.28, 0.42, 0.2))
		draw_circle(palm_position + Vector2(18.0, 6.0), 14.0, Color(0.35, 0.5, 0.24))
