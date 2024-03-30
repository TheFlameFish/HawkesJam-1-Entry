extends Area2D

var tier = 1
var max_damage = 1
var damage = 0.5
var range

var mana = 100
var mana_loss = 20
var mana_gain = 5

var dmg_cooldown = 0
var current_anim = "idle_right"

var enabled = false
var equipped = false

var player
var collider
var display
var particles
var state_machine

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $"../../.."
	collider = $CollisionPolygon2D
	particles = $GPUParticles2D
	state_machine = $"../../../AnimationTree".get("parameters/playback")
	set_range(25)
	display = $Polygon2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	damage = tier
	display.polygon = collider.polygon
	display.transform = collider.transform
	
	
	if enabled && mana > 0 + (mana_loss * delta):
		mana -= mana_loss * delta
	elif mana < 100 - (mana_gain * delta):
		mana += mana_gain * delta
	
	damage = max_damage * (mana / 100)
	
	if equipped:
		player.mana = (mana / 100) * 32
	
func _physics_process(delta):
	look_at(get_global_mouse_position())
	
	dmg_cooldown -= delta
	if dmg_cooldown <= 0:
		apply_damage()
	
func apply_damage():
	var bodies = get_overlapping_bodies()
	if bodies.size() > 0:
		dmg_cooldown = 0.1
	for body in bodies:
		if weakref(body).get_ref() && body.is_in_group("PlayerDamageable") && body.has_method("take_damage"):
			body.take_damage(damage)

func enable():
	enabled = true
	collider.disabled = false
	particles.emitting = true
	state_machine.travel("casting")
	
func disable():
	enabled = false
	collider.disabled = true
	particles.emitting = false
	if current_anim == "casting":
		state_machine.travel("idle_right")
	
func set_range(new_range):
	range = new_range
	var original_polygon = collider.polygon
	collider.polygon = [original_polygon[0],original_polygon[1],
		Vector2(range,original_polygon[2].y),
		Vector2(range,original_polygon[3].y)]
	
	#particles.lifetime = range * (1.41 / 16)
	particles.amount = range * 5
	particles.process_material.initial_velocity_min = range * (30/16)
	particles.process_material.initial_velocity_min = range * (70/16)



#func _on_body_entered(body):
	#print("Flame collided")
	#if body.is_in_group("PlayerDamageable") && body.has_method("take_damage"):
		#body.take_damage(damage)



func _on_animation_tree_animation_started(anim_name):
	current_anim = anim_name
