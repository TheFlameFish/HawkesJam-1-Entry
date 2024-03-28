extends CharacterBody2D


const SPEED = 150.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var animator
var state 

func _ready():
	animator = $Sprite/PlayerAnimation
	state = "Idle"

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up","move_down")
		
	var movement_vector = (Vector2(direction_x,direction_y) * SPEED).limit_length(SPEED)

	velocity = movement_vector
	
	# Animation
	

	move_and_slide()
