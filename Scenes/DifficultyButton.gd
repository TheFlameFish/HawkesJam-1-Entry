extends Button

var difficulty_index = 2
var difficulties = [0.1,0.5,1,2,5,10]
var difficulty_names = ["Cakewalk","Easy","Normal","Hard","Nightmare","Suffering"]

# Called when the node enters the scene tree for the first time.
func _ready():
	difficulty_index = difficulties.find(Global.difficulty)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = " Difficulty: \n" + str(difficulty_names[difficulty_index])
	Global.difficulty = difficulties[difficulty_index]

func _on_pressed():
	if difficulty_index + 1 > difficulties.size() - 1:
		difficulty_index = 0
	else:
		difficulty_index += 1
