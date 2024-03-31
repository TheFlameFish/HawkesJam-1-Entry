extends Area2D

var state_machine
var player

var on_cooldown = false
var cooldown_timer = 0

var equipped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine = $"../../../AnimationTree".get("parameters/playback")
	player = $"../../.."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cooldown_timer -= delta
	on_cooldown = cooldown_timer > 0
	
	if equipped:
		player.mana = -((cooldown_timer / 0.9) * 32) + 32
	
	if (cooldown_timer > 0):
		player.speed = 100
	else:
		player.speed = player.SPEED

func punch():
	if !on_cooldown:
		state_machine.travel("punch")
		var potential_hits = get_overlapping_bodies()

		
		for object in potential_hits:
			if object.is_in_group("PlayerDamageable") && object.has_method("take_damage"):
				object.take_damage(0.5)
		cooldown_timer = 0.9
