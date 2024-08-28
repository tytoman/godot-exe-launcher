class_name LauncherManager extends Control


signal editable_changed(value: bool)

@export var fill_target: Control
@export var button_container: Control
@export var game_button_scene: PackedScene
@export var info_edit_panel_scene: PackedScene
@export var setting_panel_scene: PackedScene
@export var editable: bool = false:
	set(value):
		if value != editable:
			editable = value
			_on_editable_changed(editable)
			editable_changed.emit(editable)

@onready var add_button: Button = $HBoxContainer/ToolBar/VBoxContainer/AddButton
@onready var setting_button: Button = $HBoxContainer/ToolBar/VBoxContainer/SettingButton


func _ready() -> void:
	DataSystem.check_local_data()
	
	add_button.visible = editable
	add_button.pressed.connect(_open_editor)
	setting_button.pressed.connect(_open_setting)
	
	var all_info := DataSystem.load_all_game_info()
	for info in all_info:
		_generate_button(info)


func _exit_tree() -> void:
	var all_info: Array[GameInfo]
	for child in button_container.get_children():
		if child is not GameButton:
			continue
		
		var button := child as GameButton
		all_info.push_back(button.game_info)
	
	DataSystem.overwrite_all_game_info(all_info)


func _open_editor() -> void:
	add_button.disabled = true
	setting_button.disabled = true
	
	var editor := info_edit_panel_scene.instantiate() as InfoEditPanel
	add_child(editor)
	editor.saved.connect(_generate_button)
	editor.appear(fill_target)
	
	await editor.disappeared
	
	add_button.disabled = false
	setting_button.disabled = false


func _generate_button(info: GameInfo) -> void:
	var button := game_button_scene.instantiate() as GameButton
	button_container.add_child(button)
	button.setup.call_deferred(info)
	editable_changed.connect(func(value: bool) -> void: button.editable = value)
	button.editable = editable
	button.fill_target = fill_target


func _open_setting() -> void:
	add_button.disabled = true
	setting_button.disabled = true
	
	var panel := setting_panel_scene.instantiate() as SettingPanel
	add_child(panel)
	panel.set_editable_toggle(editable)
	panel.editable_changed.connect(func(value: bool) -> void: editable = value)
	panel.appear(fill_target)
	
	await panel.disappeared
	
	add_button.disabled = false
	setting_button.disabled = false


func _on_editable_changed(value: bool) -> void:
	if add_button:
		add_button.visible = value
