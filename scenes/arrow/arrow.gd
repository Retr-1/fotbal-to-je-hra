extends Node3D
class_name Arrow

@onready var arrow_head := $arrow_head
@onready var arrow_shaft := $arrow_shaft
@onready var arrow_shaft_mesh: MeshInstance3D = $arrow_shaft/Plane

func set_length(length: float) -> void:
	var local_length := arrow_shaft_mesh.get_aabb().size.z
	var world_length := arrow_shaft_mesh.global_transform.basis.z.length() * local_length
	print(world_length)
	arrow_shaft.scale.z *= length / world_length
	arrow_head.position.z = -length
	
