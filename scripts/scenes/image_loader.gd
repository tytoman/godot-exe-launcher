class_name ImageLoader extends Control


signal file_selected(path: String)

@export var place_holder_texture: Texture

var file_path: String

@onready var texture_rect: TextureRect = $TextureRect
@onready var load_button: Button = $HBoxContainer/LoadButton
@onready var clear_button: Button = $HBoxContainer/ClearButton
@onready var file_dialog: FileDialog = $FileDialog


func _ready() -> void:
	load_button.pressed.connect(_on_load_button_pressed)
	clear_button.pressed.connect(_on_clear_button_pressed)
	file_dialog.file_selected.connect(update_texture)


func update_texture(path: String) -> void:
	file_path = path
	if file_path == "":
		texture_rect.texture = place_holder_texture
		return
	texture_rect.texture = DataSystem.load_texture(file_path)
	file_selected.emit(file_path)


func _on_load_button_pressed() -> void:
	file_dialog.show()


func _on_clear_button_pressed() -> void:
	texture_rect.texture = place_holder_texture
	file_path = ""
