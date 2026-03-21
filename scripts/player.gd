extends Node2D

const PLAYER_TEXTURE_FALLBACK: Texture2D = preload("res://assets/characters/pembah_world.svg")
const PLAYER_TEXTURE_CANDIDATES: Array[String] = [
	"res://assets/characters/pembah_world_v1.png",
	"res://assets/characters/pembah_world.svg"
]
const PLAYER_CONTACT_SHEET_CANDIDATES: Array[String] = [
	"res://pembah_contact.png"
]
const PLAYER_CONTACT_FRAME_SIZE := Vector2(140.0, 200.0)
const PLAYER_CONTACT_WALK_FRAMES: int = 4
const PLAYER_CONTACT_IDLE_FRAME: int = 1
const FOOTSTEP_SAMPLE_RATE: int = 22050
const FOOTSTEP_STEP_DISTANCE: float = 56.0
const FOOTSTEP_VARIATION_COUNT: int = 3

@export var color: Color = Color("f2c14e")
@export var speed: float = 240.0
@export var world_rect: Rect2 = Rect2(120.0, 140.0, 1640.0, 760.0)
@export var walk_cycle_speed: float = 8.2
@export var walk_bob_amount: float = 2.8
@export var walk_stride_amount: float = 2.4
@export var idle_breathe_speed: float = 2.6
@export var idle_breathe_amount: float = 0.028
@export var collision_radius: float = 18.0
@export var footstep_volume_db: float = -24.0
@export var visual_scale: float = 1.0
@export var visual_offset: Vector2 = Vector2.ZERO
@export var animation_scale: float = 1.0

var walk_phase: float = 0.0
var idle_phase: float = 0.0
var facing_direction: int = 1
var motion_intensity: float = 0.0
var motion_blend: float = 0.0
var current_input: Vector2 = Vector2.ZERO
var player_texture: Texture2D = PLAYER_TEXTURE_FALLBACK
var player_contact_sheet: Texture2D
var player_contact_frame_cache: Dictionary = {}
var navigation_polygons: Array[PackedVector2Array] = []
var footstep_distance_accumulator: float = 0.0
var footstep_stream_index: int = 0
var footstep_streams: Array[AudioStream] = []
var footstep_player: AudioStreamPlayer
var footstep_rng := RandomNumberGenerator.new()


func _process(delta: float) -> void:
	var input_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var world_root: Node = get_parent()
	if world_root != null and world_root.has_method("is_player_movement_locked") and bool(world_root.call("is_player_movement_locked")):
		input_vector = Vector2.ZERO
	current_input = input_vector
	motion_intensity = clampf(input_vector.length(), 0.0, 1.0)
	motion_blend = move_toward(motion_blend, motion_intensity, delta * 7.0)
	idle_phase += delta * idle_breathe_speed
	if absf(input_vector.x) > 0.01:
		# The contact sheet is authored facing right, so we only mirror when moving left.
		facing_direction = -1 if input_vector.x < 0.0 else 1
	if motion_blend > 0.01:
		walk_phase += delta * walk_cycle_speed * (0.82 + (motion_blend * 0.6))

	var moved_distance: float = _move_with_collision(input_vector * speed * delta)
	if moved_distance > 0.05:
		footstep_distance_accumulator += moved_distance
		while footstep_distance_accumulator >= FOOTSTEP_STEP_DISTANCE:
			footstep_distance_accumulator -= FOOTSTEP_STEP_DISTANCE
			_play_footstep()
	else:
		footstep_distance_accumulator = min(footstep_distance_accumulator, FOOTSTEP_STEP_DISTANCE * 0.4)
	queue_redraw()


func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	player_contact_sheet = _resolve_player_contact_sheet()
	player_texture = _resolve_player_texture()
	_setup_footsteps()


func _draw() -> void:
	var render_scale: float = maxf(0.2, visual_scale)
	var motion_scale: float = maxf(0.2, animation_scale)
	var walk_wave: float = sin(walk_phase)
	var walk_lift: float = absf(cos(walk_phase))
	var idle_wave: float = sin(idle_phase)
	var bob: float = ((-walk_lift * walk_bob_amount * motion_blend) + (idle_wave * 0.7 * (1.0 - motion_blend))) * motion_scale
	var step_shift: float = walk_wave * walk_stride_amount * motion_blend * motion_scale
	var lean: float = clampf(current_input.x * 0.045 * motion_scale, -0.045 * motion_scale, 0.045 * motion_scale)
	var sway: float = ((walk_wave * 0.025 * motion_blend) + (idle_wave * 0.015 * (1.0 - motion_blend))) * motion_scale
	var body_rotation: float = lean + sway
	var body_scale := Vector2(
		1.0 + (absf(walk_wave) * 0.035 * motion_blend * motion_scale) + (idle_wave * idle_breathe_amount * 0.45 * motion_scale),
		1.0 - (absf(walk_wave) * 0.05 * motion_blend * motion_scale) - (idle_wave * idle_breathe_amount * motion_scale)
	)
	body_scale.x *= float(facing_direction)

	var shadow_scale_x: float = 1.0 + ((0.1 * motion_blend) + (0.05 * walk_lift * motion_blend)) * motion_scale
	var shadow_alpha: float = 0.14 + (0.03 * walk_lift * motion_blend) + (0.02 * (1.0 - motion_blend))
	var draw_texture: Texture2D = _get_current_player_texture()
	var sprite_rect := Rect2(Vector2(-44.0, -58.0), Vector2(88.0, 128.0))
	if player_contact_sheet != null:
		sprite_rect = Rect2(Vector2(-50.0, -82.0), Vector2(100.0, 148.0))
	sprite_rect.position *= render_scale
	sprite_rect.size *= render_scale
	draw_set_transform(Vector2(visual_offset.x * 0.25, visual_offset.y * 0.16), 0.0, Vector2(shadow_scale_x, 1.0))
	draw_circle(Vector2(0.0, 26.0 * render_scale), 18.0 * render_scale, Color(0, 0, 0, shadow_alpha))

	draw_set_transform(visual_offset + Vector2(step_shift * 0.35, bob), body_rotation, body_scale)
	draw_texture_rect(draw_texture, sprite_rect, false)

	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _resolve_player_texture() -> Texture2D:
	for path in PLAYER_TEXTURE_CANDIDATES:
		if not ResourceLoader.exists(path):
			continue
		var resource: Resource = load(path)
		if resource is Texture2D:
			return resource
	return PLAYER_TEXTURE_FALLBACK


func _resolve_player_contact_sheet() -> Texture2D:
	for path in PLAYER_CONTACT_SHEET_CANDIDATES:
		if not ResourceLoader.exists(path):
			continue
		var resource: Resource = load(path)
		if resource is Texture2D:
			return resource
	return null


func configure_navigation(new_world_rect: Rect2, polygons: Array, new_collision_radius: float = -1.0) -> void:
	world_rect = new_world_rect
	if new_collision_radius > 0.0:
		collision_radius = new_collision_radius
	navigation_polygons.clear()
	for raw_polygon in polygons:
		if raw_polygon is PackedVector2Array and raw_polygon.size() >= 3:
			navigation_polygons.append(raw_polygon)


func is_position_walkable(world_position: Vector2) -> bool:
	return _can_stand_at(_clamp_to_world(world_position))


func _get_current_player_texture() -> Texture2D:
	if player_contact_sheet == null:
		return player_texture

	var row: int = 1
	if current_input.y < -0.18:
		row = 2
	elif current_input.y > 0.18:
		row = 0

	var col: int = PLAYER_CONTACT_IDLE_FRAME
	if motion_blend > 0.05:
		col = int(floor(walk_phase)) % PLAYER_CONTACT_WALK_FRAMES
	return _get_contact_frame_texture(col, row)


func _get_contact_frame_texture(column: int, row: int) -> Texture2D:
	var cache_key: String = "%d:%d" % [column, row]
	if player_contact_frame_cache.has(cache_key):
		var cached: Texture2D = player_contact_frame_cache[cache_key]
		if cached != null:
			return cached

	var atlas := AtlasTexture.new()
	atlas.atlas = player_contact_sheet
	atlas.region = Rect2(
		Vector2(float(column) * PLAYER_CONTACT_FRAME_SIZE.x, float(row) * PLAYER_CONTACT_FRAME_SIZE.y),
		PLAYER_CONTACT_FRAME_SIZE
	)
	player_contact_frame_cache[cache_key] = atlas
	return atlas


func _move_with_collision(motion: Vector2) -> float:
	var moved_distance: float = 0.0
	moved_distance += _move_axis(motion.x, true)
	moved_distance += _move_axis(motion.y, false)
	return moved_distance


func _move_axis(amount: float, is_horizontal: bool) -> float:
	if absf(amount) <= 0.001:
		return 0.0
	var moved_distance: float = 0.0
	var remaining: float = amount
	var max_step: float = maxf(6.0, collision_radius * 0.45)
	while absf(remaining) > 0.001:
		var step_amount: float = clampf(remaining, -max_step, max_step)
		var offset: Vector2 = Vector2(step_amount, 0.0) if is_horizontal else Vector2(0.0, step_amount)
		var candidate: Vector2 = _clamp_to_world(position + offset)
		if not _can_stand_at(candidate):
			break
		var applied: Vector2 = candidate - position
		var axis_advance: float = applied.x if is_horizontal else applied.y
		if absf(axis_advance) <= 0.001:
			break
		position = candidate
		moved_distance += absf(axis_advance)
		remaining -= axis_advance
	return moved_distance


func _clamp_to_world(world_position: Vector2) -> Vector2:
	return Vector2(
		clampf(world_position.x, world_rect.position.x, world_rect.end.x),
		clampf(world_position.y, world_rect.position.y, world_rect.end.y)
	)


func _can_stand_at(world_position: Vector2) -> bool:
	if world_position.x < world_rect.position.x or world_position.x > world_rect.end.x:
		return false
	if world_position.y < world_rect.position.y or world_position.y > world_rect.end.y:
		return false
	if navigation_polygons.is_empty():
		return true
	for sample in _get_collision_samples():
		if not _is_point_in_navigation(world_position + sample):
			return false
	return true


func _is_point_in_navigation(point: Vector2) -> bool:
	for polygon in navigation_polygons:
		if Geometry2D.is_point_in_polygon(point, polygon):
			return true
	return false


func _get_collision_samples() -> Array[Vector2]:
	var horizontal: float = collision_radius * 0.62
	var vertical: float = collision_radius * 0.46
	return [
		Vector2.ZERO,
		Vector2(horizontal, 0.0),
		Vector2(-horizontal, 0.0),
		Vector2(0.0, vertical),
		Vector2(0.0, -vertical)
	]


func _setup_footsteps() -> void:
	footstep_rng.randomize()
	footstep_player = AudioStreamPlayer.new()
	footstep_player.bus = "Master"
	footstep_player.volume_db = footstep_volume_db
	add_child(footstep_player)
	footstep_streams.clear()
	for variation in range(FOOTSTEP_VARIATION_COUNT):
		footstep_streams.append(_build_footstep_stream(variation))


func _play_footstep() -> void:
	if footstep_player == null or footstep_streams.is_empty():
		return
	footstep_player.stream = footstep_streams[footstep_stream_index % footstep_streams.size()]
	footstep_player.pitch_scale = 1.0 + footstep_rng.randf_range(-0.05, 0.05)
	footstep_player.play()
	footstep_stream_index += 1


func _build_footstep_stream(variation: int) -> AudioStreamWAV:
	var duration: float = 0.075 + float(variation) * 0.01
	var sample_count: int = int(round(duration * float(FOOTSTEP_SAMPLE_RATE)))
	var data := PackedByteArray()
	data.resize(sample_count * 2)
	var rng := RandomNumberGenerator.new()
	rng.seed = 9137 + variation * 617
	var body_frequency: float = 62.0 + float(variation) * 9.0
	var snap_frequency: float = 118.0 + float(variation) * 14.0
	for i in range(sample_count):
		var t: float = float(i) / float(FOOTSTEP_SAMPLE_RATE)
		var progress: float = float(i) / float(max(1, sample_count - 1))
		var envelope: float = pow(maxf(0.0, 1.0 - progress), 2.1)
		var body: float = sin(TAU * body_frequency * t) * 0.42 * envelope
		var snap: float = sin(TAU * snap_frequency * t) * 0.12 * pow(envelope, 1.35)
		var grit: float = rng.randf_range(-1.0, 1.0) * 0.18 * pow(envelope, 1.75)
		var sample: float = clampf(body + snap + grit, -1.0, 1.0)
		var pcm_value: int = int(round(sample * 32767.0))
		var unsigned_value: int = pcm_value & 0xFFFF
		var byte_index: int = i * 2
		data[byte_index] = unsigned_value & 0xFF
		data[byte_index + 1] = (unsigned_value >> 8) & 0xFF
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = FOOTSTEP_SAMPLE_RATE
	stream.stereo = false
	stream.data = data
	return stream
