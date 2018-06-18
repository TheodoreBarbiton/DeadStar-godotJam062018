extends Node

var timer
var num = -1

func _ready():
	timer_start()

func timer_start():
	num+=1
	timer = Timer.new()
	timer.connect("timeout",self,"timer_done")
	timer.set_wait_time(1)
	get_parent().call_deferred("add_child",timer)
	timer.start()

func timer_done():
	timer.queue_free()
	if num == 0:
		get_node("Label").text = "Game Over."
		timer_start()
	elif num == 1:
		get_node("Label").text = "Game Over.."
		timer_start()
	elif num == 2:
		get_node("Label").text = "Game Over..."
		timer_start()
	else:
		global.change("Menu")