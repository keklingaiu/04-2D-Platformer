extends Node2D

onready var Player = load("res://Player/Player.tscn")
var starting_position = Vector2(200,200)
onready var respawn = get_node("/root/Game/Player_Container/Backup_Camera")



func _ready():
	pass


func _physics_process(_delta):
	if not has_node("Player"):
		var player = Player.instance()
		player.position = Vector2(respawn.position.x, respawn.position.y)
		add_child(player)
