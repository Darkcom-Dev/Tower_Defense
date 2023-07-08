extends Node2D


var current_hp : float

func _ready():
	current_hp = 1



# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_health_bar(hp : float):
	print('HP: ' + str(hp))	
	if current_hp > 0 and current_hp <= 1:
		current_hp = hp
	elif current_hp > 1:
		current_hp = 1
		$BG/bar.scale.x = 1
	else:
		current_hp = 0
		$BG/bar.scale.x = 0
		
	$BG/bar.scale.x = current_hp
