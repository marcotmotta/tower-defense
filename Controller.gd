extends Node3D

var generic_tower_scene = preload("res://Towers/GenericTower/GenericTower.tscn")
var fire_tower_scene = preload("res://Towers/FireTower/FireTower.tscn")
var ice_tower_scene = preload("res://Towers/IceTower/IceTower.tscn")

const CAMERA_SPEED = 0.7
const MAX_HEIGHT = 45
const MIN_HEIGHT = 25

var valid_place = false

var selected_tower = null
var selected_tower_cost = 0

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_dir = Input.get_vector("a", "d", "s", "w")

	if (input_dir.y > 0 and position.z >= -50) or (input_dir.y < 0 and position.z <= 100):
		position.z -= input_dir.y * CAMERA_SPEED

	if (input_dir.x > 0 and position.x <= 50) or (input_dir.x < 0 and position.x >= -50):
		position.x += input_dir.x * CAMERA_SPEED

	calculate_mouse_position()

	# wave info ui
	$CanvasLayer/Control/WaveInfo.text = "CURRENT WAVE: " + str(Globals.current_wave) + "\n" + \
		"HP: " + str(Globals.current_enemy_health())

	$CanvasLayer/Control/NextWave.disabled = not(Globals.spawned_all_enemies and Globals.spawned_enemies <= 0)

	# gold ui
	$CanvasLayer/Control/Gold.text = 'GOLD: ' + str(Globals.gold)

	$CanvasLayer/Control/FireTower.disabled = Globals.gold < Globals.fire_tower_cost
	$CanvasLayer/Control/IceTower.disabled = Globals.gold < Globals.ice_tower_cost

	# towers ui
	$CanvasLayer/Control/SelectedTower.text = "SELECTED TOWER: " + str(selected_tower)
	$CanvasLayer/Control/HighlightedTower.text = "HIGHLIGHTED TOWER: " + str(Globals.highlighted_tower)

func _unhandled_input(event):
	# camera distance
	if Input.is_action_just_pressed("scroll_up"):
		position.y = max(position.y - CAMERA_SPEED, MIN_HEIGHT)
	if Input.is_action_just_pressed("scroll_down"):
		position.y = min(position.y + CAMERA_SPEED, MAX_HEIGHT)

	if Input.is_action_just_pressed("click1"):
		# place tower
		if valid_place:
			spawn_tower(selected_tower, selected_tower_cost)
		else:
		# highlight tower
			Globals.reset_highlight()
			for area in $ControllerPosition.get_overlapping_areas():
				if area.is_in_group('tower'):
					Globals.highlight_tower(area)
					break
		selected_tower = null

	# unselect towers
	if Input.is_action_just_pressed("esc"):
		selected_tower = null
		selected_tower_cost = 0
		Globals.highlighted_tower = null

	# place tower
	#if Input.is_action_just_pressed("click2"):
	#	if valid_place:
	#		spawn_fire_tower()

func calculate_mouse_position():
	var space_state = get_world_3d().direct_space_state
	var mouse_pos_2d = get_viewport().get_mouse_position()

	var from = $Camera3D.project_ray_origin(mouse_pos_2d)
	var to = from + $Camera3D.project_ray_normal(mouse_pos_2d) * 2000

	var ray_query = PhysicsRayQueryParameters3D.new()

	ray_query.from = from
	ray_query.to = to
	ray_query.collide_with_areas = false
	var raycast_result = space_state.intersect_ray(ray_query)

	if raycast_result:
		$ControllerPosition.global_position = raycast_result.position

		if raycast_result.collider.is_in_group('terrain') \
		and raycast_result.position.y > raycast_result.collider.get_node('Threshold').global_position.y\
		and selected_tower:
			var is_colliding_with_tower = false
			for area in $Area3D.get_overlapping_areas():
				if area.is_in_group('tower'):
					is_colliding_with_tower = true
					break
			if is_colliding_with_tower: #198a00
				$Area3D/MeshInstance3D.mesh.material.albedo_color = 'bd0000'
				#$Area3D/CPUParticles3D.visible = false
				valid_place = false
			else:
				$Area3D/MeshInstance3D.mesh.material.albedo_color = '00ffff'
				#$Area3D/CPUParticles3D.visible = true
				valid_place = true
			$Area3D.visible = true
			$Area3D.global_position = raycast_result.position
		else:
			$Area3D.visible = false
			$Area3D.global_position = global_position
			valid_place = false

func spawn_tower(tower_type, cost):
	var tower_instance = tower_type.instantiate()
	tower_instance.pos = $Area3D.global_position
	get_parent().add_child(tower_instance)
	Globals.gold -= cost

func _on_area_3d_area_entered(area):
	print(area)

func _on_fire_tower_pressed():
	selected_tower = fire_tower_scene
	selected_tower_cost = Globals.fire_tower_cost

func _on_ice_tower_pressed():
	selected_tower = ice_tower_scene
	selected_tower_cost = Globals.ice_tower_cost

func _on_next_wave_pressed():
	var map = get_parent().get_node('Map')
	if map.has_method('start_wave'):
		map.start_wave()
