tool
extends KinematicBody2D


export(float) var longueur = 100 setget changerLongueur
export(float) var hauteur = 20 setget changerHauteur
export(bool) var casser = false setget changerCasser

export(Color) var couleurBase = Color.white setget changerCouleurBase
export(Color) var couleurCasser = Color.orange setget changerCouleurCasser
export(Color) var couleurCasserEnCours = Color.red

var couleur = couleurBase

func changerCouleurCasser(c):
	couleurCasserEnCours = c
	if casser:
		couleur = couleurCasserEnCours
		update()

func changerCouleurBase(c):
	couleurBase = c
	if not casser:
		couleur = couleurBase
		update()

func changerCasser(c):
	casser = c
	if casser:
		couleur = couleurCasser
	else:
		couleur = couleurBase
	update()

func changerLongueur(_longueur):
	longueur = _longueur
	var col = get_node("CollisionShape2D")
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(longueur/2,hauteur/2)
	col.shape = shape
	col.position = Vector2(longueur/2,hauteur/2)
	update()
	
func changerHauteur(_hauteur):
	hauteur = _hauteur
	var col = get_node("CollisionShape2D")
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(longueur/2,hauteur/2)
	col.shape = shape
	col.position = Vector2(longueur/2,hauteur/2)
	update()


func _ready():
	var col = get_node("CollisionShape2D")
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(longueur/2,hauteur/2)
	col.shape = shape
	col.position = Vector2(longueur/2,hauteur/2)
	update()

func toucher(qui):
	if casser and qui.name == "joueur" and get_node("CasserTemps1").is_stopped():
		get_node("CasserTemps1").start()


func _draw():
	draw_rect(Rect2(0,0,longueur,hauteur),couleur)


func _on_CasserTemps1_timeout():
	couleur = couleurCasserEnCours
	update()
	get_node("CasserTemps2").start()


func _on_CasserTemps2_timeout():
	queue_free()
