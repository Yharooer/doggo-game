extends RichTextLabel

#Declare member variables here. Examples:

var dialog = ["[shake rate=20 level=10]An error occured..[/shake]", "This property should be set by the NPC class."]
var page = 0
var player : KinematicBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	load_dialogue()
	set_process_input(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if (event is InputEventMouseButton && event.is_pressed()) or (Input.is_action_pressed("interact")):
		
		print('poopoo')
		
		if get_visible_characters() >= get_total_character_count():
			
			print('asdfasdf')
			load_dialogue()
					
func load_dialogue():
	print(dialog)
	print(player)
	if page < dialog.size():
		if player != null:
			if 'paused' in player:
				player.paused = true
		bbcode_text = dialog[page]
		set_visible_characters(0)
		print("aaah")
		$Tween.interpolate_property(self, "visible_characters", 0, 
		len(dialog[page]), len(dialog[page])/10, 
		Tween.TRANS_LINEAR)
		$Tween.start()
		page+=1
	else:
		if player != null:
			if 'paused' in player:
				player.paused = false
		get_parent().queue_free()

