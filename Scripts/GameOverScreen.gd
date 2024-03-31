extends CanvasLayer

var lose_sfx : AudioStreamPlayer

func _ready():
	lose_sfx = $LoseSFX
	lose_sfx.play()
	
	$PanelContainer/MarginContainer/Rows/GameOver/ScoreLabel.text = "Score: " + str(Global.score)

func _on_restart_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")



func _on_exit_pressed():
	get_tree().quit()
