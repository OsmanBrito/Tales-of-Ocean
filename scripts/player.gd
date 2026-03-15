extends Node2D

const PLAYER_TEXTURE: Texture2D = preload("res://assets/characters/pembah_world.svg")

@export var color: Color = Color("f2c14e")
@export var speed: float = 240.0
@export var world_rect: Rect2 = Rect2(120.0, 140.0, 1640.0, 760.0)


func _process(delta: float) -> void:
	var input_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	position += input_vector * speed * delta
	position.x = clampf(position.x, world_rect.position.x, world_rect.end.x)
	position.y = clampf(position.y, world_rect.position.y, world_rect.end.y)
	queue_redraw()


func _draw() -> void:
	draw_circle(Vector2(0.0, 26.0), 18.0, Color(0, 0, 0, 0.18))
	draw_texture_rect(PLAYER_TEXTURE, Rect2(Vector2(-36.0, -34.0), Vector2(72.0, 96.0)), false)
