extends Sprite

var amount = 8

func _on_Area2D_body_entered(body):
	if body == global.player:
		global.player.energy += amount
		if global.player.energy > global.player.energyMax:
			global.player.energy = global.player.energyMax
		if amount > 1:
			set_region_rect(Rect2((8-amount)*16,0,16,16))
			amount-=1