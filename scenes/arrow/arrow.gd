extends Node3D
class_name Arrow

@onready var arrow_head := $arrow_head
@onready var arrow_head_mesh: MeshInstance3D = $arrow_head/Plane_002
@onready var arrow_shaft := $arrow_shaft
@onready var arrow_shaft_mesh: MeshInstance3D = $arrow_shaft/Plane
var clipping_shaders: Array[ShaderMaterial]
var head_rest_position: float = 0
var head_size: float = 0

func _ready() -> void:
	head_rest_position = arrow_shaft_mesh.get_aabb().size.z
	head_rest_position *= arrow_shaft_mesh.global_transform.basis.z.length() 
	head_size = arrow_head_mesh.get_aabb().size.z
	head_size *= arrow_head_mesh.global_transform.basis.z.length() 
	for i in range(2):
		var mat := arrow_head_mesh.mesh.surface_get_material(i)
		clipping_shaders.push_back(mat)
	

func set_start_end_pos(startpos: Vector3, endpos: Vector3, startoffset: float = 0, up: Vector3 = Vector3.UP) -> void:
	var dir := (endpos-startpos).normalized()
	arrow_shaft.global_position = startpos + dir*startoffset
	var length := (endpos-startpos).length()
	if not (is_zero_approx(length) or absf(dir.dot(up)) > 0.999):
		var shaft_length := maxf(0.01, length-startoffset-head_size)
		var local_length := arrow_shaft_mesh.get_aabb().size.z
		var world_length := arrow_shaft_mesh.global_transform.basis.z.length() * local_length
		
		arrow_shaft.scale.z *= shaft_length / world_length
		var head_delta := length-head_size-head_rest_position
		arrow_head.global_position = dir*head_delta + startpos
		
		
		arrow_shaft.look_at(endpos, up)
		arrow_head.look_at(endpos, up)
	
	for clipping_shader in clipping_shaders:
		clipping_shader.set_shader_parameter('clip_point', startpos)
		clipping_shader.set_shader_parameter('clip_normal', dir)
		
	
		
	

func set_length(length: float) -> void:
	length -= head_size
	if length <= 0:
		return
	var local_length := arrow_shaft_mesh.get_aabb().size.z
	var world_length := arrow_shaft_mesh.global_transform.basis.z.length() * local_length
	
	arrow_shaft.scale.z *= length / world_length
	arrow_head.position.z = -length + head_rest_position
	
