class_name AnimatedButton extends Button


@export var anim_duration: float = 0.2
@export var expand_scale: float = 1.03
@export var ease_type: Tween.EaseType = Tween.EASE_OUT
@export var trans_type: Tween.TransitionType = Tween.TRANS_CIRC
@export var shiny: ColorRect

var _scale_tween: Tween


func _ready() -> void:
	mouse_entered.connect(expand)
	mouse_exited.connect(shrink)


func expand() -> void:
	if _scale_tween:
		_scale_tween.kill()
	
	_scale_tween = get_tree().create_tween()
	_scale_tween.set_ease(ease_type)
	_scale_tween.set_trans(trans_type)
	_scale_tween.set_parallel()
	_scale_tween.tween_property(self, "scale", Vector2.ONE * expand_scale, anim_duration)
	
	var shiny_tween := get_tree().create_tween()
	shiny_tween.tween_method(_set_shiny_offset, -0.3, 1.8, anim_duration * 2.0)


func shrink() -> void:
	if _scale_tween:
		_scale_tween.kill()
	
	_scale_tween = get_tree().create_tween()
	_scale_tween.set_ease(ease_type)
	_scale_tween.set_trans(trans_type)
	_scale_tween.tween_property(self, "scale", Vector2.ONE, anim_duration)


func _set_shiny_offset(value: float) -> void:
	if not shiny:
		return
	
	shiny.material.set_shader_parameter("offset", value)
