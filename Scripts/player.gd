extends CharacterBody2D


const SPEED = 150.0
var speed = SPEED

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var animator
var sprite
var state_machine
var wand : Node2D

var shield = 0
var health = 3
var mana = 0
var current_spell
var obtained_spells : Array

func _ready():
	animator = $Sprite/PlayerAnimation
	sprite = $Sprite
	state_machine = $AnimationTree.get("parameters/playback")
	wand = $Sprite/Wand

func _process(delta):
	current_spell = $Sprite/Wand.currentSpell
	obtained_spells = $Sprite/Wand.obtainedSpells

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	if health <= 0:
		get_tree().change_scene_to_file("res://Scenes/GameOverScreen.tscn")
	
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up","move_down")
		
	var movement_vector = (Vector2(direction_x,direction_y) * speed).limit_length(speed)

	velocity = movement_vector
	
	# Animation
	if get_local_mouse_position().x < 0:      # direction_x < 0:
		sprite.scale.x = -1
	elif get_local_mouse_position().x > 0:      # direction_x > 0:
		sprite.scale.x = 1
		
	if movement_vector != Vector2.ZERO:
		state_machine.travel("walk_right")
	else:
		state_machine.travel("idle_right")

	move_and_slide()

func take_damage(damage):
	if (shield > 0):
		shield -= damage
	else:
		health -= damage
		
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite,"modulate",Color.RED,0.1)
	tween.tween_property($Sprite,"modulate",Color.WHITE,0.2)
	#print("Health: " + str(health))
	#print("Shield: " + str(shield))

func get_maxed_spells() -> Array:
	return wand.get_maxed_spells()

func get_spells_next_tiers(spells : Array):
	return wand.get_spells_next_tiers(spells)

func add_spells(spells : Array, maximums : Array):
	var index = 0
	for spell in spells:
		if obtained_spells.has(spell):
			wand.upgrade_spell(spell)
		else:
			wand.add_spell(spell,maximums[index])
		index += 1

func add_spell(spell, maximum_tier):
	if obtained_spells.has(spell):
		wand.upgrade_spell(spell)
	else:
		wand.add_spell(spell,maximum_tier)
