extends TextureRect

signal spell_selected(spell : String, is_event : bool)

var spells = ["Flame"]
var isEvent = [false]

var button1
var button2
var button3

var button1_spell
var button2_spell
var button3_spell

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

func updateButton(button : TextureButton, spell : String):
	pass
