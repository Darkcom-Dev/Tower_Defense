extends Node2D

@export var red_soldier : PackedScene
@export var blue_soldier : PackedScene

@export var origin_rect_red_team : Vector2
@export var end_rect_red_team : Vector2

@export var origin_rect_blue_team : Vector2
@export var end_rect_blue_team : Vector2

var root : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$blue_team_timer.wait_time = (randf_range(15,35))
	$red_team_timer.wait_time = (randf_range(15,35))
	
	$blue_team_timer.start()
	$red_team_timer.start()
	
	root = get_tree().get_root()


func _on_red_team_timer_timeout():
	var red_soldier_instance = red_soldier.instantiate()
	root.call_deferred('add_child', red_soldier_instance)
	var red_x = randi_range(origin_rect_red_team.x,end_rect_red_team.x)
	var red_y = randi_range(origin_rect_red_team.y,end_rect_red_team.y)
	var red_position = Vector2(red_x,red_y)
	red_soldier_instance.global_position = red_position

func _on_blue_team_timer_timeout():
	var blue_soldier_instance = blue_soldier.instantiate()
	root.call_deferred('add_child', blue_soldier_instance)
	var blue_x = randi_range(origin_rect_blue_team.x,end_rect_blue_team.x)
	var blue_y = randi_range(origin_rect_blue_team.y,end_rect_blue_team.y)
	var blue_position = Vector2(blue_x, blue_y)
	blue_soldier_instance.global_position = blue_position
	
