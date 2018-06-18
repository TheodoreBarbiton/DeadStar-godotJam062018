extends Node

var timer
var label
var text = ["Energy, movement, heat; all things essential for the continuation of life...\n  How often do we ponder our own fragility?","As the final star in the galaxy burns out, this is the question on the minds of the few members of humanity who remain\n  Cold, shivering, as the light dies and the temperature falls","You have been entrusted with the final portable fusion reactor, the one hope of saving what life reamins, but you know it isn't enough","Even so, you ready yourself for your quest to bring what little warmth you can back to this final oupost of humanity orbiting the now dead star\n  Good luck"]
var num = 0

func _ready():
	label = get_node("Label")
	timer_start(0.5)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		global.change("Main")

func timer_start(time):
	timer = Timer.new()
	timer.connect("timeout",self,"timer_done")
	timer.set_wait_time(time)
	get_parent().call_deferred("add_child",timer)
	timer.start()

func timer_done():
	timer.queue_free()
	if num < 4:
		label.text = text[num]
		num+=1
		timer_start(8)
	elif num == 4:
		label.text=""
		num+=1
		timer_start(0.5)
	else:
		global.change("Main")