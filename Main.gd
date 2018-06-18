extends Node

var dif
var width
var height

func _ready():
	dif = global.difficulty
	width = 11+dif*4
	height = 7+dif*4