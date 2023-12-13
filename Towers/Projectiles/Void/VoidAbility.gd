extends Area3D

var caster
var target_pos

var dps
var cd_time = 0.1 # in seconds
var expiration_time = 5 # in seconds

func _ready():
	if target_pos:
		global_position = target_pos

	# make mesh and material unique
	var new_res = $MeshInstance3D.mesh.duplicate()
	$MeshInstance3D.mesh = new_res
	var new_material = $MeshInstance3D.get_surface_override_material(0).duplicate()
	$MeshInstance3D.set_surface_override_material(0,new_material)

	#start timers for cd and expiration
	$CdTimer.start(cd_time)
	$ExpirationTimer.start(expiration_time)

	$AnimationPlayer.play("spawn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _trigger_effect():
	#get targets in area and deal damage = dps * cd_timer
	for area in get_overlapping_areas():
		if area.is_in_group('enemy') and area.has_method('take_damage'):
			area.take_damage(dps * cd_time)

func _on_cd_timer_timeout():
	_trigger_effect()

func _on_expiration_timer_timeout():
	$AnimationPlayer.play("end")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'end':
		queue_free()
