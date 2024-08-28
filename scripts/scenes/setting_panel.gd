class_name SettingPanel extends AnimatedPanel


signal editable_changed(value: bool)

@onready var editable_button: CheckButton = $HBoxContainer/SettingContainer/EditableButton
@onready var close_button: Button = $HBoxContainer/SettingContainer/CloseButton
@onready var open_button: Button = $HBoxContainer/SettingContainer/OpenButton
@onready var quit_button: Button = $HBoxContainer/SettingContainer/QuitButton


func _ready() -> void:
	close_button.pressed.connect(disappear)
	editable_button.toggled.connect(editable_changed.emit)
	open_button.pressed.connect(_open_location)
	quit_button.pressed.connect(get_tree().quit)
	
	open_button.visible = OS.get_name() == "Windows"


func set_editable_toggle(value: bool) -> void:
	editable_button.button_pressed = value


func _open_location() -> void:
	var path := DataSystem.get_data_dir()
	
	match OS.get_name():
		"Windows":
			path = path.replace("/", "\\")
			OS.create_process("powershell", ["explorer.exe", path])
		_:
			pass
