extends "res://scripts/world/world_scene.gd"

const BACKDROP: Texture2D = preload("res://assets/world/lisboa_backdrop.svg")


func _draw_world() -> void:
	draw_texture_rect(BACKDROP, Rect2(Vector2.ZERO, Vector2(1920.0, 1080.0)), false)
	draw_rect(Rect2(Vector2.ZERO, Vector2(1920.0, 1080.0)), Color(0.96, 0.88, 0.74, 0.06))
