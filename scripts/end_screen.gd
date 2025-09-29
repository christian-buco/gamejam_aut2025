extends Control

@onready var animation_player: AnimationPlayer = $SceneTransitionAnimation/AnimationPlayer

func _ready() -> void:
	animation_player.get_parent().get_node("ColorRect").color.a = 255
	animation_player.play("fade_out")
