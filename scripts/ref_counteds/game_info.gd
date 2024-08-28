class_name GameInfo extends Resource


@export var key: String
@export var title: String = ""
@export var creator: String = ""
@export_multiline var description: String = ""
@export_global_file var exe_file_path: String = ""
@export_global_file var logo_image_path: String = "":
	set(value):
		if value != logo_image_path:
			logo_image_path = value
			logo_texture = DataSystem.load_texture(logo_image_path)
@export_global_file var cover_image_path: String = "":
	set(value):
		if value != cover_image_path:
			cover_image_path = value
			cover_texture = DataSystem.load_texture(cover_image_path)
@export_global_file var screenshot_image_path: String = "":
	set(value):
		if value != screenshot_image_path:
			screenshot_image_path = value
			screenshot_texture = DataSystem.load_texture(screenshot_image_path)

var logo_texture: Texture
var cover_texture: Texture
var screenshot_texture: Texture


func _init(in_key: String) -> void:
	key = in_key


func reload_textures() -> void:
	logo_texture = DataSystem.load_texture(logo_image_path)
	cover_texture = DataSystem.load_texture(cover_image_path)
	screenshot_texture = DataSystem.load_texture(screenshot_image_path)
