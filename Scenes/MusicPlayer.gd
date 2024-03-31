extends Node

var battle_intro : AudioStreamPlayer
var battle_loop : AudioStreamPlayer

var playing_battle = false

func _ready():
	battle_intro = $BattleIntro
	battle_loop = $BattleLoop

func play_battle():
	playing_battle = true
	battle_intro.play()

func stop_battle():
	playing_battle = false
	battle_intro.stop()
	battle_loop.stop()
	
func stop_all():
	stop_battle()

func _on_battle_intro_finished():
	if playing_battle:
		battle_loop.play()
