extends Node2D

var col = 1.0
var inc = false
var timer
var buttons = []
var current = 0

func _ready():
	buttons = get_children()
	pulse_start()
	buttons[0].text = "Difficulty: "+str(global.difficulty)
	buttons[1].text = "Windowsize: "+str(global.windowS)
	buttons[2].text = "Show intro: "+str(global.showIntro)

func _process(delta):
		if Input.is_action_just_pressed("ui_up") and current > 0:
			pulse_reset()
			current-=1
		if Input.is_action_just_pressed("ui_down") and current < 3:
			pulse_reset()
			current+=1
		if Input.is_action_just_pressed("ui_accept"):
			pulse_reset()
			enter()

func enter():
	if current == 0:
		pulse_reset()
		if global.difficulty < 10:
			global.difficulty+=1
		else:
			global.difficulty = 1
		buttons[current].text = "Difficulty: "+str(global.difficulty)
	elif current == 1:
		pulse_reset()
		global.window_size(1)
		buttons[current].text = "Windowsize: "+str(global.windowS)
	elif current == 2:
		pulse_reset()
		global.showIntro = !global.showIntro
		buttons[current].text = "Show intro: "+str(global.showIntro)
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
	buttons[current].add_color_override("font_color", Color(col,col,col))

func pulse_reset():
	col = 1.0
	inc = false
	buttons[current].add_color_override("font_color", Color(1.0,1.0,1.0))
	timer.queue_free()
	pulse_start()

func pulse_start():
	timer = Timer.new()
	timer.connect("timeout",self,"pulse")
	timer.set_wait_time(0.2)
	call_deferred("add_child",timer)
	timer.start()