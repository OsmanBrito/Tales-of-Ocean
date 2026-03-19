extends Control

const GRID_COLS: int = 7
const GRID_ROWS: int = 4
const DEFAULT_ALLY_START_CELLS: Array[Vector2i] = [
	Vector2i(1, 1),
	Vector2i(1, 2)
]
const DEFAULT_ENEMY_START_CELLS: Array[Vector2i] = [
	Vector2i(5, 1),
	Vector2i(5, 2),
	Vector2i(6, 1),
	Vector2i(6, 2)
]
const CARDINAL_DIRECTIONS: Array[Vector2i] = [
	Vector2i(1, 0),
	Vector2i(-1, 0),
	Vector2i(0, 1),
	Vector2i(0, -1)
]
const STUN_GUARD_STATUS_ID := "stun_guard"

const PEMBAH_ICON: Texture2D = preload("res://assets/combat/pembah_battle_token.svg")
const JOAO_ICON: Texture2D = preload("res://assets/combat/joao_token.svg")
const BANDIT_ICON: Texture2D = preload("res://assets/combat/bandit_token.svg")
const CASTILIAN_ICON: Texture2D = preload("res://assets/combat/castilian_token.svg")
const MOURISH_ICON: Texture2D = preload("res://assets/combat/mourish_token.svg")
const CORSAIR_ICON: Texture2D = preload("res://assets/combat/corsair_token.svg")
const BOMBARDEIRO_ICON: Texture2D = preload("res://assets/combat/bombardeiro_token.svg")
const PEMBAH_PORTRAIT: Texture2D = preload("res://assets/portraits/pembah_portrait.svg")
const JOAO_PORTRAIT: Texture2D = preload("res://assets/portraits/joao_portrait.svg")
const BANDIT_PORTRAIT: Texture2D = preload("res://assets/portraits/bandit_portrait.svg")
const CASTILIAN_PORTRAIT: Texture2D = preload("res://assets/portraits/castilian_portrait.svg")
const MOURISH_PORTRAIT: Texture2D = preload("res://assets/portraits/mourish_portrait.svg")
const CORSAIR_PORTRAIT: Texture2D = preload("res://assets/portraits/corsair_portrait.svg")
const BOMBARDEIRO_PORTRAIT: Texture2D = preload("res://assets/portraits/bombardeiro_portrait.svg")
const PEMBAH_ICON_CANDIDATES: Array[String] = [
	"res://assets/combat/pembah_battler_v1.png",
	"res://assets/combat/pembah_battle_token.svg",
	"res://assets/combat/pembah_token.svg"
]
const JOAO_ICON_CANDIDATES: Array[String] = [
	"res://assets/combat/joao_battler_v1.png",
	"res://assets/combat/joao_token.svg"
]
const BANDIT_ICON_CANDIDATES: Array[String] = [
	"res://assets/combat/bandit_battler_v1.png",
	"res://assets/combat/bandit_token.svg"
]
const CASTILIAN_ICON_CANDIDATES: Array[String] = [
	"res://assets/combat/castilian_battler_v1.png",
	"res://assets/combat/castilian_token.svg"
]
const MOURISH_ICON_CANDIDATES: Array[String] = [
	"res://assets/combat/mourish_battler_v1.png",
	"res://assets/combat/mourish_token.svg"
]
const CORSAIR_ICON_CANDIDATES: Array[String] = [
	"res://assets/combat/corsair_battler_v1.png",
	"res://assets/combat/corsair_token.svg"
]
const BOMBARDEIRO_ICON_CANDIDATES: Array[String] = [
	"res://assets/combat/bombardeiro_battler_v1.png",
	"res://assets/combat/bombardeiro_token.svg"
]
const PEMBAH_PORTRAIT_CANDIDATES: Array[String] = [
	"res://assets/portraits/pembah_portrait_v1.png",
	"res://assets/portraits/pembah_portrait.svg"
]
const JOAO_PORTRAIT_CANDIDATES: Array[String] = [
	"res://assets/portraits/joao_portrait_v1.png",
	"res://assets/portraits/joao_portrait.svg"
]
const BANDIT_PORTRAIT_CANDIDATES: Array[String] = [
	"res://assets/portraits/bandit_portrait_v1.png",
	"res://assets/portraits/bandit_portrait.svg"
]
const CASTILIAN_PORTRAIT_CANDIDATES: Array[String] = [
	"res://assets/portraits/castilian_portrait_v1.png",
	"res://assets/portraits/castilian_portrait.svg"
]
const MOURISH_PORTRAIT_CANDIDATES: Array[String] = [
	"res://assets/portraits/mourish_portrait_v1.png",
	"res://assets/portraits/mourish_portrait.svg"
]
const CORSAIR_PORTRAIT_CANDIDATES: Array[String] = [
	"res://assets/portraits/corsair_portrait_v1.png",
	"res://assets/portraits/corsair_portrait.svg"
]
const BOMBARDEIRO_PORTRAIT_CANDIDATES: Array[String] = [
	"res://assets/portraits/bombardeiro_portrait_v1.png",
	"res://assets/portraits/bombardeiro_portrait.svg"
]
const MOVE_ICON: Texture2D = preload("res://assets/ui/move_icon.svg")
const ATTACK_ICON: Texture2D = preload("res://assets/ui/attack_icon.svg")
const ITEM_ICON: Texture2D = preload("res://assets/ui/item_icon.svg")
const GUARD_ICON: Texture2D = preload("res://assets/ui/guard_icon.svg")
const BATTLE_TILE_ICON: Texture2D = preload("res://assets/ui/battle_tile.svg")
const VFX_ATLAS_CANDIDATES: Array[String] = [
	"res://assets/vfx/vfx_pack_slice01_v1.png"
]
const VFX_GRID_COLS: int = 3
const VFX_GRID_ROWS: int = 4
const SFX_SAMPLE_RATE: int = 22050
const FLOAT_TEXT_RISE: Vector2 = Vector2(0, -54)
const IMPACT_FLASH_SIZE: Vector2 = Vector2(72, 72)
const SCREEN_CENTER_WEIGHT: float = 0.1
@onready var header_label: Label = %HeaderLabel
@onready var round_label: Label = %RoundLabel
@onready var turn_label: Label = %TurnLabel
@onready var initiative_chips_row: HBoxContainer = %InitiativeChipsRow
@onready var field_hint_label: Label = %FieldHintLabel
@onready var terrain_legend_label: Label = %TerrainLegendLabel
@onready var current_actor_label: Label = %CurrentActorLabel
@onready var target_label: Label = %TargetLabel
@onready var combat_log: RichTextLabel = %CombatLog
@onready var player_portrait: TextureRect = %PlayerPortrait
@onready var companion_portrait: TextureRect = %CompanionPortrait
@onready var player_hp_bar: ProgressBar = %PlayerHpBar
@onready var player_sp_bar: ProgressBar = %PlayerSpBar
@onready var companion_hp_bar: ProgressBar = %CompanionHpBar
@onready var companion_sp_bar: ProgressBar = %CompanionSpBar
@onready var player_portrait_frame: PanelContainer = $BattleFrame/RootVBox/TopStrip/PartyRailPanel/PartyRailVBox/PlayerPanel/PlayerHBox/PlayerPortraitFrame
@onready var companion_portrait_frame: PanelContainer = $BattleFrame/RootVBox/TopStrip/PartyRailPanel/PartyRailVBox/CompanionPanel/CompanionHBox/CompanionPortraitFrame
@onready var companion_panel: PanelContainer = $BattleFrame/RootVBox/TopStrip/PartyRailPanel/PartyRailVBox/CompanionPanel
@onready var player_active_border: ColorRect = %PlayerActiveBorder
@onready var companion_active_border: ColorRect = %CompanionActiveBorder
@onready var player_ap_row: HBoxContainer = %PlayerApRow
@onready var companion_ap_row: HBoxContainer = %CompanionApRow
@onready var player_move_pip: ColorRect = %PlayerMovePip
@onready var player_action_pip: ColorRect = %PlayerActionPip
@onready var companion_move_pip: ColorRect = %CompanionMovePip
@onready var companion_action_pip: ColorRect = %CompanionActionPip
@onready var player_label: Label = %PlayerLabel
@onready var companion_label: Label = %CompanionLabel
@onready var battle_grid: GridContainer = %BattleGrid
@onready var enemy_scroll: ScrollContainer = %EnemyScroll
@onready var enemy_status_list: VBoxContainer = %EnemyStatusList
@onready var action_hint_label: Label = %ActionHintLabel
@onready var result_label: Label = %ResultLabel
@onready var battle_frame: MarginContainer = $BattleFrame
@onready var effects_layer: Control = %EffectsLayer
@onready var header_panel: PanelContainer = $BattleFrame/RootVBox/HeaderPanel
@onready var header_vbox: VBoxContainer = $BattleFrame/RootVBox/HeaderPanel/HeaderVBox
@onready var current_actor_portrait_frame: PanelContainer = $BattleFrame/RootVBox/TopStrip/CurrentActorPanel/CurrentActorVBox/CurrentActorBody/CurrentActorPortraitFrame
@onready var current_actor_portrait: TextureRect = %CurrentActorPortrait
@onready var current_actor_hp_bar: ProgressBar = %CurrentActorHpBar
@onready var current_actor_sp_bar: ProgressBar = %CurrentActorSpBar
@onready var target_portrait_frame: PanelContainer = $BattleFrame/RootVBox/ArenaPanel/ArenaHBox/RightCommandColumn/TargetPanel/TargetVBox/TargetBody/TargetPortraitFrame
@onready var target_portrait: TextureRect = %TargetPortrait
@onready var target_hp_bar: ProgressBar = %TargetHpBar
@onready var target_sp_bar: ProgressBar = %TargetSpBar
@onready var action_buttons: GridContainer = %ActionButtons
@onready var move_button: Button = %MoveButton
@onready var attack_button: Button = %AttackButton
@onready var item_button: Button = %ItemButton
@onready var defend_button: Button = %DefendButton
@onready var skill_buttons: HFlowContainer = %SkillButtons
@onready var continue_button: Button = %ContinueButton
@onready var root_vbox: VBoxContainer = $BattleFrame/RootVBox
@onready var top_strip: HBoxContainer = $BattleFrame/RootVBox/TopStrip
@onready var party_rail_panel: PanelContainer = $BattleFrame/RootVBox/TopStrip/PartyRailPanel
@onready var current_actor_panel: PanelContainer = $BattleFrame/RootVBox/TopStrip/CurrentActorPanel
@onready var left_utility_column: VBoxContainer = $BattleFrame/RootVBox/ArenaPanel/ArenaHBox/LeftUtilityColumn
@onready var right_command_column: VBoxContainer = $BattleFrame/RootVBox/ArenaPanel/ArenaHBox/RightCommandColumn
@onready var field_hint_panel: PanelContainer = $BattleFrame/RootVBox/ArenaPanel/ArenaHBox/LeftUtilityColumn/FieldHintPanel
@onready var action_info_panel: PanelContainer = $BattleFrame/RootVBox/ArenaPanel/ArenaHBox/RightCommandColumn/ActionInfoPanel
@onready var bottom_panel: PanelContainer = $BattleFrame/RootVBox/BottomPanel
@onready var result_row: HBoxContainer = $BattleFrame/RootVBox/BottomPanel/BottomVBox/ResultRow

var battle_context: Dictionary = {}
var player_data: Dictionary = {}
var companion_data: Dictionary = {}
var enemies_data: Array = []
var active_actor_id: String = ""
var selected_target_id: String = ""
var pending_skill_id: String = ""
var battle_mode: String = "idle"
var turn_queue: Array[String] = []
var turn_move_used: bool = false
var turn_action_used: bool = false
var battle_over: bool = false
var ally_start_cells: Array[Vector2i] = []
var enemy_start_cells: Array[Vector2i] = []
var blocked_cells: Array[Vector2i] = []
var water_cells: Array[Vector2i] = []
var high_cells: Array[Vector2i] = []
var terrain_note: String = ""
var round_count: int = 0
var combat_log_lines: Array[String] = []
var preview_target_actor_id: String = ""
var displayed_current_portrait_actor_id: String = ""
var displayed_target_portrait_actor_id: String = ""
var battle_result: String = ""
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var sfx_library: Dictionary = {}
var battle_frame_base_position: Vector2 = Vector2.ZERO
var battle_frame_base_scale: Vector2 = Vector2.ONE
var cinematic_top_bar: ColorRect
var cinematic_bottom_bar: ColorRect
var current_shake_tween: Tween
var finale_overlay: ColorRect
var finale_label: Label
var finale_button: Button
var tutorial_overlay: ColorRect
var tutorial_label: RichTextLabel
var tutorial_next_button: Button
var tutorial_skip_button: Button
var tutorial_pages: Array[String] = []
var tutorial_index: int = 0
var tutorial_active: bool = false
var battle_idle_time: float = 0.0
var texture_cache: Dictionary = {}
var vfx_atlas_texture: Texture2D


func _ready() -> void:
	battle_context = GameState.current_battle_context
	MusicManager.play_battle_music(battle_context)
	_load_battlefield_layout()
	_load_allies()
	_load_enemies()
	rng.randomize()
	_rebalance_layout()
	_apply_visual_theme()
	_setup_effects_layer()
	_load_vfx_atlas()
	_build_sfx_library()
	enemy_scroll.resized.connect(_sync_enemy_status_width)
	call_deferred("_sync_enemy_status_width")

	header_label.text = battle_context.get("battle_title", "Recontro")
	result_label.text = ""
	continue_button.text = battle_context.get("return_button_text", "Tornar")
	terrain_legend_label.text = _build_terrain_legend()
	_write_log(battle_context.get("intro_text", "Erguem-se inimigos diante de vos."))
	_refresh_status()
	if _should_show_battle_tutorial():
		_show_battle_tutorial()
	else:
		_start_round()


func _process(delta: float) -> void:
	battle_idle_time += delta
	_update_battle_idle_loop()


func _rebalance_layout() -> void:
	if party_rail_panel.get_parent() != top_strip:
		party_rail_panel.reparent(top_strip)
		top_strip.move_child(party_rail_panel, 0)
	if current_actor_panel.get_parent() != top_strip:
		current_actor_panel.reparent(top_strip)
		top_strip.move_child(current_actor_panel, top_strip.get_child_count())

	top_strip.visible = true
	root_vbox.add_theme_constant_override("separation", 6)
	header_panel.custom_minimum_size.y = 60.0
	left_utility_column.custom_minimum_size.x = 224.0
	right_command_column.custom_minimum_size.x = 224.0
	party_rail_panel.custom_minimum_size = Vector2(408.0, 0.0)
	current_actor_panel.custom_minimum_size = Vector2(296.0, 0.0)
	field_hint_panel.custom_minimum_size.y = 68.0
	bottom_panel.custom_minimum_size.y = 86.0
	action_buttons.columns = 4
	action_buttons.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	action_buttons.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	action_buttons.add_theme_constant_override("h_separation", 10)
	action_buttons.add_theme_constant_override("v_separation", 0)
	action_info_panel.visible = false


func _apply_visual_theme() -> void:
	_style_node_tree(self)
	combat_log.add_theme_color_override("default_color", Color("eadfc8"))
	combat_log.add_theme_font_size_override("normal_font_size", 17)
	combat_log.add_theme_color_override("font_outline_color", Color(0.06, 0.09, 0.12, 0.8))
	combat_log.add_theme_constant_override("outline_size", 1)
	battle_grid.add_theme_constant_override("h_separation", 4)
	battle_grid.add_theme_constant_override("v_separation", 4)
	_apply_portrait_theme(current_actor_portrait)
	_apply_portrait_theme(target_portrait)
	_apply_portrait_theme(player_portrait)
	_apply_portrait_theme(companion_portrait)
	for bar in [
		player_hp_bar,
		player_sp_bar,
		companion_hp_bar,
		companion_sp_bar,
		current_actor_hp_bar,
		current_actor_sp_bar,
		target_hp_bar,
		target_sp_bar
	]:
		_apply_progress_bar_theme(bar, Color(0.25, 0.76, 0.45, 1.0) if bar.name.contains("Hp") else Color(0.26, 0.64, 0.94, 1.0))
	_configure_action_icon_buttons()


func _style_node_tree(node: Node) -> void:
	for child in node.get_children():
		if child is PanelContainer:
			var panel: PanelContainer = child
			panel.add_theme_stylebox_override("panel", _make_panel_style(_panel_role_for_name(panel.name)))
		elif child is Button:
			var button: Button = child
			_apply_button_theme(button)
		elif child is Label:
			var label: Label = child
			_apply_label_theme(label)
		_style_node_tree(child)


func _panel_role_for_name(panel_name: String) -> String:
	match panel_name:
		"HeaderPanel":
			return "header"
		"TurnOrderPanel", "CurrentActorPanel", "TargetPanel", "ActionInfoPanel", "PartyRailPanel", "PlayerPanel", "CompanionPanel", "FieldHintPanel":
			return "focus"
		"BottomPanel":
			return "footer"
		"EnemyPanel":
			return "enemy"
		"LogPanel":
			return "log"
		"BattlefieldPanel", "BattleSurfacePanel", "ArenaPanel":
			return "field"
		_:
			return "default"


func _make_panel_style(role: String) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.corner_radius_top_left = 18
	style.corner_radius_top_right = 18
	style.corner_radius_bottom_right = 18
	style.corner_radius_bottom_left = 18
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.28)
	style.shadow_size = 8
	style.content_margin_left = 14
	style.content_margin_top = 12
	style.content_margin_right = 14
	style.content_margin_bottom = 12

	match role:
		"header":
			style.bg_color = Color(0.13, 0.18, 0.24, 0.94)
			style.border_color = Color(0.82, 0.67, 0.36, 0.9)
		"focus":
			style.bg_color = Color(0.17, 0.22, 0.19, 0.94)
			style.border_color = Color(0.76, 0.63, 0.34, 0.88)
		"footer":
			style.bg_color = Color(0.11, 0.15, 0.2, 0.96)
			style.border_color = Color(0.78, 0.62, 0.28, 0.82)
		"enemy":
			style.bg_color = Color(0.21, 0.15, 0.16, 0.95)
			style.border_color = Color(0.7, 0.37, 0.29, 0.86)
		"log":
			style.bg_color = Color(0.14, 0.12, 0.1, 0.95)
			style.border_color = Color(0.65, 0.5, 0.29, 0.8)
		"field":
			style.bg_color = Color(0.13, 0.18, 0.17, 0.95)
			style.border_color = Color(0.62, 0.54, 0.28, 0.82)
		_:
			style.bg_color = Color(0.16, 0.18, 0.2, 0.92)
			style.border_color = Color(0.6, 0.5, 0.3, 0.72)
	return style


func _apply_button_theme(button: Button) -> void:
	button.add_theme_stylebox_override("normal", _make_button_style(Color(0.17, 0.22, 0.2, 0.98), Color(0.78, 0.61, 0.28, 0.92)))
	button.add_theme_stylebox_override("hover", _make_button_style(Color(0.23, 0.29, 0.26, 1.0), Color(0.89, 0.74, 0.4, 0.96)))
	button.add_theme_stylebox_override("pressed", _make_button_style(Color(0.3, 0.22, 0.13, 1.0), Color(0.95, 0.8, 0.45, 1.0)))
	button.add_theme_stylebox_override("disabled", _make_button_style(Color(0.13, 0.14, 0.15, 0.9), Color(0.34, 0.34, 0.34, 0.7)))
	button.add_theme_color_override("font_color", Color("f2ead8"))
	button.add_theme_color_override("font_focus_color", Color("fff6df"))
	button.add_theme_color_override("font_hover_color", Color("fff5d0"))
	button.add_theme_color_override("font_pressed_color", Color("fff1c1"))
	button.add_theme_color_override("font_disabled_color", Color(0.56, 0.56, 0.56))
	button.add_theme_font_size_override("font_size", 17)


func _apply_hotbar_button_theme(button: Button) -> void:
	button.add_theme_stylebox_override("normal", _make_button_style(Color(0.12, 0.15, 0.19, 0.98), Color(0.42, 0.67, 0.86, 0.94)))
	button.add_theme_stylebox_override("hover", _make_button_style(Color(0.17, 0.2, 0.25, 1.0), Color(0.58, 0.79, 0.95, 0.98)))
	button.add_theme_stylebox_override("pressed", _make_button_style(Color(0.23, 0.18, 0.11, 1.0), Color(0.95, 0.78, 0.41, 1.0)))
	button.add_theme_stylebox_override("disabled", _make_button_style(Color(0.1, 0.11, 0.13, 0.92), Color(0.24, 0.28, 0.34, 0.76)))
	button.add_theme_color_override("font_color", Color("eef4f8"))
	button.add_theme_color_override("font_focus_color", Color("fff8e5"))
	button.add_theme_color_override("font_hover_color", Color("fff9ec"))
	button.add_theme_color_override("font_pressed_color", Color("fff0c2"))
	button.add_theme_color_override("font_disabled_color", Color(0.53, 0.56, 0.6))
	button.add_theme_font_size_override("font_size", 15)


func _rarity_color(quality_id: String) -> Color:
	match quality_id:
		"white":
			return Color(0.32, 0.32, 0.3, 0.98)
		"green":
			return Color(0.18, 0.34, 0.24, 0.98)
		"blue":
			return Color(0.16, 0.28, 0.44, 0.98)
		"purple":
			return Color(0.3, 0.22, 0.44, 0.98)
		"gold":
			return Color(0.44, 0.34, 0.18, 0.98)
		"red":
			return Color(0.42, 0.2, 0.2, 0.98)
		_:
			return Color(0.16, 0.18, 0.2, 0.98)


func _apply_rarity_hotbar_theme(button: Button, quality_id: String) -> void:
	if quality_id.is_empty():
		return

	var base: Color = _rarity_color(quality_id)
	var border: Color = base.lightened(0.22)

	var style_normal: StyleBoxFlat = _make_button_style(base, border)
	var style_hover: StyleBoxFlat = _make_button_style(base.lightened(0.08), border.lightened(0.08))
	var style_pressed: StyleBoxFlat = _make_button_style(base.darkened(0.1), border.lightened(0.18))
	var style_disabled: StyleBoxFlat = _make_button_style(base.darkened(0.35), base.darkened(0.1))

	# Glow shadow for rare/epic/legendary tiers (matches Hero's Adventure rarity feel)
	var glow_strength: float = 0.0
	match quality_id:
		"green":
			glow_strength = 5.0
		"blue":
			glow_strength = 8.0
		"purple":
			glow_strength = 12.0
		"gold":
			glow_strength = 14.0
		"red":
			glow_strength = 14.0

	if glow_strength > 0.0:
		var glow_color: Color = border.lightened(0.18)
		glow_color.a = 0.72
		style_normal.shadow_color = glow_color
		style_normal.shadow_size = int(glow_strength)
		style_hover.shadow_color = glow_color.lightened(0.12)
		style_hover.shadow_size = int(glow_strength) + 2

	button.add_theme_stylebox_override("normal", style_normal)
	button.add_theme_stylebox_override("hover", style_hover)
	button.add_theme_stylebox_override("pressed", style_pressed)
	button.add_theme_stylebox_override("disabled", style_disabled)


func _make_button_style(fill: Color, border: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = 14
	style.corner_radius_top_right = 14
	style.corner_radius_bottom_right = 14
	style.corner_radius_bottom_left = 14
	style.content_margin_left = 12
	style.content_margin_top = 8
	style.content_margin_right = 12
	style.content_margin_bottom = 8
	return style


func _apply_label_theme(label: Label) -> void:
	label.add_theme_color_override("font_color", Color("f4ead4"))
	label.add_theme_color_override("font_outline_color", Color(0.06, 0.08, 0.1, 0.75))
	label.add_theme_constant_override("outline_size", 1)
	match label.name:
		"HeaderLabel":
			label.add_theme_color_override("font_color", Color("f6e2b1"))
		"ResultLabel":
			label.add_theme_color_override("font_color", Color("f7d682"))
		"TurnLabel", "RoundLabel", "CurrentActorTitle", "TargetTitle", "LogTitle", "EnemyTitle", "ActionInfoTitle":
			label.add_theme_color_override("font_color", Color("f3ddb4"))


func _apply_portrait_theme(portrait: TextureRect) -> void:
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	portrait.custom_minimum_size = Vector2(72, 72)
	portrait.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	portrait.modulate = Color(0.96, 0.93, 0.84, 1.0)


func _apply_progress_bar_theme(bar: ProgressBar, fill_color: Color) -> void:
	if bar == null:
		return
	var background := StyleBoxFlat.new()
	background.bg_color = Color(0.07, 0.09, 0.11, 0.92)
	background.corner_radius_top_left = 6
	background.corner_radius_top_right = 6
	background.corner_radius_bottom_right = 6
	background.corner_radius_bottom_left = 6
	background.border_width_left = 1
	background.border_width_top = 1
	background.border_width_right = 1
	background.border_width_bottom = 1
	background.border_color = Color(0.84, 0.77, 0.59, 0.56)
	var fill := StyleBoxFlat.new()
	fill.bg_color = fill_color
	fill.corner_radius_top_left = 6
	fill.corner_radius_top_right = 6
	fill.corner_radius_bottom_right = 6
	fill.corner_radius_bottom_left = 6
	bar.add_theme_stylebox_override("background", background)
	bar.add_theme_stylebox_override("fill", fill)
	bar.add_theme_stylebox_override("background_disabled", background)
	bar.add_theme_stylebox_override("fill_disabled", fill)
	bar.show_percentage = false
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar.max_value = 100.0
	bar.step = 0.1


func _configure_action_icon_buttons() -> void:
	_apply_action_icon_button_theme(move_button, MOVE_ICON, "1 mover", "1")
	_apply_action_icon_button_theme(attack_button, ATTACK_ICON, "2 golpear", "2")
	_apply_action_icon_button_theme(item_button, ITEM_ICON, "3 pocao", "3")
	_apply_action_icon_button_theme(defend_button, GUARD_ICON, "4 defender", "4")


func _apply_action_icon_button_theme(button: Button, icon: Texture2D, hint_text: String, key_text: String) -> void:
	if button == null:
		return
	var style_normal := StyleBoxFlat.new()
	style_normal.bg_color = Color(0.1, 0.13, 0.18, 0.98)
	style_normal.border_color = Color(0.88, 0.76, 0.49, 0.94)
	style_normal.border_width_left = 2
	style_normal.border_width_top = 2
	style_normal.border_width_right = 2
	style_normal.border_width_bottom = 2
	style_normal.corner_radius_top_left = 28
	style_normal.corner_radius_top_right = 28
	style_normal.corner_radius_bottom_right = 28
	style_normal.corner_radius_bottom_left = 28
	style_normal.content_margin_left = 16
	style_normal.content_margin_top = 16
	style_normal.content_margin_right = 16
	style_normal.content_margin_bottom = 16
	style_normal.shadow_color = Color(0.0, 0.0, 0.0, 0.28)
	style_normal.shadow_size = 8
	var style_hover := style_normal.duplicate()
	style_hover.bg_color = Color(0.16, 0.2, 0.27, 1.0)
	style_hover.border_color = Color(0.98, 0.85, 0.55, 1.0)
	var style_pressed := style_normal.duplicate()
	style_pressed.bg_color = Color(0.22, 0.18, 0.12, 1.0)
	style_pressed.border_color = Color(1.0, 0.9, 0.62, 1.0)
	var style_disabled := style_normal.duplicate()
	style_disabled.bg_color = Color(0.08, 0.09, 0.11, 0.92)
	style_disabled.border_color = Color(0.34, 0.37, 0.42, 0.76)
	button.add_theme_stylebox_override("normal", style_normal)
	button.add_theme_stylebox_override("hover", style_hover)
	button.add_theme_stylebox_override("pressed", style_pressed)
	button.add_theme_stylebox_override("disabled", style_disabled)
	button.icon = icon
	button.expand_icon = true
	button.text = ""
	button.custom_minimum_size = Vector2(80.0, 80.0)
	button.tooltip_text = hint_text
	button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	_ensure_action_button_key_badge(button, key_text)
	_ensure_action_button_count_badge(button)


func _apply_tutorial_action_button_theme(button: Button) -> void:
	if button == null:
		return
	var style_normal := StyleBoxFlat.new()
	style_normal.bg_color = Color(0.15, 0.18, 0.22, 0.98)
	style_normal.border_color = Color(1.0, 0.9, 0.62, 1.0)
	style_normal.border_width_left = 3
	style_normal.border_width_top = 3
	style_normal.border_width_right = 3
	style_normal.border_width_bottom = 3
	style_normal.corner_radius_top_left = 28
	style_normal.corner_radius_top_right = 28
	style_normal.corner_radius_bottom_right = 28
	style_normal.corner_radius_bottom_left = 28
	style_normal.content_margin_left = 16
	style_normal.content_margin_top = 16
	style_normal.content_margin_right = 16
	style_normal.content_margin_bottom = 16
	style_normal.shadow_color = Color(1.0, 0.85, 0.45, 0.36)
	style_normal.shadow_size = 14
	var style_hover := style_normal.duplicate()
	style_hover.bg_color = Color(0.2, 0.23, 0.3, 1.0)
	style_hover.border_color = Color(1.0, 0.93, 0.7, 1.0)
	var style_pressed := style_normal.duplicate()
	style_pressed.bg_color = Color(0.23, 0.19, 0.13, 1.0)
	style_pressed.border_color = Color(1.0, 0.9, 0.62, 1.0)
	var style_disabled := style_normal.duplicate()
	style_disabled.bg_color = Color(0.12, 0.14, 0.18, 0.95)
	style_disabled.border_color = Color(0.88, 0.78, 0.5, 0.9)
	button.add_theme_stylebox_override("normal", style_normal)
	button.add_theme_stylebox_override("hover", style_hover)
	button.add_theme_stylebox_override("pressed", style_pressed)
	button.add_theme_stylebox_override("disabled", style_disabled)


func _apply_tutorial_action_highlight(enable: bool) -> void:
	if enable:
		action_buttons.visible = true
		move_button.disabled = true
		attack_button.disabled = true
		item_button.disabled = true
		defend_button.disabled = true
		_apply_tutorial_action_button_theme(move_button)
		_apply_tutorial_action_button_theme(attack_button)
		_apply_tutorial_action_button_theme(item_button)
		_apply_tutorial_action_button_theme(defend_button)
	else:
		_configure_action_icon_buttons()


func _ensure_action_button_key_badge(button: Button, key_text: String) -> void:
	var badge: Label = button.get_node_or_null("KeyBadge") as Label
	if badge == null:
		badge = Label.new()
		badge.name = "KeyBadge"
		badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
		badge.anchor_right = 0.0
		badge.anchor_bottom = 0.0
		badge.offset_left = 8.0
		badge.offset_top = 6.0
		badge.offset_right = 28.0
		badge.offset_bottom = 24.0
		badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		badge.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_apply_label_theme(badge)
		badge.add_theme_font_size_override("font_size", 12)
		badge.add_theme_color_override("font_color", Color("fff3c6"))
		button.add_child(badge)
	badge.text = key_text


func _ensure_action_button_count_badge(button: Button) -> void:
	var badge: Label = button.get_node_or_null("CountBadge") as Label
	if badge == null:
		badge = Label.new()
		badge.name = "CountBadge"
		badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
		badge.anchor_left = 1.0
		badge.anchor_top = 1.0
		badge.anchor_right = 1.0
		badge.anchor_bottom = 1.0
		badge.offset_left = -34.0
		badge.offset_top = -24.0
		badge.offset_right = -8.0
		badge.offset_bottom = -8.0
		badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		badge.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_apply_label_theme(badge)
		badge.add_theme_font_size_override("font_size", 12)
		badge.add_theme_color_override("font_color", Color("f8e09a"))
		button.add_child(badge)
	badge.visible = false


func _set_action_button_count_badge(button: Button, count: int) -> void:
	var badge: Label = button.get_node_or_null("CountBadge") as Label
	if badge == null:
		return
	badge.text = "x%d" % count
	badge.visible = count > 0


func _set_progress_bar_percent(bar: ProgressBar, current_value: int, max_value: int, label: String) -> void:
	if bar == null:
		return
	if max_value <= 0:
		bar.visible = false
		bar.value = 0.0
		bar.tooltip_text = ""
		return
	bar.visible = true
	bar.value = clampf((float(current_value) / float(max_value)) * 100.0, 0.0, 100.0)
	bar.tooltip_text = "%s %d/%d" % [label, max(0, current_value), max_value]


func _set_combatant_bar_pair(hp_bar: ProgressBar, sp_bar: ProgressBar, combatant: Dictionary) -> void:
	if combatant.is_empty():
		_clear_bar_pair(hp_bar, sp_bar)
		return
	_set_progress_bar_percent(hp_bar, int(combatant.get("hp", 0)), int(combatant.get("max_hp", 0)), "PV")
	_set_progress_bar_percent(sp_bar, int(combatant.get("sp", 0)), int(combatant.get("max_sp", 0)), "ESP")


func _clear_bar_pair(hp_bar: ProgressBar, sp_bar: ProgressBar) -> void:
	if hp_bar != null:
		hp_bar.visible = false
		hp_bar.value = 0.0
		hp_bar.tooltip_text = ""
	if sp_bar != null:
		sp_bar.visible = false
		sp_bar.value = 0.0
		sp_bar.tooltip_text = ""


func _make_grid_cell_style(fill: Color, border: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_right = 12
	style.corner_radius_bottom_left = 12
	return style


func _make_token_frame_style(accent: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(accent.r * 0.32, accent.g * 0.32, accent.b * 0.32, 0.94)
	style.border_color = accent.lerp(Color.WHITE, 0.28)
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = 16
	style.corner_radius_top_right = 16
	style.corner_radius_bottom_right = 16
	style.corner_radius_bottom_left = 16
	return style


func _make_unit_shadow_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.0, 0.0, 0.0, 0.28)
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_right = 12
	style.corner_radius_bottom_left = 12
	return style


func _remember_control_offsets(control: Control) -> void:
	if control == null:
		return
	control.set_meta("base_offsets", {
		"left": control.offset_left,
		"top": control.offset_top,
		"right": control.offset_right,
		"bottom": control.offset_bottom
	})


func _get_control_offsets(control: Control) -> Dictionary:
	if control == null:
		return {}
	if control.has_meta("pose_offsets"):
		return control.get_meta("pose_offsets", {})
	return control.get_meta("base_offsets", {})


func _set_control_pose_offsets(control: Control, x_shift: float = 0.0, y_shift: float = 0.0) -> void:
	if control == null:
		return
	var base_offsets: Dictionary = control.get_meta("base_offsets", {})
	if base_offsets.is_empty():
		return
	if absf(x_shift) < 0.01 and absf(y_shift) < 0.01:
		control.remove_meta("pose_offsets")
		return
	control.set_meta("pose_offsets", {
		"left": float(base_offsets.get("left", control.offset_left)) + x_shift,
		"top": float(base_offsets.get("top", control.offset_top)) + y_shift,
		"right": float(base_offsets.get("right", control.offset_right)) + x_shift,
		"bottom": float(base_offsets.get("bottom", control.offset_bottom)) + y_shift
	})


func _apply_control_offsets(control: Control, offsets: Dictionary, y_shift: float = 0.0) -> void:
	if control == null or offsets.is_empty():
		return
	control.offset_left = float(offsets.get("left", control.offset_left))
	control.offset_top = float(offsets.get("top", control.offset_top)) + y_shift
	control.offset_right = float(offsets.get("right", control.offset_right))
	control.offset_bottom = float(offsets.get("bottom", control.offset_bottom)) + y_shift


func _make_badge_style(accent: Color, compact: bool = false) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(accent.r * 0.28, accent.g * 0.28, accent.b * 0.28, 0.96)
	style.border_color = accent.lerp(Color.WHITE, 0.16)
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.corner_radius_top_left = 10 if compact else 12
	style.corner_radius_top_right = 10 if compact else 12
	style.corner_radius_bottom_right = 10 if compact else 12
	style.corner_radius_bottom_left = 10 if compact else 12
	style.content_margin_left = 7 if compact else 8
	style.content_margin_top = 2 if compact else 3
	style.content_margin_right = 7 if compact else 8
	style.content_margin_bottom = 2 if compact else 3
	return style


func _make_accent_frame_style(accent: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.11, 0.14, 0.17, 0.98)
	style.border_color = accent.lerp(Color.WHITE, 0.2)
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = 14
	style.corner_radius_top_right = 14
	style.corner_radius_bottom_right = 14
	style.corner_radius_bottom_left = 14
	return style


func _apply_actor_frame_accent(frame: PanelContainer, actor_id: String) -> void:
	if frame == null:
		return
	var accent: Color = Color(0.42, 0.42, 0.42, 0.82)
	if not actor_id.is_empty():
		accent = _get_actor_accent_color(actor_id)
	frame.add_theme_stylebox_override("panel", _make_accent_frame_style(accent))


func _get_status_badges(combatant: Dictionary) -> Array[Dictionary]:
	var badges: Array[Dictionary] = []
	for raw_status in combatant.get("status_effects", []):
		var status: Dictionary = raw_status
		var status_id: String = str(status.get("id", ""))
		var duration: int = int(status.get("duration", 0))
		match status_id:
			"bleed":
				badges.append({
					"text": "Sangr. %d" % duration,
					"compact": "SG%d" % duration,
					"color": Color(0.86, 0.31, 0.28, 1.0)
				})
			"stun":
				badges.append({
					"text": "Atord. %d" % duration,
					"compact": "AT%d" % duration,
					"color": Color(0.94, 0.79, 0.38, 1.0)
				})
			STUN_GUARD_STATUS_ID:
				badges.append({
					"text": "Firme",
					"compact": "FR",
					"color": Color(0.48, 0.68, 0.88, 1.0)
				})
	if combatant.get("defending", false) and int(combatant.get("hp", 0)) > 0:
		badges.append({
			"text": "Guarda",
			"compact": "GD",
			"color": Color(0.38, 0.71, 0.54, 1.0)
		})
	return badges


func _make_status_badge(badge_data: Dictionary, compact: bool = false) -> PanelContainer:
	var badge := PanelContainer.new()
	badge.add_theme_stylebox_override("panel", _make_badge_style(Color(badge_data.get("color", Color.WHITE)), compact))
	var label := Label.new()
	label.text = str(badge_data.get("compact", "")) if compact else str(badge_data.get("text", ""))
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_apply_label_theme(label)
	label.add_theme_font_size_override("font_size", 11 if compact else 12)
	label.add_theme_color_override("font_color", Color("fff8ec"))
	badge.add_child(label)
	return badge


func _setup_grid_button_widgets(button: Button) -> void:
	var tile_art := TextureRect.new()
	tile_art.name = "TileArt"
	tile_art.anchor_right = 1.0
	tile_art.anchor_bottom = 1.0
	tile_art.offset_left = 0.0
	tile_art.offset_top = 0.0
	tile_art.offset_right = 0.0
	tile_art.offset_bottom = 0.0
	tile_art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tile_art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tile_art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	tile_art.texture = BATTLE_TILE_ICON
	button.add_child(tile_art)

	var terrain_label := Label.new()
	terrain_label.name = "TerrainLabel"
	terrain_label.anchor_right = 0.0
	terrain_label.anchor_bottom = 0.0
	terrain_label.offset_left = 10.0
	terrain_label.offset_top = 10.0
	terrain_label.offset_right = 30.0
	terrain_label.offset_bottom = 30.0
	terrain_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	terrain_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	terrain_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_apply_label_theme(terrain_label)
	terrain_label.add_theme_font_size_override("font_size", 18)
	button.add_child(terrain_label)

	var hp_bar := ProgressBar.new()
	hp_bar.name = "UnitHpBar"
	hp_bar.anchor_left = 0.0
	hp_bar.anchor_top = 0.0
	hp_bar.anchor_right = 1.0
	hp_bar.anchor_bottom = 0.0
	hp_bar.offset_left = 14.0
	hp_bar.offset_top = 8.0
	hp_bar.offset_right = -14.0
	hp_bar.offset_bottom = 13.0
	_apply_progress_bar_theme(hp_bar, Color(0.25, 0.76, 0.45, 1.0))
	button.add_child(hp_bar)

	var sp_bar := ProgressBar.new()
	sp_bar.name = "UnitSpBar"
	sp_bar.anchor_left = 0.0
	sp_bar.anchor_top = 0.0
	sp_bar.anchor_right = 1.0
	sp_bar.anchor_bottom = 0.0
	sp_bar.offset_left = 14.0
	sp_bar.offset_top = 15.0
	sp_bar.offset_right = -14.0
	sp_bar.offset_bottom = 20.0
	_apply_progress_bar_theme(sp_bar, Color(0.26, 0.64, 0.94, 1.0))
	button.add_child(sp_bar)

	var unit_shadow := PanelContainer.new()
	unit_shadow.name = "UnitShadow"
	unit_shadow.anchor_left = 0.5
	unit_shadow.anchor_top = 1.0
	unit_shadow.anchor_right = 0.5
	unit_shadow.anchor_bottom = 1.0
	unit_shadow.offset_left = -22.0
	unit_shadow.offset_top = -20.0
	unit_shadow.offset_right = 22.0
	unit_shadow.offset_bottom = -7.0
	unit_shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	unit_shadow.add_theme_stylebox_override("panel", _make_unit_shadow_style())
	button.add_child(unit_shadow)
	_remember_control_offsets(unit_shadow)
	unit_shadow.pivot_offset = Vector2(22.0, 6.0)

	var token_frame := PanelContainer.new()
	token_frame.name = "TokenFrame"
	token_frame.anchor_left = 0.5
	token_frame.anchor_top = 0.5
	token_frame.anchor_right = 0.5
	token_frame.anchor_bottom = 0.5
	token_frame.offset_left = -35.0
	token_frame.offset_top = -28.0
	token_frame.offset_right = 35.0
	token_frame.offset_bottom = 58.0
	token_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(token_frame)
	_remember_control_offsets(token_frame)
	token_frame.pivot_offset = Vector2(35.0, 43.0)

	var unit_icon := TextureRect.new()
	unit_icon.name = "UnitIcon"
	unit_icon.anchor_left = 0.5
	unit_icon.anchor_top = 0.5
	unit_icon.anchor_right = 0.5
	unit_icon.anchor_bottom = 0.5
	unit_icon.offset_left = -34.0
	unit_icon.offset_top = -26.0
	unit_icon.offset_right = 34.0
	unit_icon.offset_bottom = 56.0
	unit_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	unit_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	unit_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	unit_icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	button.add_child(unit_icon)
	_remember_control_offsets(unit_icon)
	unit_icon.pivot_offset = Vector2(34.0, 41.0)

	var unit_label := Label.new()
	unit_label.name = "UnitLabel"
	unit_label.anchor_left = 0.5
	unit_label.anchor_top = 1.0
	unit_label.anchor_right = 0.5
	unit_label.anchor_bottom = 1.0
	unit_label.offset_left = -22.0
	unit_label.offset_top = -24.0
	unit_label.offset_right = 22.0
	unit_label.offset_bottom = -4.0
	unit_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	unit_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	unit_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_apply_label_theme(unit_label)
	unit_label.add_theme_font_size_override("font_size", 13)
	button.add_child(unit_label)
	_remember_control_offsets(unit_label)

	var status_badge_panel := PanelContainer.new()
	status_badge_panel.name = "StatusBadgePanel"
	status_badge_panel.anchor_left = 1.0
	status_badge_panel.anchor_top = 1.0
	status_badge_panel.anchor_right = 1.0
	status_badge_panel.anchor_bottom = 1.0
	status_badge_panel.offset_left = -38.0
	status_badge_panel.offset_top = -24.0
	status_badge_panel.offset_right = -6.0
	status_badge_panel.offset_bottom = -6.0
	status_badge_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(status_badge_panel)

	var status_badge_label := Label.new()
	status_badge_label.name = "StatusBadgeLabel"
	status_badge_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_badge_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	status_badge_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_apply_label_theme(status_badge_label)
	status_badge_label.add_theme_font_size_override("font_size", 11)
	status_badge_label.add_theme_color_override("font_color", Color("fff8ec"))
	status_badge_panel.add_child(status_badge_label)


func _setup_effects_layer() -> void:
	effects_layer.z_index = 30
	effects_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	battle_grid.pivot_offset = battle_grid.size * 0.5
	battle_frame_base_position = battle_frame.position
	battle_frame_base_scale = battle_frame.scale

	cinematic_top_bar = ColorRect.new()
	cinematic_top_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cinematic_top_bar.color = Color(0.02, 0.03, 0.05, 0.0)
	cinematic_top_bar.anchor_right = 1.0
	cinematic_top_bar.offset_bottom = 0.0
	effects_layer.add_child(cinematic_top_bar)

	cinematic_bottom_bar = ColorRect.new()
	cinematic_bottom_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cinematic_bottom_bar.color = Color(0.02, 0.03, 0.05, 0.0)
	cinematic_bottom_bar.anchor_top = 1.0
	cinematic_bottom_bar.anchor_right = 1.0
	cinematic_bottom_bar.anchor_bottom = 1.0
	effects_layer.add_child(cinematic_bottom_bar)


func _load_vfx_atlas() -> void:
	vfx_atlas_texture = null
	for path in VFX_ATLAS_CANDIDATES:
		if not ResourceLoader.exists(path):
			continue
		var resource: Resource = load(path)
		if resource is Texture2D:
			vfx_atlas_texture = resource
			return


func _get_vfx_region_index(region_id: String) -> Vector2i:
	match region_id:
		"slash":
			return Vector2i(0, 0)
		"spark":
			return Vector2i(1, 0)
		"dust":
			return Vector2i(2, 0)
		"guard":
			return Vector2i(0, 1)
		"heal":
			return Vector2i(2, 1)
		"splash":
			return Vector2i(0, 2)
		"arc":
			return Vector2i(1, 2)
		"bleed":
			return Vector2i(2, 2)
		"bleed_strong":
			return Vector2i(2, 3)
		_:
			return Vector2i(1, 0)


func _get_vfx_region_rect(region_id: String) -> Rect2:
	if vfx_atlas_texture == null:
		return Rect2()
	var atlas_size: Vector2 = vfx_atlas_texture.get_size()
	if atlas_size.x <= 0.0 or atlas_size.y <= 0.0:
		return Rect2()
	var cell_size := Vector2(atlas_size.x / float(VFX_GRID_COLS), atlas_size.y / float(VFX_GRID_ROWS))
	var index: Vector2i = _get_vfx_region_index(region_id)
	var pad := Vector2(cell_size.x * 0.12, cell_size.y * 0.15)
	return Rect2(
		Vector2(float(index.x) * cell_size.x + pad.x, float(index.y) * cell_size.y + pad.y),
		Vector2(cell_size.x - pad.x * 2.0, cell_size.y - pad.y * 2.0)
	)


func _spawn_cell_vfx(cell: Vector2i, region_id: String, tint: Color = Color.WHITE, scale_amount: float = 1.0, y_offset: float = -10.0, duration: float = 0.3) -> void:
	if vfx_atlas_texture == null or not _cell_in_bounds(cell):
		return
	var region: Rect2 = _get_vfx_region_rect(region_id)
	if region.size.x <= 0.0 or region.size.y <= 0.0:
		return
	var atlas := AtlasTexture.new()
	atlas.atlas = vfx_atlas_texture
	atlas.region = region
	var fx := TextureRect.new()
	fx.texture = atlas
	fx.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	fx.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	fx.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	fx.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var base_size := Vector2(74.0, 74.0) * scale_amount
	fx.custom_minimum_size = base_size
	fx.size = base_size
	fx.pivot_offset = base_size * 0.5
	fx.position = _get_cell_effect_position(cell) - (base_size * 0.5) + Vector2(0.0, y_offset)
	fx.modulate = Color(tint.r, tint.g, tint.b, 0.9)
	effects_layer.add_child(fx)

	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(fx, "scale", Vector2(1.14, 1.14), duration * 0.55).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(fx, "position:y", fx.position.y - 10.0, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(fx, "modulate:a", 0.0, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.finished.connect(fx.queue_free)


func _spawn_actor_vfx(actor_id: String, region_id: String, tint: Color = Color.WHITE, scale_amount: float = 1.0, y_offset: float = -10.0, duration: float = 0.3) -> void:
	_spawn_cell_vfx(_get_actor_cell(actor_id), region_id, tint, scale_amount, y_offset, duration)


func _build_sfx_library() -> void:
	sfx_library = {
		"blade": _create_sfx_stream([
			{"start_freq": 880.0, "end_freq": 520.0, "gain": 0.22, "wave": "saw", "decay": 2.8},
			{"freq": 220.0, "gain": 0.18, "wave": "square", "decay": 3.8},
			{"freq": 1160.0, "gain": 0.08, "wave": "sine", "decay": 5.4}
		], 0.16, 0.005, 1.15),
		"heavy_blade": _create_sfx_stream([
			{"start_freq": 520.0, "end_freq": 250.0, "gain": 0.26, "wave": "square", "decay": 2.1},
			{"freq": 160.0, "gain": 0.22, "wave": "sine", "decay": 2.8},
			{"freq": 780.0, "gain": 0.06, "wave": "saw", "decay": 3.8}
		], 0.22, 0.008, 1.3),
		"wave": _create_sfx_stream([
			{"start_freq": 320.0, "end_freq": 180.0, "gain": 0.2, "wave": "sine", "decay": 1.8},
			{"freq": 96.0, "gain": 0.2, "wave": "triangle", "decay": 2.5},
			{"freq": 540.0, "gain": 0.08, "wave": "sine", "decay": 3.4}
		], 0.28, 0.012, 1.0, 5.0),
		"guard": _create_sfx_stream([
			{"start_freq": 420.0, "end_freq": 220.0, "gain": 0.22, "wave": "triangle", "decay": 2.4},
			{"freq": 140.0, "gain": 0.18, "wave": "square", "decay": 3.2}
		], 0.18, 0.01, 1.45),
		"heal": _create_sfx_stream([
			{"start_freq": 420.0, "end_freq": 760.0, "gain": 0.16, "wave": "sine", "decay": 1.1},
			{"start_freq": 560.0, "end_freq": 920.0, "gain": 0.14, "wave": "triangle", "decay": 1.3},
			{"freq": 210.0, "gain": 0.1, "wave": "sine", "decay": 2.2}
		], 0.3, 0.014, 0.9, 6.0),
		"stun": _create_sfx_stream([
			{"freq": 760.0, "gain": 0.16, "wave": "sine", "decay": 1.5},
			{"freq": 1120.0, "gain": 0.12, "wave": "sine", "decay": 2.6},
			{"freq": 1520.0, "gain": 0.08, "wave": "triangle", "decay": 4.0}
		], 0.24, 0.004, 1.0, 8.0),
		"fire": _create_sfx_stream([
			{"start_freq": 720.0, "end_freq": 280.0, "gain": 0.24, "wave": "saw", "decay": 1.9},
			{"start_freq": 430.0, "end_freq": 180.0, "gain": 0.18, "wave": "square", "decay": 2.4},
			{"freq": 980.0, "gain": 0.08, "wave": "triangle", "decay": 3.2}
		], 0.24, 0.006, 1.25),
		"bleed": _create_sfx_stream([
			{"start_freq": 540.0, "end_freq": 220.0, "gain": 0.18, "wave": "saw", "decay": 2.6},
			{"freq": 260.0, "gain": 0.14, "wave": "square", "decay": 3.4}
		], 0.14, 0.004, 1.35),
		"victory": _create_sfx_stream([
			{"start_freq": 420.0, "end_freq": 640.0, "gain": 0.17, "wave": "triangle", "decay": 0.9},
			{"start_freq": 620.0, "end_freq": 940.0, "gain": 0.14, "wave": "sine", "decay": 1.0},
			{"freq": 220.0, "gain": 0.08, "wave": "sine", "decay": 2.0}
		], 0.48, 0.02, 0.85, 4.0),
		"defeat": _create_sfx_stream([
			{"start_freq": 360.0, "end_freq": 120.0, "gain": 0.18, "wave": "triangle", "decay": 1.2},
			{"start_freq": 220.0, "end_freq": 90.0, "gain": 0.14, "wave": "sine", "decay": 1.4}
		], 0.52, 0.02, 1.1)
	}


func _create_sfx_stream(partials: Array, duration: float, attack: float = 0.008, tail_power: float = 1.2, tremolo_hz: float = 0.0) -> AudioStreamWAV:
	var total_samples: int = max(1, ceili(duration * float(SFX_SAMPLE_RATE)))
	var data := PackedByteArray()
	data.resize(total_samples * 2)

	for i in range(total_samples):
		var t: float = float(i) / float(SFX_SAMPLE_RATE)
		var progress: float = min(1.0, t / max(0.001, duration))
		var envelope: float = min(1.0, t / max(0.001, attack)) * pow(max(0.0, 1.0 - progress), tail_power)
		var sample_value: float = 0.0

		for raw_partial in partials:
			var partial: Dictionary = raw_partial
			var start_freq: float = float(partial.get("start_freq", partial.get("freq", 440.0)))
			var end_freq: float = float(partial.get("end_freq", start_freq))
			var freq: float = lerpf(start_freq, end_freq, progress)
			var gain: float = float(partial.get("gain", 0.15))
			var wave: String = str(partial.get("wave", "sine"))
			var decay: float = float(partial.get("decay", 2.0))
			var partial_envelope: float = pow(max(0.0, 1.0 - progress), decay)
			sample_value += _sample_wave(wave, freq, t) * gain * partial_envelope

		if tremolo_hz > 0.0:
			sample_value *= 0.82 + 0.18 * sin(TAU * tremolo_hz * t)

		var final_sample: float = clampf(sample_value * envelope, -1.0, 1.0)
		var sample_int: int = int(round(final_sample * 32767.0))
		var unsigned_sample: int = sample_int if sample_int >= 0 else 65536 + sample_int
		var byte_index: int = i * 2
		data[byte_index] = unsigned_sample & 0xFF
		data[byte_index + 1] = (unsigned_sample >> 8) & 0xFF

	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = SFX_SAMPLE_RATE
	stream.stereo = false
	stream.data = data
	return stream


func _sample_wave(wave: String, freq: float, t: float) -> float:
	var phase: float = TAU * freq * t
	match wave:
		"square":
			return 1.0 if sin(phase) >= 0.0 else -1.0
		"triangle":
			return asin(sin(phase)) * (2.0 / PI)
		"saw":
			var cycle: float = wrapf(freq * t, 0.0, 1.0)
			return cycle * 2.0 - 1.0
		_:
			return sin(phase)


func _play_sfx(sound_id: String, pitch_jitter: float = 0.03, volume_db: float = -5.0) -> void:
	var stream: AudioStream = sfx_library.get(sound_id)
	if stream == null:
		return

	var player := AudioStreamPlayer.new()
	player.bus = "Master"
	player.stream = stream
	player.volume_db = volume_db
	player.pitch_scale = 1.0 + rng.randf_range(-pitch_jitter, pitch_jitter)
	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()


func _play_skill_sfx(skill: Dictionary, is_enemy: bool = false) -> void:
	var sound_id: String = "blade"
	var skill_id: String = str(skill.get("id", ""))
	var school: String = str(skill.get("school", ""))
	var effect_id: String = str(skill.get("effect", ""))
	var status_effect: Dictionary = skill.get("status_effect", {})

	if skill_id.contains("fogo") or school.contains("Corsarios"):
		sound_id = "fire"
	elif effect_id == "defend_buff" or effect_id == "guard_stance":
		sound_id = "guard"
	elif effect_id == "speed_boost":
		sound_id = "heal"
	elif str(status_effect.get("id", "")) == "stun" or school.contains("Farol"):
		sound_id = "stun"
	elif bool(skill.get("pierce_row", false)) or int(skill.get("area_radius", 0)) > 0 or school.contains("Douro"):
		sound_id = "wave"
	elif str(status_effect.get("id", "")) == "bleed":
		sound_id = "bleed"
	if is_enemy and sound_id == "blade":
		sound_id = "heavy_blade"
	_play_sfx(sound_id, 0.035, -4.5)


func _play_attack_sfx(is_enemy: bool, heavy: bool = false) -> void:
	var sound_id: String = "heavy_blade" if is_enemy or heavy else "blade"
	_play_sfx(sound_id, 0.03, -5.0)


func _load_battlefield_layout() -> void:
	ally_start_cells = _parse_cell_list(battle_context.get("ally_start_cells", DEFAULT_ALLY_START_CELLS))
	if ally_start_cells.is_empty():
		ally_start_cells = _copy_cell_list(DEFAULT_ALLY_START_CELLS)

	enemy_start_cells = _parse_cell_list(battle_context.get("enemy_start_cells", DEFAULT_ENEMY_START_CELLS))
	if enemy_start_cells.is_empty():
		enemy_start_cells = _copy_cell_list(DEFAULT_ENEMY_START_CELLS)

	var terrain: Dictionary = battle_context.get("terrain", {})
	blocked_cells = _parse_cell_list(terrain.get("blocked_cells", []))
	water_cells = _parse_cell_list(terrain.get("water_cells", []))
	high_cells = _parse_cell_list(terrain.get("high_cells", []))
	terrain_note = str(terrain.get("note", ""))


func _load_allies() -> void:
	player_data = GameState.get_player().duplicate(true)
	player_data["defending"] = false
	player_data["status_effects"] = player_data.get("status_effects", [])
	player_data["skill_discount_ready"] = false
	player_data["cell"] = _get_start_cell(ally_start_cells, 0, Vector2i(1, 1))
	player_data["move_range"] = player_data.get("move_range", 2)
	player_data["attack_range"] = player_data.get("attack_range", 1)
	player_data["water_stride"] = player_data.get("water_stride", true)

	if GameState.has_companion("joao"):
		companion_data = GameState.get_companion("joao").duplicate(true)
		companion_data["defending"] = false
		companion_data["status_effects"] = companion_data.get("status_effects", [])
		companion_data["skill_discount_ready"] = false
		companion_data["cell"] = _get_start_cell(ally_start_cells, 1, Vector2i(1, 2))
		companion_data["move_range"] = companion_data.get("move_range", 2)
		companion_data["attack_range"] = companion_data.get("attack_range", 1)
		companion_data["water_stride"] = companion_data.get("water_stride", false)
	else:
		companion_data = {}


func _load_enemies() -> void:
	enemies_data.clear()

	var enemy_ids: Array[String] = _get_battle_enemy_ids()
	if enemy_ids.is_empty():
		enemy_ids.append("bandit_scout")

	for i in range(enemy_ids.size()):
		var enemy_id: String = enemy_ids[i]
		var enemy_template: Dictionary = GameState.enemy_defs.get(enemy_id, {})
		if enemy_template.is_empty():
			continue

		var enemy: Dictionary = enemy_template.duplicate(true)
		enemy["actor_id"] = "enemy_%d" % i
		enemy["hp"] = enemy.get("max_hp", 0)
		enemy["sp"] = enemy.get("max_sp", 0)
		enemy["status_effects"] = enemy.get("status_effects", [])
		enemy["cell"] = _get_start_cell(enemy_start_cells, i, Vector2i(5, 1))
		enemy["attack_range"] = enemy.get("attack_range", 1)
		enemy["move_range"] = enemy.get("move_range", 1)
		enemy["water_stride"] = enemy.get("water_stride", false)
		enemies_data.append(enemy)

	selected_target_id = _first_alive_enemy_id()


func _get_battle_enemy_ids() -> Array[String]:
	var enemy_ids: Array[String] = []
	if battle_context.has("enemy_ids"):
		for raw_enemy_id in battle_context.get("enemy_ids", []):
			enemy_ids.append(str(raw_enemy_id))
	elif not str(battle_context.get("enemy_id", "")).is_empty():
		enemy_ids.append(str(battle_context.get("enemy_id", "")))
	return enemy_ids


func _start_round() -> void:
	if battle_over:
		return

	round_count += 1
	turn_queue = _build_turn_queue()
	_refresh_turn_header()
	_advance_turn()


func _build_turn_queue() -> Array[String]:
	var queue: Array[String] = []
	if _is_actor_alive("pembah"):
		queue.append("pembah")
	if _is_actor_alive("joao"):
		queue.append("joao")
	for enemy in enemies_data:
		if enemy.get("hp", 0) > 0:
			queue.append(enemy.get("actor_id", ""))

	queue.sort_custom(_compare_turn_order)
	return queue


func _compare_turn_order(a: String, b: String) -> bool:
	var speed_a: int = _get_actor_speed(a)
	var speed_b: int = _get_actor_speed(b)
	if speed_a == speed_b:
		return _turn_priority(a) < _turn_priority(b)
	return speed_a > speed_b


func _turn_priority(actor_id: String) -> int:
	if actor_id == "pembah":
		return 0
	if actor_id == "joao":
		return 1
	return 2


func _get_actor_speed(actor_id: String) -> int:
	if actor_id == "pembah":
		return player_data.get("spd", 0)
	if actor_id == "joao":
		return companion_data.get("spd", 0)

	var enemy: Dictionary = _get_enemy_by_actor_id(actor_id)
	return enemy.get("spd", 0)


func _advance_turn() -> void:
	if battle_over:
		return
	if _all_enemies_down():
		_victory()
		return
	if _all_allies_down():
		_defeat()
		return
	if turn_queue.is_empty():
		_start_round()
		return

	var next_actor: String = str(turn_queue.pop_front())
	active_actor_id = next_actor
	_refresh_turn_header()
	if active_actor_id.begins_with("enemy_"):
		_begin_enemy_turn(active_actor_id)
	else:
		_begin_ally_turn(active_actor_id)


func _begin_ally_turn(actor_id: String) -> void:
	var actor: Dictionary = _get_actor_data(actor_id)
	if actor.is_empty() or actor.get("hp", 0) <= 0:
		_advance_turn()
		return

	actor["skill_discount_ready"] = _get_combatant_passive_effect_value(actor_id, "first_skill_discount") > 0
	_set_actor_data(actor_id, actor)

	turn_label.text = "Vez de: %s" % actor.get("name", actor_id.capitalize())
	if _process_turn_start_effects(actor_id):
		return

	battle_mode = "idle"
	pending_skill_id = ""
	turn_move_used = false
	turn_action_used = false
	action_buttons.visible = true
	_setup_skill_buttons(actor)
	_update_field_hint()
	_refresh_status()


func _begin_enemy_turn(enemy_actor_id: String) -> void:
	var enemy: Dictionary = _get_enemy_by_actor_id(enemy_actor_id)
	if enemy.is_empty() or enemy.get("hp", 0) <= 0:
		_advance_turn()
		return

	turn_label.text = "Vez de: %s" % enemy.get("name", "Inimigo")
	if _process_turn_start_effects(enemy_actor_id):
		return

	battle_mode = "idle"
	pending_skill_id = ""
	action_buttons.visible = true
	skill_buttons.visible = false
	field_hint_label.text = "O inimigo procura o melhor flanco."
	action_hint_label.text = "Aguardai a manobra inimiga. A ordem da ronda segue acima."
	_refresh_status()
	await get_tree().create_timer(0.4).timeout
	_enemy_turn(enemy_actor_id)


func _setup_skill_buttons(actor: Dictionary) -> void:
	for child in skill_buttons.get_children():
		child.queue_free()

	var has_skills: bool = false
	var actor_sp: int = int(actor.get("sp", 0))
	for raw_skill_id in actor.get("skills", []):
		var skill_id: String = str(raw_skill_id)
		var skill: Dictionary = GameState.skill_defs.get(skill_id, {})
		if skill.is_empty():
			continue

		has_skills = true
		var button: Button = Button.new()
		button.custom_minimum_size = Vector2(104.0, 34.0)
		var effective_cost: int = _get_skill_cost_for_actor(active_actor_id, skill_id)
		var listed_name: String = str(skill.get("name", skill_id))
		var status_effect: Dictionary = skill.get("status_effect", {})
		var status_icon: String = ""
		if not status_effect.is_empty():
			match str(status_effect.get("id", "")):
				"bleed":
					status_icon = " [B]"
				"stun":
					status_icon = " [S]"
		button.text = "%s [%d]%s" % [listed_name, effective_cost, status_icon]
		button.alignment = HORIZONTAL_ALIGNMENT_CENTER
		button.autowrap_mode = TextServer.AUTOWRAP_OFF
		_apply_hotbar_button_theme(button)
		_apply_rarity_hotbar_theme(button, str(skill.get("quality", "")))
		var tooltip_parts: Array[String] = []
		var description: String = str(skill.get("description", ""))
		if not description.is_empty():
			tooltip_parts.append(description)
		tooltip_parts.append("Custo %d" % effective_cost)
		if effective_cost < int(skill.get("cost", 0)):
			tooltip_parts.append("Brisa da Alvorada alivia o primeiro gasto")
		if int(skill.get("range", 1)) > 0:
			tooltip_parts.append("Alcance %d" % int(skill.get("range", 1)))
		if bool(skill.get("pierce_row", false)):
			tooltip_parts.append("Fere toda a fileira")
		if int(skill.get("area_radius", 0)) > 0:
			tooltip_parts.append("Area %d" % int(skill.get("area_radius", 0)))
		if not status_effect.is_empty():
			tooltip_parts.append("Causa %s" % _get_status_name(str(status_effect.get("id", ""))))
		if actor_sp < effective_cost:
			tooltip_parts.append("Espirito insuficiente")
			button.disabled = true
		elif int(skill.get("range", 1)) > 0 and not _has_enemy_in_range(active_actor_id, int(skill.get("range", 1))):
			tooltip_parts.append("Nenhum alvo ao alcance")
			button.disabled = true
		button.tooltip_text = " | ".join(tooltip_parts)
		button.pressed.connect(_on_skill_pressed.bind(skill_id))
		skill_buttons.add_child(button)

	skill_buttons.visible = has_skills


func _refresh_status() -> void:
	_sanitize_preview_target()
	_ensure_valid_target()
	player_label.text = _format_party_panel("pembah", player_data)
	_set_portrait(player_portrait, "pembah", "pembah", "Retrato de Pembah.")
	_apply_actor_frame_accent(player_portrait_frame, "pembah")
	_set_combatant_bar_pair(player_hp_bar, player_sp_bar, player_data)
	if companion_data.is_empty():
		companion_panel.visible = false
		party_rail_panel.custom_minimum_size.y = 78.0
		companion_label.text = "Sem companheiro\nNenhum aliado."
		_set_portrait(companion_portrait, "", "", "Sem companheiro.")
		_apply_actor_frame_accent(companion_portrait_frame, "")
		_clear_bar_pair(companion_hp_bar, companion_sp_bar)
	else:
		companion_panel.visible = true
		party_rail_panel.custom_minimum_size.y = 146.0
		companion_label.text = _format_party_panel("joao", companion_data)
		_set_portrait(companion_portrait, "joao", "joao", "Retrato de Joao.")
		_apply_actor_frame_accent(companion_portrait_frame, "joao")
		_set_combatant_bar_pair(companion_hp_bar, companion_sp_bar, companion_data)

	_refresh_enemy_statuses()
	_refresh_focus_panels()
	_refresh_action_buttons()
	_refresh_turn_header()
	_refresh_footer_visibility()
	_refresh_battle_grid()


func _sanitize_preview_target() -> void:
	if not _is_target_preview_mode():
		preview_target_actor_id = ""
		return
	if preview_target_actor_id.is_empty():
		return
	if not _is_actor_alive(preview_target_actor_id):
		preview_target_actor_id = ""


func _is_target_preview_mode() -> bool:
	return battle_mode == "attack_select" or battle_mode == "skill_select"


func _get_focus_target_actor_id() -> String:
	if _is_target_preview_mode() and not preview_target_actor_id.is_empty():
		return preview_target_actor_id
	return selected_target_id


func _refresh_enemy_statuses() -> void:
	for child in enemy_status_list.get_children():
		child.queue_free()

	var focus_target_actor_id: String = _get_focus_target_actor_id()
	var preview_target_ids: Array[String] = _get_preview_target_ids(focus_target_actor_id)
	for enemy in _ordered_enemies():
		enemy_status_list.add_child(_build_enemy_status_card(enemy, focus_target_actor_id, preview_target_ids))
	_sync_enemy_status_width()


func _build_enemy_status_card(enemy: Dictionary, focus_target_actor_id: String, preview_target_ids: Array[String]) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var is_dead: bool = enemy.get("hp", 0) <= 0
	if is_dead:
		# Collapsed row for defeated enemies
		var dead_style: StyleBoxFlat = _make_panel_style("enemy")
		dead_style.bg_color = Color(0.10, 0.09, 0.09, 0.72)
		dead_style.border_color = Color(0.28, 0.22, 0.22, 0.45)
		panel.add_theme_stylebox_override("panel", dead_style)

		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 8)
		panel.add_child(row)

		var x_label := Label.new()
		x_label.text = "✕"
		x_label.add_theme_font_size_override("font_size", 13)
		x_label.add_theme_color_override("font_color", Color("7a4040"))
		x_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		row.add_child(x_label)

		var name_label := Label.new()
		name_label.text = enemy.get("name", "Inimigo")
		name_label.add_theme_font_size_override("font_size", 13)
		name_label.add_theme_color_override("font_color", Color("5a4848"))
		name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(name_label)

		var fallen_label := Label.new()
		fallen_label.text = "Caido"
		fallen_label.add_theme_font_size_override("font_size", 11)
		fallen_label.add_theme_color_override("font_color", Color("6a3838"))
		fallen_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		row.add_child(fallen_label)

		return panel

	panel.add_theme_stylebox_override("panel", _make_panel_style("enemy"))

	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 4)
	panel.add_child(content)

	var cell: Vector2i = enemy.get("cell", Vector2i.ZERO)
	var enemy_actor_id: String = enemy.get("actor_id", "")
	var accent: Color = _get_actor_accent_color(enemy_actor_id)
	var prefix: String = ""
	if enemy_actor_id == focus_target_actor_id and _is_target_preview_mode():
		prefix = ">> "
	elif preview_target_ids.has(enemy_actor_id):
		prefix = "*> "

	content.add_child(_make_enemy_status_label("%s%s" % [prefix, enemy.get("name", "Inimigo")], 17, accent.lerp(Color("f6e0c0"), 0.45)))
	content.add_child(_make_enemy_status_label("PV %d/%d" % [
		enemy.get("hp", 0),
		enemy.get("max_hp", 0)
	], 15))
	content.add_child(_make_enemy_status_label("Casa %d,%d | %s" % [
		cell.x + 1,
		cell.y + 1,
		_get_terrain_name(cell)
	], 15))
	var badge_row := HFlowContainer.new()
	badge_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	badge_row.add_theme_constant_override("h_separation", 6)
	badge_row.add_theme_constant_override("v_separation", 4)
	var enemy_badges: Array[Dictionary] = _get_status_badges(enemy)
	if enemy_badges.is_empty():
		badge_row.add_child(_make_status_badge({
			"text": "Sem estado",
			"compact": "-",
			"color": Color(0.42, 0.45, 0.5, 1.0)
		}))
	else:
		for badge_data in enemy_badges:
			badge_row.add_child(_make_status_badge(badge_data))
	content.add_child(badge_row)

	var preview_line: String = _get_preview_line_for_target(focus_target_actor_id, enemy_actor_id)
	if not preview_line.is_empty():
		content.add_child(_make_enemy_status_label(preview_line, 14, Color("f2d796")))

	return panel


func _make_enemy_status_label(text: String, font_size: int = 16, font_color: Color = Color("f4ead4")) -> Label:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_apply_label_theme(label)
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", font_color)
	return label


func _sync_enemy_status_width() -> void:
	if not is_instance_valid(enemy_scroll) or not is_instance_valid(enemy_status_list):
		return

	var target_width: float = max(250.0, enemy_scroll.size.x - 10.0)
	enemy_status_list.custom_minimum_size.x = target_width
	enemy_status_list.size.x = target_width
	for child in enemy_status_list.get_children():
		if child is Control:
			var control := child as Control
			control.custom_minimum_size.x = target_width
			control.size_flags_horizontal = Control.SIZE_EXPAND_FILL


func _refresh_battle_grid() -> void:
	var focus_target_actor_id: String = _get_focus_target_actor_id()
	var preview_target_ids: Array[String] = _get_preview_target_ids(focus_target_actor_id)
	for child in battle_grid.get_children():
		child.queue_free()

	for row in range(GRID_ROWS):
		for col in range(GRID_COLS):
			var cell: Vector2i = Vector2i(col, row)
			var button: Button = Button.new()
			button.custom_minimum_size = Vector2(96.0, 96.0)
			button.focus_mode = Control.FOCUS_NONE
			button.flat = true
			button.clip_contents = false
			button.tooltip_text = _build_cell_tooltip(cell)
			var base_fill := Color(0.08, 0.09, 0.12, 0.68)
			var base_border := Color(0.22, 0.25, 0.31, 0.9)
			button.add_theme_stylebox_override("normal", _make_grid_cell_style(base_fill, base_border))
			button.add_theme_stylebox_override("hover", _make_grid_cell_style(base_fill.lightened(0.08), base_border.lightened(0.18)))
			button.add_theme_stylebox_override("pressed", _make_grid_cell_style(base_fill.darkened(0.08), base_border))
			button.add_theme_stylebox_override("disabled", _make_grid_cell_style(base_fill.darkened(0.16), base_border.darkened(0.2)))
			button.pressed.connect(_on_grid_cell_pressed.bind(cell))
			button.mouse_entered.connect(_on_grid_cell_hovered.bind(cell))
			button.mouse_exited.connect(_on_grid_cell_unhovered.bind(cell))
			_setup_grid_button_widgets(button)
			battle_grid.add_child(button)
			_apply_grid_button_state(button, cell, focus_target_actor_id, preview_target_ids)


func _get_button_scale_meta(button: Button, key: String, fallback: Vector2 = Vector2.ONE) -> Vector2:
	if button == null or not button.has_meta(key):
		return fallback
	var value: Variant = button.get_meta(key, fallback)
	if value is Vector2:
		return value
	return fallback


func _apply_actor_visual_tuning(button: Button, actor_id: String, unit_shadow: PanelContainer, token_frame: PanelContainer, unit_icon: TextureRect, unit_label: Label) -> void:
	var tuning: Dictionary = _get_actor_visual_tuning(actor_id)
	var icon_scale: float = float(tuning.get("icon_scale", 1.0))
	var frame_scale: float = float(tuning.get("frame_scale", 1.0))
	var shadow_scale: Vector2 = tuning.get("shadow_scale", Vector2.ONE)
	button.set_meta("icon_base_scale", Vector2(icon_scale, icon_scale))
	button.set_meta("frame_base_scale", Vector2(frame_scale, frame_scale))
	button.set_meta("shadow_base_scale", shadow_scale)
	button.set_meta("ghost_size", float(tuning.get("ghost_size", 68.0)))

	_set_control_pose_offsets(unit_shadow, 0.0, float(tuning.get("shadow_y", 0.0)))
	_set_control_pose_offsets(token_frame, 0.0, float(tuning.get("frame_y", 0.0)))
	_set_control_pose_offsets(unit_icon, 0.0, float(tuning.get("icon_y", 0.0)))
	_set_control_pose_offsets(unit_label, 0.0, float(tuning.get("label_y", 0.0)))


func _clear_actor_visual_tuning(button: Button, unit_shadow: PanelContainer, token_frame: PanelContainer, unit_icon: TextureRect, unit_label: Label) -> void:
	button.set_meta("icon_base_scale", Vector2.ONE)
	button.set_meta("frame_base_scale", Vector2.ONE)
	button.set_meta("shadow_base_scale", Vector2.ONE)
	button.set_meta("ghost_size", 68.0)
	_set_control_pose_offsets(unit_shadow, 0.0, 0.0)
	_set_control_pose_offsets(token_frame, 0.0, 0.0)
	_set_control_pose_offsets(unit_icon, 0.0, 0.0)
	_set_control_pose_offsets(unit_label, 0.0, 0.0)


func _apply_grid_button_state(button: Button, cell: Vector2i, focus_target_actor_id: String, preview_target_ids: Array[String]) -> void:
	var tint: Color = _get_base_cell_tint(cell)
	if _cell_is_valid_move(cell):
		tint = Color(0.34, 0.57, 0.43, 1.0)
	elif _cell_is_valid_target(cell):
		tint = Color(0.67, 0.36, 0.28, 1.0)

	var occupant_id: String = _actor_id_at_cell(cell)
	var terrain_marker: String = _get_terrain_marker(cell)
	var tile_art: TextureRect = button.get_node_or_null("TileArt") as TextureRect
	var terrain_label: Label = button.get_node_or_null("TerrainLabel") as Label
	var unit_shadow: PanelContainer = button.get_node_or_null("UnitShadow") as PanelContainer
	var token_frame: PanelContainer = button.get_node_or_null("TokenFrame") as PanelContainer
	var unit_icon: TextureRect = button.get_node_or_null("UnitIcon") as TextureRect
	var unit_label: Label = button.get_node_or_null("UnitLabel") as Label
	var unit_hp_bar: ProgressBar = button.get_node_or_null("UnitHpBar") as ProgressBar
	var unit_sp_bar: ProgressBar = button.get_node_or_null("UnitSpBar") as ProgressBar
	var status_badge_panel: PanelContainer = button.get_node_or_null("StatusBadgePanel") as PanelContainer
	var status_badge_label: Label = button.get_node_or_null("StatusBadgePanel/StatusBadgeLabel") as Label
	button.icon = null
	button.text = ""
	if not occupant_id.is_empty():
		if preview_target_ids.has(occupant_id) and _is_target_preview_mode():
			if occupant_id == focus_target_actor_id:
				tint = Color(0.82, 0.58, 0.23, 1.0)
			else:
				tint = Color(0.74, 0.45, 0.24, 1.0)
		elif occupant_id == selected_target_id:
			tint = Color(0.76, 0.66, 0.31, 1.0)

	if _is_ally_turn() and _get_actor_cell(active_actor_id) == cell:
		tint = Color(0.36, 0.51, 0.76, 1.0)

	button.tooltip_text = _build_cell_tooltip(cell)
	button.disabled = _is_cell_blocked(cell)
	button.modulate = Color.WHITE
	if tile_art != null:
		tile_art.modulate = tint
	if terrain_label != null:
		terrain_label.text = terrain_marker
		terrain_label.visible = not terrain_marker.is_empty()
		terrain_label.modulate = Color(0.18, 0.18, 0.2, 0.78)
	if unit_icon != null and unit_label != null:
		if occupant_id.is_empty():
			_clear_actor_visual_tuning(button, unit_shadow, token_frame, unit_icon, unit_label)
			if unit_shadow != null:
				unit_shadow.visible = false
			if token_frame != null:
				token_frame.visible = false
			unit_icon.visible = false
			unit_icon.texture = null
			unit_label.visible = false
			if status_badge_panel != null:
				status_badge_panel.visible = false
			_clear_bar_pair(unit_hp_bar, unit_sp_bar)
			_reset_battle_token_pose(button)
		else:
			if unit_shadow != null:
				unit_shadow.visible = true
			var occupant_data: Dictionary = _get_combatant_data(occupant_id)
			_apply_actor_visual_tuning(button, occupant_id, unit_shadow, token_frame, unit_icon, unit_label)
			if token_frame != null:
				token_frame.visible = true
				token_frame.add_theme_stylebox_override("panel", _make_token_frame_style(_get_actor_accent_color(occupant_id)))
			unit_icon.visible = true
			unit_icon.texture = _get_actor_icon(occupant_id)
			unit_icon.modulate = Color.WHITE
			unit_label.visible = true
			unit_label.text = _get_actor_grid_label(occupant_id)
			unit_label.add_theme_color_override("font_color", _get_actor_accent_color(occupant_id).lerp(Color.WHITE, 0.35))
			_set_combatant_bar_pair(unit_hp_bar, unit_sp_bar, occupant_data)
			if status_badge_panel != null and status_badge_label != null:
				var badges: Array[Dictionary] = _get_status_badges(occupant_data)
				if badges.is_empty():
					status_badge_panel.visible = false
				else:
					var primary_badge: Dictionary = badges[0]
					status_badge_panel.visible = true
					status_badge_panel.add_theme_stylebox_override("panel", _make_badge_style(Color(primary_badge.get("color", Color.WHITE)), true))
					status_badge_label.text = str(primary_badge.get("compact", ""))
			_reset_battle_token_pose(button)


func _refresh_grid_visuals() -> void:
	var focus_target_actor_id: String = _get_focus_target_actor_id()
	var preview_target_ids: Array[String] = _get_preview_target_ids(focus_target_actor_id)
	for row in range(GRID_ROWS):
		for col in range(GRID_COLS):
			var index: int = row * GRID_COLS + col
			if index >= battle_grid.get_child_count():
				return
			var button: Button = battle_grid.get_child(index) as Button
			if button == null:
				continue
			_apply_grid_button_state(button, Vector2i(col, row), focus_target_actor_id, preview_target_ids)


func _reset_battle_token_pose(button: Button) -> void:
	if button == null:
		return

	var unit_shadow: PanelContainer = button.get_node_or_null("UnitShadow") as PanelContainer
	var token_frame: PanelContainer = button.get_node_or_null("TokenFrame") as PanelContainer
	var unit_icon: TextureRect = button.get_node_or_null("UnitIcon") as TextureRect
	var unit_label: Label = button.get_node_or_null("UnitLabel") as Label

	_apply_control_offsets(unit_shadow, _get_control_offsets(unit_shadow))
	_apply_control_offsets(token_frame, _get_control_offsets(token_frame))
	_apply_control_offsets(unit_icon, _get_control_offsets(unit_icon))
	_apply_control_offsets(unit_label, _get_control_offsets(unit_label))

	var base_shadow_scale: Vector2 = _get_button_scale_meta(button, "shadow_base_scale", Vector2.ONE)
	var base_frame_scale: Vector2 = _get_button_scale_meta(button, "frame_base_scale", Vector2.ONE)
	var base_icon_scale: Vector2 = _get_button_scale_meta(button, "icon_base_scale", Vector2.ONE)

	if unit_shadow != null:
		unit_shadow.scale = base_shadow_scale
		unit_shadow.self_modulate = Color.WHITE
	if token_frame != null:
		token_frame.scale = base_frame_scale
		token_frame.rotation = 0.0
		token_frame.self_modulate = Color.WHITE
	if unit_icon != null:
		unit_icon.scale = base_icon_scale
		unit_icon.rotation = 0.0
		unit_icon.self_modulate = Color.WHITE
	if unit_label != null:
		unit_label.self_modulate = Color.WHITE


func _update_battle_idle_loop() -> void:
	if battle_grid == null or battle_grid.get_child_count() == 0:
		return

	var now_seconds: float = Time.get_ticks_msec() * 0.001
	for index in range(battle_grid.get_child_count()):
		var button: Button = battle_grid.get_child(index) as Button
		if button == null:
			continue
		var cell := Vector2i(index % GRID_COLS, index / GRID_COLS)
		var actor_id: String = _actor_id_at_cell(cell)
		if actor_id.is_empty():
			_reset_battle_token_pose(button)
			continue

		var unit_icon: TextureRect = button.get_node_or_null("UnitIcon") as TextureRect
		if unit_icon == null or not unit_icon.visible or unit_icon.texture == null:
			_reset_battle_token_pose(button)
			continue

		if float(button.get_meta("idle_lock_until", 0.0)) > now_seconds:
			continue

		_apply_battle_idle_pose(button, actor_id, index)


func _apply_battle_idle_pose(button: Button, actor_id: String, token_index: int) -> void:
	var unit_shadow: PanelContainer = button.get_node_or_null("UnitShadow") as PanelContainer
	var token_frame: PanelContainer = button.get_node_or_null("TokenFrame") as PanelContainer
	var unit_icon: TextureRect = button.get_node_or_null("UnitIcon") as TextureRect
	var unit_label: Label = button.get_node_or_null("UnitLabel") as Label
	if unit_icon == null:
		return

	var is_active: bool = actor_id == active_actor_id and not battle_over
	var active_gain: float = 1.0 if is_active else 0.0
	var phase: float = battle_idle_time * (2.6 + active_gain * 0.5) + float(token_index) * 0.42
	var bob: float = sin(phase) * (0.85 + active_gain * 0.55)
	var breath: float = sin(phase * 1.7)
	var sway: float = sin(phase * 0.8) * (0.028 + active_gain * 0.012)
	var frame_shift: float = bob * 0.45
	var base_shadow_scale: Vector2 = _get_button_scale_meta(button, "shadow_base_scale", Vector2.ONE)
	var base_frame_scale: Vector2 = _get_button_scale_meta(button, "frame_base_scale", Vector2.ONE)
	var base_icon_scale: Vector2 = _get_button_scale_meta(button, "icon_base_scale", Vector2.ONE)

	_apply_control_offsets(unit_shadow, _get_control_offsets(unit_shadow))
	_apply_control_offsets(token_frame, _get_control_offsets(token_frame), frame_shift)
	_apply_control_offsets(unit_icon, _get_control_offsets(unit_icon), bob)
	_apply_control_offsets(unit_label, _get_control_offsets(unit_label), bob * 0.24)

	if unit_shadow != null:
		unit_shadow.scale = Vector2(
			base_shadow_scale.x * (1.0 - (bob * 0.02)),
			base_shadow_scale.y * (1.0 + (active_gain * 0.03))
		)
		unit_shadow.self_modulate = Color(1.0, 1.0, 1.0, 0.72 - (bob * 0.06))
	if token_frame != null:
		token_frame.scale = base_frame_scale * (1.0 + (active_gain * 0.015) + (absf(breath) * 0.012))
		token_frame.rotation = sway * 0.55
	if unit_icon != null:
		unit_icon.scale = Vector2(
			base_icon_scale.x * (1.0 + (breath * (0.026 + active_gain * 0.012))),
			base_icon_scale.y * (1.0 - (breath * (0.018 + active_gain * 0.008)))
		)
		unit_icon.rotation = sway
		unit_icon.self_modulate = Color(1.0, 1.0, 1.0, 0.97 + (active_gain * 0.03))
	if unit_label != null:
		unit_label.self_modulate = Color(1.0, 1.0, 1.0, 0.86 + (active_gain * 0.12))


func _format_party_panel(actor_id: String, actor: Dictionary) -> String:
	var title: String = actor.get("name", "Aliado")
	if actor_id == active_actor_id:
		title += "  [Vez]"
	var status_text: String = _format_statuses(actor)
	var status_suffix: String = ""
	if status_text != "nenhum":
		status_suffix = " | %s" % status_text
	if actor.get("defending", false) and actor.get("hp", 0) > 0:
		status_suffix += " | Guarda"
	return "%s\nPV %d/%d  ESP %d/%d%s" % [
		title,
		actor.get("hp", 0),
		actor.get("max_hp", 0),
		actor.get("sp", 0),
		actor.get("max_sp", 0),
		status_suffix
	]


func _format_actor_panel(actor: Dictionary) -> String:
	if actor.get("hp", 0) <= 0:
		return "%s\nCaido em batalha." % actor.get("name", "Aliado")

	var cell: Vector2i = actor.get("cell", Vector2i.ZERO)
	var water_stride_text: String = " | Passo de agua" if actor.get("water_stride", false) else ""
	var panel_text: String = "%s\nSaude %d/%d\nEspirito %d/%d\nATQ %d  DEF %d  VEL %d\nCasa %d,%d\nTerreno %s%s" % [
		actor.get("name", "Aliado"),
		actor.get("hp", 0),
		actor.get("max_hp", 0),
		actor.get("sp", 0),
		actor.get("max_sp", 0),
		actor.get("atk", 0),
		actor.get("def", 0),
		actor.get("spd", 0),
		cell.x + 1,
		cell.y + 1,
		_get_terrain_name(cell),
		water_stride_text
	]
	panel_text += "\nEstados %s" % _format_statuses(actor)
	return panel_text


func _write_log(message: String) -> void:
	combat_log_lines.append(message)
	# Keep full history for any future "expand" feature, but display only the last 4 lines
	# so the newest entry is always readable without scrolling.
	if combat_log_lines.size() > 60:
		combat_log_lines = combat_log_lines.slice(combat_log_lines.size() - 60, combat_log_lines.size())

	var display_lines: Array[String] = combat_log_lines.slice(
		max(0, combat_log_lines.size() - 4),
		combat_log_lines.size()
	)
	combat_log.text = "\n".join(display_lines)
	combat_log.scroll_to_line(combat_log.get_line_count())


func _get_actor_visual_profile(actor_id: String) -> String:
	if actor_id == "pembah":
		return "pembah"
	if actor_id == "joao":
		return "joao"

	var enemy: Dictionary = _get_enemy_by_actor_id(actor_id)
	match enemy.get("id", ""):
		"castilian_duelist":
			return "castilian"
		"mourish_guard", "atalaiador_zenete":
			return "mourish"
		"bombardeiro_renegado", "renegado_da_aduana":
			return "bombardeiro"
		"corsair_raider", "corsario_barbaresco":
			return "corsair"
		_:
			return "bandit"


func _get_actor_visual_tuning(actor_id: String) -> Dictionary:
	var profile: String = _get_actor_visual_profile(actor_id)
	match profile:
		"pembah":
			return {
				"icon_scale": 1.08,
				"frame_scale": 1.03,
				"shadow_scale": Vector2(1.18, 1.0),
				"icon_y": 10.0,
				"frame_y": 8.0,
				"shadow_y": 6.0,
				"label_y": 8.0,
				"ghost_size": 76.0
			}
		"joao":
			return {
				"icon_scale": 1.05,
				"frame_scale": 1.02,
				"shadow_scale": Vector2(1.12, 1.0),
				"icon_y": 8.0,
				"frame_y": 7.0,
				"shadow_y": 5.0,
				"label_y": 7.0,
				"ghost_size": 74.0
			}
		"bandit":
			return {
				"icon_scale": 1.03,
				"frame_scale": 1.01,
				"shadow_scale": Vector2(1.24, 1.0),
				"icon_y": 12.0,
				"frame_y": 10.0,
				"shadow_y": 7.0,
				"label_y": 9.0,
				"ghost_size": 78.0
			}
		"castilian":
			return {
				"icon_scale": 1.01,
				"frame_scale": 1.0,
				"shadow_scale": Vector2(1.18, 1.0),
				"icon_y": 9.0,
				"frame_y": 8.0,
				"shadow_y": 6.0,
				"label_y": 8.0,
				"ghost_size": 74.0
			}
		"mourish":
			return {
				"icon_scale": 1.02,
				"frame_scale": 1.0,
				"shadow_scale": Vector2(1.16, 1.0),
				"icon_y": 10.0,
				"frame_y": 8.0,
				"shadow_y": 6.0,
				"label_y": 8.0,
				"ghost_size": 74.0
			}
		"corsair":
			return {
				"icon_scale": 1.0,
				"frame_scale": 1.0,
				"shadow_scale": Vector2(1.18, 1.0),
				"icon_y": 9.0,
				"frame_y": 8.0,
				"shadow_y": 6.0,
				"label_y": 8.0,
				"ghost_size": 74.0
			}
		"bombardeiro":
			return {
				"icon_scale": 1.0,
				"frame_scale": 1.0,
				"shadow_scale": Vector2(1.2, 1.0),
				"icon_y": 10.0,
				"frame_y": 8.0,
				"shadow_y": 6.0,
				"label_y": 8.0,
				"ghost_size": 74.0
			}
		_:
			return {
				"icon_scale": 1.0,
				"frame_scale": 1.0,
				"shadow_scale": Vector2.ONE,
				"icon_y": 0.0,
				"frame_y": 0.0,
				"shadow_y": 0.0,
				"label_y": 0.0,
				"ghost_size": 68.0
			}


func _get_profile_icon_candidates(profile: String) -> Array[String]:
	match profile:
		"pembah":
			return PEMBAH_ICON_CANDIDATES
		"joao":
			return JOAO_ICON_CANDIDATES
		"castilian":
			return CASTILIAN_ICON_CANDIDATES
		"mourish":
			return MOURISH_ICON_CANDIDATES
		"bombardeiro":
			return BOMBARDEIRO_ICON_CANDIDATES
		"corsair":
			return CORSAIR_ICON_CANDIDATES
		_:
			return BANDIT_ICON_CANDIDATES


func _get_profile_portrait_candidates(profile: String) -> Array[String]:
	match profile:
		"pembah":
			return PEMBAH_PORTRAIT_CANDIDATES
		"joao":
			return JOAO_PORTRAIT_CANDIDATES
		"castilian":
			return CASTILIAN_PORTRAIT_CANDIDATES
		"mourish":
			return MOURISH_PORTRAIT_CANDIDATES
		"bombardeiro":
			return BOMBARDEIRO_PORTRAIT_CANDIDATES
		"corsair":
			return CORSAIR_PORTRAIT_CANDIDATES
		_:
			return BANDIT_PORTRAIT_CANDIDATES


func _get_profile_icon_fallback(profile: String) -> Texture2D:
	match profile:
		"pembah":
			return PEMBAH_ICON
		"joao":
			return JOAO_ICON
		"castilian":
			return CASTILIAN_ICON
		"mourish":
			return MOURISH_ICON
		"bombardeiro":
			return BOMBARDEIRO_ICON
		"corsair":
			return CORSAIR_ICON
		_:
			return BANDIT_ICON


func _get_profile_portrait_fallback(profile: String) -> Texture2D:
	match profile:
		"pembah":
			return PEMBAH_PORTRAIT
		"joao":
			return JOAO_PORTRAIT
		"castilian":
			return CASTILIAN_PORTRAIT
		"mourish":
			return MOURISH_PORTRAIT
		"bombardeiro":
			return BOMBARDEIRO_PORTRAIT
		"corsair":
			return CORSAIR_PORTRAIT
		_:
			return BANDIT_PORTRAIT


func _load_texture_with_fallback(cache_key: String, candidates: Array[String], fallback: Texture2D) -> Texture2D:
	if texture_cache.has(cache_key):
		var cached: Texture2D = texture_cache[cache_key]
		if cached != null:
			return cached

	for path in candidates:
		if not ResourceLoader.exists(path):
			continue
		var resource: Resource = load(path)
		if resource is Texture2D:
			var texture: Texture2D = resource
			texture_cache[cache_key] = texture
			return texture

	texture_cache[cache_key] = fallback
	return fallback


func _get_actor_portrait(actor_id: String) -> Texture2D:
	var profile: String = _get_actor_visual_profile(actor_id)
	return _load_texture_with_fallback(
		"portrait:%s" % profile,
		_get_profile_portrait_candidates(profile),
		_get_profile_portrait_fallback(profile)
	)


func _get_actor_accent_color(actor_id: String) -> Color:
	if actor_id == "pembah":
		return Color(0.33, 0.61, 0.79, 1.0)
	if actor_id == "joao":
		return Color(0.29, 0.69, 0.55, 1.0)

	var enemy: Dictionary = _get_enemy_by_actor_id(actor_id)
	match enemy.get("id", ""):
		"castilian_duelist":
			return Color(0.75, 0.44, 0.3, 1.0)
		"mourish_guard":
			return Color(0.39, 0.69, 0.57, 1.0)
		"bombardeiro_renegado":
			return Color(0.82, 0.48, 0.18, 1.0)
		"corsair_raider":
			return Color(0.54, 0.44, 0.76, 1.0)
		"corsario_barbaresco":
			return Color(0.71, 0.44, 0.24, 1.0)
		"atalaiador_zenete":
			return Color(0.36, 0.63, 0.48, 1.0)
		"renegado_da_aduana":
			return Color(0.83, 0.38, 0.19, 1.0)
		_:
			return Color(0.71, 0.38, 0.33, 1.0)


func _set_portrait(texture_rect: TextureRect, actor_id: String, displayed_actor_id: String, empty_hint: String) -> String:
	if actor_id.is_empty():
		texture_rect.texture = null
		texture_rect.tooltip_text = empty_hint
		texture_rect.modulate = Color(0.46, 0.48, 0.52, 0.68)
		return ""

	texture_rect.texture = _get_actor_portrait(actor_id)
	texture_rect.tooltip_text = _get_combatant_name(actor_id)
	texture_rect.modulate = Color.WHITE
	if displayed_actor_id != actor_id:
		_animate_portrait_focus(texture_rect)
	return actor_id


func _animate_portrait_focus(texture_rect: TextureRect) -> void:
	texture_rect.scale = Vector2(0.88, 0.88)
	texture_rect.self_modulate = Color(1.0, 1.0, 1.0, 0.84)
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(texture_rect, "scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(texture_rect, "self_modulate", Color.WHITE, 0.22).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _refresh_focus_panels() -> void:
	var actor: Dictionary = _get_combatant_data(active_actor_id)
	if actor.is_empty():
		current_actor_label.text = "A ronda ainda nao escolheu actor."
		displayed_current_portrait_actor_id = _set_portrait(current_actor_portrait, "", displayed_current_portrait_actor_id, "Nenhum actor activo.")
		_apply_actor_frame_accent(current_actor_portrait_frame, "")
		_clear_bar_pair(current_actor_hp_bar, current_actor_sp_bar)
	else:
		var action_state: String = "Pode mover e agir."
		if not _is_ally_turn():
			action_state = "Actua por conta propria."
		elif turn_action_used:
			action_state = "Ja cumpriu a accao desta vez."
		elif turn_move_used:
			action_state = "Ja moveu; falta a accao."
		current_actor_label.text = "%s\nPV %d/%d | ESP %d/%d\n%s" % [
			actor.get("name", "Combatente"),
			actor.get("hp", 0),
			actor.get("max_hp", 0),
			actor.get("sp", 0),
			actor.get("max_sp", 0),
			"%s | %s" % [action_state, _format_statuses(actor)]
		]
		displayed_current_portrait_actor_id = _set_portrait(current_actor_portrait, active_actor_id, displayed_current_portrait_actor_id, "Nenhum actor activo.")
		_apply_actor_frame_accent(current_actor_portrait_frame, active_actor_id)
		_set_combatant_bar_pair(current_actor_hp_bar, current_actor_sp_bar, actor)

	var focus_target_actor_id: String = _get_focus_target_actor_id()
	var target: Dictionary = _get_enemy_by_actor_id(focus_target_actor_id)
	if target.is_empty():
		target_label.text = "Nenhum inimigo marcado."
		displayed_target_portrait_actor_id = _set_portrait(target_portrait, "", displayed_target_portrait_actor_id, "Nenhum alvo marcado.")
		_apply_actor_frame_accent(target_portrait_frame, "")
		_clear_bar_pair(target_hp_bar, target_sp_bar)
	else:
		var target_cell: Vector2i = target.get("cell", Vector2i.ZERO)
		var target_text: String = "%s\nPV %d/%d\nCasa %d,%d | %s" % [
			target.get("name", "Inimigo"),
			target.get("hp", 0),
			target.get("max_hp", 0),
			target_cell.x + 1,
			target_cell.y + 1,
			"%s | %s" % [_get_terrain_name(target_cell), _format_statuses(target)]
		]
		var preview_summary: String = _build_preview_summary(target.get("actor_id", ""))
		if not preview_summary.is_empty():
			target_text += "\n" + preview_summary
		target_label.text = target_text
		displayed_target_portrait_actor_id = _set_portrait(target_portrait, focus_target_actor_id, displayed_target_portrait_actor_id, "Nenhum alvo marcado.")
		_apply_actor_frame_accent(target_portrait_frame, focus_target_actor_id)
		_set_combatant_bar_pair(target_hp_bar, target_sp_bar, target)


func _refresh_turn_header() -> void:
	round_label.text = "Ronda %d" % max(1, round_count)

	_rebuild_initiative_chips()
	_refresh_party_rail_active_state()


func _rebuild_initiative_chips() -> void:
	if not is_instance_valid(initiative_chips_row):
		return
	for child in initiative_chips_row.get_children():
		child.queue_free()

	# Build full ordered list: active first, then remaining queue
	var all_ids: Array[String] = []
	if not active_actor_id.is_empty():
		all_ids.append(active_actor_id)
	for queued_id in turn_queue:
		all_ids.append(queued_id)

	var shown: int = 0
	for actor_id in all_ids:
		if shown >= 8:
			var overflow_label: Label = Label.new()
			overflow_label.text = "…"
			overflow_label.add_theme_font_size_override("font_size", 14)
			overflow_label.add_theme_color_override("font_color", Color("a08848"))
			overflow_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			initiative_chips_row.add_child(overflow_label)
			break

		var chip: PanelContainer = _make_initiative_chip(actor_id, actor_id == active_actor_id)
		initiative_chips_row.add_child(chip)

		if shown < all_ids.size() - 1 and shown < 7:
			var arrow: Label = Label.new()
			arrow.text = "›"
			arrow.add_theme_font_size_override("font_size", 14)
			arrow.add_theme_color_override("font_color", Color("6a5830"))
			arrow.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			initiative_chips_row.add_child(arrow)
		shown += 1


func _make_initiative_chip(actor_id: String, is_active: bool) -> PanelContainer:
	var is_ally: bool = not actor_id.begins_with("enemy_")
	var is_dead: bool = not _is_actor_alive(actor_id)
	var accent: Color = _get_actor_accent_color(actor_id)

	var style := StyleBoxFlat.new()
	style.corner_radius_top_left = 20
	style.corner_radius_top_right = 20
	style.corner_radius_bottom_right = 20
	style.corner_radius_bottom_left = 20
	style.content_margin_left = 8
	style.content_margin_top = 3
	style.content_margin_right = 8
	style.content_margin_bottom = 3

	if is_dead:
		style.bg_color = Color(0.12, 0.12, 0.13, 0.7)
		style.border_color = Color(0.28, 0.28, 0.3, 0.5)
		style.border_width_left = 1
		style.border_width_top = 1
		style.border_width_right = 1
		style.border_width_bottom = 1
	elif is_active:
		style.bg_color = Color(accent.r * 0.4, accent.g * 0.4, accent.b * 0.4, 0.98)
		style.border_color = Color(0.94, 0.78, 0.3, 0.95)
		style.border_width_left = 2
		style.border_width_top = 2
		style.border_width_right = 2
		style.border_width_bottom = 2
		style.shadow_color = Color(0.94, 0.78, 0.3, 0.4)
		style.shadow_size = 6
	else:
		style.bg_color = Color(accent.r * 0.22, accent.g * 0.22, accent.b * 0.22, 0.88)
		style.border_color = accent.lerp(Color.BLACK, 0.18)
		style.border_width_left = 1
		style.border_width_top = 1
		style.border_width_right = 1
		style.border_width_bottom = 1

	var chip := PanelContainer.new()
	chip.add_theme_stylebox_override("panel", style)
	chip.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 4)
	chip.add_child(row)

	# Dot indicator
	var dot := ColorRect.new()
	dot.custom_minimum_size = Vector2(7, 7)
	dot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if is_dead:
		dot.color = Color(0.4, 0.4, 0.42, 0.6)
	elif is_ally:
		dot.color = accent.lerp(Color.WHITE, 0.3)
	else:
		dot.color = accent.lerp(Color.WHITE, 0.3)
	var dot_style := StyleBoxFlat.new()
	dot_style.corner_radius_top_left = 4
	dot_style.corner_radius_top_right = 4
	dot_style.corner_radius_bottom_right = 4
	dot_style.corner_radius_bottom_left = 4
	dot.add_theme_stylebox_override("panel", dot_style)
	row.add_child(dot)

	var name_label := Label.new()
	var short_name: String = _get_combatant_name(actor_id)
	if short_name.length() > 8:
		short_name = short_name.left(7) + "."
	if is_dead:
		name_label.text = "✕ " + short_name
	else:
		name_label.text = short_name
	name_label.add_theme_font_size_override("font_size", 13)
	var text_color: Color
	if is_dead:
		text_color = Color("666060")
	elif is_active:
		text_color = Color("f6e18a")
	else:
		text_color = accent.lerp(Color.WHITE, 0.55)
	name_label.add_theme_color_override("font_color", text_color)
	name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	row.add_child(name_label)

	# Animate pulse for active chip
	if is_active and not battle_over:
		var pulse_tween: Tween = create_tween().set_loops()
		pulse_tween.tween_property(chip, "modulate:a", 0.82, 0.55).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		pulse_tween.tween_property(chip, "modulate:a", 1.0, 0.55).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		chip.tree_exited.connect(pulse_tween.kill)

	return chip


func _refresh_party_rail_active_state() -> void:
	# Player
	var player_is_active: bool = active_actor_id == "pembah" and _is_ally_turn() and not battle_over
	_apply_rail_active_highlight(
		player_portrait_frame,
		player_active_border,
		player_ap_row,
		player_move_pip,
		player_action_pip,
		player_is_active
	)

	# Companion
	var companion_is_active: bool = active_actor_id == "joao" and _is_ally_turn() and not battle_over
	_apply_rail_active_highlight(
		companion_portrait_frame,
		companion_active_border,
		companion_ap_row,
		companion_move_pip,
		companion_action_pip,
		companion_is_active
	)


func _apply_rail_active_highlight(
	portrait_frame: PanelContainer,
	active_border: ColorRect,
	ap_row: HBoxContainer,
	move_pip: ColorRect,
	action_pip: ColorRect,
	is_active: bool
) -> void:
	if not is_instance_valid(portrait_frame) or not is_instance_valid(active_border):
		return

	if is_active:
		active_border.visible = true
		active_border.color = Color(0.94, 0.78, 0.3, 0.18)
		# Pulse the border
		if not active_border.has_meta("pulsing"):
			active_border.set_meta("pulsing", true)
			var t: Tween = create_tween().set_loops()
			t.tween_property(active_border, "color:a", 0.32, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			t.tween_property(active_border, "color:a", 0.10, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			active_border.set_meta("pulse_tween", t)

		# AP pips
		if is_instance_valid(ap_row):
			ap_row.visible = true
		if is_instance_valid(move_pip):
			move_pip.color = Color(0.22, 0.22, 0.25, 0.55) if turn_move_used else Color(0.42, 0.74, 0.94, 1.0)
			move_pip.tooltip_text = "Movimento: usado" if turn_move_used else "Movimento: livre"
		if is_instance_valid(action_pip):
			action_pip.color = Color(0.22, 0.22, 0.25, 0.55) if turn_action_used else Color(0.94, 0.67, 0.28, 1.0)
			action_pip.tooltip_text = "Ação: usada" if turn_action_used else "Ação: livre"

		# Gold border on portrait frame
		var gold_style: StyleBoxFlat = _make_accent_frame_style(Color(0.94, 0.78, 0.3, 1.0))
		portrait_frame.add_theme_stylebox_override("panel", gold_style)
	else:
		if is_instance_valid(active_border):
			active_border.visible = false
			if active_border.has_meta("pulse_tween"):
				var old_tween: Tween = active_border.get_meta("pulse_tween") as Tween
				if old_tween != null:
					old_tween.kill()
				active_border.remove_meta("pulse_tween")
			if active_border.has_meta("pulsing"):
				active_border.remove_meta("pulsing")
		if is_instance_valid(ap_row):
			ap_row.visible = false
		# Restore default portrait frame style
		portrait_frame.add_theme_stylebox_override("panel", _make_panel_style("focus"))


func _refresh_footer_visibility() -> void:
	var show_result: bool = battle_over or continue_button.visible or not result_label.text.strip_edges().is_empty()
	result_row.visible = show_result
	if show_result:
		bottom_panel.custom_minimum_size.y = 118.0
	else:
		bottom_panel.custom_minimum_size.y = 86.0


func _build_preview_summary(primary_target_actor_id: String) -> String:
	var preview_entries: Array[Dictionary] = _build_preview_entries(primary_target_actor_id)
	if preview_entries.is_empty():
		return ""

	if battle_mode == "attack_select":
		return str(preview_entries[0].get("line", ""))

	var skill: Dictionary = GameState.skill_defs.get(pending_skill_id, {})
	var lines: Array[String] = ["Previsto para %s:" % skill.get("name", pending_skill_id)]
	for preview_entry in preview_entries:
		lines.append("- %s" % str(preview_entry.get("line", "")))
	return "\n".join(lines)


func _build_preview_entries(primary_target_actor_id: String) -> Array[Dictionary]:
	var preview_entries: Array[Dictionary] = []
	if not _is_target_preview_mode() or primary_target_actor_id.is_empty():
		return preview_entries

	var actor: Dictionary = _get_actor_data(active_actor_id)
	var primary_target: Dictionary = _get_enemy_by_actor_id(primary_target_actor_id)
	if actor.is_empty() or primary_target.is_empty():
		return preview_entries

	if battle_mode == "attack_select":
		var predicted_damage: int = _calculate_damage(
			actor,
			primary_target,
			6,
			_get_actor_cell(active_actor_id),
			primary_target.get("cell", Vector2i.ZERO),
			active_actor_id,
			primary_target_actor_id
		)
		var result_note: String = " | Caira" if predicted_damage >= int(primary_target.get("hp", 0)) else ""
		preview_entries.append({
			"target_id": primary_target_actor_id,
			"line": "Previsto: %d dano%s" % [predicted_damage, result_note]
		})
		return preview_entries

	if battle_mode == "skill_select":
		var skill: Dictionary = GameState.skill_defs.get(pending_skill_id, {})
		if skill.is_empty():
			return preview_entries
		var target_ids: Array[String] = _get_skill_target_ids(skill, primary_target_actor_id)
		for target_id in target_ids:
			var target: Dictionary = _get_enemy_by_actor_id(target_id)
			if target.is_empty() or target.get("hp", 0) <= 0:
				continue
			var predicted_damage: int = _calculate_damage(
				actor,
				target,
				int(skill.get("power", 0)),
				_get_actor_cell(active_actor_id),
				target.get("cell", Vector2i.ZERO),
				active_actor_id,
				target_id
			)
			var status_note: String = ""
			var status_effect: Dictionary = skill.get("status_effect", {})
			if not status_effect.is_empty():
				var status_name: String = _preview_status_name(target_id, status_effect)
				if not status_name.is_empty():
					status_note = " | %s" % status_name
			var result_note: String = " | Caira" if predicted_damage >= int(target.get("hp", 0)) else ""
			preview_entries.append({
				"target_id": target_id,
				"line": "%s: %d dano%s%s" % [target.get("name", "Inimigo"), predicted_damage, status_note, result_note]
			})
		return preview_entries

	return preview_entries


func _get_preview_target_ids(primary_target_actor_id: String = "") -> Array[String]:
	var resolved_target_actor_id: String = primary_target_actor_id if not primary_target_actor_id.is_empty() else _get_focus_target_actor_id()
	var preview_target_ids: Array[String] = []
	for preview_entry in _build_preview_entries(resolved_target_actor_id):
		var target_id: String = str(preview_entry.get("target_id", ""))
		if not target_id.is_empty():
			preview_target_ids.append(target_id)
	return preview_target_ids


func _get_preview_line_for_target(primary_target_actor_id: String, target_actor_id: String) -> String:
	for preview_entry in _build_preview_entries(primary_target_actor_id):
		if str(preview_entry.get("target_id", "")) == target_actor_id:
			return str(preview_entry.get("line", ""))
	return ""


func _get_grid_button(cell: Vector2i) -> Button:
	if not _cell_in_bounds(cell):
		return null
	var index: int = cell.y * GRID_COLS + cell.x
	if index < 0 or index >= battle_grid.get_child_count():
		return null
	return battle_grid.get_child(index) as Button


func _get_cell_effect_position(cell: Vector2i) -> Vector2:
	var button: Button = _get_grid_button(cell)
	if button == null:
		return effects_layer.size * 0.5
	return button.global_position + button.size * 0.5 - effects_layer.global_position


func _get_actor_unit_icon(actor_id: String) -> TextureRect:
	var button: Button = _get_grid_button(_get_actor_cell(actor_id))
	if button == null:
		return null
	return button.get_node_or_null("UnitIcon") as TextureRect


func _lock_battle_token_pose(actor_id: String, duration: float) -> Button:
	var button: Button = _get_grid_button(_get_actor_cell(actor_id))
	if button == null:
		return null
	button.set_meta("idle_lock_until", (Time.get_ticks_msec() * 0.001) + duration)
	return button


func _animate_actor_action(actor_id: String, mode: String, accent_color: Color = Color.WHITE) -> void:
	var unit_icon: TextureRect = _get_actor_unit_icon(actor_id)
	if unit_icon == null or not is_instance_valid(unit_icon):
		return

	var button: Button = _lock_battle_token_pose(actor_id, 0.34)
	if button != null:
		_reset_battle_token_pose(button)
	unit_icon.pivot_offset = unit_icon.size * 0.5
	var base_icon_scale: Vector2 = _get_button_scale_meta(button, "icon_base_scale", Vector2.ONE)
	var tween: Tween = create_tween()
	match mode:
		"attack":
			var push_x: float = 8.0 if _is_ally_turn() else -8.0
			tween.tween_property(unit_icon, "position:x", unit_icon.position.x + push_x, 0.08).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.tween_property(unit_icon, "position:x", unit_icon.position.x, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
			tween.parallel().tween_property(unit_icon, "scale", Vector2(base_icon_scale.x * 1.1, base_icon_scale.y * 0.94), 0.08).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			tween.parallel().tween_property(unit_icon, "scale", base_icon_scale, 0.1).set_delay(0.08).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		"hit":
			unit_icon.self_modulate = Color(accent_color.r, accent_color.g, accent_color.b, 0.88)
			tween.tween_property(unit_icon, "rotation_degrees", -7.0, 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.tween_property(unit_icon, "rotation_degrees", 5.0, 0.06).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(unit_icon, "rotation_degrees", 0.0, 0.06).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.parallel().tween_property(unit_icon, "self_modulate", Color.WHITE, 0.22).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		"potion":
			unit_icon.self_modulate = Color(0.58, 0.95, 0.7, 1.0)
			tween.tween_property(unit_icon, "scale", Vector2(base_icon_scale.x * 0.93, base_icon_scale.y * 1.08), 0.08).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			tween.tween_property(unit_icon, "scale", Vector2(base_icon_scale.x * 1.07, base_icon_scale.y * 0.94), 0.08).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(unit_icon, "scale", base_icon_scale, 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			tween.parallel().tween_property(unit_icon, "self_modulate", Color.WHITE, 0.26).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		"guard":
			unit_icon.self_modulate = Color(0.58, 0.74, 0.98, 0.92)
			tween.tween_property(unit_icon, "scale", Vector2(base_icon_scale.x * 1.13, base_icon_scale.y * 1.13), 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			tween.tween_property(unit_icon, "scale", base_icon_scale, 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
			tween.parallel().tween_property(unit_icon, "self_modulate", Color.WHITE, 0.26).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		"cast":
			unit_icon.self_modulate = Color(accent_color.r, accent_color.g, accent_color.b, 0.9)
			tween.tween_property(unit_icon, "scale", Vector2(base_icon_scale.x * 1.08, base_icon_scale.y * 1.08), 0.09).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.tween_property(unit_icon, "scale", base_icon_scale, 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
			tween.parallel().tween_property(unit_icon, "self_modulate", Color.WHITE, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		_:
			tween.tween_property(unit_icon, "scale", Vector2(base_icon_scale.x * 1.05, base_icon_scale.y * 1.05), 0.08).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.tween_property(unit_icon, "scale", base_icon_scale, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.finished.connect(_on_actor_action_tween_finished.bind(actor_id))


func _on_actor_action_tween_finished(actor_id: String) -> void:
	var button: Button = _get_grid_button(_get_actor_cell(actor_id))
	if button == null or not is_instance_valid(button):
		return
	_reset_battle_token_pose(button)


func _animate_actor_move(actor_id: String, from_cell: Vector2i, to_cell: Vector2i) -> void:
	if from_cell == to_cell:
		return

	var start_position: Vector2 = _get_cell_effect_position(from_cell)
	var end_position: Vector2 = _get_cell_effect_position(to_cell)
	var ghost: TextureRect = TextureRect.new()
	ghost.texture = _get_actor_icon(actor_id)
	ghost.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ghost.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ghost.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ghost.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var tuning: Dictionary = _get_actor_visual_tuning(actor_id)
	var ghost_size: float = float(tuning.get("ghost_size", 68.0))
	ghost.custom_minimum_size = Vector2(ghost_size, ghost_size)
	ghost.size = Vector2(ghost_size, ghost_size)
	ghost.pivot_offset = ghost.size * 0.5
	ghost.position = start_position - ghost.size * 0.5
	ghost.modulate = Color(1.0, 1.0, 1.0, 0.9)
	effects_layer.add_child(ghost)

	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(ghost, "position", end_position - ghost.size * 0.5, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(ghost, "scale", Vector2(1.08, 0.92), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(ghost, "modulate:a", 0.24, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.chain().tween_property(ghost, "scale", Vector2.ONE, 0.06).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.finished
	ghost.queue_free()


func _show_floating_text(actor_id: String, text: String, color: Color, vertical_offset: float = 0.0) -> void:
	if text.is_empty():
		return

	var label: Label = Label.new()
	label.text = text
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 28 if text.begins_with("-") or text.begins_with("+") else 22)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_outline_color", Color(0.05, 0.06, 0.08, 0.9))
	label.add_theme_constant_override("outline_size", 2)
	effects_layer.add_child(label)
	label.size = label.get_combined_minimum_size()
	var anchor_position: Vector2 = _get_cell_effect_position(_get_actor_cell(actor_id))
	label.position = anchor_position - (label.size * 0.5) + Vector2(0, vertical_offset)
	label.scale = Vector2(0.82, 0.82)

	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "position", label.position + FLOAT_TEXT_RISE, 0.66).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "modulate:a", 0.0, 0.66).set_delay(0.12)
	tween.finished.connect(label.queue_free)


func _animate_cell_impact(actor_id: String, color: Color) -> void:
	var cell: Vector2i = _get_actor_cell(actor_id)
	if not _cell_in_bounds(cell):
		return

	var flash: ColorRect = ColorRect.new()
	flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	flash.color = Color(color.r, color.g, color.b, 0.44)
	flash.size = IMPACT_FLASH_SIZE
	flash.position = _get_cell_effect_position(cell) - (IMPACT_FLASH_SIZE * 0.5)
	flash.pivot_offset = IMPACT_FLASH_SIZE * 0.5
	effects_layer.add_child(flash)
	flash.scale = Vector2(0.42, 0.42)
	flash.rotation = deg_to_rad(float(((cell.x + 1) * 9) - ((cell.y + 1) * 4)))

	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(flash, "scale", Vector2(1.22, 1.22), 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(flash, "modulate:a", 0.0, 0.22).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.finished.connect(flash.queue_free)

	var button: Button = _get_grid_button(cell)
	if button != null:
		button.pivot_offset = button.size * 0.5
		button.scale = Vector2(0.92, 0.92)
		var pulse: Tween = create_tween()
		pulse.tween_property(button, "scale", Vector2(1.08, 1.08), 0.08).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		pulse.tween_property(button, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)


func _animate_portrait_feedback(actor_id: String, color: Color) -> void:
	var portrait: TextureRect = null
	if actor_id == active_actor_id:
		portrait = current_actor_portrait
	elif actor_id == _get_focus_target_actor_id():
		portrait = target_portrait
	if portrait == null:
		return

	portrait.self_modulate = Color(color.r, color.g, color.b, 0.82)
	portrait.scale = Vector2(0.92, 0.92)
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(portrait, "scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(portrait, "self_modulate", Color.WHITE, 0.22).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _play_damage_feedback(actor_id: String, damage: int, status_text: String = "", accent_color: Color = Color(0.84, 0.41, 0.29, 1.0)) -> void:
	if damage > 0:
		_show_floating_text(actor_id, "-%d" % damage, accent_color)
		_spawn_actor_vfx(actor_id, "slash", accent_color, 1.02, -12.0, 0.26)
		_animate_cell_impact(actor_id, accent_color)
		_animate_portrait_feedback(actor_id, accent_color)
		_animate_actor_action(actor_id, "hit", accent_color)
	if not status_text.is_empty():
		_show_floating_text(actor_id, status_text, Color(0.96, 0.86, 0.54, 1.0), -24.0)
		if status_text.begins_with("Sangr"):
			_spawn_actor_vfx(actor_id, "bleed", Color(0.88, 0.34, 0.29, 1.0), 0.98, -16.0, 0.34)


func _play_support_feedback(actor_id: String, text: String, accent_color: Color, secondary_text: String = "") -> void:
	_show_floating_text(actor_id, text, accent_color)
	var secondary_lower: String = secondary_text.to_lower()
	if secondary_lower.contains("guarda"):
		_spawn_actor_vfx(actor_id, "guard", Color(0.74, 0.85, 0.96, 1.0), 1.0, -14.0, 0.34)
	elif secondary_lower.contains("vida"):
		_spawn_actor_vfx(actor_id, "heal", Color(0.8, 0.95, 0.62, 1.0), 1.02, -16.0, 0.38)
	else:
		_spawn_actor_vfx(actor_id, "arc", accent_color, 0.94, -14.0, 0.3)
	_animate_cell_impact(actor_id, accent_color)
	_animate_portrait_feedback(actor_id, accent_color)
	_animate_actor_action(actor_id, "cast", accent_color)
	if not secondary_text.is_empty():
		_show_floating_text(actor_id, secondary_text, Color(0.88, 0.93, 1.0, 1.0), -24.0)


func _play_cinematic_strike(attacker_id: String, target_ids: Array[String], strong: bool, accent_color: Color) -> void:
	_animate_actor_action(attacker_id, "attack" if not target_ids.is_empty() else "cast", accent_color)
	if not target_ids.is_empty():
		_spawn_actor_vfx(attacker_id, "slash", accent_color, 0.98 if strong else 0.9, -12.0, 0.24)
		for target_id in target_ids:
			_spawn_actor_vfx(target_id, "spark", accent_color.lerp(Color.WHITE, 0.35), 0.9 if strong else 0.82, -10.0, 0.22)
	var intensity: float = 1.35 if strong else 0.72
	_play_screen_shake(intensity, 0.24 if strong else 0.14)
	if strong:
		_play_cinematic_bars(34.0, 0.18)
		_flash_scene(Color(accent_color.r, accent_color.g, accent_color.b, 0.11))
		_focus_battle_frame(attacker_id, target_ids, 1.028, 0.22)
	else:
		_focus_battle_frame(attacker_id, target_ids, 1.012, 0.12)


func _play_screen_shake(intensity: float, duration: float) -> void:
	if current_shake_tween != null:
		current_shake_tween.kill()

	battle_grid.pivot_offset = battle_grid.size * 0.5
	battle_grid.scale = Vector2.ONE
	current_shake_tween = create_tween()
	current_shake_tween.tween_property(battle_grid, "scale", Vector2.ONE * (1.0 + 0.024 * intensity), duration * 0.45).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	current_shake_tween.tween_property(battle_grid, "scale", Vector2.ONE, duration * 0.55).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)


func _focus_battle_frame(attacker_id: String, target_ids: Array[String], zoom: float, duration: float) -> void:
	battle_grid.pivot_offset = battle_grid.size * 0.5
	battle_grid.scale = Vector2.ONE
	var tween: Tween = create_tween()
	tween.tween_property(battle_grid, "scale", Vector2.ONE * zoom, duration * 0.45).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(battle_grid, "scale", Vector2.ONE, duration * 0.55).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _play_cinematic_bars(bar_height: float, duration: float) -> void:
	if cinematic_top_bar == null or cinematic_bottom_bar == null:
		return

	cinematic_top_bar.size = Vector2(effects_layer.size.x, 0.0)
	cinematic_bottom_bar.position = Vector2(0.0, effects_layer.size.y)
	cinematic_bottom_bar.size = Vector2(effects_layer.size.x, 0.0)
	cinematic_top_bar.color = Color(0.02, 0.03, 0.05, 0.0)
	cinematic_bottom_bar.color = Color(0.02, 0.03, 0.05, 0.0)
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(cinematic_top_bar, "size:y", bar_height, duration * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(cinematic_bottom_bar, "size:y", bar_height, duration * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(cinematic_bottom_bar, "position:y", effects_layer.size.y - bar_height, duration * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(cinematic_top_bar, "color:a", 0.92, duration * 0.5)
	tween.tween_property(cinematic_bottom_bar, "color:a", 0.92, duration * 0.5)
	tween.chain()
	tween.set_parallel(true)
	tween.tween_property(cinematic_top_bar, "size:y", 0.0, duration * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(cinematic_bottom_bar, "size:y", 0.0, duration * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(cinematic_bottom_bar, "position:y", effects_layer.size.y, duration * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(cinematic_top_bar, "color:a", 0.0, duration * 0.5)
	tween.tween_property(cinematic_bottom_bar, "color:a", 0.0, duration * 0.5)


func _flash_scene(color: Color) -> void:
	var flash := ColorRect.new()
	flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	flash.anchor_right = 1.0
	flash.anchor_bottom = 1.0
	flash.color = color
	effects_layer.add_child(flash)
	var tween: Tween = create_tween()
	tween.tween_property(flash, "color:a", 0.0, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.finished.connect(flash.queue_free)


func _is_heavy_skill(skill: Dictionary, target_ids: Array[String]) -> bool:
	return int(skill.get("power", 0)) >= 18 or target_ids.size() > 1 or bool(skill.get("pierce_row", false))


func _animate_result_banner(color: Color) -> void:
	result_label.pivot_offset = result_label.size * 0.5
	result_label.scale = Vector2(0.84, 0.84)
	result_label.self_modulate = color
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(result_label, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(result_label, "self_modulate", Color.WHITE, 0.34).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _preview_status_name(target_actor_id: String, status_effect: Dictionary) -> String:
	var status_id: String = str(status_effect.get("id", ""))
	if status_id.is_empty():
		return ""

	var adjusted_status: Dictionary = _get_adjusted_status_effect(target_actor_id, status_effect)
	if _status_effect_is_blocked(status_id, adjusted_status):
		return "resiste"
	var chance: int = _get_status_effect_chance(adjusted_status)
	if chance >= 100:
		return _get_status_name(status_id)
	return "%s %d%%" % [_get_status_name(status_id), chance]


func _get_adjusted_status_effect(target_actor_id: String, status_effect: Dictionary) -> Dictionary:
	if status_effect.is_empty():
		return {}

	var status_id: String = str(status_effect.get("id", ""))
	if status_id.is_empty():
		return {}

	var adjusted_status: Dictionary = status_effect.duplicate(true)
	match status_id:
		"bleed":
			var bleed_resist: int = _get_combatant_passive_effect_value(target_actor_id, "bleed_resist")
			if bleed_resist > 0:
				adjusted_status["duration"] = max(0, int(adjusted_status.get("duration", 1)) - 1)
				adjusted_status["power"] = max(0, int(adjusted_status.get("power", 0)) - bleed_resist * 4)
		"stun":
			if _has_status(target_actor_id, STUN_GUARD_STATUS_ID):
				adjusted_status["duration"] = 0
			else:
				var stun_resist: int = _get_combatant_passive_effect_value(target_actor_id, "stun_resist")
				if stun_resist > 0:
					adjusted_status["duration"] = max(0, int(adjusted_status.get("duration", 1)) - stun_resist)
	return adjusted_status


func _status_effect_is_blocked(status_id: String, adjusted_status: Dictionary) -> bool:
	if adjusted_status.is_empty():
		return true
	return int(adjusted_status.get("duration", 0)) <= 0 or (status_id == "bleed" and int(adjusted_status.get("power", 0)) <= 0)


func _get_status_effect_chance(adjusted_status: Dictionary) -> int:
	return clampi(int(adjusted_status.get("chance", 100)), 0, 100)


func _refresh_action_buttons() -> void:
	var is_ally_phase: bool = _is_ally_turn() and not battle_over
	var actor: Dictionary = _get_actor_data(active_actor_id)
	var actor_name: String = actor.get("name", "Aliado")
	var potion_count: int = GameState.get_item_quantity("health_potion")

	move_button.text = ""
	attack_button.text = ""
	item_button.text = ""
	defend_button.text = ""
	move_button.custom_minimum_size = Vector2(80.0, 80.0)
	attack_button.custom_minimum_size = Vector2(80.0, 80.0)
	item_button.custom_minimum_size = Vector2(80.0, 80.0)
	defend_button.custom_minimum_size = Vector2(80.0, 80.0)
	_set_action_button_count_badge(item_button, potion_count)

	if not is_ally_phase:
		move_button.disabled = true
		attack_button.disabled = true
		item_button.disabled = true
		defend_button.disabled = true
		_set_action_button_used_stamp(move_button, false)
		_set_action_button_used_stamp(attack_button, false)
		_set_action_button_used_stamp(item_button, false)
		_set_action_button_used_stamp(defend_button, false)
		return

	move_button.disabled = turn_move_used or turn_action_used or _get_reachable_costs(active_actor_id).size() <= 1
	attack_button.disabled = turn_action_used or not _has_enemy_in_range(active_actor_id, _get_actor_attack_range(active_actor_id))
	item_button.disabled = turn_action_used or potion_count <= 0
	defend_button.disabled = turn_action_used

	_set_action_button_used_stamp(move_button, turn_move_used)
	_set_action_button_used_stamp(attack_button, turn_action_used)
	_set_action_button_used_stamp(item_button, turn_action_used)
	_set_action_button_used_stamp(defend_button, turn_action_used)

	move_button.tooltip_text = "Tecla 1. Reposiciona %s nas casas alcancaveis." % actor_name
	attack_button.tooltip_text = "Tecla 2. Golpe simples ao alcance da arma."
	item_button.tooltip_text = "Tecla 3. Bebe uma Pocao de Vida do bornal. Restam %d." % potion_count
	defend_button.tooltip_text = "Tecla 4. Ergue a guarda e recobra Espirito."


func _set_action_button_used_stamp(button: Button, used: bool) -> void:
	if button == null:
		return
	var stamp: Label = button.get_node_or_null("UsedStamp") as Label
	if used:
		if stamp == null:
			stamp = Label.new()
			stamp.name = "UsedStamp"
			stamp.mouse_filter = Control.MOUSE_FILTER_IGNORE
			stamp.anchor_left = 0.0
			stamp.anchor_top = 0.0
			stamp.anchor_right = 1.0
			stamp.anchor_bottom = 1.0
			stamp.offset_left = 0.0
			stamp.offset_top = 0.0
			stamp.offset_right = 0.0
			stamp.offset_bottom = 0.0
			stamp.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			stamp.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			stamp.text = "✓"
			stamp.add_theme_font_size_override("font_size", 26)
			stamp.add_theme_color_override("font_color", Color(0.94, 0.78, 0.3, 0.72))
			stamp.add_theme_color_override("font_outline_color", Color(0.05, 0.06, 0.08, 0.8))
			stamp.add_theme_constant_override("outline_size", 2)
			button.add_child(stamp)
		stamp.visible = true
	else:
		if stamp != null:
			stamp.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if battle_over:
		return
	if tutorial_active:
		if event is InputEventKey and event.pressed and not event.echo:
			if event.keycode == KEY_ESCAPE:
				_on_tutorial_skip_pressed()
			elif event.keycode in [KEY_ENTER, KEY_KP_ENTER, KEY_SPACE]:
				_on_tutorial_next_pressed()
		return
	if not (event is InputEventKey):
		return
	if not event.pressed or event.echo:
		return

	if event.keycode == KEY_ESCAPE and _is_ally_turn():
		if battle_mode != "idle":
			battle_mode = "idle"
			pending_skill_id = ""
			_update_field_hint()
			_refresh_status()
		return

	if not _is_ally_turn():
		return

	match event.keycode:
		KEY_1:
			_on_move_button_pressed()
		KEY_2:
			_on_attack_button_pressed()
		KEY_3:
			_on_item_button_pressed()
		KEY_4:
			_on_defend_button_pressed()


func _on_move_button_pressed() -> void:
	if not _is_ally_turn() or turn_move_used or turn_action_used:
		return

	var reachable_cells: Dictionary = _get_reachable_costs(active_actor_id)
	if reachable_cells.size() <= 1:
		_write_log("Nao ha casa livre ao alcance do vosso passo.")
		return

	battle_mode = "move_select"
	pending_skill_id = ""
	preview_target_actor_id = ""
	_update_field_hint()
	_refresh_status()


func _on_attack_button_pressed() -> void:
	if not _is_ally_turn() or turn_action_used:
		return

	if not _has_enemy_in_range(active_actor_id, _get_actor_attack_range(active_actor_id)):
		_write_log("Nao tendes inimigo ao alcance da arma.")
		return

	battle_mode = "attack_select"
	pending_skill_id = ""
	preview_target_actor_id = ""
	_update_field_hint()
	_refresh_status()


func _on_item_button_pressed() -> void:
	if not _is_ally_turn() or turn_action_used:
		return

	var actor: Dictionary = _get_actor_data(active_actor_id)
	if actor.is_empty():
		return

	var potion_name: String = GameState.item_defs.get("health_potion", {}).get("name", "Pocao")
	var previous_hp: int = int(actor.get("hp", 0))
	if GameState.consume_item("health_potion"):
		var heal_amount: int = int(GameState.item_defs.get("health_potion", {}).get("heal_hp", 50))
		actor["hp"] = min(actor.get("max_hp", 0), actor.get("hp", 0) + heal_amount)
		_set_actor_data(active_actor_id, actor)
		_write_log("%s bebe %s e recupera %d pontos de Saude." % [actor.get("name", "Aliado"), potion_name, heal_amount])
	else:
		_write_log("Ja nao tendes %s no bornal." % potion_name)
		return
	var recovered_hp: int = int(actor.get("hp", 0)) - previous_hp
	_animate_actor_action(active_actor_id, "potion")
	_play_sfx("heal", 0.02, -5.0)
	_play_support_feedback(active_actor_id, "+%d" % recovered_hp, Color(0.37, 0.78, 0.52, 1.0), "Vida")
	await get_tree().create_timer(0.18).timeout
	await _finish_ally_action()


func _on_defend_button_pressed() -> void:
	if not _is_ally_turn() or turn_action_used:
		return

	var actor: Dictionary = _get_actor_data(active_actor_id)
	if actor.is_empty():
		return

	actor["defending"] = true
	actor["sp"] = min(actor.get("max_sp", 0), actor.get("sp", 0) + 5)
	_set_actor_data(active_actor_id, actor)
	_write_log("%s firma a guarda e recobra 5 pontos de Espirito." % actor.get("name", "Aliado"))
	_animate_actor_action(active_actor_id, "guard")
	_play_sfx("guard", 0.02, -5.0)
	_play_support_feedback(active_actor_id, "+5 ESP", Color(0.39, 0.63, 0.92, 1.0), "Guarda")
	await get_tree().create_timer(0.16).timeout
	await _finish_ally_action()


func _on_skill_pressed(skill_id: String) -> void:
	if not _is_ally_turn() or turn_action_used:
		return

	var actor: Dictionary = _get_actor_data(active_actor_id)
	var skill: Dictionary = GameState.skill_defs.get(skill_id, {})
	if actor.is_empty() or skill.is_empty():
		return

	var cost: int = _get_skill_cost_for_actor(active_actor_id, skill_id)
	if actor.get("sp", 0) < cost:
		_write_log("Nao ha Espirito bastante para %s." % skill.get("name", skill_id))
		return

	if int(skill.get("range", 1)) <= 0:
		_execute_self_skill(skill_id)
		return

	if not _has_enemy_in_range(active_actor_id, int(skill.get("range", 1))):
		_write_log("%s nao alcanca qualquer inimigo." % skill.get("name", skill_id))
		return

	battle_mode = "skill_select"
	pending_skill_id = skill_id
	preview_target_actor_id = ""
	_update_field_hint()
	_refresh_status()


func _execute_self_skill(skill_id: String) -> void:
	var actor: Dictionary = _get_actor_data(active_actor_id)
	var skill: Dictionary = GameState.skill_defs.get(skill_id, {})
	_consume_skill_cost(active_actor_id, skill_id)
	actor = _get_actor_data(active_actor_id)
	var support_text: String = ""
	var support_subtext: String = ""
	var support_color: Color = Color(0.44, 0.72, 0.93, 1.0)

	match skill.get("effect", ""):
		"defend_buff":
			actor["defending"] = true
			support_text = "Guarda"
			_write_log("%s envolve %s numa mare protectora." % [skill.get("name", skill_id), actor.get("name", "Aliado")])
		"speed_boost":
			actor["sp"] = min(actor.get("max_sp", 0), actor.get("sp", 0) + 3)
			support_text = "+3 ESP"
			support_subtext = "Animo"
			_write_log("%s aviva o animo de %s. Recupera 3 pontos de Espirito." % [skill.get("name", skill_id), actor.get("name", "Aliado")])
		"guard_stance":
			actor["defending"] = true
			actor["sp"] = min(actor.get("max_sp", 0), actor.get("sp", 0) + 3)
			support_text = "+3 ESP"
			support_subtext = "Guarda"
			_write_log("%s fecha a guarda de %s e restituem-se 3 pontos de Espirito." % [skill.get("name", skill_id), actor.get("name", "Aliado")])

	_set_actor_data(active_actor_id, actor)
	if not support_text.is_empty():
		_play_skill_sfx(skill)
		_play_cinematic_strike(active_actor_id, [], false, support_color)
		_play_support_feedback(active_actor_id, support_text, support_color, support_subtext)
		await get_tree().create_timer(0.18).timeout
	await _finish_ally_action()


func _on_grid_cell_pressed(cell: Vector2i) -> void:
	if battle_over:
		return

	var occupant_id: String = _actor_id_at_cell(cell)
	if battle_mode == "move_select":
		if _cell_is_valid_move(cell):
			var previous_cell: Vector2i = _get_actor_cell(active_actor_id)
			await _animate_actor_move(active_actor_id, previous_cell, cell)
			_set_actor_cell(active_actor_id, cell)
			turn_move_used = true
			battle_mode = "idle"
			_write_log("%s reposiciona-se para a casa %d,%d." % [_get_actor_data(active_actor_id).get("name", "Aliado"), cell.x + 1, cell.y + 1])
			_update_field_hint()
			_refresh_status()
		return

	if battle_mode == "attack_select":
		if _cell_is_valid_target(cell):
			selected_target_id = occupant_id
			await _execute_basic_attack()
		return

	if battle_mode == "skill_select":
		if _cell_is_valid_target(cell):
			selected_target_id = occupant_id
			await _execute_target_skill(pending_skill_id)
		return

	if occupant_id.begins_with("enemy_"):
		selected_target_id = occupant_id
		preview_target_actor_id = ""
		_refresh_status()


func _on_grid_cell_hovered(cell: Vector2i) -> void:
	if not _is_target_preview_mode():
		return
	if not _cell_is_valid_target(cell):
		preview_target_actor_id = ""
		_refresh_focus_panels()
		_refresh_enemy_statuses()
		_refresh_grid_visuals()
		return

	preview_target_actor_id = _actor_id_at_cell(cell)
	_refresh_focus_panels()
	_refresh_enemy_statuses()
	_refresh_grid_visuals()


func _on_grid_cell_unhovered(cell: Vector2i) -> void:
	if not _is_target_preview_mode():
		return
	var occupant_id: String = _actor_id_at_cell(cell)
	if not occupant_id.is_empty() and occupant_id == preview_target_actor_id:
		preview_target_actor_id = ""
		_refresh_focus_panels()
		_refresh_enemy_statuses()
		_refresh_grid_visuals()


func _execute_basic_attack() -> void:
	var actor: Dictionary = _get_actor_data(active_actor_id)
	var target: Dictionary = _get_selected_enemy()
	if actor.is_empty() or target.is_empty():
		return

	var damage: int = _calculate_damage(
		actor,
		target,
		6,
		_get_actor_cell(active_actor_id),
		target.get("cell", Vector2i.ZERO),
		active_actor_id,
		target.get("actor_id", "")
	)
	target["hp"] = max(0, target.get("hp", 0) - damage)
	_set_enemy(target.get("actor_id", ""), target)
	_write_log("%s desfere um golpe em %s e causa %d de dano." % [
		actor.get("name", "Aliado"),
		target.get("name", "Inimigo"),
		damage
	])
	_play_attack_sfx(false, damage >= 24)
	_play_cinematic_strike(active_actor_id, [str(target.get("actor_id", ""))], damage >= 24, Color(0.86, 0.52, 0.25, 1.0))
	_play_damage_feedback(target.get("actor_id", ""), damage)
	await get_tree().create_timer(0.18).timeout
	_handle_enemy_defeat(target.get("actor_id", ""), active_actor_id)
	await _finish_ally_action()


func _execute_target_skill(skill_id: String) -> void:
	var actor: Dictionary = _get_actor_data(active_actor_id)
	var target: Dictionary = _get_selected_enemy()
	var skill: Dictionary = GameState.skill_defs.get(skill_id, {})
	if actor.is_empty() or target.is_empty() or skill.is_empty():
		return

	_consume_skill_cost(active_actor_id, skill_id)
	actor = _get_actor_data(active_actor_id)

	var target_ids: Array[String] = _get_skill_target_ids(skill, target.get("actor_id", ""))
	_write_log("%s usa %s." % [
		actor.get("name", "Aliado"),
		skill.get("name", skill_id)
	])
	_play_skill_sfx(skill)
	_play_cinematic_strike(active_actor_id, target_ids, _is_heavy_skill(skill, target_ids), Color(0.37, 0.72, 0.86, 1.0))
	for target_id in target_ids:
		var live_target: Dictionary = _get_enemy_by_actor_id(target_id)
		if live_target.is_empty() or live_target.get("hp", 0) <= 0:
			continue

		var damage: int = _calculate_damage(
			actor,
			live_target,
			int(skill.get("power", 0)),
			_get_actor_cell(active_actor_id),
			live_target.get("cell", Vector2i.ZERO),
			active_actor_id,
			target_id
		)
		live_target["hp"] = max(0, live_target.get("hp", 0) - damage)
		_set_enemy(target_id, live_target)
		_write_log("  %s sofre %d de dano." % [
			live_target.get("name", "Inimigo"),
			damage
		])
		var status_text: String = ""
		if live_target.get("hp", 0) > 0:
			status_text = _apply_status_to_target(target_id, skill.get("status_effect", {}), actor.get("name", "Aliado"))
		else:
			_handle_enemy_defeat(target_id, active_actor_id)
		_play_damage_feedback(target_id, damage, status_text, Color(0.82, 0.46, 0.27, 1.0))
		await get_tree().create_timer(0.1).timeout

	await _finish_ally_action()


func _finish_ally_action() -> void:
	turn_action_used = true
	battle_mode = "idle"
	pending_skill_id = ""
	preview_target_actor_id = ""
	_update_field_hint()
	_refresh_status()
	if _all_enemies_down():
		_victory()
		return

	action_buttons.visible = true
	skill_buttons.visible = false
	await get_tree().create_timer(0.28).timeout
	_advance_turn()


func _enemy_turn(enemy_actor_id: String) -> void:
	if battle_over:
		return

	var enemy: Dictionary = _get_enemy_by_actor_id(enemy_actor_id)
	if enemy.is_empty() or enemy.get("hp", 0) <= 0:
		_advance_turn()
		return

	var target_actor_id: String = _pick_enemy_target(enemy_actor_id)
	if target_actor_id.is_empty():
		_defeat()
		return

	var target_cell: Vector2i = _get_actor_cell(target_actor_id)
	var enemy_cell: Vector2i = enemy.get("cell", Vector2i.ZERO)
	if _grid_distance(enemy_cell, target_cell) > int(enemy.get("attack_range", 1)):
		var moved: bool = _move_enemy_towards(enemy_actor_id, target_actor_id)
		if moved:
			enemy = _get_enemy_by_actor_id(enemy_actor_id)
			var moved_cell: Vector2i = enemy.get("cell", Vector2i.ZERO)
			_write_log("%s avanca para a casa %d,%d." % [enemy.get("name", "Inimigo"), moved_cell.x + 1, moved_cell.y + 1])

	enemy = _get_enemy_by_actor_id(enemy_actor_id)
	enemy_cell = enemy.get("cell", Vector2i.ZERO)
	var chosen_skill: Dictionary = _choose_enemy_skill(enemy_actor_id, target_actor_id)
	if not chosen_skill.is_empty():
		await _execute_enemy_skill(enemy_actor_id, target_actor_id, chosen_skill)
	elif _grid_distance(enemy_cell, target_cell) <= int(enemy.get("attack_range", 1)):
		var target_data: Dictionary = _get_actor_data(target_actor_id)
		var base_damage: int = _calculate_damage(
			enemy,
			target_data,
			5,
			enemy_cell,
			target_cell,
			enemy_actor_id,
			target_actor_id
		)
		var damage: int = base_damage
		if target_data.get("defending", false):
			damage = max(1, int(round(base_damage * 0.5)))
			target_data["defending"] = false

		target_data["hp"] = max(0, target_data.get("hp", 0) - damage)
		_set_actor_data(target_actor_id, target_data)
		_write_log("%s fere %s em %d pontos." % [
			enemy.get("name", "Inimigo"),
			target_data.get("name", "Aliado"),
			damage
		])
		_play_attack_sfx(true, damage >= 22)
		_play_cinematic_strike(enemy_actor_id, [target_actor_id], damage >= 22, Color(0.8, 0.38, 0.28, 1.0))
		_play_damage_feedback(target_actor_id, damage, "", Color(0.83, 0.38, 0.31, 1.0))
		await get_tree().create_timer(0.16).timeout
	else:
		_write_log("%s nao encontra abertura para golpear." % enemy.get("name", "Inimigo"))

	_refresh_status()
	if _all_allies_down():
		_defeat()
		return

	await get_tree().create_timer(0.28).timeout
	_advance_turn()


func _pick_enemy_target(enemy_actor_id: String) -> String:
	var enemy: Dictionary = _get_enemy_by_actor_id(enemy_actor_id)
	var enemy_cell: Vector2i = enemy.get("cell", Vector2i.ZERO)
	var living_allies: Array[String] = []
	if _is_actor_alive("pembah"):
		living_allies.append("pembah")
	if _is_actor_alive("joao"):
		living_allies.append("joao")
	if living_allies.is_empty():
		return ""

	var chosen_id: String = living_allies[0]
	var best_distance: int = _grid_distance(enemy_cell, _get_actor_cell(chosen_id))
	for actor_id in living_allies:
		var distance: int = _grid_distance(enemy_cell, _get_actor_cell(actor_id))
		if distance < best_distance:
			best_distance = distance
			chosen_id = actor_id
	return chosen_id


func _move_enemy_towards(enemy_actor_id: String, target_actor_id: String) -> bool:
	var enemy: Dictionary = _get_enemy_by_actor_id(enemy_actor_id)
	var current_cell: Vector2i = enemy.get("cell", Vector2i.ZERO)
	var target_cell: Vector2i = _get_actor_cell(target_actor_id)
	var reachable_costs: Dictionary = _get_reachable_costs(enemy_actor_id)
	var best_cell: Vector2i = current_cell
	var best_distance: int = _grid_distance(current_cell, target_cell)
	var best_height_advantage: int = _height_advantage_score(current_cell, target_cell)

	for cell_key in reachable_costs.keys():
		var candidate: Vector2i = _cell_from_key(str(cell_key))
		if candidate == current_cell:
			continue

		var distance: int = _grid_distance(candidate, target_cell)
		var height_advantage: int = _height_advantage_score(candidate, target_cell)
		if distance < best_distance:
			best_distance = distance
			best_height_advantage = height_advantage
			best_cell = candidate
		elif distance == best_distance and height_advantage > best_height_advantage:
			best_height_advantage = height_advantage
			best_cell = candidate

	if best_cell == current_cell:
		return false

	enemy["cell"] = best_cell
	_set_enemy(enemy_actor_id, enemy)
	return true


func _get_actor_data(actor_id: String) -> Dictionary:
	if actor_id == "pembah":
		return player_data
	if actor_id == "joao":
		return companion_data
	return {}


func _set_actor_data(actor_id: String, actor: Dictionary) -> void:
	if actor_id == "pembah":
		player_data = actor
	elif actor_id == "joao":
		companion_data = actor


func _get_combatant_passive_ids(actor_id: String) -> Array[String]:
	var passive_ids: Array[String] = []
	var combatant: Dictionary = _get_combatant_data(actor_id)
	for raw_passive_id in combatant.get("passives", []):
		var passive_id: String = str(raw_passive_id)
		if not passive_id.is_empty():
			passive_ids.append(passive_id)
	return passive_ids


func _get_combatant_passive_effect_value(actor_id: String, effect_id: String) -> int:
	var total: int = 0
	for passive_id in _get_combatant_passive_ids(actor_id):
		var passive: Dictionary = GameState.passive_defs.get(passive_id, {})
		for raw_effect in passive.get("effects", []):
			var effect: Dictionary = raw_effect
			if str(effect.get("id", "")) == effect_id:
				total += int(effect.get("value", 0))
	return total


func _get_skill_cost_for_actor(actor_id: String, skill_id: String) -> int:
	var skill: Dictionary = GameState.skill_defs.get(skill_id, {})
	if skill.is_empty():
		return 0

	var cost: int = int(skill.get("cost", 0))
	var combatant: Dictionary = _get_combatant_data(actor_id)
	if bool(combatant.get("skill_discount_ready", false)):
		cost = max(0, cost - _get_combatant_passive_effect_value(actor_id, "first_skill_discount"))
	return cost


func _consume_skill_cost(actor_id: String, skill_id: String) -> int:
	var combatant: Dictionary = _get_combatant_data(actor_id)
	if combatant.is_empty():
		return 0

	var cost: int = _get_skill_cost_for_actor(actor_id, skill_id)
	combatant["sp"] = max(0, int(combatant.get("sp", 0)) - cost)
	combatant["skill_discount_ready"] = false
	_set_combatant_data(actor_id, combatant)
	return cost


func _get_actor_cell(actor_id: String) -> Vector2i:
	if actor_id.begins_with("enemy_"):
		return _get_enemy_by_actor_id(actor_id).get("cell", Vector2i.ZERO)
	return _get_actor_data(actor_id).get("cell", Vector2i.ZERO)


func _set_actor_cell(actor_id: String, cell: Vector2i) -> void:
	if actor_id.begins_with("enemy_"):
		var enemy: Dictionary = _get_enemy_by_actor_id(actor_id)
		if enemy.is_empty():
			return
		enemy["cell"] = cell
		_set_enemy(actor_id, enemy)
		return

	var actor: Dictionary = _get_actor_data(actor_id)
	if actor.is_empty():
		return
	actor["cell"] = cell
	_set_actor_data(actor_id, actor)


func _get_enemy_by_actor_id(actor_id: String) -> Dictionary:
	for enemy in enemies_data:
		if enemy.get("actor_id", "") == actor_id:
			return enemy
	return {}


func _set_enemy(actor_id: String, enemy_data: Dictionary) -> void:
	for i in range(enemies_data.size()):
		var enemy: Dictionary = enemies_data[i]
		if enemy.get("actor_id", "") == actor_id:
			enemies_data[i] = enemy_data
			return


func _ordered_enemies() -> Array:
	var ordered: Array = enemies_data.duplicate(true)
	ordered.sort_custom(_compare_enemy_order)
	return ordered


func _compare_enemy_order(a: Dictionary, b: Dictionary) -> bool:
	var cell_a: Vector2i = a.get("cell", Vector2i.ZERO)
	var cell_b: Vector2i = b.get("cell", Vector2i.ZERO)
	if cell_a.y == cell_b.y:
		return cell_a.x < cell_b.x
	return cell_a.y < cell_b.y


func _actor_id_at_cell(cell: Vector2i) -> String:
	if _is_actor_alive("pembah") and _get_actor_cell("pembah") == cell:
		return "pembah"
	if _is_actor_alive("joao") and _get_actor_cell("joao") == cell:
		return "joao"
	for enemy in enemies_data:
		if enemy.get("hp", 0) > 0 and enemy.get("cell", Vector2i.ZERO) == cell:
			return enemy.get("actor_id", "")
	return ""


func _cell_is_empty(cell: Vector2i, ignore_actor_id: String = "") -> bool:
	var occupant_id: String = _actor_id_at_cell(cell)
	return occupant_id.is_empty() or occupant_id == ignore_actor_id


func _cell_in_bounds(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < GRID_COLS and cell.y >= 0 and cell.y < GRID_ROWS


func _grid_distance(a: Vector2i, b: Vector2i) -> int:
	return absi(a.x - b.x) + absi(a.y - b.y)


func _is_ally_turn() -> bool:
	return active_actor_id == "pembah" or active_actor_id == "joao"


func _get_actor_attack_range(actor_id: String) -> int:
	if actor_id.begins_with("enemy_"):
		return int(_get_enemy_by_actor_id(actor_id).get("attack_range", 1))
	return int(_get_actor_data(actor_id).get("attack_range", 1))


func _get_actor_move_range(actor_id: String) -> int:
	if actor_id.begins_with("enemy_"):
		return int(_get_enemy_by_actor_id(actor_id).get("move_range", 1))
	return int(_get_actor_data(actor_id).get("move_range", 2))


func _cell_is_valid_move(cell: Vector2i) -> bool:
	if battle_mode != "move_select" or not _is_ally_turn() or turn_move_used:
		return false
	if not _cell_in_bounds(cell) or _is_cell_blocked(cell):
		return false

	var reachable_costs: Dictionary = _get_reachable_costs(active_actor_id)
	return reachable_costs.has(_cell_key(cell)) and cell != _get_actor_cell(active_actor_id)


func _cell_is_valid_target(cell: Vector2i) -> bool:
	if not (battle_mode == "attack_select" or battle_mode == "skill_select"):
		return false

	var occupant_id: String = _actor_id_at_cell(cell)
	if not occupant_id.begins_with("enemy_"):
		return false

	var range: int = _get_actor_attack_range(active_actor_id)
	if battle_mode == "skill_select":
		range = int(GameState.skill_defs.get(pending_skill_id, {}).get("range", 1))

	var source_cell: Vector2i = _get_actor_cell(active_actor_id)
	return _grid_distance(source_cell, cell) <= range


func _has_enemy_in_range(actor_id: String, range: int) -> bool:
	var source_cell: Vector2i = _get_actor_cell(actor_id)
	for enemy in enemies_data:
		if enemy.get("hp", 0) <= 0:
			continue
		if _grid_distance(source_cell, enemy.get("cell", Vector2i.ZERO)) <= range:
			return true
	return false


func _get_selected_enemy() -> Dictionary:
	_ensure_valid_target()
	return _get_enemy_by_actor_id(selected_target_id)


func _first_alive_enemy_id() -> String:
	for enemy in enemies_data:
		if enemy.get("hp", 0) > 0:
			return enemy.get("actor_id", "")
	return ""


func _ensure_valid_target() -> void:
	var target: Dictionary = _get_enemy_by_actor_id(selected_target_id)
	if target.is_empty() or target.get("hp", 0) <= 0:
		selected_target_id = _first_alive_enemy_id()


func _is_actor_alive(actor_id: String) -> bool:
	if actor_id.begins_with("enemy_"):
		var enemy: Dictionary = _get_enemy_by_actor_id(actor_id)
		return not enemy.is_empty() and enemy.get("hp", 0) > 0

	var actor: Dictionary = _get_actor_data(actor_id)
	return not actor.is_empty() and actor.get("hp", 0) > 0


func _all_enemies_down() -> bool:
	for enemy in enemies_data:
		if enemy.get("hp", 0) > 0:
			return false
	return true


func _all_allies_down() -> bool:
	return not _is_actor_alive("pembah") and not _is_actor_alive("joao")


func _process_turn_start_effects(actor_id: String) -> bool:
	var combatant: Dictionary = _get_combatant_data(actor_id)
	if combatant.is_empty():
		return false

	var current_statuses: Array = combatant.get("status_effects", [])
	if current_statuses.is_empty():
		return false

	var updated_statuses: Array = []
	var total_bleed_damage: int = 0
	var stunned: bool = false
	for raw_status in current_statuses:
		var status: Dictionary = raw_status.duplicate(true)
		var duration: int = int(status.get("duration", 0))
		if duration <= 0:
			continue

		var status_id: String = str(status.get("id", ""))
		match status_id:
			"bleed":
				total_bleed_damage += int(status.get("power", 5))
				duration -= 1
			"stun":
				stunned = true
				duration -= 1
			_:
				duration -= 1

		if duration > 0:
			status["duration"] = duration
			updated_statuses.append(status)

	if total_bleed_damage > 0:
		combatant["hp"] = max(0, combatant.get("hp", 0) - total_bleed_damage)
		_write_log("%s sofre %d pontos de Sangramento." % [
			combatant.get("name", "Combatente"),
			total_bleed_damage
		])
		_play_sfx("bleed", 0.04, -6.0)
		_play_damage_feedback(actor_id, total_bleed_damage, "Sangr.", Color(0.78, 0.22, 0.24, 1.0))

	if combatant.get("hp", 0) > 0 and stunned:
		var has_stun_guard: bool = false
		for raw_status in updated_statuses:
			if str(raw_status.get("id", "")) == STUN_GUARD_STATUS_ID:
				has_stun_guard = true
				break
		if not has_stun_guard:
			updated_statuses.append({
				"id": STUN_GUARD_STATUS_ID,
				"duration": 1
			})
		_write_log("%s fica em Atordoamento e perde a vez." % combatant.get("name", "Combatente"))
		_play_sfx("stun", 0.02, -6.0)
		_show_floating_text(actor_id, "Atord.", Color(0.95, 0.84, 0.49, 1.0), -18.0)
		_animate_portrait_feedback(actor_id, Color(0.95, 0.84, 0.49, 1.0))

	combatant["status_effects"] = updated_statuses
	_set_combatant_data(actor_id, combatant)
	_refresh_status()

	if combatant.get("hp", 0) <= 0:
		_write_log("%s cai antes de poder agir." % combatant.get("name", "Combatente"))
		if actor_id.begins_with("enemy_") and _all_enemies_down():
			_victory()
		elif not actor_id.begins_with("enemy_") and _all_allies_down():
			_defeat()
		else:
			_advance_turn()
		return true

	if stunned:
		action_buttons.visible = true
		skill_buttons.visible = false
		_advance_turn()
		return true

	return false


func _is_cell_blocked(cell: Vector2i) -> bool:
	return blocked_cells.has(cell)


func _is_water_cell(cell: Vector2i) -> bool:
	return water_cells.has(cell)


func _is_high_ground(cell: Vector2i) -> bool:
	return high_cells.has(cell)


func _get_terrain_name(cell: Vector2i) -> String:
	if _is_cell_blocked(cell):
		return "Obstaculo"
	if _is_high_ground(cell):
		return "Alto"
	if _is_water_cell(cell):
		return "Agua"
	return "Plano"


func _get_terrain_marker(cell: Vector2i) -> String:
	if _is_cell_blocked(cell):
		return "#"
	if _is_high_ground(cell):
		return "^"
	if _is_water_cell(cell):
		return "~"
	return ""


func _get_base_cell_tint(cell: Vector2i) -> Color:
	if _is_cell_blocked(cell):
		return Color(0.34, 0.31, 0.29, 1.0)
	if _is_high_ground(cell):
		return Color(0.72, 0.58, 0.38, 1.0)
	if _is_water_cell(cell):
		return Color(0.43, 0.67, 0.9, 1.0)
	return Color(0.83, 0.81, 0.86, 1.0) if (cell.x + cell.y) % 2 == 0 else Color(0.73, 0.72, 0.79, 1.0)


func _build_cell_tooltip(cell: Vector2i) -> String:
	var parts: Array[String] = []
	parts.append("Casa %d,%d" % [cell.x + 1, cell.y + 1])
	parts.append(_get_terrain_name(cell))

	if _is_water_cell(cell):
		parts.append("Custa 2 passos, salvo a Pembah")
	if _is_high_ground(cell):
		parts.append("Da vantagem de altura")
	if _is_cell_blocked(cell):
		parts.append("Nao se pode ocupar")

	var occupant_id: String = _actor_id_at_cell(cell)
	if not occupant_id.is_empty():
		parts.append("Ocupa: %s" % _get_combatant_name(occupant_id))
		parts.append("Estados: %s" % _format_statuses(_get_combatant_data(occupant_id)))
		var focus_target_actor_id: String = _get_focus_target_actor_id()
		var preview_line: String = _get_preview_line_for_target(focus_target_actor_id, occupant_id)
		if not preview_line.is_empty():
			parts.append(preview_line)
			if battle_mode == "skill_select":
				if occupant_id == focus_target_actor_id:
					parts.append("Centro da arte")
				elif _get_preview_target_ids(focus_target_actor_id).has(occupant_id):
					parts.append("Apanhado pela area")
	return " | ".join(parts)


func _build_terrain_legend() -> String:
	var legend_parts: Array[String] = [
		"Legenda: ^ alto | ~ agua | # obstaculo",
		"Altura: +3 dano a descer, -2 a subir",
		"Agua custa 2 passos"
	]
	if GameState.get_player().get("water_stride", true):
		legend_parts.append("Pembah cruza a agua sem perda")
	if not terrain_note.is_empty():
		legend_parts.append(terrain_note)
	return " | ".join(legend_parts)


func _get_combatant_name(actor_id: String) -> String:
	if actor_id.begins_with("enemy_"):
		return _get_enemy_by_actor_id(actor_id).get("name", "Inimigo")
	return _get_actor_data(actor_id).get("name", actor_id.capitalize())


func _get_status_name(status_id: String) -> String:
	match status_id:
		"bleed":
			return "Sangramento"
		"stun":
			return "Atordoamento"
		_:
			return "Afeccao"


func _format_statuses(combatant: Dictionary) -> String:
	var labels: Array[String] = []
	for badge_data in _get_status_badges(combatant):
		labels.append(str(badge_data.get("text", "")))
	if labels.is_empty():
		return "nenhum"
	return ", ".join(labels)


func _get_start_cell(cells: Array[Vector2i], index: int, fallback: Vector2i) -> Vector2i:
	if cells.is_empty():
		return fallback
	return cells[min(index, cells.size() - 1)]


func _copy_cell_list(source: Array[Vector2i]) -> Array[Vector2i]:
	var copied: Array[Vector2i] = []
	for cell in source:
		copied.append(cell)
	return copied


func _parse_cell_list(raw_cells: Variant) -> Array[Vector2i]:
	var parsed: Array[Vector2i] = []
	if typeof(raw_cells) != TYPE_ARRAY:
		return parsed

	for raw_cell in raw_cells:
		if raw_cell is Vector2i:
			parsed.append(raw_cell)
		elif typeof(raw_cell) == TYPE_ARRAY and raw_cell.size() >= 2:
			parsed.append(Vector2i(int(raw_cell[0]), int(raw_cell[1])))
		elif typeof(raw_cell) == TYPE_DICTIONARY:
			parsed.append(Vector2i(int(raw_cell.get("x", 0)), int(raw_cell.get("y", 0))))
	return parsed


func _cell_key(cell: Vector2i) -> String:
	return "%d:%d" % [cell.x, cell.y]


func _cell_from_key(key: String) -> Vector2i:
	var parts: PackedStringArray = key.split(":")
	if parts.size() != 2:
		return Vector2i.ZERO
	return Vector2i(int(parts[0]), int(parts[1]))


func _get_combatant_data(actor_id: String) -> Dictionary:
	if actor_id.begins_with("enemy_"):
		return _get_enemy_by_actor_id(actor_id)
	return _get_actor_data(actor_id)


func _set_combatant_data(actor_id: String, combatant: Dictionary) -> void:
	if actor_id.begins_with("enemy_"):
		_set_enemy(actor_id, combatant)
	else:
		_set_actor_data(actor_id, combatant)


func _get_reachable_costs(actor_id: String) -> Dictionary:
	var start_cell: Vector2i = _get_actor_cell(actor_id)
	var max_cost: int = _get_actor_move_range(actor_id)
	var distances: Dictionary = {_cell_key(start_cell): 0}
	var frontier: Array[Vector2i] = [start_cell]

	while not frontier.is_empty():
		var current: Vector2i = frontier.pop_front()
		var current_cost: int = int(distances.get(_cell_key(current), 0))

		for direction in CARDINAL_DIRECTIONS:
			var candidate: Vector2i = current + direction
			if not _cell_in_bounds(candidate):
				continue
			if _is_cell_blocked(candidate):
				continue
			if not _cell_is_empty(candidate, actor_id):
				continue

			var next_cost: int = current_cost + _get_cell_move_cost(actor_id, candidate)
			if next_cost > max_cost:
				continue

			var candidate_key: String = _cell_key(candidate)
			if not distances.has(candidate_key) or next_cost < int(distances.get(candidate_key, max_cost + 1)):
				distances[candidate_key] = next_cost
				frontier.append(candidate)

	return distances


func _get_cell_move_cost(actor_id: String, cell: Vector2i) -> int:
	if _is_water_cell(cell) and not _has_water_stride(actor_id):
		return 2
	return 1


func _has_water_stride(actor_id: String) -> bool:
	if actor_id.begins_with("enemy_"):
		return bool(_get_enemy_by_actor_id(actor_id).get("water_stride", false))
	return bool(_get_actor_data(actor_id).get("water_stride", false))


func _height_advantage_score(source_cell: Vector2i, target_cell: Vector2i) -> int:
	if _is_high_ground(source_cell) and not _is_high_ground(target_cell):
		return 1
	if not _is_high_ground(source_cell) and _is_high_ground(target_cell):
		return -1
	return 0


func _calculate_damage(attacker: Dictionary, target: Dictionary, base_power: int, source_cell: Vector2i, target_cell: Vector2i, attacker_actor_id: String = "", target_actor_id: String = "") -> int:
	var damage: int = max(1, attacker.get("atk", 0) - target.get("def", 0) + base_power)
	if _is_high_ground(source_cell) and not _is_high_ground(target_cell):
		damage += 3 + _get_combatant_passive_effect_value(attacker_actor_id, "high_ground_mastery")
	elif not _is_high_ground(source_cell) and _is_high_ground(target_cell):
		damage = max(1, damage - 2)

	if _is_water_cell(target_cell):
		damage += 2
		damage = max(1, damage - _get_combatant_passive_effect_value(target_actor_id, "water_guard"))
	if _is_high_ground(target_cell):
		damage = max(1, damage - _get_combatant_passive_effect_value(target_actor_id, "high_ground_guard"))
	return damage


func _handle_enemy_defeat(enemy_actor_id: String, source_actor_id: String) -> void:
	var enemy: Dictionary = _get_enemy_by_actor_id(enemy_actor_id)
	if enemy.is_empty() or enemy.get("hp", 0) > 0:
		return

	var spirit_gain: int = _get_combatant_passive_effect_value(source_actor_id, "sp_on_defeat")
	if spirit_gain <= 0:
		return

	var source: Dictionary = _get_combatant_data(source_actor_id)
	if source.is_empty() or source.get("hp", 0) <= 0:
		return

	var previous_sp: int = int(source.get("sp", 0))
	source["sp"] = min(int(source.get("max_sp", 0)), previous_sp + spirit_gain)
	_set_combatant_data(source_actor_id, source)

	var recovered_sp: int = int(source.get("sp", 0)) - previous_sp
	if recovered_sp > 0:
		_write_log("%s recolhe %d pontos de Espirito ao derrubar %s." % [
			source.get("name", "Aliado"),
			recovered_sp,
			enemy.get("name", "Inimigo")
		])


func _apply_status_to_target(target_actor_id: String, status_effect: Dictionary, source_name: String) -> String:
	if status_effect.is_empty():
		return ""

	var target: Dictionary = _get_combatant_data(target_actor_id)
	if target.is_empty() or target.get("hp", 0) <= 0:
		return ""

	var status_id: String = str(status_effect.get("id", ""))
	if status_id.is_empty():
		return ""

	var adjusted_status: Dictionary = _get_adjusted_status_effect(target_actor_id, status_effect)
	if _status_effect_is_blocked(status_id, adjusted_status):
		_write_log("%s resiste a %s." % [
			target.get("name", "Alvo"),
			_get_status_name(status_id)
		])
		return "Resiste"
	var chance: int = _get_status_effect_chance(adjusted_status)
	if chance < 100 and rng.randi_range(1, 100) > chance:
		_write_log("%s escapa a %s." % [
			target.get("name", "Alvo"),
			_get_status_name(status_id)
		])
		return "Escapa"

	var statuses: Array = target.get("status_effects", []).duplicate(true)
	var refreshed: bool = false
	for i in range(statuses.size()):
		var current_status: Dictionary = statuses[i]
		if str(current_status.get("id", "")) != status_id:
			continue

		current_status["duration"] = max(int(current_status.get("duration", 0)), int(adjusted_status.get("duration", 1)))
		current_status["power"] = max(int(current_status.get("power", 0)), int(adjusted_status.get("power", 0)))
		statuses[i] = current_status
		refreshed = true
		break

	if not refreshed:
		statuses.append(adjusted_status)

	target["status_effects"] = statuses
	_set_combatant_data(target_actor_id, target)
	_write_log("%s deixa %s em %s." % [
		source_name,
		target.get("name", "Alvo"),
		_get_status_name(status_id)
	])
	return "Sangr." if status_id == "bleed" else "Atord."


func _has_status(actor_id: String, status_id: String) -> bool:
	for raw_status in _get_combatant_data(actor_id).get("status_effects", []):
		if str(raw_status.get("id", "")) == status_id:
			return true
	return false


func _get_target_ids(target_allies: bool) -> Array[String]:
	var target_ids: Array[String] = []
	if target_allies:
		if _is_actor_alive("pembah"):
			target_ids.append("pembah")
		if _is_actor_alive("joao"):
			target_ids.append("joao")
		return target_ids

	for enemy in enemies_data:
		if enemy.get("hp", 0) > 0:
			target_ids.append(enemy.get("actor_id", ""))
	return target_ids


func _get_skill_target_ids(skill: Dictionary, primary_target_id: String, target_allies: bool = false) -> Array[String]:
	var target_ids: Array[String] = []
	var primary_target: Dictionary = _get_combatant_data(primary_target_id)
	if primary_target.is_empty() or primary_target.get("hp", 0) <= 0:
		return target_ids

	var possible_targets: Array[String] = _get_target_ids(target_allies)
	if bool(skill.get("pierce_row", false)):
		var target_row: int = primary_target.get("cell", Vector2i.ZERO).y
		for target_id in possible_targets:
			if _get_actor_cell(target_id).y == target_row:
				target_ids.append(target_id)
		return target_ids

	var area_radius: int = int(skill.get("area_radius", 0))
	if area_radius > 0:
		var center_cell: Vector2i = primary_target.get("cell", Vector2i.ZERO)
		for target_id in possible_targets:
			if _grid_distance(center_cell, _get_actor_cell(target_id)) <= area_radius:
				target_ids.append(target_id)
		return target_ids

	target_ids.append(primary_target_id)
	return target_ids


func _choose_enemy_skill(enemy_actor_id: String, target_actor_id: String) -> Dictionary:
	var enemy: Dictionary = _get_enemy_by_actor_id(enemy_actor_id)
	if enemy.is_empty():
		return {}

	var best_skill: Dictionary = {}
	var best_score: int = -1
	for raw_skill_id in enemy.get("skills", []):
		var skill_id: String = str(raw_skill_id)
		var skill: Dictionary = GameState.skill_defs.get(skill_id, {})
		if skill.is_empty():
			continue
		if int(enemy.get("sp", 0)) < int(skill.get("cost", 0)):
			continue
		if _grid_distance(enemy.get("cell", Vector2i.ZERO), _get_actor_cell(target_actor_id)) > int(skill.get("range", 1)):
			continue

		var target_ids: Array[String] = _get_skill_target_ids(skill, target_actor_id, true)
		if target_ids.is_empty():
			continue

		var score: int = int(skill.get("power", 0)) + max(0, target_ids.size() - 1) * 8
		var status_effect: Dictionary = skill.get("status_effect", {})
		var status_id: String = str(status_effect.get("id", ""))
		if not status_id.is_empty() and not _has_status(target_actor_id, status_id):
			var adjusted_status: Dictionary = _get_adjusted_status_effect(target_actor_id, status_effect)
			if not _status_effect_is_blocked(status_id, adjusted_status):
				score += int(round(10.0 * float(_get_status_effect_chance(adjusted_status)) / 100.0))

		if score > best_score:
			best_score = score
			best_skill = skill

	return best_skill


func _execute_enemy_skill(enemy_actor_id: String, primary_target_id: String, skill: Dictionary) -> void:
	var enemy: Dictionary = _get_enemy_by_actor_id(enemy_actor_id)
	if enemy.is_empty() or skill.is_empty():
		return

	enemy["sp"] = max(0, int(enemy.get("sp", 0)) - int(skill.get("cost", 0)))
	_set_enemy(enemy_actor_id, enemy)

	var target_ids: Array[String] = _get_skill_target_ids(skill, primary_target_id, true)
	_write_log("%s usa %s." % [
		enemy.get("name", "Inimigo"),
		skill.get("name", "Arte")
	])
	_play_skill_sfx(skill, true)
	_play_cinematic_strike(enemy_actor_id, target_ids, _is_heavy_skill(skill, target_ids), Color(0.88, 0.42, 0.26, 1.0))
	for target_id in target_ids:
		var target_data: Dictionary = _get_actor_data(target_id)
		if target_data.is_empty() or target_data.get("hp", 0) <= 0:
			continue

		var damage: int = _calculate_damage(
			enemy,
			target_data,
			int(skill.get("power", 0)),
			enemy.get("cell", Vector2i.ZERO),
			target_data.get("cell", Vector2i.ZERO),
			enemy_actor_id,
			target_id
		)
		if target_data.get("defending", false):
			damage = max(1, int(round(damage * 0.5)))
			target_data["defending"] = false

		target_data["hp"] = max(0, target_data.get("hp", 0) - damage)
		_set_actor_data(target_id, target_data)
		_write_log("  %s sofre %d de dano." % [
			target_data.get("name", "Aliado"),
			damage
		])
		var status_text: String = ""
		if target_data.get("hp", 0) > 0:
			status_text = _apply_status_to_target(target_id, skill.get("status_effect", {}), enemy.get("name", "Inimigo"))
		_play_damage_feedback(target_id, damage, status_text, Color(0.86, 0.37, 0.28, 1.0))
		await get_tree().create_timer(0.1).timeout
	_refresh_status()


func _get_actor_icon(actor_id: String) -> Texture2D:
	var profile: String = _get_actor_visual_profile(actor_id)
	return _load_texture_with_fallback(
		"icon:%s" % profile,
		_get_profile_icon_candidates(profile),
		_get_profile_icon_fallback(profile)
	)


func _get_actor_grid_label(actor_id: String) -> String:
	if actor_id == "pembah":
		return "P"
	if actor_id == "joao":
		return "J"

	var enemy: Dictionary = _get_enemy_by_actor_id(actor_id)
	match enemy.get("id", ""):
		"castilian_duelist":
			return "C"
		"mourish_guard":
			return "M"
		"bombardeiro_renegado":
			return "B"
		"corsair_raider", "corsario_barbaresco":
			return "R"
		"renegado_da_aduana":
			return "A"
		"atalaiador_zenete":
			return "Z"
		_:
			return "S"


func _update_field_hint() -> void:
	if battle_over:
		action_hint_label.text = "A peleja esta resolvida. Podeis tornar quando quiserdes."
		return

	if not _is_ally_turn():
		action_hint_label.text = "O inimigo age agora. Le a ordem da ronda e vigia o alvo marcado."
		return

	if battle_mode == "move_select":
		field_hint_label.text = "Escolhei uma casa vazia ao alcance do movimento."
		action_hint_label.text = "As casas verdes recebem o vosso passo; Esc cancela a escolha."
	elif battle_mode == "attack_select":
		field_hint_label.text = "Escolhei um inimigo ao alcance da arma."
		action_hint_label.text = "As casas rubras marcam alvos validos para o golpe simples; Esc cancela."
	elif battle_mode == "skill_select":
		var skill_name: String = GameState.skill_defs.get(pending_skill_id, {}).get("name", "Arte")
		field_hint_label.text = "Escolhei o alvo de %s. A fileira e a area contam." % skill_name
		action_hint_label.text = "O alvo marcado mostra a zona onde a arte ha-de cair; Esc cancela."
	else:
		var actor: Dictionary = _get_actor_data(active_actor_id)
		var step_note: String = " e passar por agua sem pena" if actor.get("water_stride", false) else ""
		field_hint_label.text = "%s pode mover ate %d casas%s e agir neste turno." % [
			actor.get("name", "Aliado"),
			actor.get("move_range", 2),
			step_note
		]
		action_hint_label.text = "1 mover | 2 golpear | 3 pocao | 4 defender | Esc limpa a escolha."


func _victory() -> void:
	battle_over = true
	battle_result = "victory"
	battle_mode = "idle"
	turn_label.text = "Vez de: concluida"
	field_hint_label.text = "A companhia alcançou a vitória."
	action_hint_label.text = "O recontro terminou. Podeis recolher e tornar ao mapa."
	result_label.text = "Vitoria"
	_animate_result_banner(Color(0.96, 0.82, 0.36, 1.0))
	_play_sfx("victory", 0.0, -3.5)
	_write_log(battle_context.get("victory_text", "Os inimigos caem por terra."))
	_commit_party_state()
	GameState.finish_battle_victory(battle_context)
	if bool(battle_context.get("overworld_encounter", false)):
		GameState.register_battle_outcome("victory")
	continue_button.visible = true
	action_buttons.visible = false
	skill_buttons.visible = false
	var finale_message: String = str(battle_context.get("finale_message", "")).strip_edges()
	if not finale_message.is_empty():
		_show_finale_message(finale_message)
		continue_button.visible = false
	_refresh_status()


func _defeat() -> void:
	battle_over = true
	battle_result = "defeat"
	battle_mode = "idle"
	turn_label.text = "Vez de: perdida"
	field_hint_label.text = "A formação cedeu por ora."
	action_hint_label.text = "A peleja perdeu-se, por ora. Podeis retirar-vos e tentar de novo."
	result_label.text = "Derrota"
	_animate_result_banner(Color(0.88, 0.43, 0.33, 1.0))
	_play_sfx("defeat", 0.0, -3.5)
	_write_log(battle_context.get("defeat_text", "A batalha perde-se, por ora."))
	if bool(battle_context.get("overworld_encounter", false)):
		GameState.register_battle_outcome("defeat")
		GameState.clear_overworld_travel_state()
		GameState.set_overworld_current_node(str(battle_context.get("origin_node_id", "")))
	continue_button.visible = true
	action_buttons.visible = false
	skill_buttons.visible = false
	_refresh_status()


func _commit_party_state() -> void:
	var player: Dictionary = GameState.get_player()
	player["hp"] = max(1, player_data.get("hp", 0))
	player["sp"] = player_data.get("sp", 0)
	player["defending"] = false
	player["status_effects"] = []
	player.erase("skill_discount_ready")
	GameState.party["pembah"] = player

	if not companion_data.is_empty():
		var companion_id: String = companion_data.get("id", "")
		if not companion_id.is_empty():
			companion_data["hp"] = max(0, companion_data.get("hp", 0))
			companion_data["sp"] = companion_data.get("sp", 0)
			companion_data["defending"] = false
			companion_data["status_effects"] = []
			companion_data.erase("skill_discount_ready")
			GameState.party[companion_id] = companion_data


func _on_continue_button_pressed() -> void:
	if not battle_over:
		return

	var next_scene: String = battle_context.get("return_scene", "res://scenes/world/lisboa.tscn")
	if battle_result == "defeat":
		next_scene = battle_context.get("defeat_return_scene", next_scene)
	get_tree().change_scene_to_file(next_scene)


func _show_finale_message(message: String) -> void:
	if message.is_empty():
		return

	if finale_overlay == null:
		finale_overlay = ColorRect.new()
		finale_overlay.name = "FinaleOverlay"
		finale_overlay.color = Color(0.0, 0.0, 0.0, 0.96)
		finale_overlay.anchor_left = 0.0
		finale_overlay.anchor_top = 0.0
		finale_overlay.anchor_right = 1.0
		finale_overlay.anchor_bottom = 1.0
		finale_overlay.offset_left = 0.0
		finale_overlay.offset_top = 0.0
		finale_overlay.offset_right = 0.0
		finale_overlay.offset_bottom = 0.0
		finale_overlay.mouse_filter = Control.MOUSE_FILTER_STOP

		var layout := VBoxContainer.new()
		layout.anchor_left = 0.5
		layout.anchor_top = 0.5
		layout.anchor_right = 0.5
		layout.anchor_bottom = 0.5
		layout.offset_left = -360.0
		layout.offset_top = -140.0
		layout.offset_right = 360.0
		layout.offset_bottom = 140.0
		layout.alignment = BoxContainer.ALIGNMENT_CENTER
		layout.add_theme_constant_override("separation", 20)
		finale_overlay.add_child(layout)

		finale_label = Label.new()
		finale_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		finale_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		finale_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		finale_label.add_theme_font_size_override("font_size", 22)
		finale_label.add_theme_color_override("font_color", Color("f8f3e4"))
		layout.add_child(finale_label)

		finale_button = Button.new()
		finale_button.custom_minimum_size = Vector2(220.0, 44.0)
		_apply_button_theme(finale_button)
		finale_button.pressed.connect(_on_finale_button_pressed)
		layout.add_child(finale_button)

		add_child(finale_overlay)

	finale_label.text = message
	finale_button.text = str(battle_context.get("finale_button_text", "Tornar ao menu"))
	finale_overlay.visible = true
	finale_overlay.modulate = Color(1.0, 1.0, 1.0, 0.0)
	var fade_tween := create_tween()
	fade_tween.tween_property(finale_overlay, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.45).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_finale_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func _should_show_battle_tutorial() -> bool:
	return not bool(GameState.world_state.get("battle_tutorial_seen", false))


func _show_battle_tutorial() -> void:
	tutorial_pages = [
		"[b]Bem-vindo ao recontro[/b]\nAqui medeis a vossa arte na quadricula. Vencei ao tombar todos os inimigos.\n[i]Enter prossegue  |  Esc salta[/i]",
		"[b]Ordem da ronda[/b]\nNo topo vedeis quem age primeiro. Cada aliado move e age uma vez por ronda.\n[i]Enter prossegue  |  Esc salta[/i]",
		"[b]Comandos[/b]\n1 mover  |  2 golpear  |  3 pocao  |  4 defender\nAs artes especiais surgem na barra de acoes.\n[i]Enter prossegue  |  Esc salta[/i]"
	]
	tutorial_index = 0
	tutorial_active = true
	battle_mode = "tutorial"
	_apply_tutorial_action_highlight(true)
	skill_buttons.visible = false

	if tutorial_overlay == null:
		tutorial_overlay = ColorRect.new()
		tutorial_overlay.name = "TutorialOverlay"
		tutorial_overlay.color = Color(0.0, 0.0, 0.0, 0.78)
		tutorial_overlay.anchor_left = 0.0
		tutorial_overlay.anchor_top = 0.0
		tutorial_overlay.anchor_right = 1.0
		tutorial_overlay.anchor_bottom = 1.0
		tutorial_overlay.offset_left = 0.0
		tutorial_overlay.offset_top = 0.0
		tutorial_overlay.offset_right = 0.0
		tutorial_overlay.offset_bottom = 0.0
		tutorial_overlay.mouse_filter = Control.MOUSE_FILTER_STOP

		var frame := PanelContainer.new()
		frame.anchor_left = 0.5
		frame.anchor_top = 0.5
		frame.anchor_right = 0.5
		frame.anchor_bottom = 0.5
		frame.offset_left = -360.0
		frame.offset_top = -160.0
		frame.offset_right = 360.0
		frame.offset_bottom = 160.0
		frame.add_theme_stylebox_override("panel", _make_panel_style("focus"))
		tutorial_overlay.add_child(frame)

		var layout := VBoxContainer.new()
		layout.add_theme_constant_override("separation", 18)
		layout.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		frame.add_child(layout)

		tutorial_label = RichTextLabel.new()
		tutorial_label.bbcode_enabled = true
		tutorial_label.fit_content = true
		tutorial_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		tutorial_label.scroll_active = false
		tutorial_label.custom_minimum_size = Vector2(620.0, 0.0)
		tutorial_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tutorial_label.add_theme_font_size_override("normal_font_size", 19)
		tutorial_label.add_theme_color_override("default_color", Color("f4ead4"))
		layout.add_child(tutorial_label)

		var button_row := HBoxContainer.new()
		button_row.alignment = BoxContainer.ALIGNMENT_CENTER
		button_row.add_theme_constant_override("separation", 16)
		layout.add_child(button_row)

		tutorial_skip_button = Button.new()
		tutorial_skip_button.custom_minimum_size = Vector2(160.0, 40.0)
		_apply_button_theme(tutorial_skip_button)
		tutorial_skip_button.text = "Saltar"
		tutorial_skip_button.pressed.connect(_on_tutorial_skip_pressed)
		button_row.add_child(tutorial_skip_button)

		tutorial_next_button = Button.new()
		tutorial_next_button.custom_minimum_size = Vector2(200.0, 40.0)
		_apply_button_theme(tutorial_next_button)
		tutorial_next_button.pressed.connect(_on_tutorial_next_pressed)
		button_row.add_child(tutorial_next_button)

		add_child(tutorial_overlay)

	_set_tutorial_page()
	tutorial_overlay.visible = true
	tutorial_overlay.modulate = Color(1.0, 1.0, 1.0, 0.0)
	var fade := create_tween()
	fade.tween_property(tutorial_overlay, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _set_tutorial_page() -> void:
	if tutorial_label == null:
		return
	var clamped_index: int = clampi(tutorial_index, 0, tutorial_pages.size() - 1)
	tutorial_label.text = tutorial_pages[clamped_index]
	if tutorial_next_button != null:
		tutorial_next_button.text = "Entrar em combate" if clamped_index >= tutorial_pages.size() - 1 else "Prosseguir"


func _on_tutorial_next_pressed() -> void:
	tutorial_index += 1
	if tutorial_index >= tutorial_pages.size():
		_finish_battle_tutorial()
		return
	_set_tutorial_page()


func _on_tutorial_skip_pressed() -> void:
	_finish_battle_tutorial()


func _finish_battle_tutorial() -> void:
	tutorial_active = false
	if tutorial_overlay != null:
		tutorial_overlay.visible = false
	_apply_tutorial_action_highlight(false)
	GameState.world_state["battle_tutorial_seen"] = true
	GameState.state_changed.emit()
	_start_round()
