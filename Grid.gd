extends Node

#var data = {}
var map = []
var timer
var count
var player
var tile = load("res://Tile.gd")
var person = load("res://Person.tscn")
var breach = load("res://Breach.tscn")
var storage = load("res://Storage.tscn")
var dif
var width
var height
signal upd
var colours = [
	Color(0.0,0.0,0.0),
	Color(0.039,0.039,0.039),
	Color(0.078,0.078,0.078),
	Color(0.156,0.156,0.156),
	Color(0.216,0.216,0.216),
	Color(0.274,0.274,0.274),
	Color(0.341,0.306,0.306),
	Color(0.329,0.325,0.325),
	Color(0.455,0.325,0.325),
	Color(0.573,0.267,0.267),
	Color(0.784,0.157,0.078),
	Color(1.0,0.141,0.0),
	Color(1.0,0.427,0.0),
	Color(1.0,0.569,0.141),
	Color(1.0,0.714,0.282),
	Color(1.0,0.855,0.569),
	Color(1.0,0.855,0.714),
	Color(1.0,1.0,0.854),
	Color(1.0,1.0,1.0),
	Color(0.855,1.0,1.0),
	Color(0.855,0.855,1.0),
	Color(0.714,0.855,1.0)]

func _ready():
	randomize()
	dif = global.difficulty
	width = 11+dif*2
	height = 7+dif*2
	global.w = width*16
	global.h = height*16
	prep_map()
	prep_people()
	prep_objects()
	player = get_parent().get_node("Player")
	player.connect("heated",self,"tile_heated")
#	var file = File.new()
#	file.open("res://map.txt", file.READ)
#	var text = file.get_as_text().split(";")
#	file.close()
#	var temp1 = []
#	var temp2 = []
#	for i in text:
#		temp1.append(i.split(","))
#	for y in temp1:
#		for x in y:
#			temp2.append(int(x))
#		map.append(temp2)
#		temp2 = []
	timer_start()
	display()

func prep_map():
	var totHeat = 11*7*11+dif*24
	for y in range(0,height):
		var temp = []
		for x in range(0,width):
			temp.append(0)
		map.append(temp)
	for h in totHeat:
		var con = 0
		while con < 300:
			var hY = randi()%height
			var hX = randi()%width
			con+=1
			if map[hY][hX] < 21:
				map[hY][hX]+=1
				con = 300
	update()
	update()
	update()

func prep_people():
	var temP = 0
	global.people = dif*2
	for p in range(0,global.people):
		var con = 0
		while con < 300:
			var pY = randi()%height
			var pX = randi()%width
			con+=1
			if map[pY][pX] > 3:
				temP+=1
				var per = person.instance()
				get_parent().call_deferred("add_child",per)
				per.position = Vector2(pX*16+8,pY*16+8)
				con = 300
	global.people = temP

func prep_objects():
	var breaches = 1+int(dif/3)
	var storages = 1+int(dif/2)
	for b in range(0,breaches):
		var bY = randi()%height
		var bX = randi()%width
		var bre = breach.instance()
		get_parent().call_deferred("add_child",bre)
		bre.position = Vector2(bX*16,bY*16)
		bre.sta(self)
	for s in range(0,storages):
		var sY = randi()%height
		var sX = randi()%width
		var sto = storage.instance()
		get_parent().call_deferred("add_child",sto)
		sto.position = Vector2(sX*16,sY*16)

func update():
	var inc = []
	var dec = []
	for y in range(0,map.size()):
		for x in range(0,map[y].size()):
			if map[y][x] > 0:
				var changed = false
				if 0 < y and map[y-1][x] < map[y][x]:
					if list_check(inc,[y-1,x]) == true:
						inc.append([y-1,x,map[y][x]])
						changed = true
				if y < map.size()-1 and map[y+1][x] < map[y][x]:
					if list_check(inc,[y+1,x]) == true:
						inc.append([y+1,x,map[y][x]])
						changed = true
				if 0 < x and map[y][x-1] < map[y][x]:
					if list_check(inc,[y,x-1]) == true:
						inc.append([y,x-1,map[y][x]])
						changed = true
				if x < map[y].size()-1 and map[y][x+1] < map[y][x]:
					if list_check(inc,[y,x+1]) == true:
						inc.append([y,x+1,map[y][x]])
						changed = true
				if changed == true:
					dec.append([y,x])
	for n in inc:
		map[n[0]][n[1]]=n[2]-1
	for m in dec:
		map[m[0]][m[1]]-=1
	emit_signal("upd")

func list_check(list,val):
	var res = true
	for i in list:
		if i[0] == val[0] and i[1] == val[1]:
			res = false
	return res

func timer_start():
	timer = Timer.new()
	timer.connect("timeout",self,"timer_done")
	timer.set_wait_time(3)
	get_parent().call_deferred("add_child",timer)
	timer.start()

func timer_done():
	timer.queue_free()
	timer_start()
	update()
	display()

func display():
	for n in get_children():
		n.queue_free()
	for y in range(0,map.size()):
		for x in range(0,map[y].size()):
			var t = tile.new(Vector2(x*global.tileSize+global.tileSize/2,y*global.tileSize+global.tileSize/2),colours[map[y][x]])
			add_child(t)

func tile_heated():
	var tX = player.position.x/16
	var tY = player.position.y/16
	if map[tY][tX] < 21:
		map[tY][tX]+=1
		display()
	if map[tY-1][tX] < 21:
		map[tY-1][tX]+=1
	if map[tY+1][tX] < 21:
		map[tY+1][tX]+=1
	if map[tY][tX+1] < 21:
		map[tY][tX+1]+=1
	if map[tY][tX-1] < 21:
		map[tY][tX-1]+=1

func suck(brX,brY):
	var breX = brX/16
	var breY = brY/16
	if map[breY][breX] > 0:
		map[breY][breX]-=1