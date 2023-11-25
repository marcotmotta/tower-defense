extends "res://Towers/Tower.gd"

var projectile_scene = preload("res://Towers/Projectiles/Ice/IceProjectile.tscn")

var projectile_speed = 40 # projectile speed
var attack_speed = Globals.NORMAL # in seconds

var slow_duration = 2
var slow_amount = 0.4

func _ready():
	if pos:
		global_position = pos

		current_level = 1
		levels = ['Ice1Mesh']
		damages_per_level = [25, 50, 75, 100]
		damage = damages_per_level[current_level - 1]

	# $Timer.start(attack_speed)

func _on_timer_timeout():
		if is_instance_valid(target):
			var projectile_instance = projectile_scene.instantiate()
			projectile_instance.pos = $Marker3D.global_position
			projectile_instance.damage = damage
			projectile_instance.speed = projectile_speed
			projectile_instance.slow_duration = slow_duration
			projectile_instance.slow_amount = slow_amount
			projectile_instance.target = target
			get_parent().add_child(projectile_instance)

func _on_attackrange_area_entered(area):
	attackRangeAreaEntered(area)

func _on_attackrange_area_exited(area):
	attackRangeAreaExited(area)
