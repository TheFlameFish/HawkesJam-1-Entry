extends TextureRect

var normal_pos = Vector2(364,468)
var vanish_pos = Vector2(364,664)

func _ready():
	visible = false
	position = vanish_pos
	
func vanish():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",vanish_pos,0.3).set_trans(Tween.TRANS_SINE)
	visible = false

func appear():
	visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",normal_pos,0.3).set_trans(Tween.TRANS_SINE)
