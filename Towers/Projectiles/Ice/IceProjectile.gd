extends "res://Towers/Projectiles/Projectile.gd"

var slow_duration
var slow_amount

func _ready():
	if pos:
		global_position = pos

	# free projectile after x seconds
	free_timeout()

func _on_area_entered(area):
	if area.is_in_group('enemy'):
		for enemy in $SlowArea.get_overlapping_areas():
			if enemy.is_in_group('enemy') and enemy.has_method('take_damage'):
				enemy.take_damage(damage)
		free_projectile()

func free_projectile():
	for enemy in $SlowArea.get_overlapping_areas():
		if enemy.is_in_group('enemy') and enemy.has_method('take_slow'):
			enemy.take_slow(slow_amount, slow_duration)
	queue_free()
