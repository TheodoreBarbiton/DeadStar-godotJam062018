extends Sprite

var pos
var col
var tex = load("res://tile.png")
var mater = load("res://colour.shader")

func _init(pos,col):
	self.pos = pos
	self.col = col

func _ready():
	set_position(pos)
	set_texture(tex)
	var mat = ShaderMaterial.new()
	mat.set_shader(mater)
	set_material(mat)
	self.material.set_shader_param("colour",col)