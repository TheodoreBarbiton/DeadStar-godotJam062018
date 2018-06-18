extends Sprite

var g

func sta(thing):
	g = thing
	g.connect("upd",self,"do")

func do():
	g.suck(position.x,position.y)