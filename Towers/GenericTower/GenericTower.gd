extends "res://Towers/Tower.gd"

var projectile_scene = preload("res://Towers/Projectiles/Fireball/FireballProjectile.tscn")

func _on_timer_timeout():
		if is_instance_valid(target):
			var projectile_instance = projectile_scene.instantiate()
			projectile_instance.pos = $Marker3D.global_position
			projectile_instance.target = target
			get_parent().add_child(projectile_instance)

func _on_attackrange_area_entered(area):
	attackRangeAreaEntered(area)

func _on_attackrange_area_exited(area):
	attackRangeAreaExited(area)
