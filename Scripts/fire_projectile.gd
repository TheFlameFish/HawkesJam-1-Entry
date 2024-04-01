extends Area2D

var time : float = 2
var speed: float = 200
var damage : float = 10

var sprite : AnimatedSprite2D
var collider : CollisionShape2D
var timer : Timer
var audio_player : AudioStreamPlayer2D

var firing : bool = false

func _ready():
	sprite = $AnimatedSprite2D
	collider = $CollisionShape2D
	timer = $Timer
	audio_player = $AudioStreamPlayer2D

func _physics_process(delta):
	if firing:
		translate(self.global_transform.basis_xform(Vector2.UP) * speed * delta)

func fire():
	sprite.visible = true
	collider.disabled = false
	timer.start(time)
	audio_player.play()
	firing = true
	#while firing == true and await get_tree().idle_frame:
		#translate(self.global_transform.basis_xform(Vector2.UP))
		#translate(transform.y)

func _on_timer_timeout():
	var scale_tween = get_tree().create_tween()
	scale_tween.tween_property(self,"scale",Vector2.ZERO,1).set_trans(Tween.TRANS_SINE)
	
	var volume_tween = get_tree().create_tween()
	volume_tween.tween_property(audio_player,"volume_db",-50,1)
	
	var speed_tween = get_tree().create_tween()
	speed_tween.tween_property(self,"speed",0,1.5)
	speed_tween.tween_callback(queue_free)

func _on_body_entered(body):
	if weakref(body).get_ref() && body.is_in_group("PlayerDamageable") && body.has_method("take_damage"):
			body.take_damage(damage)
