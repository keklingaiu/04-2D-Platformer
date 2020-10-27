extends Area2D

onready var global = get_node("/root/Global")


func _on_Exit_body_entered(body):
	if body.name == "Player":
		if name == "Exit_to_2":
			global.score += 100
			var _target = get_tree().change_scene("res://Levels/Level2.tscn")
		if name == "Exit_to_3":
			global.score += 200
			var _target = get_tree().change_scene("res://Levels/Level3.tscn")
		if name == "Exit_to_4":
			global.score += 300
			var _target = get_tree().change_scene("res://Levels/Game_Over.tscn")
