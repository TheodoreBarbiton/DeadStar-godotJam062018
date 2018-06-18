extends Node

var tileSize = 16
var difficulty = 1
var showIntro = true
var people
var windowD
var windowS = 3
var player
var grid
var w
var h

func _ready():
	windowD = OS.get_window_size()
	window_size(0)

func change(s):
	match s:
		"Main":
			get_tree().change_scene("res://Main.tscn")
			call_deferred("get_things")
		"Intro":
			get_tree().change_scene("res://Intro.tscn")
		"Menu":
			get_tree().change_scene("res://Menu.tscn")
		"Instructions":
			get_tree().change_scene("res://Instructions.tscn")
		"Gameover":
			get_tree().change_scene("res://Gameover.tscn")
		"Options":
			get_tree().change_scene("res://Options.tscn")

func get_things():
	player = get_parent().get_node("Main/Player")
	grid = get_parent().get_node("Main/Grid")

func window_size(c):
	if c > 0:
		var sSize = OS.get_screen_size()
		if sSize.y > windowD.y*(windowS+1):
			windowS+=1
		else:
			windowS = 1
	OS.set_window_size(Vector2(windowD.x*windowS,windowD.y*windowS))