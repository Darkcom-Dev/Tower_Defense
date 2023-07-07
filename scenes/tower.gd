extends Area2D

@export var health : int = 100
@export var bullet : PackedScene
@export var target_team : String
var is_dead : bool = false
var is_hurting : bool = false
var root : Node
# Called when the node enters the scene tree for the first time.
func _ready():
	root = get_tree().get_root()
	set_collisions()
	#get_collisions_info()
	
func set_collisions():
	if target_team == 'team_red':
		set_collision_layer_value(3,true) #blue
		set_collision_layer_value(2, false) #red
		set_collision_mask_value(2,true) #red
		set_collision_mask_value(3, false) #blue
		$damage_area.set_collision_mask_value(2, true) #red
	elif target_team == 'team_blue':
		set_collision_layer_value(3,false) #blue
		set_collision_layer_value(2, true) #red
		set_collision_mask_value(2,false) #red
		set_collision_mask_value(3, true) #blue
		$damage_area.set_collision_mask_value(3, true) #blue

func get_collisions_info():
	print('collisions_info of: ' + name)
	print('collision_layer -> blue: ' + str(get_collision_layer_value(3)) + ' red: ' + str(get_collision_layer_value(2)))
	print('collision_mask -> blue: ' + str(get_collision_mask_value(3)) + ' red: ' + str(get_collision_mask_value(2)))
	print('damage_area_mask -> blue:' +str($damage_area.get_collision_mask_value(3)) + ' red: ' + str($damage_area.get_collision_mask_value(2)))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):	pass

func set_damage(damage : int):
	
	if health > 0:
		health -= damage
		is_hurting = true
	else:
		is_dead = true

func dead():
	queue_free()


func _on_damage_area_body_entered(body):
	if body.is_in_group(target_team):
		print('body_name: ' + body.name + ' is_entered to: ' + name)
		var bullet_instance = bullet.instantiate()
		root.add_child(bullet_instance)
		bullet_instance.global_position = global_position
		print(bullet_instance.get_parent().name + ' position: ' + str(bullet_instance.position))
		bullet_instance.set_direction(body.position - position)
		if target_team == 'team_red':
			bullet_instance.set_damage_collision_mask(2)
		elif target_team == 'team_blue':
			bullet_instance.set_damage_collision_mask(3)
		bullet_instance.set_target_team(target_team)
		
