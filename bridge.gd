extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", self, "on_area_enter")
	connect("area_exited", self, "on_area_exit")

const TILEMAP = 0

func on_area_enter(area):
	print(area.get_parent().tags_list)
	area.get_parent().set_collision_mask_bit(TILEMAP, false)


func on_area_exit(area):
	area.get_parent().set_collision_mask_bit(TILEMAP, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
