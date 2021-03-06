extends RichTextLabel

#Declare member variables here. Examples:

var dialog = ["Oh no i lost my [b][color=#FF8800]doggo[/color][/b]", "can u find it [color=red]plzzzzzzzzzzz[/color]", "i [shake rate=20 level=10]rly[/shake] miss my doggu"]
var page = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	load_dialogue()
	set_process_input(true)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton && event.is_pressed():
		if get_visible_characters() > get_total_character_count():
			load_dialogue()
					
func load_dialogue():
	if page < dialog.size() :
		bbcode_text = dialog[page]
		set_visible_characters(0)
		print("aaah")
		$Tween.interpolate_property(self, "visible_characters", 0, 
		len(dialog[page]), len(dialog[page])/10, 
		Tween.TRANS_LINEAR)
		$Tween.start()
		page+=1
	else:
		get_parent().queue_free()

