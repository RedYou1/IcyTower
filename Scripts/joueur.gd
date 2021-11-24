tool
extends KinematicBody2D


export(float) var radius = 20 setget setR
export(float) var gravity = 0.98 setget setGrav

var vitesseY = 0

func setR(_radius):
	radius = _radius
	var col = get_node("CollisionShape2D")
	var shape = CircleShape2D.new()
	shape.radius = radius
	col.shape = shape
	col.position = Vector2()
	update()

func setGrav(_gravity):
	gravity = _gravity

func _ready():
	var col = get_node("CollisionShape2D")
	var shape = CircleShape2D.new()
	shape.radius = radius
	col.shape = shape
	col.position = Vector2()

func _process(delta):
	vitesseY += gravity
	
	var col = move_and_collide(Vector2(0,vitesseY))
	
	if col != null:
		vitesseY = 0

func _draw():
	draw_circle(Vector2(),radius,Color.white)
