extends "res://Towers/Projectiles/Projectile.gd"

func _ready():
	if pos:
		global_position = pos

	speed = 20
	damage = 40

func _on_area_entered(area):
	areaEntered(area)
