extends Node2D

var wave = 0
var enemies_remaining
var immune_remaining

@export var upper_bound = -100
@export var lower_bound = 350
@export var left_bound = -150
@export var right_bound = 570

var enemy = preload("res://Scenes/enemy.tscn")
var immune = preload("res://Scenes/immune_cell.tscn")

var player
var wave_label
var enemies_label
var immune_label

var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $Player
	wave_label = $HUD/WaveLabel
	enemies_label = $HUD/WaveLabel/EnemiesLabel
	immune_label = $HUD/WaveLabel/ImmuneLabel
	await get_tree().create_timer(5).timeout

	start_wave()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	enemies_remaining = get_tree().get_nodes_in_group("Enemy").size()
	immune_remaining = get_tree().get_nodes_in_group("Immune").size()
	
	if enemies_remaining == 0 && wave != 0:
		start_wave()
		
	wave_label.text = "Wave " + str(wave)
	enemies_label.text = str(enemies_remaining) + " enemies remain"
	immune_label.text = str(immune_remaining) + " immune cells remain"

func start_wave():
	wave += 1
	print("Starting wave " + str(wave))
	random.randomize()
	var enemy_spawn_number = random.randi_range(int(1+(wave/15)),int(3+(wave/10)))
	print("Spawning " + str(enemy_spawn_number) + " enemies")
	for i in range(enemy_spawn_number):
		spawn_enemy(enemy.instantiate())
	
func getRandomPosition() -> Vector2:
	var position = player.global_position
	while position.distance_to(player.global_position) < 50:
		random.randomize()
		var x = random.randf_range(left_bound,right_bound)
		var y = random.randf_range(lower_bound,upper_bound)
		position = Vector2(x,y)
	return position
	

func spawn_enemy(node):
	node.position = getRandomPosition()
	add_child(node)
	print("Spawned enemy at " + str(node.position) + ":")
	print(node)
	random.randomize()
	node.health = round(random.randf_range(1+(wave/10),3+(wave/3)))
	print("Enemy given health: " + str(node.health))
	
func spawn_immune_system():
	var immune_spawn_number = random.randi_range(int(5+(wave/15)),int(10+(wave/10)))
	print("Spawning " + str(immune_spawn_number) + " enemies")
	for i in range(immune_spawn_number):
		spawn_immune(immune.instantiate())

func spawn_immune(node):
	node.position = getRandomPosition()
	add_child(node)
	print("Spawned immune cell at " + str(node.position) + ":")
	print(node)
	random.randomize()
	node.health = round(random.randf_range(5+(wave/11),15+(wave/4)))
	print("Immune cell given health: " + str(node.health))
