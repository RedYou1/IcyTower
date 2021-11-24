tool
extends KinematicBody2D


export(float) var width = 100 setget setW
export(float) var height = 20 setget setH

func setW(_width):
	width = _width
	var col = get_node("CollisionShape2D")
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(width/2,height/2)
	col.shape = shape
	col.position = Vector2(width/2,height/2)
	update()
	
func setH(_height):
	height = _height
	var col = get_node("CollisionShape2D")
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(width/2,height/2)
	col.shape = shape
	col.position = Vector2(width/2,height/2)
	update()


func _ready():
	var col = get_node("CollisionShape2D")
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(width/2,height/2)
	col.shape = shape
	col.position = Vector2(width/2,height/2)
	update()

func _draw():
	draw_rect(Rect2(0,0,width,height),Color.white)
