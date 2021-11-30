tool
extends Node2D

export(float) var width = 1000 setget setWidth

export(float) var height = 1000 setget setHeight

export(float) var speed = 5

var parent
var joueur

func setWidth(w):
	width = w
	update()

func setHeight(h):
	height = h
	update()

func _ready():
	if not Engine.editor_hint:
		parent = get_parent()
		joueur = parent.get_node("joueur")

func _process(delta):
	if not Engine.editor_hint:
		position.y -= speed
		if joueur.position.y + joueur.radius > position.y:
			parent.niveau = 1
			parent.reset_interne()
		else:
			parent.setPosLave()

func _draw():
	draw_rect(Rect2(0,0,width,height),Color.orange)
