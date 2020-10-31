extends Node




var fade = null
var fade_speed = 0.015
var lives = 5
var score = 0
var level = 0

var fade_in = false
var fade_out = ""

var death_zone = 1000

var saves = [
	"user://game-data_0.json"
]

var levels = [
	"res://Levels/Level1.tscn"
	,"res://Levels/Level2.tscn"
]

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func _physics_process(_delta):
	if fade == null:
		fade = get_node_or_null("/root/Game/Camera/Fade")
	if fade_out != "":
		execute_fade_out(fade_out)
	if fade_in:
		execute_fade_in()
		
func reset():
	lives = 5
	score = 0
		

func start_fade_in():
	if fade != null:
		fade.visible = true
		fade.color.a = 1
		fade_in = true

func start_fade_out(target):
	if fade != null:
		fade.color.a = 0
		fade.visible = true
		fade_out = target

func execute_fade_in():
	if fade != null:
		fade.color.a -= fade_speed
		if fade.color.a <= 0:
			fade_in = false

func execute_fade_out(target):
	if fade != null:
		fade.color.a += fade_speed
		if fade.color.a >= 1:
			fade_out = ""
			

		
func _input(event):
	if event.is_action_pressed("menu"):
		var menu = get_node_or_null("/root/Game/CanvasLayer/Menu")
		if menu != null:
			var p = get_tree().paused
			if p:
				menu.hide()
				get_tree().paused = false
			else:
				menu.show()
				get_tree().paused = true
				
		
func get_save_data():
	var data = {
		"score":score
		,"lives":lives
		,"level":level
		,"player":""
		,"enemy_ground":[]
		,"enemy_flying":[]
		,"coins":[]
	}
	var player = get_node_or_null("/root/Game/Player_Container/Player")
	if player != null:
		data["player"] = var2str(player.position)
	var enemies = get_node("/root/Game/Enemy_Container").get_children()
	for e in enemies:
		if e.is_in_group("Enemy_Ground"):
			var temp = {"position":var2str(e.position), "max_constraint": e.max_constraint, "min_constraint":e.min_constraint}
			data["enemy_ground"].append(temp)
		if e.is_in_group("Enemy_Flying"):
			var temp = {"position":var2str(e.position)}
			data["enemy_flying"].append(temp)
	var coins = get_node("/root/Game/Coin_Container").get_children()
	for c in coins:
		var temp = {"position":var2str(c.position), "score":c.score}
		data["coins"].append(temp)
	print(data)
	return data
	
func load_save_level(data):
	score = data["score"]
	lives = data["lives"]
	level = data["level"]
	
	get_tree().change_scene(levels[level])
	call_deferred("load_save_data", data)
	
func load_save_data(data):
	var menu = get_node_or_null("/root/Game/CanvasLayer/Menu")
	if menu != null:
		menu.show()
	
	if data["player"] != "":
		var player = get_node_or_null("/root/Game/Player_Container/Player")
		if player != null:
			player.name = "Player2"
			player.queue_free()
		get_node("/root/Game/Player_Container").spawn(str2var(data["player"]))
	var enemy_container = get_node("/root/Game/Enemy_Container")
	for e in enemy_container.get_children():
		e.queue_free()
	for e in data["enemy_ground"]:
		var attr = {"max_constraint":e["max_constraint"], "min_constraint":e["min_constraint"]}
		enemy_container.spawn("Enemy_Ground", attr, str2var(e["position"]))
	for e in data["enemy_flying"]:
		var attr = {}
		enemy_container.spawn("Enemy_Flying", attr, str2var(e["position"]))
	
	var coint_container = get_node("/root/Game/Coin_Container")
	for c in coint_container.get_children():
		c.queue_free()
	for c in data["coins"]:
		var attr = {"score":c["score"]}
		coint_container.spawn(attr, str2var(c["position"]))

func save_game(which_file):
	var file = File.new()
	var data = get_save_data()
	file.open(saves[which_file], File.WRITE)	
	file.store_string(to_json(data))
	file.close()
	
func load_game(which_file):
	var file = File.new()
	if file.file_exists(saves[which_file]):
		file.open(saves[which_file], File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			load_save_level(data)
		else:
			print("Corrupted data")
	else:
		print("No saved data")

