extends KinematicBody2D

var sprite
var label
var timer
var heat = 9
var corpse = load("res://Corpse.tscn")

func _ready():
	sprite = get_node("Sprite")
	label = get_node("Label")
	randomize()
	timer_start()

func timer_start():
	timer = Timer.new()
	timer.connect("timeout",self,"timer_done")
	timer.set_wait_time(5)
	get_parent().call_deferred("add_child",timer)
	timer.start()

func timer_done():
	var oldPos = position
	var num = randi()%3
	if num == 0:
		move_and_collide(Vector2(0,-global.tileSize))
		sprite.flip_h = !sprite.flip_h
	elif num == 1:
		move_and_collide(Vector2(0,global.tileSize))
		sprite.flip_h = !sprite.flip_h
	elif num == 2:
		move_and_collide(Vector2(-global.tileSize,0))
		sprite.flip_h = true
	else:
		move_and_collide(Vector2(global.tileSize,0))
		sprite.flip_h = false
	if position.x < 1 or position.y < 1 or position.x > global.w-1 or position.y > global.h-1:
		position = oldPos
	timer.queue_free()
	timer_start()
	check()

func check():
	var pX = position.x/16
	var pY = position.y/16
	heat = global.grid.map[pY][pX]
	if heat < 3 or heat > 19:
		global.people-=1
		var dead = corpse.instance()
		var dir = bool(randi()%1)
		get_parent().add_child(dead)
		dead.flip_h = dir
		dead.position = position
		queue_free()

func _on_Area_body_entered(body):
	if body == global.player:
		check()
		if heat < 7:
			label.text = "I feel cold"
		elif heat > 16:
			label.text = "I feel hot"
		else:
			label.text = "Thank you"
		label.show()

func _on_Area_body_exited(body):
	if body == global.player:
		label.hide()