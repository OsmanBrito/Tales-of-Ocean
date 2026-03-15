extends Node

const TRACK_PATHS := {
	"celestial_pages": "res://assets/audio/celestial_pages.mp3",
	"battle_ballad": "res://assets/audio/battle_ballad.mp3",
	"porto_morning_tides": "res://assets/audio/porto_morning_tides.mp3",
	"storm_over_black_cliffs": "res://assets/audio/storm_over_black_cliffs.mp3",
	"steel_on_saltwind": "res://assets/audio/steel_on_saltwind.mp3"
}

var music_player: AudioStreamPlayer
var current_track_id: String = ""


func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.name = "MusicPlayer"
	music_player.bus = "Master"
	music_player.volume_db = -8.0
	add_child(music_player)


func _exit_tree() -> void:
	stop_track()
	if music_player != null:
		music_player.stream = null
		remove_child(music_player)
		music_player.free()
		music_player = null


func play_track(track_id: String, restart: bool = false) -> void:
	var normalized_track_id: String = track_id.strip_edges()
	if normalized_track_id.is_empty():
		stop_track()
		return
	if not TRACK_PATHS.has(normalized_track_id):
		push_error("Unknown music track id: %s" % normalized_track_id)
		return
	if current_track_id == normalized_track_id and music_player.playing and not restart:
		return

	var stream: AudioStream = _load_track(normalized_track_id)
	if stream == null:
		push_error("Could not load music track: %s" % normalized_track_id)
		return

	music_player.stream = stream
	current_track_id = normalized_track_id
	music_player.play()


func stop_track() -> void:
	current_track_id = ""
	if music_player != null and music_player.playing:
		music_player.stop()


func play_menu_music() -> void:
	play_track("celestial_pages")


func play_world_music(scene_id: String) -> void:
	match scene_id:
		"lisboa", "porto":
			play_track("porto_morning_tides")
		"sagres", "ceuta":
			play_track("storm_over_black_cliffs")
		"tomar":
			play_track("celestial_pages")
		_:
			play_track("porto_morning_tides")


func play_overworld_music() -> void:
	play_track("celestial_pages")


func play_battle_music(battle_context: Dictionary) -> void:
	play_track(_resolve_battle_track_id(battle_context))


func _resolve_battle_track_id(battle_context: Dictionary) -> String:
	var battle_title: String = str(battle_context.get("battle_title", "")).to_lower()
	var intro_text: String = str(battle_context.get("intro_text", "")).to_lower()
	var return_scene: String = str(battle_context.get("return_scene", battle_context.get("defeat_return_scene", ""))).to_lower()
	var return_button_text: String = str(battle_context.get("return_button_text", "")).to_lower()

	if return_button_text.contains("retomar") or battle_title.contains("corsari") or battle_title.contains("levante"):
		return "steel_on_saltwind"
	if return_scene.contains("ceuta") or battle_title.contains("marina") or battle_title.contains("alcacova"):
		return "steel_on_saltwind"
	if intro_text.contains("mar alto") or intro_text.contains("costado") or intro_text.contains("barca"):
		return "steel_on_saltwind"
	return "battle_ballad"


func _load_track(track_id: String) -> AudioStream:
	var path: String = str(TRACK_PATHS.get(track_id, ""))
	if path.is_empty():
		return null

	return ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE) as AudioStream
