extends KinematicBody2D

export var tags : String
export var run_from : String
export var whitelist = false
export var movement_speed = 80
export var walk_speed = 40
export var scare_radius = 50
export var scare_time = 2

var tags_list = []
var run_list = []
var run_from_all = false

var scare_area
var detection_area

var running_from : Node2D
var running_time_left = 0

var idle_move_time = 0
var idle_is_moving = false
var idle_moving_direction = Vector2(0,1)

enum Direction {UP, DOWN, LEFT, RIGHT}
var last_moving = false
var last_direction = Direction.DOWN

func _ready():
	tags_list = Array(tags.split(' '))
	if run_from == '*':
		run_from_all = true
	else:
		run_list = Array(run_from.split(' '))
	
	# Create scare Area2D
	scare_area = Area2D.new()
	var area_collision = CollisionShape2D.new()
	var circleshape = CircleShape2D.new()
	circleshape.radius = scare_radius
	area_collision.shape = circleshape
	scare_area.add_child(area_collision)
	add_child(scare_area)
	
	# Create detection Area2D
	detection_area = Area2D.new()
	var detect_collision = CollisionShape2D.new()
	var circleshape2 = CircleShape2D.new()
	circleshape2.radius = 1
	detect_collision.shape = circleshape2
	detection_area.add_child(detect_collision)
	add_child(detection_area)
	
	# Connect scare Area2D signal for when another area enters
	scare_area.connect("area_entered", self, "on_area_enter")
	
func on_area_enter(area : Area2D):
	if whitelist and run_from_all:
		return
	
	var a_parent = area.get_parent()
	if not "tags_list" in a_parent:
		return
	
	var a_tag_list = a_parent.tags_list
	
	if (not whitelist) and run_from_all and len(a_tag_list) > 0:
		trigger_run_from(a_parent)
		return
	
	var tag_match = false
	for t in a_tag_list:
		if tags_list.has(t):
			tag_match = true
			break
			
	if (not whitelist) and tag_match:
		trigger_run_from(a_parent)
		
	if whitelist and (not tag_match):
		trigger_run_from(a_parent)

func trigger_run_from(node):
	running_from = node
	running_time_left = scare_time

func idle_movement(delta):
	idle_move_time -= delta
	if idle_move_time < 0:
		idle_is_moving = not idle_is_moving
		if idle_is_moving:
			idle_move_time = rand_range(0.5,1.5)
		else:
			idle_move_time = rand_range(1,6)
		
		if idle_is_moving:
			for i in range(0,5):
				idle_moving_direction = Vector2(rand_range(0,1), rand_range(0,1)).normalized()
				# If will hit a wall, don't move.
				var will_collide = test_move(global_transform, idle_moving_direction * 1)
				if not will_collide:
					break
	
	if idle_is_moving:
		var velocity = idle_moving_direction * walk_speed
		var will_collide = test_move(global_transform, velocity)
		if not will_collide:
			move_and_slide(velocity)
		else:
			idle_is_moving = false
			
	play_animation(idle_is_moving, idle_moving_direction)
	
func flee_movement(delta):
	running_time_left -= delta
	var velocity = -1*movement_speed*(running_from.global_position - global_position).normalized()
	move_and_slide(velocity)
	play_animation(true, velocity)
	idle_moving_direction = velocity.normalized()
	idle_is_moving = false
	idle_move_time = 1
	
func play_animation(moving, vector):
	var ang = vector.angle()
	var direction
	if ang <= PI/4 and ang >= -1*PI/4:
		direction = Direction.RIGHT
	elif ang > PI/4 and ang <= 3*PI/4:
		direction = Direction.DOWN
	elif ang <= -1*PI/4 and ang >= -3*PI/4:
		direction = Direction.UP
	else:
		direction = Direction.LEFT
		
	if vector.x == 0 and vector.y == 0:
		direction = Direction.DOWN
		moving = false
	
	if moving == last_moving and direction == last_direction:
		return
		
	last_moving = moving
	last_direction = direction
	
	var start = 'run' if moving else 'idle'
	var end
	
	if direction == Direction.RIGHT:
		end = 'right'
	elif direction == Direction.LEFT:
		end = 'left'
	elif direction == Direction.DOWN:
		end = 'down'
	elif direction == Direction.UP:
		end = 'up'
	
	if $AnimatedSprite.frames.has_animation(start + '_' + end):
		$AnimatedSprite.play(start + '_' + end)
	else:
		start = 'run'
		$AnimatedSprite.play(start + '_' + end)
		$AnimatedSprite.stop()
		$AnimatedSprite.frame = 0

func _process(delta):
	if running_time_left <= 0:
		$AnimatedSprite.speed_scale = 1.0
		idle_movement(delta)
	else:
		$AnimatedSprite.speed_scale = 2.0
		flee_movement(delta)
		
	
		
	
