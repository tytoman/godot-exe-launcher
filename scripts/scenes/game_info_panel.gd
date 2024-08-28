class_name GameInfoPanel extends AnimatedPanel


signal game_info_changed(info: GameInfo)

@export var info_edit_panel_scene: PackedScene
@export var running_panel_scene: PackedScene
@export var editable: bool = false:
	set(value):
		if value != editable:
			editable = value
			_editable_changed()

var game_info: GameInfo
var thread: Thread

@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var creator_label: Label = $VBoxContainer/CreatorLabel
@onready var description_label: Label = $VBoxContainer/DescriptionLabel
@onready var play_button: Button = $PlayButton
@onready var close_button: Button = $CloseButton
@onready var edit_button: Button = $EditButton
@onready var background: TextureRect = $Background


func _ready() -> void:
	close_button.pressed.connect(disappear)
	play_button.pressed.connect(_run_exe)
	edit_button.pressed.connect(_open_editor)


func setup(info: GameInfo) -> void:
	game_info = info
	title_label.text = info.title
	creator_label.text = info.creator
	description_label.text = info.description
	background.texture = info.screenshot_texture


func _run_exe() -> void:
	var panel := running_panel_scene.instantiate() as AnimatedPanel
	var scene := get_tree().current_scene
	scene.add_child(panel)
	panel.appear(scene)
	
	if game_info.exe_file_path != "":
		thread = Thread.new()
		thread.start(OS.execute.bind(game_info.exe_file_path, []))
		
		while thread.is_alive():
			await get_tree().process_frame
		
		thread.wait_to_finish()
	
	panel.disappear()


func _open_editor() -> void:
	var editor := info_edit_panel_scene.instantiate() as InfoEditPanel
	add_child(editor)
	editor.saved.connect(_on_editor_saved)
	editor.setup(game_info)
	editor.appear(self)


func _on_editor_saved(info: GameInfo) -> void:
	if info:
		setup(info)
		game_info_changed.emit(info)
	else:
		game_info_changed.emit(null)
		disappear()


func _editable_changed() -> void:
	edit_button.visible = editable
