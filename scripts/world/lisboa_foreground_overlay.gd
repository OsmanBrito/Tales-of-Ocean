extends Node2D

const LISBOA_ISO_META_PATH := "res://assets/world/iso/iso_asset_meta_v2.json"
const LISBOA_ISO_FRONT_OCCLUDERS_CANDIDATES: Array[String] = [
	"res://assets/world/iso/lisboa_ribeira_front_occluders_v2_iso.png"
]

var overlay_texture: Texture2D
var meta_loaded: bool = false
var meta: Dictionary = {}


func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var texture: Texture2D = _get_overlay_texture()
	if texture == null:
		return
	var root: Node = get_parent()
	if root == null:
		return

	var casa_pasto_pos: Vector2 = _get_root_position(root, "casa_de_pasto_da_ribeira", Vector2(522.0, 678.0))
	var roteiros_pos: Vector2 = _get_root_position(root, "casa_dos_roteiros", Vector2(820.0, 438.0))
	var caravela_pos: Vector2 = _get_root_position(root, "caravela_do_norte", Vector2(246.0, 406.0))
	var rossio_pos: Vector2 = _get_root_position(root, "to_rossio", Vector2(1324.0, 646.0))
	var se_pos: Vector2 = _get_root_position(root, "to_se", Vector2(1176.0, 598.0))

	var placements: Array = [
		{"index": 19, "anchor_position": Vector2(444.0, 748.0), "scale": 0.68, "alpha": 0.92},
		{"index": 2, "anchor_position": caravela_pos + Vector2(246.0, 124.0), "scale": 0.42, "alpha": 0.98},
		{"index": 21, "anchor_position": roteiros_pos + Vector2(92.0, 86.0), "scale": 0.42, "alpha": 0.98},
		{"index": 20, "anchor_position": casa_pasto_pos + Vector2(92.0, 110.0), "scale": 0.44, "alpha": 0.99},
		{"index": 11, "anchor_position": Vector2(866.0, 964.0), "scale": 0.4, "alpha": 0.94},
		{"index": 1, "anchor_position": Vector2(1290.0, 988.0), "scale": 0.46, "alpha": 0.96},
		{"index": 21, "anchor_position": Vector2(1504.0, 1132.0), "scale": 0.42, "alpha": 0.96},
		{"index": 22, "anchor_position": Vector2(1596.0, 942.0), "scale": 0.44, "alpha": 0.98},
		{"index": 22, "anchor_position": Vector2(1820.0, 1064.0), "scale": 0.42, "alpha": 0.96},
		{"index": 11, "anchor_position": Vector2(1044.0, 1118.0), "scale": 0.42, "alpha": 0.98},
		{"index": 16, "anchor_position": se_pos + Vector2(6.0, 108.0), "scale": 0.5, "alpha": 0.92},
		{"index": 24, "anchor_position": rossio_pos + Vector2(90.0, 112.0), "scale": 0.54, "alpha": 0.92},
		{"index": 25, "anchor_position": Vector2(1818.0, 1100.0), "scale": 0.68, "alpha": 0.88},
		{"index": 25, "anchor_position": Vector2(2438.0, 1326.0), "scale": 0.64, "alpha": 0.86}
	]
	for raw_placement in placements:
		var placement: Dictionary = raw_placement
		_draw_component_anchored(
			texture,
			int(placement.get("index", -1)),
			placement.get("anchor_position", Vector2.ZERO),
			float(placement.get("scale", 1.0)),
			Vector2(0.5, 1.0),
			float(placement.get("alpha", 1.0))
		)


func _get_overlay_texture() -> Texture2D:
	if overlay_texture != null:
		return overlay_texture
	for path in LISBOA_ISO_FRONT_OCCLUDERS_CANDIDATES:
		if not ResourceLoader.exists(path):
			continue
		var resource: Resource = load(path)
		if resource is Texture2D:
			overlay_texture = resource
			return overlay_texture
	return null


func _get_meta() -> Dictionary:
	if meta_loaded:
		return meta
	meta_loaded = true
	if not ResourceLoader.exists(LISBOA_ISO_META_PATH):
		return meta
	var handle: FileAccess = FileAccess.open(LISBOA_ISO_META_PATH, FileAccess.READ)
	if handle == null:
		return meta
	var parsed: Variant = JSON.parse_string(handle.get_as_text())
	if parsed is Dictionary:
		meta = parsed
	return meta


func _get_box(index: int) -> Rect2:
	var boxes: Array = _get_meta().get("front_occluders", [])
	if index < 0 or index >= boxes.size():
		return Rect2()
	var box: Dictionary = boxes[index]
	return Rect2(
		float(box.get("x", 0.0)),
		float(box.get("y", 0.0)),
		float(box.get("w", 0.0)),
		float(box.get("h", 0.0))
	)


func _draw_component_anchored(texture: Texture2D, index: int, anchor_position: Vector2, scale_value: float, anchor: Vector2, alpha: float) -> void:
	var source_rect: Rect2 = _get_box(index)
	if texture == null or source_rect.size.x <= 0.0 or source_rect.size.y <= 0.0:
		return
	var size: Vector2 = source_rect.size * scale_value
	var top_left: Vector2 = anchor_position - Vector2(size.x * anchor.x, size.y * anchor.y)
	draw_texture_rect_region(texture, Rect2(top_left, size), source_rect, Color(1.0, 1.0, 1.0, alpha), false, false)


func _get_root_position(root: Node, interactable_id: String, fallback: Vector2) -> Vector2:
	if root.has_method("_get_lisboa_interactable_position"):
		return root.call("_get_lisboa_interactable_position", interactable_id, fallback)
	return fallback
