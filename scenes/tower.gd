extends CharacterBody2D

@export var health : float = 100.0
@export var bullet : PackedScene
@export var target_team : String

var max_health : float
var strenght : float

var is_dead : bool = false
var is_hurting : bool = false
var root : Node
# Called when the node enters the scene tree for the first time.
func _ready():
	root = get_tree().get_root()
	set_collisions()
	set_initial_stats()
	#get_collisions_info()

func set_initial_stats():
	randomize()
	health = randf_range(health - 12, health + 12)
	max_health = health
	strenght = randf_range(8,12)
	print('health: ' + str(health) + ' max_health: ' + str(max_health))

func set_collisions():
	
	var red = target_team == 'team_red'
	
	set_collision_layer_value(3, is_in_group('team_blue')) #blue
	set_collision_layer_value(2, is_in_group('team_red')) #red
	
	set_collision_mask_value(2,red) #red
	set_collision_mask_value(3, not red) #blue
	
	$damage_area.set_collision_mask_value(2 if red else 3, true) #red
	

func get_collisions_info():
	print('collisions_info of: ' + name)
	print('collision_layer -> blue: ' + str(get_collision_layer_value(3)) + ' red: ' + str(get_collision_layer_value(2)))
	print('collision_mask -> blue: ' + str(get_collision_mask_value(3)) + ' red: ' + str(get_collision_mask_value(2)))
	print('damage_area_mask -> blue:' +str($damage_area.get_collision_mask_value(3)) + ' red: ' + str($damage_area.get_collision_mask_value(2)))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):	pass

func set_damage(hit_damage : int):
	
	if health > 0:
		health -= hit_damage
		is_hurting = true
	else:
		health = 0
		is_dead = true
		dead()
	
	var normalized_health = float(health / max_health)
	print('normalized_health: ' + str(normalized_health) + ' hp:'+str(health)+ ' max_hp:' + str(max_health))
	$health_bar.update_health_bar(normalized_health)

func dead():
	queue_free()


func _on_damage_area_body_entered(body):
	if body.is_in_group(target_team):
		print('body_name: ' + body.name + ' is_entered to: ' + name)
		var bullet_instance = bullet.instantiate()
		root.call_deferred('add_child',bullet_instance)# add_child(bullet_instance)
		bullet_instance.global_position = global_position
		#print(bullet_instance.get_parent().name + ' position: ' + str(bullet_instance.position))
		bullet_instance.set_direction(body.position - position)
			
		bullet_instance.set_damage_collision_mask(2 if target_team == 'team_red' else 3)
		bullet_instance.set_target_team(target_team)
		
