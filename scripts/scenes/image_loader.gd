class_name ImageLoader extends Control


signal file_selected(path: String)

@export var place_holder_texture: Texture

var file_path: String

@onready var texture_rect: TextureRect = $TextureRect
@onready var load_button: Button = $HBoxContainer/LoadButton
@onready var clear_button: Button = $HBoxContainer/ClearButton
@onready var file_dialog: FileDialog = $FileDialog
@onready var path_edit: LineEdit = $HBoxContainer/PathEdit


func _ready() -> void:
	load_button.pressed.connect(_open_explorer)
	clear_button.pressed.connect(_clear)
	file_dialog.file_selected.connect(update_texture_path)
	path_edit.text_submitted.connect(update_texture_path)


func update_texture_path(path: String) -> void:
	file_path = path
	path_edit.text = file_path
	
	if file_path == "":
		texture_rect.texture = place_holder_texture
		return
	
	texture_rect.texture = DataSystem.load_texture(file_path)
	file_selected.emit(file_path)


func _open_explorer() -> void:
	file_dialog.show()


func _clear() -> void:
	texture_rect.texture = place_holder_texture
	file_path = ""
