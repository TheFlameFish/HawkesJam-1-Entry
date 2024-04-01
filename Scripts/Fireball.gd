extends Node2D

var fire_projectile_resource = preload("res://Scenes/fire_projectile.tscn")

var player : CharacterBody2D

var equipped : bool = false

var speed : float = 200
var lifetime : float = 2
var cooldown_time: float = 10
var cooldown : float = 10
var tier : int = 1

func _ready():
	player = $"../../.."

func _process(delta):
	cooldown_time = 10 / tier
	
	cooldown -= delta
	
	if equipped:
		player.mana = -((cooldown / cooldown_time) * 32) + 32

func fire():
	if cooldown <= 0:
		cooldown = cooldown_time
		var fire_projectile : Area2D = fire_projectile_resource.instantiate()
		
		$"../../../..".add_child(fire_projectile)
		fire_projectile.global_position = global_position
		fire_projectile.look_at(get_global_mouse_position())
		fire_projectile.rotation_degrees += 90
		fire_projectile.speed = speed
		fire_projectile.time = lifetime
		
		fire_projectile.fire()
