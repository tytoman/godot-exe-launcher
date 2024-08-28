class_name AnimatedPanel extends Control


signal appeared()
signal disappeared()

@export var appear_duration: float = 0.2
@export var disappear_duration: float = 0.15
@export var ease_type: Tween.EaseType = Tween.EASE_OUT
@export var trans_type: Tween.TransitionType = Tween.TRANS_CIRC
@export var destroy_on_disappear: bool = true


func appear(fill_target: Control = null) -> void:
	modulate.a = 0.0
	show()
	var tween := get_tree().create_tween()
	tween.set_parallel()
	tween.set_ease(ease_type)
	tween.set_trans(trans_type)
	tween.tween_property(self, "modulate:a", 1.0, appear_duration)
	
	if fill_target:
		pivot_offset = fill_target.size * 0.5
		tween.tween_property(self, "size", fill_target.size, appear_duration)
		tween.tween_property(self, "global_position", fill_target.global_position, appear_duration)
	else:
		pivot_offset = size * 0.5
	
	await tween.finished
	appeared.emit()


func disappear() -> void:
	var tween := get_tree().create_tween()
	tween.set_parallel()
	tween.set_ease(ease_type)
	tween.set_trans(trans_type)
	tween.tween_property(self, "modulate:a", 0.0, disappear_duration)
	tween.tween_property(self, "scale", Vector2.ONE * 0.95, disappear_duration)
	tween.set_parallel(false)
	
	if destroy_on_disappear:
		tween.tween_callback(queue_free)
	else:
		tween.tween_callback(hide)
	
	await tween.finished
	
	disappeared.emit()
