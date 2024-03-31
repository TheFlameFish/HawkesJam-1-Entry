extends Node2D

var wave = 0
var enemies_remaining
var immune_remaining

var available_spells
var available_spells_tiers
var spells = ["Punch","Flame","Heal","Shield","Immune"]
var spell_maximums = [1,3]

@export var upper_bound = -100
@export var lower_bound = 350
@export var left_bound = -150
@export var right_bound = 570

var enemy = preload("res://Scenes/enemy.tscn")
var immune = preload("res://Scenes/immune_cell.tscn")

var player
var spell_selection_ui
var wave_label
var enemies_label
var immune_label

var waiting_for_spell_selection = false

var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $Player
	spell_selection_ui = $HUD/SpellSelection
	wave_label = $HUD/WaveLabel
	enemies_label = $HUD/WaveLabel/EnemiesLabel
	immune_label = $HUD/WaveLabel/ImmuneLabel
	await get_tree().create_timer(5).timeout

	start_wave()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	enemies_remaining = get_tree().get_nodes_in_group("Enemy").size()
	immune_remaining = get_tree().get_nodes_in_group("Immune").size()
	
	if enemies_remaining == 0 && wave != 0 && !waiting_for_spell_selection:
		waiting_for_spell_selection = true
		await spell_selection()
		start_wave()
		waiting_for_spell_selection = false
		
	wave_label.text = "Wave " + str(wave)
	enemies_label.text = str(enemies_remaining) + " enemies remain"
	if immune_remaining > 0:
		immune_label.text = str(immune_remaining) + " immune cells remain"
	else:
		immune_label.text = ""

func start_wave():
	wave += 1
	print("Starting wave " + str(wave))
	random.randomize()
	var enemy_spawn_number = random.randi_range(int(1+(wave/10)),int(3+(wave/5)))
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
	node.health = round(random.randf_range(1+(wave/7),3+(wave/2)))
	print("Enemy given health: " + str(node.health))
	
func spawn_immune_system():
	var immune_spawn_number = random.randi_range(int(1+(wave/15)),int(2+(wave/10)))
	print("Spawning " + str(immune_spawn_number) + " enemies")
	for i in range(immune_spawn_number):
		spawn_immune(immune.instantiate())

func spawn_immune(node):
	node.position = getRandomPosition()
	add_child(node)
	print("Spawned immune cell at " + str(node.position) + ":")
	print(node)
	random.randomize()
	node.health = round(random.randf_range(1+(wave/11),5+(wave/4)))
	print("Immune cell given health: " + str(node.health))

func spell_selection():
	print("Spell Selection Begin")
	available_spells = subtract(spells,player.get_maxed_spells())
	print(player.get_maxed_spells())
	available_spells_tiers = player.get_spells_next_tiers(available_spells)

	
	spell_selection_ui.setup(available_spells, available_spells_tiers)
	spell_selection_ui.appear()
	
	var selected_spell = await spell_selection_ui.spell_selected
	var selected_spell_index = spells.find(selected_spell)
	
	if (selected_spell == "Heal"):
		player.health = 3
	elif (selected_spell == "Shield"):
		player.shield = 3
	elif (selected_spell == "Immune"):
		spawn_immune_system()
	else:
		player.add_spell(selected_spell,spell_maximums[selected_spell_index])
	
	spell_selection_ui.vanish()
	print("Spell Selection End")

static func subtract(a: Array, b: Array) -> Array:
	var result := []
	var bag := {}
	for item in b:
		if not bag.has(item):
			bag[item] = 0
		bag[item] += 1
	for item in a:
		if bag.has(item):
			bag[item] -= 1
			if bag[item] == 0:
				bag.erase(item)
		else:
			result.append(item)
	return result
