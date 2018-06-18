extends CanvasLayer

var labelT
var labelP
var count
var sec = 0
var secMilli = 0

func _ready():
	labelT = get_node("LabelT")
	labelP = get_node("LabelP")
	count_start()

func _process(delta):
	labelP.text = str(global.people)+"p"

func count_start():
	count = Timer.new()
	count.connect("timeout",self,"count_done")
	count.set_wait_time(0.1)
	add_child(count)
	count.start()

func count_done():
	count.queue_free()
	count_start()
	secMilli+=1
	if secMilli == 10:
		secMilli = 0
		sec+=1
	labelT.text = str(sec)+"."+str(secMilli)+"s"
