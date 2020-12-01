extends Area2D

onready var global = get_node("/root/Global")


func _on_Exit_body_entered(body):
	if body.name == "Player":
		if name == "Exit_to_2":
			Global.level = 1
			global.score += 100
#		if name == "Exit_to_3":
#			Global.level = 2
#			global.score += 200
			
		if Global.level < Global.levels.size():
			get_tree().change_scene(Global.levels[Global.level])
		else:
			global.score += 200
			get_tree().change_scene("res://Menu/GameOver.tscn")
