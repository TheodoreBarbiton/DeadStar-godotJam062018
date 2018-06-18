extends KinematicBody2D

var sprite
var timer
var labelT
var labelP
var energy = 6
var energyMax = 6
var wait = false
signal heated

func _ready():
	sprite = get_node("Sprite")
	call_deferred("set_camera")

func _physics_process(delta):
	var oldPos = position
	if Input.is_action_just_pressed("ui_up"):
		move_and_collide(Vector2(0,-global.tileSize))
		sprite.flip_h = !sprite.flip_h
	if Input.is_action_just_pressed("ui_down"):
		move_and_collide(Vector2(0,global.tileSize))
		sprite.flip_h = !sprite.flip_h
	if Input.is_action_just_pressed("ui_left"):
		move_and_collide(Vector2(-global.tileSize,0))
		sprite.flip_h = true
	if Input.is_action_just_pressed("ui_right"):
		move_and_collide(Vector2(global.tileSize,0))
		sprite.flip_h = false
	if position.x < 1 or position.y < 1 or position.x > global.w-1 or position.y > global.h-1:
		position = oldPos
	if Input.is_action_just_pressed("ui_accept"):
		if wait == false:
			use()
	if global.people < 1:
		global.change("Gameover")

func use():
	if energy > 0:
		energy-=1
		emit_signal("heated")
	else:
		wait = true
		get_node("EnergyLow").show()
		timer = Timer.new()
		timer.connect("timeout",self,"timer_done")
		timer.set_wait_time(2)
		get_parent().call_deferred("add_child",timer)
		timer.start()

func timer_done():
	wait = false
	timer.queue_free()
	get_node("EnergyLow").hide()

func set_camera():
	get_node("Camera").limit_right = global.w
	get_node("Camera").limit_bottom = global.h