extends Node2D

var obtainedSpells = ["Punch","Flame"]

var currentSpell = "Punch"
var currentSpellIndex = 0

var punch_spell
var flame_spell

# Called when the node enters the scene tree for the first time.
func _ready():
	punch_spell = $Punch
	flame_spell = $Flame


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_inputs()

func check_inputs():
	if Input.is_action_just_released("spell_next"):
		print("Spell Next Attempted")
		var newSpellIndex = currentSpellIndex + 1
		if newSpellIndex <= obtainedSpells.size() - 1:
			print("Spell Next Accepted")
			currentSpellIndex = newSpellIndex
			currentSpell = obtainedSpells[currentSpellIndex]
			print(currentSpell)
	if Input.is_action_just_released("spell_previous"):
		print("Spell Previous Attempted")
		var newSpellIndex = currentSpellIndex - 1
		if newSpellIndex >= 0:
			print("Spell Previous Accepted")
			currentSpellIndex = newSpellIndex
			currentSpell = obtainedSpells[currentSpellIndex]
			print(currentSpell)
	
	if Input.is_action_pressed("spell_use"):
		handle_spell()

func handle_spell():
	if currentSpell == "Punch":
		punch_spell.punch()
