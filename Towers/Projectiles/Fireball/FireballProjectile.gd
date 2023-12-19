extends "res://Towers/Projectiles/Projectile.gd"

func _ready():
	if pos:
		global_position = pos

	if has_tracking:
		ready_tracking()

	# free projectile after x seconds
	free_timeout()

func _on_area_entered(area):
	areaEntered(area)
