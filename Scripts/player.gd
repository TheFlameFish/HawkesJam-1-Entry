extends CharacterBody2D


const SPEED = 150.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var animator
var sprite
var state_machine

var shield = 0
var health = 3
var current_spell
var obtained_spells

func _ready():
	animator = $Sprite/PlayerAnimation
	sprite = $Sprite
	state_machine = $AnimationTree.get("parameters/playback")

func _process(delta):
	current_spell = $Sprite/Wand.currentSpell
	obtained_spells = $Sprite/Wand.obtainedSpells

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up","move_down")
		
	var movement_vector = (Vector2(direction_x,direction_y) * SPEED).limit_length(SPEED)

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
	#print("Health: " + str(health))
	#print("Shield: " + str(shield))
