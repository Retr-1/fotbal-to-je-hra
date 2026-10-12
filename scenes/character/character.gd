extends CharacterBody3D
class_name Character

@onready var anim_tree: AnimationTree = $AnimationTree
@onready var hover_ring : Node3D = $UIElements/ring
@onready var arrow : Arrow = $UIElements/Arrow
const MAX_SPEED := 2.0


	
func set_hovered(hovered: bool) -> void:
	hover_ring.visible = hovered

func set_arrow_endpos(endpos: Vector3) -> void:
	var length := (global_position - endpos).length()
	arrow.set_length(length)

func _ready() -> void:
	#velocity.x = 1
	print('hello')
	
	var blend_position := velocity.length() / MAX_SPEED
	print(blend_position)
	anim_tree.set('parameters/locomotion/blend_position', blend_position)


	


	
func _physics_process(delta: float) -> void:
	velocity.y -= 10 * delta
	move_and_slide()
	
