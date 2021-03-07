extends KinematicBody2D

export var movement_speed = 75
export var camera_path : NodePath
export var interact_radius = 50

var player
var camera : Camera2D

export var text = ["Oh no i lost my [b][color=#FF8800]doggo[/color][/b]", "can u find it [color=red]plzzzzzzzzzzz[/color]", "i [shake rate=20 level=10]rly[/shake] miss my doggu"]
var DIALOG = preload("res://objects/dialog_box.tscn")

export var tags_list = ['npc', 'human', 'interactable']

var can_interact = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if camera_path != null:
		camera = get_node(camera_path)
		
	# Create detection Area2D
	var detection_area = Area2D.new()
	var detect_collision = CollisionShape2D.new()
	var circleshape2 = CircleShape2D.new()
	circleshape2.radius = interact_radius
	detect_collision.shape = circleshape2
	detection_area.add_child(detect_collision)
	add_child(detection_area)
	
	detection_area.connect("area_entered", self, "on_area_enter")
	detection_area.connect("area_exited", self, "on_area_exit")
	
func on_area_enter(area : Area2D):
	var a_parent = area.get_parent()
	if "tags_list" in a_parent:
		if "player" in a_parent.tags_list:
			$InteractSprite.visible = true
			can_interact = true
	player = a_parent
	
func on_area_exit(area : Area2D):
	var a_parent = area.get_parent()
	if "tags_list" in a_parent:
		if "player" in a_parent.tags_list:
			$InteractSprite.visible = false
			can_interact = false

func _process(delta):
	if Input.is_action_pressed('interact') and can_interact:
		var box = DIALOG.instance()
		box.get_node("ColorRect/RichTextLabel").dialog = text
		box.get_node("ColorRect/RichTextLabel").player = player
		add_child(box)
		$InteractSprite.visible = false
		can_interact = false
		
	
