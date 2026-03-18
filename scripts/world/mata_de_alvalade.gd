extends "res://scripts/world/lisboa_district_scene.gd"


func _draw_world() -> void:
	_draw_district_sky(Color(0.82, 0.9, 0.86), Color(0.93, 0.9, 0.8, 0.08))
	draw_rect(Rect2(Vector2.ZERO, DISTRICT_SIZE), Color(0.55, 0.67, 0.44, 0.35))
	var clearing := [
		Vector2(170.0, 662.0), Vector2(1130.0, 540.0), Vector2(1656.0, 646.0), Vector2(1478.0, 802.0), Vector2(338.0, 830.0)
	]
	draw_colored_polygon(_poly(clearing), Color(0.68, 0.6, 0.42))
	draw_polyline(_poly(clearing), Color(0.47, 0.37, 0.24), 4.0, true)
	for line in range(7):
		var x0: float = 250.0 + float(line) * 180.0
		draw_line(Vector2(x0, 690.0), Vector2(x0 + 350.0, 608.0 + float(line % 2) * 20.0), Color(0.52, 0.42, 0.28), 1.0)

	for tree in [
		Vector2(202.0, 456.0), Vector2(328.0, 356.0), Vector2(484.0, 298.0), Vector2(702.0, 250.0),
		Vector2(1002.0, 272.0), Vector2(1268.0, 340.0), Vector2(1548.0, 430.0), Vector2(1728.0, 564.0),
		Vector2(1546.0, 892.0), Vector2(1260.0, 956.0), Vector2(932.0, 1006.0), Vector2(548.0, 980.0),
		Vector2(278.0, 910.0)
	]:
		_draw_tree_cluster(tree, 1.1 if tree.y > 800.0 else 0.95)

	_draw_crate_stack(Vector2(1220.0, 610.0), 2)
	_draw_barrel(Vector2(1318.0, 640.0), 16.0, 30.0)
	_draw_zone_label(Vector2(226.0, 600.0), "Mata de Alvalade")
	_draw_zone_label(Vector2(1206.0, 580.0), "Clareira dos Salteadores")
