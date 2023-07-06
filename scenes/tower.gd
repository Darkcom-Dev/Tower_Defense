extends Area2D

@export var health : int = 100
@export var bullet : NodePath

var is_dead : bool = false
var is_hurting : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
	if body.is_in_group('team_red'):
		# instanciar bullet
		pass
