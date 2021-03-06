extends KinematicBody2D

export var movement_speed = 2

enum Direction {UP, DOWN, LEFT, RIGHT}
var last_direction = Direction.DOWN

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	var xness = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	var yness = int(Input.is_action_pressed("move_up")) - int(Input.is_action_pressed("move_down"))
	
	var velocity = Vector2(xness, yness)
	velocity = velocity * movement_speed / velocity.length()
	
	move_and_slide(velocity)
