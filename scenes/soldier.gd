extends CharacterBody2D


@export var speed = 300.0
@export var health = 100

@export var target_team : String
@export var bullet : PackedScene
@export var destination : Vector2
@onready var playback : AnimationNodeStateMachinePlayback = $anim_tree.get("parameters/playback")

var is_selected : bool = false
var is_mouse_entered : bool = false
var is_dead : bool = false
var is_hurting : bool = false
var root : Node
func _ready():
	root = get_tree().get_root()
	$anim_tree.active = true
	
	$Agent.path_desired_distance = 4.0
	$Agent.target_desired_distance = 4.0
	
	call_deferred("actor_setup")
	
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

func actor_setup():
	await  get_tree().physics_frame
	set_destination(destination)

func set_destination(new_destination : Vector2):
	destination = new_destination
	$Agent.set_target_position(destination)

func _physics_process(_delta):
	
	movement()
	move_and_slide()
	anim_control()
	select_manager()
	
	if is_selected:
		capture_new_target()

func select_manager():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		is_selected = is_mouse_entered
	
	$spr_soldier.modulate = Color.ORANGE if is_selected else Color.WHITE

func movement():
	if $Agent.is_navigation_finished():
		velocity = Vector2.ZERO
	else:
		var current_agent_position : Vector2 = global_position
		var next_path_position: Vector2 = $Agent.get_next_path_position()
		var diff : Vector2 = (next_path_position - current_agent_position).normalized()
		var new_velocity = diff * speed
		velocity = new_velocity

func capture_new_target():
	var mouse_position = get_global_mouse_position()
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		set_destination(mouse_position)
		#print('mouse_pos: ' + str(mouse_position))

func anim_control():
	
	$spr_soldier.z_index = global_position.y
	
	if abs(velocity.x) > abs(velocity.y):
		$spr_soldier.flip_h = velocity.x < 0
		playback.travel('Right_Walk' if velocity.x > 5 else 'Right_Idle')
	if abs(velocity.y) > abs(velocity.x):
		var down_facing = velocity.y > 0
		
		if velocity.y > 5:
			playback.travel('Down_Walk' if down_facing else 'Up_Walk')
		else:
			playback.travel('Down_Idle' if down_facing else 'Up_Idle')
		
func _on_timer_timeout():
	randomize()
	set_destination(Vector2(randf_range(32,330), randf_range(40, 464)))

func _on_mouse_entered():
	is_mouse_entered = true

func _on_mouse_exited():
	is_mouse_entered = false
		
func set_damage(hit_damage : int):
	
	if health > 0:
		health -= hit_damage
		is_hurting = true
		$hurt_timer.start()
	else:
		health = 0
		is_dead = true
		queue_free()

func _on_damage_area_body_entered(body):
	if body.is_in_group(target_team):
		print('body_name: ' + body.name + ' is_entered to: ' + name)
		var bullet_instance = bullet.instantiate()		
		root.call_deferred('add_child',bullet_instance)
		bullet_instance.global_position = global_position
		bullet_instance.set_direction(body.position - position)
		bullet_instance.set_target_team(target_team)


func _on_hurt_timer_timeout():
	is_hurting = false
