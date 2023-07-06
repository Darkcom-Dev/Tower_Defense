extends CharacterBody2D


@export var speed = 300.0
@export var target : Node2D
@export var destination : Vector2
@onready var playback : AnimationNodeStateMachinePlayback = $anim_tree.get("parameters/playback")

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	
	$anim_tree.active = true
	
	$Agent.path_desired_distance = 4.0
	$Agent.target_desired_distance = 4.0
	
	call_deferred("actor_setup")
	
func actor_setup():
	await  get_tree().physics_frame
	set_destination(destination)

func set_destination(new_destination : Vector2):
	destination = new_destination
	$Agent.set_target_position(destination)

func _physics_process(delta):
	
	if $Agent.is_navigation_finished():
		return
		
	var current_agent_position : Vector2 = global_position
	var next_path_position: Vector2 = $Agent.get_next_path_position()
	var diff : Vector2 = (next_path_position - current_agent_position).normalized()
	var new_velocity = diff * speed
	velocity = new_velocity
	move_and_slide()
	anim_control()

func anim_control():
	print('velocity: ' + str(velocity))
	
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
