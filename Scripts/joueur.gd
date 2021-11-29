tool
extends KinematicBody2D


export(float) var radius = 20 setget setR
export(float) var gravity = 0.98
export(float) var speed = 5
export(float) var forceSaut = 30

var vitesseY = 0

var jeu

func setR(_radius):
	radius = _radius
	var col = get_node("CollisionShape2D")
	var shape = CircleShape2D.new()
	shape.radius = radius
	col.shape = shape
	col.position = Vector2()
	update()

func _ready():
	jeu = get_parent()
	var col = get_node("CollisionShape2D")
	var shape = CircleShape2D.new()
	shape.radius = radius
	col.shape = shape
	col.position = Vector2()

func _physics_process(delta):
	if not Engine.editor_hint:
		vitesseY += gravity
		
		var col = move_and_collide(Vector2(0,vitesseY))
		
		if col != null:
			vitesseY = 0
			if col.collider.has_method("hit"):
				col.collider.hit(self)
		
		
		if vitesseY == 0 and Input.is_action_just_pressed("SAUT"):
			vitesseY -= forceSaut
		
		var move = 0
		if Input.is_action_pressed("GAUCHE"):
			move -= 1
		if Input.is_action_pressed("DROIT"):
			move += 1
		
		if move != 0:
			col = move_and_collide(Vector2(move,0)*speed)
			if col != null and col.collider.has_method("hit"):
				col.collider.hit(self)

func _draw():
	draw_circle(Vector2(),radius,Color.white)
