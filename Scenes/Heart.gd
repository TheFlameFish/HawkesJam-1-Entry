extends Sprite2D

var state_machine

# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine = $AnimationTree.get("parameters/playback")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_status(status):
	if status == "default":
		state_machine.travel("Default")
	elif status == "dead":
		state_machine.travel("Decay")
	elif status == "shield":
		state_machine.travel("Shielded")
