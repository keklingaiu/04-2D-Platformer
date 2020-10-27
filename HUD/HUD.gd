extends Control

onready var global = get_node("/root/Global")

func _ready():
	update_score(0)
	update_lives(0)
	
	
func update_score(s):
	global.score += s
	$Score.text = "Score: " + str(global.score)
	
	
func update_lives(l):
	global.lives += l
	$Lives.text = "Lives: " + str(global.lives)
	if global.lives <= 0:
		get_tree().change_scene("res://Menu/GameOver.tscn")
