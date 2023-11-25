extends "res://Towers/Projectiles/Projectile.gd"

func _ready():
	if pos:
		global_position = pos

	# free projectile after x seconds
	free_timeout()

func _on_area_entered(area):
	areaEntered(area)
