extends Control

@onready var continue_button: Button = %ContinueButton
@onready var status_label: Label = %StatusLabel


func _ready() -> void:
	MusicManager.play_menu_music()
	continue_button.disabled = not SaveSystem.has_save()
	status_label.text = "Fatia vertical: Lisboa exploravel, dialogos, combate, inventario e gravacao."


func _on_new_game_pressed() -> void:
	GameState.reset_new_game()
	get_tree().change_scene_to_file("res://scenes/world/lisboa.tscn")


func _on_continue_pressed() -> void:
	if SaveSystem.load_game():
		get_tree().change_scene_to_file(GameState.get_current_scene_path())


func _on_quit_pressed() -> void:
	get_tree().quit()
