extends TextureRect

signal spell_selected(spell : String)

var spells = ["Flame"]
var tiers = [1]

var button1: TextureButton
var button2: TextureButton
var button3: TextureButton

var button1_spell
var button2_spell
var button3_spell

var normal_pos = Vector2(364,468)
var vanish_pos = Vector2(364,664)

var random = RandomNumberGenerator.new()

func _ready():
	visible = false
	position = vanish_pos
	
	button1 = $Control/Option1
	button2 = $Control/Option2
	button3 = $Control/Option3



func vanish():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",vanish_pos,0.3).set_trans(Tween.TRANS_SINE)
	visible = false

func appear():
	visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",normal_pos,0.3).set_trans(Tween.TRANS_SINE)

func setup(available_spells: Array,available_spells_tiers: Array):
	spells = available_spells
	tiers = available_spells_tiers
	
	random.randomize()
	
	button1_spell = random.randi_range(0, (spells.size() - 1))
	updateButton(button1,spells[button1_spell],tiers[button1_spell])
	
	button2_spell = random.randi_range(0, (spells.size() - 1))
	updateButton(button2,spells[button2_spell],tiers[button2_spell])
	
	button3_spell = random.randi_range(0, (spells.size() - 1))
	updateButton(button3,spells[button3_spell],tiers[button3_spell])
	

func updateButton(button : TextureButton, spell : String, tier : int):
	if (spell == "Flame"):
		button.texture_normal = ResourceLoader.load("res://Textures/spell_icons/Flame_Icon.png")
		button.tooltip_text = "Active Spell : Tier " + str(tier) + "
			Holding down the mouse produces a flame that deals damage in a cone. 
			The range and damage is based on tier and mana."



func _on_option_1_pressed():
	spell_selected.emit(spells[button1_spell])

func _on_option_2_pressed():
	spell_selected.emit(spells[button2_spell])

func _on_option_3_pressed():
	spell_selected.emit(spells[button3_spell])
