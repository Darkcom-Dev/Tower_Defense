extends CharacterBody2D


@export var speed = 300.0
@export var health : float = 100.0
@export var strength : float = 10.0

var max_health : float

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
	
	#call_deferred("actor_setup")
	set_initial_stats()
	set_collisions()
	#get_collisions_info()
	
	
func set_initial_stats():
	randomize()
	health = randi_range(80,100)
	strength = randi_range(8,12)
	speed = randi_range(25,50)
	
	max_health = health
	print('health: ' + str(health) + ' strength: ' + str(strength) + ' speed: ' + str(speed))
	
	

func set_collisions():
	
	set_collision_layer_value(3, is_in_group('team_blue')) #blue
	set_collision_layer_value(2, is_in_group('team_red')) #red
	
	var red = target_team == 'team_red'
	set_collision_mask_value(2,red) #red
	set_collision_mask_value(3, not red) #blue
	$damage_area.set_collision_mask_value(2 if red else 3, true) #red
	
		
	
func get_collisions_info():
	print('collisions_info of: ' + name)
	print('collision_layer -> blue: ' + str(get_collision_layer_value(3)) + ' red: ' + str(get_collision_layer_value(2)))
	print('collision_mask -> blue: ' + str(get_collision_mask_value(3)) + ' red: ' + str(get_collision_mask_value(2)))
	print('damage_area_mask -> blue:' +str($damage_area.get_collision_mask_value(3)) + ' red: ' + str($damage_area.get_collision_mask_value(2)))

func actor_setup():
	await  get_tree().physics_frame
	#set_destination(destination)
	print('init')

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
	if is_in_group('team_blue'):
		set_destination(Vector2(randf_range(704,832), randf_range(128, 464)))
	elif is_in_group('team_red'):
		set_destination(Vector2(randf_range(32,160), randf_range(128, 464)))
	$Timer.wait_time = (randf_range(10,25))

func _on_mouse_entered():
	is_mouse_entered = true

func _on_mouse_exited():
	is_mouse_entered = false
		
func set_damage(hit_damage : int):
	
	if health > 0:
		print('hit_damage: ' + str(hit_damage) + ' health: ' + str(health))
		health -= hit_damage
				
		is_hurting = true
		$hurt_timer.start()
		randomize_next_destination()
	else:
		health = 0
		is_dead = true
		queue_free()
		
	var normalized_health : float = float(health/max_health)
	#print('normalized_health: ' + str(normalized_health) + ' hp:'+str(health)+ ' max_hp:' + str(max_health))
	$health_bar.update_health_bar(normalized_health)

func _on_damage_area_body_entered(body):
	if body.is_in_group(target_team):		
		var bullet_instance = bullet.instantiate()		
		root.call_deferred('add_child',bullet_instance)
		bullet_instance.global_position = global_position
		bullet_instance.set_direction(body.position - position)
		bullet_instance.set_target_team(target_team)
		
		bullet_instance.set_damage_collision_mask(2 if target_team == 'team_red' else 3)
		
		bullet_instance.set_target_team(target_team)
		
		randomize_next_destination()
	if 'bullet' in body.name:
		randomize_next_destination()
			

func randomize_next_destination():
	if position.x < 165:
		var xpos = randf_range(165,330)
		var ypos = randf_range(64,464)
		set_destination(Vector2(xpos,ypos))
	else:
		var xpos = randf_range(0,165)
		var ypos = randf_range(64,464)
		set_destination(Vector2(xpos,ypos))

func _on_hurt_timer_timeout():
	is_hurting = false
