extends SceneTree

const OUTPUT_META_PATH := "res://assets/world/iso/iso_asset_meta_v2.json"

const CLEAN_SHEETS := [
	{
		"key": "crowd_extra",
		"source": "res://source_art/tiles/lisboa_ribeira_iso/lisboa_ribeira_crowd_extra_v2_source.png",
		"dest": "res://assets/world/iso/lisboa_ribeira_crowd_extra_v2_iso.png",
		"diff_threshold": 0.115,
		"step_threshold": 0.045,
		"min_pixels": 90,
		"cleanup_pixels": 1000,
		"hole_fill_pixels": 6000
	},
	{
		"key": "front_occluders",
		"source": "res://source_art/tiles/lisboa_ribeira_iso/lisboa_ribeira_front_occluders_v2_source.png",
		"dest": "res://assets/world/iso/lisboa_ribeira_front_occluders_v2_iso.png",
		"diff_threshold": 0.12,
		"step_threshold": 0.04,
		"min_pixels": 120,
		"cleanup_pixels": 500,
		"hole_fill_pixels": 12000
	},
	{
		"key": "passages",
		"source": "res://source_art/tiles/lisboa_ribeira_iso/lisboa_ribeira_passages_v2_source.png",
		"dest": "res://assets/world/iso/lisboa_ribeira_passages_v2_iso.png",
		"diff_threshold": 0.12,
		"step_threshold": 0.04,
		"min_pixels": 120,
		"cleanup_pixels": 500,
		"hole_fill_pixels": 4000
	}
]

const META_SHEETS := [
	{"key": "ground", "path": "res://assets/world/iso/lisboa_ribeira_ground_v2_iso.png", "min_pixels": 120},
	{"key": "buildings", "path": "res://assets/world/iso/lisboa_ribeira_buildings_v2_iso.png", "min_pixels": 120},
	{"key": "harbor_props", "path": "res://assets/world/iso/lisboa_ribeira_harbor_props_v2_iso.png", "min_pixels": 120},
	{"key": "ships", "path": "res://assets/world/iso/lisboa_ribeira_ships_v2_iso.png", "min_pixels": 120},
	{"key": "crowd", "path": "res://assets/world/iso/lisboa_ribeira_crowd_v2_iso.png", "min_pixels": 120},
	{"key": "battle_grid", "path": "res://assets/world/iso/battle_grid_v2_iso.png", "min_pixels": 120},
	{"key": "crowd_extra", "path": "res://assets/world/iso/lisboa_ribeira_crowd_extra_v2_iso.png", "min_pixels": 90},
	{"key": "front_occluders", "path": "res://assets/world/iso/lisboa_ribeira_front_occluders_v2_iso.png", "min_pixels": 120},
	{"key": "passages", "path": "res://assets/world/iso/lisboa_ribeira_passages_v2_iso.png", "min_pixels": 120}
]


func _init() -> void:
	var ok: bool = _prepare_clean_sheets()
	ok = _write_meta() and ok
	quit(0 if ok else 1)


func _prepare_clean_sheets() -> bool:
	var all_ok: bool = true
	for raw_sheet in CLEAN_SHEETS:
		var sheet: Dictionary = raw_sheet
		var source_path: String = sheet.get("source", "")
		var dest_path: String = sheet.get("dest", "")
		var image: Image = Image.load_from_file(source_path)
		if image == null or image.is_empty():
			push_error("Failed to load source sheet: %s" % source_path)
			all_ok = false
			continue
		image.convert(Image.FORMAT_RGBA8)
		var original: Image = image.duplicate()
		_remove_edge_connected_background(
			image,
			float(sheet.get("diff_threshold", 0.12)),
			float(sheet.get("step_threshold", 0.065))
		)
		_remove_small_foreground_components(image, int(sheet.get("cleanup_pixels", 0)))
		_restore_enclosed_transparent_holes(
			image,
			original,
			int(sheet.get("hole_fill_pixels", 0))
		)
		var save_error: Error = image.save_png(dest_path)
		if save_error != OK:
			push_error("Failed to save cleaned sheet: %s" % dest_path)
			all_ok = false
			continue
		print("%s -> %s" % [source_path, dest_path])
	return all_ok


func _write_meta() -> bool:
	var meta: Dictionary = {}
	for raw_sheet in META_SHEETS:
		var sheet: Dictionary = raw_sheet
		var path: String = sheet.get("path", "")
		if not FileAccess.file_exists(path):
			continue
		var boxes: Array = _extract_components(path, int(sheet.get("min_pixels", 120)))
		meta[sheet.get("key", "")] = boxes
		print("%s %d" % [sheet.get("key", ""), boxes.size()])
		for i in range(min(10, boxes.size())):
			print("  %d %s" % [i, str(boxes[i])])
	var file: FileAccess = FileAccess.open(OUTPUT_META_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open metadata output: %s" % OUTPUT_META_PATH)
		return false
	file.store_string(JSON.stringify(meta, "\t"))
	print("written %s" % OUTPUT_META_PATH)
	return true


func _remove_edge_connected_background(image: Image, diff_threshold: float, step_threshold: float) -> void:
	var width: int = image.get_width()
	var height: int = image.get_height()
	var total: int = width * height
	if total == 0:
		return

	var bg_estimate: Image = image.duplicate()
	var small_width: int = max(24, int(round(width / 28.0)))
	var small_height: int = max(24, int(round(height / 28.0)))
	bg_estimate.resize(small_width, small_height, Image.INTERPOLATE_BILINEAR)
	bg_estimate.resize(width, height, Image.INTERPOLATE_CUBIC)

	var background_mask := PackedByteArray()
	background_mask.resize(total)
	var diff_map := PackedFloat32Array()
	diff_map.resize(total)
	var queue: Array[int] = []

	for y in range(height):
		for x in range(width):
			var index: int = y * width + x
			diff_map[index] = _color_delta(image.get_pixel(x, y), bg_estimate.get_pixel(x, y))

	for x in range(width):
		_try_enqueue_background_seed(image, width, height, x, 0, diff_map, background_mask, queue, diff_threshold)
		_try_enqueue_background_seed(image, width, height, x, height - 1, diff_map, background_mask, queue, diff_threshold)
	for y in range(1, height - 1):
		_try_enqueue_background_seed(image, width, height, 0, y, diff_map, background_mask, queue, diff_threshold)
		_try_enqueue_background_seed(image, width, height, width - 1, y, diff_map, background_mask, queue, diff_threshold)

	var cursor: int = 0
	while cursor < queue.size():
		var index: int = queue[cursor]
		cursor += 1
		var x: int = index % width
		var y: int = index / width
		var base_color: Color = image.get_pixel(x, y)
		_try_expand_background(image, width, height, x + 1, y, base_color, diff_map, background_mask, queue, diff_threshold, step_threshold)
		_try_expand_background(image, width, height, x - 1, y, base_color, diff_map, background_mask, queue, diff_threshold, step_threshold)
		_try_expand_background(image, width, height, x, y + 1, base_color, diff_map, background_mask, queue, diff_threshold, step_threshold)
		_try_expand_background(image, width, height, x, y - 1, base_color, diff_map, background_mask, queue, diff_threshold, step_threshold)

	for y in range(height):
		for x in range(width):
			var index: int = y * width + x
			if background_mask[index] == 0:
				continue
			image.set_pixel(x, y, Color(0.0, 0.0, 0.0, 0.0))


func _try_enqueue_background_seed(
	image: Image,
	width: int,
	height: int,
	x: int,
	y: int,
	diff_map: PackedFloat32Array,
	background_mask: PackedByteArray,
	queue: Array[int],
	diff_threshold: float
) -> void:
	if x < 0 or y < 0 or x >= width or y >= height:
		return
	var index: int = y * width + x
	if background_mask[index] != 0:
		return
	if diff_map[index] > diff_threshold:
		return
	background_mask[index] = 1
	queue.append(index)


func _try_expand_background(
	image: Image,
	width: int,
	height: int,
	x: int,
	y: int,
	base_color: Color,
	diff_map: PackedFloat32Array,
	background_mask: PackedByteArray,
	queue: Array[int],
	diff_threshold: float,
	step_threshold: float
) -> void:
	if x < 0 or y < 0 or x >= width or y >= height:
		return
	var index: int = y * width + x
	if background_mask[index] != 0:
		return
	if diff_map[index] > diff_threshold:
		return
	var candidate: Color = image.get_pixel(x, y)
	if _color_delta(base_color, candidate) > step_threshold:
		return
	background_mask[index] = 1
	queue.append(index)


func _extract_components(path: String, min_pixels: int) -> Array:
	var image: Image = Image.load_from_file(path)
	if image == null or image.is_empty():
		return []
	image.convert(Image.FORMAT_RGBA8)
	var width: int = image.get_width()
	var height: int = image.get_height()
	var visited := PackedByteArray()
	visited.resize(width * height)
	var boxes: Array = []
	var queue: Array[int] = []

	for y in range(height):
		for x in range(width):
			var index: int = y * width + x
			if visited[index] != 0:
				continue
			visited[index] = 1
			if image.get_pixel(x, y).a < 0.05:
				continue
			queue.clear()
			queue.append(index)
			var cursor: int = 0
			var count: int = 0
			var min_x: int = x
			var max_x: int = x
			var min_y: int = y
			var max_y: int = y
			while cursor < queue.size():
				var current: int = queue[cursor]
				cursor += 1
				var cx: int = current % width
				var cy: int = current / width
				count += 1
				min_x = mini(min_x, cx)
				max_x = maxi(max_x, cx)
				min_y = mini(min_y, cy)
				max_y = maxi(max_y, cy)
				_component_enqueue(image, width, height, cx + 1, cy, visited, queue)
				_component_enqueue(image, width, height, cx - 1, cy, visited, queue)
				_component_enqueue(image, width, height, cx, cy + 1, visited, queue)
				_component_enqueue(image, width, height, cx, cy - 1, visited, queue)
			if count >= min_pixels:
				boxes.append({
					"x": min_x,
					"y": min_y,
					"w": max_x - min_x + 1,
					"h": max_y - min_y + 1,
					"pixels": count
				})
	boxes.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		if int(a.get("y", 0)) == int(b.get("y", 0)):
			return int(a.get("x", 0)) < int(b.get("x", 0))
		return int(a.get("y", 0)) < int(b.get("y", 0))
	)
	return boxes


func _remove_small_foreground_components(image: Image, min_component_pixels: int) -> void:
	if min_component_pixels <= 0:
		return
	var width: int = image.get_width()
	var height: int = image.get_height()
	var visited := PackedByteArray()
	visited.resize(width * height)
	var queue: Array[int] = []
	var component_pixels: Array[int] = []

	for y in range(height):
		for x in range(width):
			var index: int = y * width + x
			if visited[index] != 0:
				continue
			visited[index] = 1
			if image.get_pixel(x, y).a < 0.05:
				continue
			queue.clear()
			component_pixels.clear()
			queue.append(index)
			component_pixels.append(index)
			var cursor: int = 0
			while cursor < queue.size():
				var current: int = queue[cursor]
				cursor += 1
				var cx: int = current % width
				var cy: int = current / width
				_collect_component_pixel(image, width, height, cx + 1, cy, visited, queue, component_pixels, true)
				_collect_component_pixel(image, width, height, cx - 1, cy, visited, queue, component_pixels, true)
				_collect_component_pixel(image, width, height, cx, cy + 1, visited, queue, component_pixels, true)
				_collect_component_pixel(image, width, height, cx, cy - 1, visited, queue, component_pixels, true)
			if component_pixels.size() >= min_component_pixels:
				continue
			for pixel_index in component_pixels:
				var px: int = pixel_index % width
				var py: int = pixel_index / width
				image.set_pixel(px, py, Color(0.0, 0.0, 0.0, 0.0))


func _restore_enclosed_transparent_holes(image: Image, original: Image, max_hole_pixels: int) -> void:
	if max_hole_pixels <= 0:
		return
	var width: int = image.get_width()
	var height: int = image.get_height()
	var visited := PackedByteArray()
	visited.resize(width * height)
	var queue: Array[int] = []
	var hole_pixels: Array[int] = []

	for y in range(height):
		for x in range(width):
			var index: int = y * width + x
			if visited[index] != 0:
				continue
			visited[index] = 1
			if image.get_pixel(x, y).a >= 0.05:
				continue
			queue.clear()
			hole_pixels.clear()
			queue.append(index)
			hole_pixels.append(index)
			var cursor: int = 0
			var touches_border: bool = (x == 0 or y == 0 or x == width - 1 or y == height - 1)
			while cursor < queue.size():
				var current: int = queue[cursor]
				cursor += 1
				var cx: int = current % width
				var cy: int = current / width
				touches_border = _collect_component_pixel(image, width, height, cx + 1, cy, visited, queue, hole_pixels, false) or touches_border
				touches_border = _collect_component_pixel(image, width, height, cx - 1, cy, visited, queue, hole_pixels, false) or touches_border
				touches_border = _collect_component_pixel(image, width, height, cx, cy + 1, visited, queue, hole_pixels, false) or touches_border
				touches_border = _collect_component_pixel(image, width, height, cx, cy - 1, visited, queue, hole_pixels, false) or touches_border
			if touches_border or hole_pixels.size() > max_hole_pixels:
				continue
			for pixel_index in hole_pixels:
				var px: int = pixel_index % width
				var py: int = pixel_index / width
				image.set_pixel(px, py, original.get_pixel(px, py))


func _component_enqueue(
	image: Image,
	width: int,
	height: int,
	x: int,
	y: int,
	visited: PackedByteArray,
	queue: Array[int]
) -> void:
	if x < 0 or y < 0 or x >= width or y >= height:
		return
	var index: int = y * width + x
	if visited[index] != 0:
		return
	visited[index] = 1
	if image.get_pixel(x, y).a < 0.05:
		return
	queue.append(index)


func _collect_component_pixel(
	image: Image,
	width: int,
	height: int,
	x: int,
	y: int,
	visited: PackedByteArray,
	queue: Array[int],
	pixels: Array[int],
	expect_foreground: bool
) -> bool:
	if x < 0 or y < 0 or x >= width or y >= height:
		return false
	var index: int = y * width + x
	if visited[index] != 0:
		return false
	visited[index] = 1
	var is_foreground: bool = image.get_pixel(x, y).a >= 0.05
	if is_foreground != expect_foreground:
		return false
	queue.append(index)
	pixels.append(index)
	return x == 0 or y == 0 or x == width - 1 or y == height - 1


func _color_delta(a: Color, b: Color) -> float:
	return maxf(absf(a.r - b.r), maxf(absf(a.g - b.g), absf(a.b - b.b)))
