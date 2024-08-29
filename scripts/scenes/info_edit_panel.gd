class_name InfoEditPanel extends AnimatedPanel


signal saved(info: GameInfo)

var game_info: GameInfo

@onready var title_edit: LineEdit = $VBoxContainer/HBoxContainer/VBoxContainer/TitleEdit
@onready var creator_edit: LineEdit = $VBoxContainer/HBoxContainer/VBoxContainer/CreatorEdit
@onready var description_edit: TextEdit = $VBoxContainer/HBoxContainer/VBoxContainer/DescriptionEdit
@onready var logo_loader: ImageLoader = $VBoxContainer/HBoxContainer/VBoxContainer2/LogoLoader
@onready var cover_loader: ImageLoader = $VBoxContainer/HBoxContainer/VBoxContainer2/CoverLoader
@onready var screenshot_loader: ImageLoader = $VBoxContainer/HBoxContainer/VBoxContainer2/ScreenshotLoader
@onready var exe_file_edit: LineEdit = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/ExeFileEdit
@onready var select_button: Button = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/SelectButton
@onready var file_dialog: FileDialog = $FileDialog
@onready var cancel_button: Button = $VBoxContainer/Buttons/CancelButton
@onready var save_button: Button = $VBoxContainer/Buttons/SaveButton
@onready var delete_button: Button = $VBoxContainer/Buttons/DeleteButton


func _ready() -> void:
	save_button.pressed.connect(_save)
	cancel_button.pressed.connect(disappear)
	delete_button.pressed.connect(_delete_data)
	select_button.pressed.connect(_open_file_dialog)
	file_dialog.file_selected.connect(_on_file_selected)
	modulate.a = 0
	delete_button.hide()


func setup(info: GameInfo) -> void:
	game_info = info
	title_edit.text = info.title
	creator_edit.text = info.creator
	description_edit.text = info.description
	exe_file_edit.text = info.exe_file_path
	logo_loader.update_texture_path(info.logo_image_path)
	cover_loader.update_texture_path(info.cover_image_path)
	screenshot_loader.update_texture_path(info.screenshot_image_path)
	
	if game_info:
		delete_button.show()


func _save() -> void:
	var key := game_info.key if game_info else str(get_instance_id())
	var info := GameInfo.new(key)
	info.title = title_edit.text
	info.creator = creator_edit.text
	info.description = description_edit.text
	info.exe_file_path = exe_file_edit.text
	info.logo_image_path = logo_loader.file_path
	info.cover_image_path = cover_loader.file_path
	info.screenshot_image_path = screenshot_loader.file_path
	DataSystem.save_game_info(info)
	saved.emit(info)
	disappear()


func _open_file_dialog() -> void:
	file_dialog.show()


func _on_file_selected(path: String) -> void:
	exe_file_edit.text = path


func _delete_data() -> void:
	if not game_info:
		return
	
	DataSystem.delete_game_info(game_info.key)
	
	saved.emit(null)
	disappear()
