extends KinematicBody2D

export var movement_speed = 75
export var camera_path : NodePath

var camera : Camera2D

enum Direction {UP, DOWN, LEFT, RIGHT}
var last_direction = Direction.DOWN
var last_moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if camera_path != null:
		camera = get_node(camera_path)

func play_animation(moving, direction):
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
		
	$AnimatedSprite.play(start + '_' + end)

func _process(delta):
	if camera != null:
		camera.position = position
	
	var xness = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	var yness = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	var velocity = Vector2(xness, yness).normalized()
	velocity = velocity * movement_speed
	
	if xness == 0 and yness == 0:
		play_animation(false, last_direction)
	elif yness > 0:
		play_animation(true, Direction.DOWN)
	elif xness > 0:
		play_animation(true, Direction.RIGHT)
	elif xness < 0:
		play_animation(true, Direction.LEFT)
	elif yness < 0:
		play_animation(true, Direction.UP)
	
	move_and_slide(velocity)
