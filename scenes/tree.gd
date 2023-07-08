extends CharacterBody2D

@export var health : float
var max_health : float
var is_dead = false


func _ready():
	health = randf_range(health -12, health + 12)
	max_health = health
	

func set_damage(hit_damage):
	if health > 0:
		health -= hit_damage
		
		
	else:
		health = 0
		is_dead = true
		queue_free()
		
	var normalized_health = health / max_health
	var amount = roundi(50 - normalized_health * 50)
	$fire.amount = amount
	print('fire_amount: ' + str(amount))
	$spr_tree.modulate = Color(normalized_health, normalized_health, normalized_health)

func _process(_delta):
	$spr_tree.z_index = position.y
	$fire.z_index = position.y +1

func _on_damage_area_body_entered(body):
	pass # Replace with function body.
