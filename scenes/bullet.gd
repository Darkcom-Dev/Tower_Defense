extends CharacterBody2D


@export var speed = 300.0
@export var target_team : String = 'team_blue'
@export var hit_damage : int = 10
var direction : Vector2

func _ready():
	print('blue: ' + str($damage_area.get_collision_mask_value(3)) + ' red: ' + str($damage_area.get_collision_mask_value(2)))

func set_damage_collision_mask(value_index : int):
	set_collision_mask_value(2,false)
	set_collision_mask_value(3,false)
	set_collision_mask_value(value_index, true)
	
	$damage_area.set_collision_mask_value(2,false)
	$damage_area.set_collision_mask_value(3,false)
	$damage_area.set_collision_mask_value(value_index, true)
	
	print('blue')

func set_target_team(new_target_team : String):
	target_team = new_target_team

func set_direction(new_direction : Vector2):
	direction = new_direction.normalized()

func _physics_process(_delta):
	
	$spr_bullet.z_index = position.y
	velocity = direction * speed
	move_and_slide()


func _on_area_2d_body_entered(body):
	
	print('blue: ' + str($damage_area.get_collision_mask_value(3)) + ' red: ' + str($damage_area.get_collision_mask_value(2)))
	if body.is_in_group(target_team):
		body.set_damage(hit_damage)
		print(name + ' hitted: ' + body.name)
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
