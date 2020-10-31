extends Node2D

onready var Player = load("res://Player/Player.tscn")
onready var respawn = get_node("/root/Game/Player_Container/Backup_Camera")



func _ready():
	pass


func _physics_process(_delta):
	var player = get_node_or_null("Player")
	if player == null:
		spawn(Vector2(respawn.position.x, respawn.position.y))
		
func spawn(p):
	var player = Player.instance()
	player.position = p
	player.name = "Player"
	add_child(player)
