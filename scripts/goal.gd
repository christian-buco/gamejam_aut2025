extends Area2D

@onready var animation_player: AnimationPlayer = $"../SceneTransitionAnimation/AnimationPlayer"

func _on_body_entered(body: Node2D) -> void:
	animation_player.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/end_screen.tscn")
