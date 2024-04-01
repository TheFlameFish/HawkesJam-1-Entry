extends CanvasLayer

func _ready():
	pass

func _on_restart_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")



func _on_exit_pressed():
	get_tree().quit()
