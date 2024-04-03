extends Node2D

var obtainedSpells = ["Punch"]
var tiers = [1]
var max_tiers = [1]

var currentSpell = "Punch"
var currentSpellIndex = 0

var player : CharacterBody2D
var punch_spell : Area2D
var flame_spell : Area2D
var fireball_spell : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	punch_spell = $Punch
	flame_spell = $Flame
	fireball_spell = $Fireball
	player = $"../.."
	
	if Global.difficulty < 1:
		add_spell("Flame",3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_inputs()
	player.obtained_spells = obtainedSpells

func check_inputs():
	if Input.is_action_just_released("spell_next"):
		print("Spell Next Attempted")
		var newSpellIndex = currentSpellIndex + 1
		if newSpellIndex <= obtainedSpells.size() - 1:
			print("Spell Next Accepted")
			currentSpellIndex = newSpellIndex
			currentSpell = obtainedSpells[currentSpellIndex]
		else:
			currentSpellIndex = 0
			currentSpell = obtainedSpells[currentSpellIndex]
		print(currentSpell)
	if Input.is_action_just_released("spell_previous"):
		print("Spell Previous Attempted")
		var newSpellIndex = currentSpellIndex - 1
		if newSpellIndex >= 0:
			print("Spell Previous Accepted")
			currentSpellIndex = newSpellIndex
			currentSpell = obtainedSpells[currentSpellIndex]
		else:
			currentSpellIndex = obtainedSpells.size() - 1
			currentSpell = obtainedSpells[currentSpellIndex]
		print(currentSpell)
	
	notify_equipped()
	
	if Input.is_action_pressed("spell_use"):
		handle_spell()
	else:
		disable_spells()

func handle_spell():
	if currentSpell == "Punch":
		punch_spell.punch()
	elif currentSpell == "Flame":
		flame_spell.enable()
	elif currentSpell == "Fireball":
		fireball_spell.fire()
	
func disable_spells():
	flame_spell.disable()

func notify_equipped():
	punch_spell.equipped = false
	flame_spell.equipped = false
	fireball_spell.equipped = false
	
	if currentSpell == "Punch":
		punch_spell.equipped = true
	elif currentSpell == "Flame":
		flame_spell.equipped = true
		flame_spell.tier = tiers[currentSpellIndex]
	elif currentSpell == "Fireball":
		fireball_spell.equipped = true
		fireball_spell.tier = tiers[currentSpellIndex]
	

func get_maxed_spells() -> Array:
	var maxed_spells : Array = []
	var index = 0
	for spell in obtainedSpells:
		if tiers[index] >= max_tiers[index]:
			maxed_spells.append(spell)
		index += 1
	return maxed_spells

func get_spells_next_tiers(spells):
	var index = 0
	var next_tiers : Array = []
	for spell in spells:
		var spell_index = obtainedSpells.find(spell)
		if spell_index != -1:
			next_tiers.append(tiers[spell_index]+1)
		else:
			next_tiers.append(1)
		index += 1
	return next_tiers
	
func add_spell(spell, max_tier):
	obtainedSpells.append(spell)
	max_tiers.append(max_tier)
	tiers.append(1)
	
func upgrade_spell(spell):
	tiers[obtainedSpells.find(spell)] += 1
	
static func subtract(a: Array, b: Array) -> Array:
	var result := []
	var bag := {}
	for item in b:
		if not bag.has(item):
			bag[item] = 0
		bag[item] += 1
	for item in a:
		if bag.has(item):
			bag[item] -= 1
			if bag[item] == 0:
				bag.erase(item)
		else:
			result.append(item)
	return result
