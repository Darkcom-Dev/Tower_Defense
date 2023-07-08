extends CharacterBody2D

@export var target_team : String
@export var health : float = 200
var max_health : float
@export var strenght : float = 20
var is_hurting : bool

func _ready():
	set_init_stats()
	set_collisions()

func set_init_stats():
	randomize()
	health = randf_range(health -12, health + 12)
	max_health = health
	strenght = randf_range(strenght -4, strenght +4)

func set_collisions():
	
	set_collision_layer_value(3, is_in_group('team_blue')) #blue
	set_collision_layer_value(2, is_in_group('team_red')) #red
	
	var red = target_team == 'team_red'
	set_collision_mask_value(2,red) #red
	set_collision_mask_value(3, not red) #blue
	$damage_area.set_collision_mask_value(2 if red else 3, true) #red
	

func set_damage(hit_damage : int):
	
	if health > 0:
		health -= hit_damage
		is_hurting = true
		
	else:
		health = 0
	
	var normalize_health = health / max_health
	$health_bar.update_health_bar(normalize_health)

func _physics_process(_delta):
	pass


func _on_hurt_time_timeout():
	is_hurting = false
