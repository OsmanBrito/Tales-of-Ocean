extends "res://scripts/world/world_scene.gd"

const DISTRICT_SIZE := Vector2(1920.0, 1080.0)
const ISO_DEPTH := Vector2(48.0, -28.0)
const SHADOW_DRIFT := Vector2(44.0, 24.0)

var district_time: float = 0.0


func _process(delta: float) -> void:
	super._process(delta)
	district_time += delta
	queue_redraw()


func _draw_district_sky(top_color: Color, haze_color: Color) -> void:
	draw_rect(Rect2(Vector2.ZERO, DISTRICT_SIZE), top_color)
	draw_rect(Rect2(0.0, 220.0, DISTRICT_SIZE.x, 860.0), haze_color)
	draw_circle(Vector2(1460.0, 154.0), 84.0, Color(1.0, 0.93, 0.72, 0.16))
	for band in range(4):
		var y: float = 152.0 + float(band) * 44.0
		draw_rect(Rect2(0.0, y, DISTRICT_SIZE.x, 20.0), Color(1.0, 0.97, 0.87, 0.04))


func _draw_district_water(area: Rect2, deep_color: Color, glow_color: Color) -> void:
	draw_rect(area, deep_color)
	for band in range(6):
		var points := PackedVector2Array()
		var y: float = area.position.y + 26.0 + float(band) * 46.0
		for step in range(11):
			var t: float = float(step) / 10.0
			var x: float = lerpf(area.position.x + 20.0, area.end.x - 20.0, t)
			points.append(Vector2(x, y + sin(district_time * 1.7 + t * 5.2 + float(band)) * 6.0))
		draw_polyline(points, glow_color, 2.0, false)


func _draw_cobbled_plane(corners: Array, fill: Color, edge: Color, rows: int, cols: int) -> void:
	var polygon := _poly(corners)
	draw_colored_polygon(polygon, fill)
	draw_polyline(polygon, edge, 3.0, true)
	var a: Vector2 = corners[0]
	var b: Vector2 = corners[1]
	var c: Vector2 = corners[2]
	var d: Vector2 = corners[3]
	for row in range(1, rows):
		var t: float = float(row) / float(rows)
		draw_line(a.lerp(d, t), b.lerp(c, t), edge.darkened(0.06), 1.0)
	for col in range(1, cols):
		var u: float = float(col) / float(cols)
		draw_line(a.lerp(b, u), d.lerp(c, u), edge.lightened(0.04), 1.0)


func _draw_iso_building(front_rect: Rect2, wall_color: Color, roof_color: Color, trim_color: Color, door_color: Color, window_color: Color, windows_x: int = 2, windows_y: int = 1, depth_scale: float = 1.0) -> void:
	var depth: Vector2 = ISO_DEPTH * depth_scale
	var tl: Vector2 = front_rect.position
	var tr: Vector2 = Vector2(front_rect.end.x, front_rect.position.y)
	var br: Vector2 = front_rect.end
	var bl: Vector2 = Vector2(front_rect.position.x, front_rect.end.y)
	var rtl: Vector2 = tl + depth
	var rtr: Vector2 = tr + depth
	var sbr: Vector2 = br + depth

	var shadow := _poly([
		bl + Vector2(16.0, 10.0),
		br + Vector2(20.0, 10.0),
		sbr + SHADOW_DRIFT,
		bl + depth + SHADOW_DRIFT
	])
	draw_colored_polygon(shadow, Color(0.0, 0.0, 0.0, 0.14))
	draw_colored_polygon(_poly([tr, rtr, sbr, br]), wall_color.darkened(0.12))
	draw_rect(front_rect, wall_color)
	draw_colored_polygon(_poly([tl, tr, rtr, rtl]), roof_color)
	draw_polyline(_poly([tl, tr, rtr, rtl]), trim_color, 2.0, true)
	draw_line(tl, bl, trim_color.darkened(0.08), 2.0)
	draw_line(tr, br, trim_color.darkened(0.08), 2.0)
	draw_line(bl, br, trim_color.darkened(0.14), 2.0)

	var spacing_x: float = (front_rect.size.x - 32.0) / float(max(windows_x, 1))
	var spacing_y: float = (front_rect.size.y - 44.0) / float(max(windows_y, 1))
	for row in range(windows_y):
		for col in range(windows_x):
			var wx: float = front_rect.position.x + 16.0 + float(col) * spacing_x
			var wy: float = front_rect.position.y + 16.0 + float(row) * spacing_y
			draw_rect(Rect2(wx, wy, 18.0, 18.0), window_color)
			draw_rect(Rect2(wx + 4.0, wy + 4.0, 10.0, 10.0), window_color.darkened(0.2))

	var door_rect := Rect2(front_rect.position.x + front_rect.size.x * 0.5 - 14.0, front_rect.end.y - 42.0, 28.0, 42.0)
	draw_rect(door_rect, door_color)
	draw_rect(Rect2(door_rect.position + Vector2(4.0, 4.0), door_rect.size - Vector2(8.0, 8.0)), door_color.lightened(0.06))


func _draw_iso_stall(front_rect: Rect2, cloth_color: Color, wood_color: Color, goods_color: Color) -> void:
	var depth: Vector2 = ISO_DEPTH * 0.7
	var wave: float = sin(district_time * 2.0 + front_rect.position.x * 0.03) * 5.0
	var awning := _poly([
		front_rect.position + Vector2(0.0, 16.0),
		Vector2(front_rect.end.x, front_rect.position.y + 16.0),
		Vector2(front_rect.end.x, front_rect.position.y + 16.0) + depth + Vector2(0.0, wave),
		front_rect.position + Vector2(0.0, 16.0) + depth + Vector2(0.0, wave)
	])
	var shadow := _poly([
		front_rect.position + Vector2(8.0, front_rect.size.y + 12.0),
		Vector2(front_rect.end.x + 8.0, front_rect.position.y + front_rect.size.y + 12.0),
		Vector2(front_rect.end.x + 40.0, front_rect.position.y + front_rect.size.y + 34.0),
		front_rect.position + Vector2(40.0, front_rect.size.y + 34.0)
	])
	draw_colored_polygon(shadow, Color(0.0, 0.0, 0.0, 0.12))
	draw_rect(Rect2(front_rect.position + Vector2(10.0, 30.0), Vector2(front_rect.size.x - 20.0, front_rect.size.y - 24.0)), wood_color)
	draw_colored_polygon(awning, cloth_color)
	draw_line(front_rect.position + Vector2(10.0, 16.0), front_rect.position + Vector2(10.0, front_rect.size.y + 2.0), wood_color.darkened(0.2), 4.0)
	draw_line(Vector2(front_rect.end.x - 10.0, front_rect.position.y + 16.0), Vector2(front_rect.end.x - 10.0, front_rect.position.y + front_rect.size.y + 2.0), wood_color.darkened(0.2), 4.0)
	for index in range(3):
		draw_circle(Vector2(front_rect.position.x + 28.0 + float(index) * 28.0, front_rect.end.y - 14.0), 8.0, goods_color)


func _draw_tree_cluster(position: Vector2, scale_value: float = 1.0) -> void:
	_draw_ground_shadow(position + Vector2(0.0, 22.0 * scale_value), Vector2(34.0 * scale_value, 15.0 * scale_value), Color(0.0, 0.0, 0.0, 0.14))
	draw_rect(Rect2(position + Vector2(-7.0, 2.0) * scale_value, Vector2(14.0, 38.0) * scale_value), Color(0.42, 0.29, 0.16))
	draw_circle(position + Vector2(0.0, -8.0) * scale_value, 24.0 * scale_value, Color(0.31, 0.45, 0.24))
	draw_circle(position + Vector2(-18.0, 4.0) * scale_value, 17.0 * scale_value, Color(0.28, 0.41, 0.22))
	draw_circle(position + Vector2(18.0, 2.0) * scale_value, 16.0 * scale_value, Color(0.34, 0.49, 0.26))


func _draw_barrel(center: Vector2, radius: float = 14.0, height: float = 28.0) -> void:
	_draw_ground_shadow(center + Vector2(0.0, height * 0.65), Vector2(radius * 1.2, radius * 0.45), Color(0.0, 0.0, 0.0, 0.12))
	var body := Rect2(center.x - radius, center.y - height * 0.5, radius * 2.0, height)
	draw_rect(body, Color(0.49, 0.34, 0.21))
	draw_rect(Rect2(body.position.x, body.position.y + 6.0, body.size.x, 3.0), Color(0.24, 0.18, 0.16))
	draw_rect(Rect2(body.position.x, body.end.y - 9.0, body.size.x, 3.0), Color(0.24, 0.18, 0.16))


func _draw_crate_stack(origin: Vector2, count: int) -> void:
	for index in range(count):
		var offset := Vector2(float(index % 2) * 22.0, -float(index / 2) * 18.0)
		_draw_box(Rect2(origin + offset, Vector2(28.0, 22.0)))


func _draw_box(front_rect: Rect2) -> void:
	var depth: Vector2 = ISO_DEPTH * 0.34
	var tl: Vector2 = front_rect.position
	var tr: Vector2 = Vector2(front_rect.end.x, front_rect.position.y)
	var br: Vector2 = front_rect.end
	draw_rect(front_rect, Color(0.58, 0.42, 0.25))
	draw_colored_polygon(_poly([tl, tr, tr + depth, tl + depth]), Color(0.68, 0.5, 0.29))
	draw_colored_polygon(_poly([tr, tr + depth, br + depth, br]), Color(0.46, 0.33, 0.2))
	draw_polyline(_poly([tl, tr, tr + depth, tl + depth]), Color(0.32, 0.23, 0.16), 1.5, true)


func _draw_banner(anchor: Vector2, color: Color) -> void:
	var swing: float = sin(district_time * 2.2 + anchor.x * 0.03) * 5.0
	draw_line(anchor, anchor + Vector2(0.0, 40.0), Color(0.45, 0.31, 0.19), 3.0)
	draw_colored_polygon(_poly([
		anchor + Vector2(0.0, 6.0),
		anchor + Vector2(34.0, 10.0),
		anchor + Vector2(28.0, 30.0 + swing),
		anchor + Vector2(0.0, 26.0)
	]), color)


func _draw_small_ship(center: Vector2, scale_value: float = 1.0) -> void:
	_draw_ground_shadow(center + Vector2(0.0, 44.0 * scale_value), Vector2(46.0 * scale_value, 14.0 * scale_value), Color(0.0, 0.0, 0.0, 0.12))
	var hull := _poly([
		center + Vector2(-58.0, 10.0) * scale_value,
		center + Vector2(-10.0, -8.0) * scale_value,
		center + Vector2(44.0, 0.0) * scale_value,
		center + Vector2(62.0, 22.0) * scale_value,
		center + Vector2(12.0, 34.0) * scale_value,
		center + Vector2(-42.0, 30.0) * scale_value
	])
	draw_colored_polygon(hull, Color(0.34, 0.21, 0.13))
	draw_polyline(hull, Color(0.5, 0.36, 0.22), 2.0, true)
	draw_line(center + Vector2(4.0, 8.0) * scale_value, center + Vector2(4.0, -58.0) * scale_value, Color(0.38, 0.24, 0.16), 3.0)
	draw_colored_polygon(_poly([
		center + Vector2(4.0, -50.0) * scale_value,
		center + Vector2(4.0, 2.0) * scale_value,
		center + Vector2(-40.0, -8.0) * scale_value
	]), Color(0.94, 0.92, 0.83))


func _draw_gate(position: Vector2, size_value: Vector2, wall_color: Color, roof_color: Color) -> void:
	draw_rect(Rect2(position, size_value), wall_color)
	draw_rect(Rect2(position.x + size_value.x * 0.36, position.y + size_value.y * 0.26, size_value.x * 0.28, size_value.y * 0.74), Color(0.34, 0.22, 0.14))
	draw_colored_polygon(_poly([
		position + Vector2(-12.0, 0.0),
		position + Vector2(size_value.x + 12.0, 0.0),
		position + Vector2(size_value.x - 6.0, -24.0),
		position + Vector2(6.0, -24.0)
	]), roof_color)


func _draw_ground_shadow(center: Vector2, radii: Vector2, color: Color) -> void:
	draw_set_transform(center, 0.0, Vector2(radii.x / maxf(radii.y, 1.0), 1.0))
	draw_circle(Vector2.ZERO, radii.y, color)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _draw_zone_label(position: Vector2, text: String) -> void:
	draw_string(ThemeDB.fallback_font, position + Vector2(2.0, 2.0), text, HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color(0.09, 0.07, 0.05, 0.34))
	draw_string(ThemeDB.fallback_font, position, text, HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color(0.96, 0.91, 0.81, 0.74))


func _poly(points: Array) -> PackedVector2Array:
	var packed := PackedVector2Array()
	for point in points:
		packed.append(point)
	return packed
