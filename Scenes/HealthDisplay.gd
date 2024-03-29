extends Control

var health
var shield

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $"../../Player"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health = player.health
	shield = player.shield
	
	update($"Heart1",1)
	update($"Heart2",2)
	update($"Heart3",3)

func update(heart,number):
	if (shield >= number):
		heart.set_status("shield")
	elif (health >= number):
		heart.set_status("default")
	else:
		heart.set_status("dead")
