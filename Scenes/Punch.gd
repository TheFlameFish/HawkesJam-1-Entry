extends Area2D

var state_machine

var on_cooldown = false
var cooldown_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine = $"../../../AnimationTree".get("parameters/playback")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cooldown_timer -= delta
	on_cooldown = cooldown_timer > 0

func punch():
	if !on_cooldown:
		state_machine.travel("punch")
		var potential_hits = get_overlapping_bodies()
		print(potential_hits)
		
		for object in potential_hits:
			if object.is_in_group("PlayerDamageable") && object.has_method("take_damage"):
				object.take_damage(0.5)
		cooldown_timer = 0.9
