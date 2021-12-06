tool
extends KinematicBody2D


export(float) var rayon = 20 setget changerRayon
export(float) var gravite = 0.98
export(float) var vitesse = 7.5
export(float) var forceSaut = 25

var vitesseY = 0

var jeu

func changerRayon(_rayon):
	rayon = _rayon
	var col = get_node("CollisionShape2D")
	var shape = CircleShape2D.new()
	shape.rayon = rayon
	col.shape = shape
	col.position = Vector2()
	update()

func _ready():
	jeu = get_parent()
	var col = get_node("CollisionShape2D")
	var shape = CircleShape2D.new()
	shape.radius = rayon
	col.shape = shape
	col.position = Vector2()

func _physics_process(delta):
	if not Engine.editor_hint:
		vitesseY += gravite
		
		var qui = move_and_collide(Vector2(0,vitesseY))
		
		if qui != null:
			vitesseY = 0
			if qui.collider.has_method("toucher"):
				qui.collider.toucher(self)
		
		
		if vitesseY == 0 and Input.is_action_pressed("SAUT"):
			vitesseY -= forceSaut
		
		var deplacement = 0
		if Input.is_action_pressed("GAUCHE"):
			deplacement -= 1
		if Input.is_action_pressed("DROIT"):
			deplacement += 1
		
		if deplacement != 0:
			qui = move_and_collide(Vector2(deplacement,0)*vitesse)
			if qui != null and qui.collider.has_method("toucher"):
				qui.collider.toucher(self)

func _draw():
	draw_circle(Vector2(),rayon,Color.white)
