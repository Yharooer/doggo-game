extends Node2D

export var NEIGHBOUR_SPECIAL_DOG_TRIGGER_DISTANCE = 100

export var special_dog_1_path : NodePath
export var special_dog_2_path : NodePath
export var special_dog_3_path : NodePath

export var neighbour_path : NodePath
export var farmer_1_path : NodePath
export var farmer_2_path : NodePath
export var farmer_3_path : NodePath

export var player_path : NodePath
export var camera_path : NodePath

var special_dog_1
var special_dog_2
var special_dog_3
var neighbour
var farmer_1
var farmer_2
var farmer_3
var player
var camera

var prev_vx
var prev_vy

var stage = 0

func _ready():
	special_dog_1 = get_node(special_dog_1_path)
	special_dog_2 = get_node(special_dog_2_path)
	special_dog_3 = get_node(special_dog_3_path)
	neighbour = get_node(neighbour_path)
	farmer_1 = get_node(farmer_1_path)
	farmer_2 = get_node(farmer_2_path)
	farmer_3 = get_node(farmer_3_path)
	player = get_node(player_path)
	camera = get_node(camera_path)
	
	special_dog_2.set_process(false)
	special_dog_2.set_physics_process(false)
	special_dog_2.set_process_input(false)
	special_dog_2.visible = false
	
	special_dog_3.set_process(false)
	special_dog_3.set_physics_process(false)
	special_dog_3.set_process_input(false)
	special_dog_3.visible = false
	
	farmer_2.set_process(false)
	farmer_2.set_physics_process(false)
	farmer_2.set_process_input(false)
	farmer_2.visible = false
	
	farmer_3.set_process(false)
	farmer_3.set_physics_process(false)
	farmer_3.set_process_input(false)
	farmer_3.visible = false

func advance_1():
	neighbour.text = ["God no! That's not [shake rate=20 level=10]myy[/shake] [b][color=#FF8800]doggo[/color][/b]", "can u find my [b][color=#FF8800]doggo[/color][/b] [color=red]plzzzzzzzzzzz[/color]", "i [shake rate=20 level=10]rly[/shake] miss my doggu"]
	
	stage = 1
	farmer_2.set_process(true)
	farmer_2.set_physics_process(true)
	farmer_2.set_process_input(true)
	farmer_2.visible = true
	
	farmer_1.queue_free()
	
	special_dog_2.set_process(true)
	special_dog_2.set_physics_process(true)
	special_dog_2.set_process_input(true)
	special_dog_2.visible = true

func advance_2():
	special_dog_2.movement_speed = 0
	special_dog_2.run_list = []
	
	neighbour.text = ["Thank you for finding my [b][color=#FF8800]doggo[/color][/b]", "but I have another lost [b][color=#FF8800]doggo[/color][/b]", "i [shake rate=20 level=10]rly[/shake] miss my doggu"]
	
	stage = 2
	farmer_3.set_process(true)
	farmer_3.set_physics_process(true)
	farmer_3.set_process_input(true)
	farmer_3.visible = true
	
	farmer_2.queue_free()
	
	special_dog_3.set_process(true)
	special_dog_3.set_physics_process(true)
	special_dog_3.set_process_input(true)
	special_dog_3.visible = true
	
func advance_3():
	neighbour.text = ["Thank you for finding my [b][color=#FF8800]doggos[/color][/b]!!"]

func advance():
	neighbour.player = player
	
	stage += 1
	if stage == 1:
		advance_1()
	if stage == 2:
		advance_2()
	if stage == 3:
		advance_3()
	
	neighbour.talk()
	camera.global_transform = neighbour.global_transform

func set_viewport_scale():
	var vx = get_viewport_rect().size.x
	var vy = get_viewport_rect().size.y
	
	if vx == prev_vx and vy == prev_vy:
		return
	
	prev_vx = vx
	prev_vy = vy
	var ratio = vy/vx
	
	if ratio > 75.0/128.0:
		var zoom = 1 + 0.5*(ratio * 128 / 75 - 1)
		camera.zoom.x = 0.5 / zoom
		camera.zoom.y = 0.5 / zoom
	else:
		camera.zoom.x = 0.5
		camera.zoom.y = 0.5

func _process(delta):
	var special_dog
	if stage == 0:
		special_dog = special_dog_1
	if stage == 1:
		special_dog = special_dog_2
	if stage > 1:
		special_dog = special_dog_3
		
	var dist = (special_dog.global_position - neighbour.global_position).length()
	if dist < NEIGHBOUR_SPECIAL_DOG_TRIGGER_DISTANCE:
		advance()
		
	set_viewport_scale()
		
