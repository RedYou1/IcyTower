tool
extends Node2D

export(float) var longueur = 1000 setget setLongueur

export(float) var hauteur = 1000 setget setHauteur

export(float) var vitesse = 3

var parent
var joueur

func setLongueur(l):
	longueur = l
	update()

func setHauteur(h):
	hauteur = h
	update()

func _ready():
	if not Engine.editor_hint:
		parent = get_parent()
		joueur = parent.get_node("joueur")

func _process(delta):
	if not Engine.editor_hint:
		position.y -= vitesse
		if joueur.position.y + joueur.rayon > position.y:
			parent.niveau = 1
			parent.reset_interne()
		else:
			joueur.update()

func _draw():
	draw_rect(Rect2(0,0,longueur,hauteur),Color.orange)
