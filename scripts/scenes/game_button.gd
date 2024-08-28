class_name GameButton extends AnimatedButton


@export var game_info_panel_scene: PackedScene
@export var fill_target: Control
@export var editable: bool = false:
	set(value):
		if value != editable:
			editable = value
			_editable_changed()

var game_info: GameInfo

@onready var title_label: Label = $TitleLabel
@onready var logo_texture: TextureRect = $LogoTexture
@onready var cover_texture: TextureRect = $CoverTexture
@onready var left_button: Button = $LeftButton
@onready var right_button: Button = $RightButton


func _ready() -> void:
	super._ready()
	
	pivot_offset = size * 0.5
	pressed.connect(_on_pressed)
	left_button.pressed.connect(_move.bind(-1))
	right_button.pressed.connect(_move.bind(1))


func setup(info: GameInfo) -> void:
	game_info = info
	title_label.text = info.title
	logo_texture.texture = info.logo_texture
	cover_texture.texture = info.cover_texture


func _on_pressed() -> void:
	var panel := game_info_panel_scene.instantiate() as GameInfoPanel
	get_tree().current_scene.add_child(panel)
	panel.set_deferred("size", size)
	panel.global_position = global_position
	panel.modulate.a = 0.0
	panel.pivot_offset = fill_target.size * 0.5
	panel.editable = editable
	panel.setup(game_info)
	panel.game_info_changed.connect(_on_info_changed)
	panel.appear(fill_target)


func _on_info_changed(info: GameInfo) -> void:
	if info:
		setup(info)
	else:
		queue_free()


func _editable_changed() -> void:
	left_button.visible = editable
	right_button.visible = editable


func _move(direction: int) -> void:
	get_parent().move_child(self, get_index() + direction)	
