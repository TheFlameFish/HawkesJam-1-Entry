extends Area2D

var tier = 1
var damage = 1
var range

var collider
var display
var particles

# Called when the node enters the scene tree for the first time.
func _ready():
	collider = $CollisionPolygon2D
	particles = $GPUParticles2D
	set_range(25)
	display = $Polygon2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	damage = tier
	display.polygon = collider.polygon
	display.transform = collider.transform
	
func _physics_process(delta):
	look_at(get_global_mouse_position())
	
func enable():
	collider.disabled = false
	particles.emitting = true
	
func disable():
	collider.disabled = true
	particles.emitting = false
	
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



func _on_body_entered(body):
	print("Flame collided")
	if body.is_in_group("PlayerDamageable") && body.has_method("take_damage"):
		body.take_damage(damage)
