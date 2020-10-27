extends Area2D

onready var HUD = get_node("/root/Game/CanvasLayer/HUD")

export var score = 100

func _ready():
	pass # Replace with function body.


func _on_Coin_body_entered(body):
	if body.name == "Player":
		HUD.update_score(score)
		queue_free()
