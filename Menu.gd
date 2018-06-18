extends Node

var buttons = []
var current = 0
var done = false
var col = 1.0
var inc = false
var timer

func _ready():
	buttons = get_node("Buttons").get_children()
	pulse_start()

func _process(delta):
	if done == false:
		if Input.is_action_just_pressed("ui_up") and current > 0:
			pulse_reset()
			current-=1
		if Input.is_action_just_pressed("ui_down") and current < 3:
			pulse_reset()
			current+=1
		if Input.is_action_just_pressed("ui_accept"):
			pulse_reset()
			done = true
			flash_start()

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

func flash():
	timer.queue_free()
	flash_start()
	if inc == true:
		inc = false
		buttons[current].add_color_override("font_color", Color(1.0,1.0,1.0))
	else:
		inc = true
		buttons[current].add_color_override("font_color", Color(0.0,0.0,0.0))
		col+=1
	if col >= 5:
		enter(current)

func flash_start():
	timer.queue_free()
	timer = Timer.new()
	timer.connect("timeout",self,"flash")
	timer.set_wait_time(0.2)
	call_deferred("add_child",timer)
	timer.start()

func enter(b):
	if b == 0:
		if global.showIntro == true:
			global.change("Intro")
		else:
			global.change("Main")
	elif b == 1:
		global.change("Instructions")
	elif b == 2:
		global.change("Options")
	else:
		get_tree().quit()