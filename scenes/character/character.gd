extends CharacterBody3D
class_name Character

@onready var anim_tree: AnimationTree = $AnimationTree
@onready var hover_ring : Node3D = $UIElements/ring
@onready var arrow : Arrow = $UIElements/Arrow
@onready var ui_elements : Node3D = $UIElements
const HORIZONTAL_SPEED := 2.0
const GRAVITY_ACCELERATION := 2.0
var pos_to_move_to: Vector3

func move_to(pos: Vector3) -> void:
	pos_to_move_to = pos

func set_hovered(visibility: bool) -> void:
	ui_elements.visible = visibility

func update_auxiliary_elements() -> void:
	if velocity.is_zero_approx():
		arrow.visible = false
		hover_ring.visible = true
	else:
		arrow.visible = true
		hover_ring.visible = false
		set_arrow_endpos(pos_to_move_to)

func set_arrow_endpos(endpos: Vector3) -> void:
	#var length := (global_position - endpos).length()
	#arrow.set_length(length)
	#ui_elements.look_at(Vector3(endpos.x, ui_elements.global_position.y, endpos.z), Vector3.UP)
	
	arrow.set_start_end_pos(ui_elements.global_position, Vector3(endpos.x, ui_elements.position.y, endpos.z), 0.1)
	

func _ready() -> void:
	pos_to_move_to = global_position


func _physics_process(delta: float) -> void:	
	velocity.y -= GRAVITY_ACCELERATION * delta
	
	if not pos_to_move_to.is_equal_approx(global_position):
		var dir = (pos_to_move_to-global_position).normalized()
		var new_hor_speed: Vector3 = dir*HORIZONTAL_SPEED
		velocity.x = new_hor_speed.x
		velocity.z = new_hor_speed.z
		anim_tree.set('parameters/locomotion/blend_position', 1)
	else:
		anim_tree.set('parameters/locomotion/blend_position', 0)
		
		if not pos_to_move_to.is_equal_approx(global_position):
			look_at(pos_to_move_to, Vector3.UP)
		
	move_and_slide()
	
	
