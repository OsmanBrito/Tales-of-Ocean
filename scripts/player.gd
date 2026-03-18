extends Node2D

const PLAYER_TEXTURE: Texture2D = preload("res://assets/characters/pembah_world.svg")

@export var color: Color = Color("f2c14e")
@export var speed: float = 240.0
@export var world_rect: Rect2 = Rect2(120.0, 140.0, 1640.0, 760.0)
@export var walk_cycle_speed: float = 8.2
@export var walk_bob_amount: float = 2.8
@export var walk_stride_amount: float = 2.4
@export var idle_breathe_speed: float = 2.6
@export var idle_breathe_amount: float = 0.028

var walk_phase: float = 0.0
var idle_phase: float = 0.0
var facing_direction: int = 1
var motion_intensity: float = 0.0
var motion_blend: float = 0.0
var current_input: Vector2 = Vector2.ZERO


func _process(delta: float) -> void:
	var input_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	current_input = input_vector
	motion_intensity = clampf(input_vector.length(), 0.0, 1.0)
	motion_blend = move_toward(motion_blend, motion_intensity, delta * 7.0)
	idle_phase += delta * idle_breathe_speed
	if absf(input_vector.x) > 0.01:
		facing_direction = -1 if input_vector.x < 0.0 else 1
	if motion_blend > 0.01:
		walk_phase += delta * walk_cycle_speed * (0.82 + (motion_blend * 0.6))

	position += input_vector * speed * delta
	position.x = clampf(position.x, world_rect.position.x, world_rect.end.x)
	position.y = clampf(position.y, world_rect.position.y, world_rect.end.y)
	queue_redraw()


func _draw() -> void:
	var walk_wave: float = sin(walk_phase)
	var walk_lift: float = absf(cos(walk_phase))
	var idle_wave: float = sin(idle_phase)
	var bob: float = (-walk_lift * walk_bob_amount * motion_blend) + (idle_wave * 0.7 * (1.0 - motion_blend))
	var step_shift: float = walk_wave * walk_stride_amount * motion_blend
	var lean: float = clampf(current_input.x * 0.045, -0.045, 0.045)
	var sway: float = (walk_wave * 0.025 * motion_blend) + (idle_wave * 0.015 * (1.0 - motion_blend))
	var body_rotation: float = lean + sway
	var body_scale := Vector2(
		1.0 + (absf(walk_wave) * 0.035 * motion_blend) + (idle_wave * idle_breathe_amount * 0.45),
		1.0 - (absf(walk_wave) * 0.05 * motion_blend) - (idle_wave * idle_breathe_amount)
	)
	body_scale.x *= float(facing_direction)

	var shadow_scale_x: float = 1.0 + (0.1 * motion_blend) + (0.05 * walk_lift * motion_blend)
	var shadow_alpha: float = 0.14 + (0.03 * walk_lift * motion_blend) + (0.02 * (1.0 - motion_blend))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(shadow_scale_x, 1.0))
	draw_circle(Vector2(0.0, 26.0), 18.0, Color(0, 0, 0, shadow_alpha))

	draw_set_transform(Vector2(step_shift * 0.35, bob), body_rotation, body_scale)
	draw_texture_rect(PLAYER_TEXTURE, Rect2(Vector2(-36.0, -34.0), Vector2(72.0, 96.0)), false)

	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
