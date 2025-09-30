extends Control

@onready var animation_player: AnimationPlayer = $SceneTransitionAnimation/AnimationPlayer
@onready var h_box_container: HBoxContainer = $HBoxContainer


func _ready() -> void:
	animation_player.get_parent().get_node("ColorRect").color.a = 255
	animation_player.play("fade_out")
	await get_tree().create_timer(1.5).timeout
	h_box_container.visible = true


func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
