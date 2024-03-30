extends CharacterBody2D

const SPEED = 100
var speed
var max_health = 0
@export var health = 1
var target
var health_bar
var health_label
var hitbox

var cooldown = 0

var state_machine

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar = $TextureProgressBar
	health_label = $TextureProgressBar/Label
	hitbox = $DamageHitbox
	speed = SPEED
	state_machine = $AnimationTree.get("parameters/playback")
	await get_tree().create_timer(0.1).timeout
	max_health = health

func _process(delta):
	health_bar.value = (round_to_dec(health,2) * 100)
	health_bar.max_value = (max_health * 100)
	
	health_label.text = str(round_to_dec(health,2) * 100) + "/" + str(max_health * 100)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (health <= 0):
		queue_free()
	
	target = find_target()
	
	if target != null:
		var difference = Vector2(target.position - position)
		velocity = difference.normalized() * speed
		
		if (difference.x > 0):
			$Sprite2D.flip_h = 0
		elif (difference.x < 0):
			$Sprite2D.flip_h = 1
	
	cooldown -= delta
	if cooldown <= 0:
		apply_damage()
	
	move_and_slide()
	
func find_target():
	var all_targets = get_tree().get_nodes_in_group("EnemyTarget")
	var closest_target = null
	
	if (all_targets.size() > 0):
		closest_target = all_targets[0]
		for target in all_targets:
			var distance_to_target = global_position.distance_squared_to(target.global_position)
			var distance_to_closest_target = global_position.distance_squared_to(closest_target.global_position)
			if (distance_to_target < distance_to_closest_target):
				closest_target = target
		
	return closest_target

func apply_damage():
	var bodies = hitbox.get_overlapping_bodies()
	if bodies.size() > 0:
		cooldown = 1.6
	for body in bodies:
		if weakref(body).get_ref() && body.is_in_group("EnemyTarget") && body.has_method("take_damage"):
			body.take_damage(1)
			speed = 0
			state_machine.travel("wiggle_slow")
			await get_tree().create_timer(1.6).timeout
			speed = SPEED


#func _on_damage_hitbox_body_entered(body):
	#if body.is_in_group("EnemyTarget") && body.has_method("take_damage"):
		#body.take_damage(1)
		#speed = 0
		#state_machine.travel("wiggle_slow")
		#await get_tree().create_timer(1.6).timeout
		#speed = SPEED

func take_damage(damage):
	health -= damage
	print(health)

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
