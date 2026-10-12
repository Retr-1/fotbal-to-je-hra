extends Node3D
class_name Game

enum InteractionState {
	NOTHING,
	HOVERING,
	DRAGGING
}

@onready var camera: Camera3D = $Camera3D
var active_character: Character = null
var is_dragging := false
var interaction_state := InteractionState.NOTHING

func raycast_to_find_floor() -> Variant:
	var plane := Plane(Vector3.UP, 0.0)
	var mouse_position := get_viewport().get_mouse_position()
	var ray_origin := camera.project_ray_origin(mouse_position)
	var ray_dir := camera.project_ray_normal(mouse_position)
	
	return plane.intersects_ray(ray_origin, ray_dir)
	
	

func raycast_to_find_character() -> Character:
	const RAY_LENGTH := 100.0
	const COLLISION_MASK := 1<<1
	var mouse_position := get_viewport().get_mouse_position()
	var ray_origin := camera.project_ray_origin(mouse_position)
	var ray_dir := camera.project_ray_normal(mouse_position)
	var ray_end := ray_origin + ray_dir * RAY_LENGTH
	
	var query := PhysicsRayQueryParameters3D.create(ray_origin, ray_end, COLLISION_MASK)
	query.collide_with_areas = true
	query.collide_with_bodies = false
	
	var result := get_world_3d().direct_space_state.intersect_ray(query)
	
	if result:
		#print('Hovering', result.collider)
		var area := result.collider as Area3D
		if not area:
			return null
		
		return area.get_parent() as Character
			
	return null
			

func update_interaction() -> void:
	var new_character := raycast_to_find_character()
	
	match interaction_state:
		InteractionState.NOTHING:
			if new_character:
				active_character = new_character
				active_character.set_hovered(true)
				interaction_state = InteractionState.HOVERING
		
		InteractionState.HOVERING:
			if new_character == null:
				active_character.set_hovered(false)
				active_character = null
				interaction_state = InteractionState.NOTHING
			elif new_character != active_character:
				active_character.set_hovered(false)
				active_character = new_character
			elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				interaction_state = InteractionState.DRAGGING
				active_character.set_hovered(false)
		
		InteractionState.DRAGGING:
			var intersect: Variant = raycast_to_find_floor()
			if intersect is Vector3:
				debug_sphere(intersect)
				active_character.set_arrow_endpos(intersect)
				
		
func debug_sphere(
	position: Vector3,
	radius: float = 0.1,
	duration: float = 1.0
) -> void:
	var instance := MeshInstance3D.new()

	var sphere := SphereMesh.new()
	sphere.radius = radius
	sphere.height = radius * 2.0

	instance.mesh = sphere

	get_tree().current_scene.add_child(instance)
	instance.global_position = position

	await get_tree().create_timer(duration).timeout

	if is_instance_valid(instance):
		instance.queue_free()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				pass
			else:
				pass
				
	elif event is InputEventMouseMotion and is_dragging:
#		Update the arrow
		pass

func _physics_process(delta: float) -> void:
	update_interaction()

		
		
	
			
