extends Area3D

var max_health = 100
var health

var is_dead = false

func _ready():
	health = max_health

	# unique mesh and material
	var new_res = $Healthbar.mesh.duplicate()
	$Healthbar.mesh = new_res
	var new_material = $Healthbar.mesh.material.duplicate()
	$Healthbar.mesh.material = new_material

func _process(delta):
	$Healthbar.mesh.size.x = float(health) * 3.0 / float(max_health)

	if get_parent().slow_amount:
		#$Healthbar.mesh.material.albedo_color = '00bac5'
		$SlowEffect.emitting = true
	else:
		#$Healthbar.mesh.material.albedo_color = 'a80000'
		$SlowEffect.emitting = false

func take_damage(dmg):
	health -= dmg

	if health <= 0 and not is_dead:
		is_dead = true # in case two projectiles hit at the same time
		Globals.enemy_killed()
		get_parent().queue_free()

func take_slow(amount, duration):
	get_parent().take_slow(amount, duration)
