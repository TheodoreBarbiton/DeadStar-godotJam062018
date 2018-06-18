extends Node

var instructs = []
var current = 1
var timer
var next
var col = 1.0
var inc = false

func _ready():
	instructs = get_children()
	next = get_node("Next")
	pulse_start()

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if current < 4:
			instructs[current].hide()
			current+=1
			instructs[current].show()
			pulse_reset()
		else:
			global.change("Menu")

func pulse():
	timer.queue_free()
	pulse_start()
	if col > 1.2 or col < 0.4:
		inc = !inc
	if inc == true:
		col+=0.2
	else:
		col-=0.2
	next.add_color_override("font_color", Color(col,col,col))

func pulse_reset():
	col = 1.0
	inc = false
	next.add_color_override("font_color", Color(1.0,1.0,1.0))
	timer.queue_free()
	pulse_start()

func pulse_start():
	timer = Timer.new()
	timer.connect("timeout",self,"pulse")
	timer.set_wait_time(0.2)
	call_deferred("add_child",timer)
	timer.start()