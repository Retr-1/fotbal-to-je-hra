extends CharacterBody3D
class_name Character

@onready var anim_tree: AnimationTree = $AnimationTree
@onready var hover_ring : Node3D = $UIElements/ring
@onready var arrow : Arrow = $UIElements/Arrow
@onready var ui_elements : Node3D = $UIElements
const HORIZONTAL_SPEED := 2.0
const GRAVITY_ACCELERATION := 2.0
var pos_to_move_to: Vector2

func move_to(pos: Vector3) -> void:
	pos_to_move_to = Vector2(pos.x, pos.z)

func set_hovered(visibility: bool) -> void:
	ui_elements.visible = visibility

func update_auxiliary_elements() -> void:
	if velocity.is_zero_approx():
		arrow.visible = false
		hover_ring.visible = true
	else:
		arrow.visible = true
		hover_ring.visible = false
		set_arrow_endpos(Vector3(pos_to_move_to.x, 0, pos_to_move_to.y))

func set_arrow_endpos(endpos: Vector3) -> void:
	#var length := (global_position - endpos).length()
	#arrow.set_length(length)
	#ui_elements.look_at(Vector3(endpos.x, ui_elements.global_position.y, endpos.z), Vector3.UP)
	
	arrow.set_start_end_pos(ui_elements.global_position, Vector3(endpos.x, ui_elements.position.y, endpos.z), 0.1)
	
func get_gamefield_pos() -> Vector2:
	return Vector2(global_position.x, global_position.z)

func _ready() -> void:
	pos_to_move_to = get_gamefield_pos()


func _physics_process(delta: float) -> void:	
	velocity.y -= GRAVITY_ACCELERATION * delta
	var gamefield_pos := get_gamefield_pos()
	
	if (pos_to_move_to-gamefield_pos).length_squared() > 0.025:
		print(pos_to_move_to, gamefield_pos)
		var dir = (pos_to_move_to-gamefield_pos).normalized()
		var new_hor_speed: Vector2 = dir*HORIZONTAL_SPEED
		velocity.x = new_hor_speed.x
		velocity.z = new_hor_speed.y
		
		anim_tree.set('parameters/locomotion/blend_position', 1)
		
		look_at(Vector3(pos_to_move_to.x, 0, pos_to_move_to.y), Vector3.UP)
	else:
		velocity.x = 0
		velocity.z = 0
		anim_tree.set('parameters/locomotion/blend_position', 0)
		
	
		
		
	move_and_slide()
	
	
