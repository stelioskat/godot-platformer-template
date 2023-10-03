extends Node2D

var loc = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.hide()

func _draw():
	$Area2D.position = loc
	$Label.position = Vector2(loc.x, loc.y - 25)
	$Label.text = "(%s, %s)" % [round(loc.x), abs(round(loc.y))]
	draw_line(loc, loc + Vector2(1.0 ,1.0 ), Color(1, 0, 0, 1), 1, true)

func init(pos : Vector2):
	loc = pos
	queue_redraw()

func _on_area_2d_mouse_entered():
	$Label.show()

func _on_area_2d_mouse_exited():
	$Label.hide()
