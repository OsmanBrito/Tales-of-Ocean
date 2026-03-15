extends Node

const SAVE_PATH := "user://save_slot_1.json"


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)


func save_game() -> bool:
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Could not open save file for writing.")
		return false

	file.store_string(JSON.stringify(GameState.to_save_data(), "\t"))
	return true


func load_game() -> bool:
	if not has_save():
		return false

	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("Could not open save file for reading.")
		return false

	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Save data is not valid JSON.")
		return false

	GameState.load_from_save_data(parsed)
	return true
