extends SceneTree

const DEFAULT_SCENE_PATH := "res://scenes/world/lisboa.tscn"
const DEFAULT_OUTPUT_PATH := "/tmp/tales_of_ocean_scene_capture.png"
const DEFAULT_FOCUS_POSITION := Vector2(1620.0, 940.0)


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var args: PackedStringArray = OS.get_cmdline_args()
	var scene_path: String = DEFAULT_SCENE_PATH
	var output_path: String = DEFAULT_OUTPUT_PATH
	for arg in args:
		if arg.ends_with(".tscn"):
			scene_path = arg
		elif arg.ends_with(".png"):
			output_path = arg

	var packed_scene: PackedScene = load(scene_path)
	if packed_scene == null:
		push_error("Unable to load scene: %s" % scene_path)
		quit(1)
		return

	var scene: Node = packed_scene.instantiate()
	root.add_child(scene)
	root.size = Vector2i(1600, 1000)
	var player: Node2D = scene.get_node_or_null("Player")
	if player != null:
		player.position = DEFAULT_FOCUS_POSITION

	await process_frame
	await process_frame
	await process_frame
	await create_timer(0.2).timeout

	var viewport_texture: ViewportTexture = root.get_texture()
	if viewport_texture == null:
		push_error("Viewport texture unavailable.")
		quit(1)
		return

	var image: Image = viewport_texture.get_image()
	if image == null:
		push_error("Viewport image unavailable.")
		quit(1)
		return

	var save_error: Error = image.save_png(output_path)
	if save_error != OK:
		push_error("Unable to save capture to %s" % output_path)
		quit(1)
		return

	print(output_path)
	quit()
