extends KinematicBody2D

export var movement_speed = 75
export var camera_path : NodePath

var camera : Camera2D

export var tags_list = ['npc', 'human', 'interactable']

# Called when the node enters the scene tree for the first time.
func _ready():
	if camera_path != null:
		camera = get_node(camera_path)
		
	# Create detection Area2D
	var detection_area = Area2D.new()
	var detect_collision = CollisionShape2D.new()
	var circleshape2 = CircleShape2D.new()
	circleshape2.radius = 1
	detect_collision.shape = circleshape2
	detection_area.add_child(detect_collision)
	add_child(detection_area)

func _process(delta):
	pass
	
