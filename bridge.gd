extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var size 
const TILEMAP = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", self, "on_area_enter")
	connect("area_exited", self, "on_area_exit")


func on_area_enter(area):
	print("baa")
	for child in area.get_children():
		if child is CollisionShape2D:
			if child.get_shape() is CircleShape2D:
				if child.get_shape().radius > 13:
					return
	area.get_parent().set_collision_mask_bit(TILEMAP, false)


func on_area_exit(area):
	for child in area.get_children():
		if child is CollisionShape2D:
			if child.get_shape() is CircleShape2D:
				if child.get_shape().radius > 13:
					return
	area.get_parent().set_collision_mask_bit(TILEMAP, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
