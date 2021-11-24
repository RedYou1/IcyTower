tool
extends Node

const rang = preload("res://Scenes/rang.tscn")

export(float) var width = 1000 setget setWidth
export(float) var height = 1000 setget setHeight

export(float) var plancher_min_width = 50 setget setPMin
export(float) var plancher_max_width = 200 setget setPMax
export(int) var nombre_plancher = 6 setget setPNb

export(float) var plancher_height = 20 setget setPHeight

export(bool) var reset setget reset_rangs

var joueur
var cam
var checkout

func setPMin(pmw):
	plancher_min_width = pmw
	reset_rangs()

func setPMax(pmw):
	plancher_max_width = pmw
	reset_rangs()

func setPNb(nb):
	nombre_plancher = nb
	reset_rangs()

func setWidth(w):
	width = w
	reset_rangs()

func setHeight(h):
	height = h
	reset_rangs()

func setPHeight(h):
	plancher_height = h
	reset_rangs()

func reset_rangs(none=true):
	if Engine.editor_hint:
		var rangs = get_node("rangs")
		for rang in rangs.get_children():
			rangs.remove_child(rang)
		__ajoutRangs()

func __ajoutRangs():
	var rangs = get_node("rangs")
	var joueur = get_node("joueur")
	var diff = -height + plancher_height + joueur.radius
	
	joueur.position = Vector2(width/2,0)
	
	var t = rang.instance()
	t.width = width
	t.height = height
	t.plancher_min_width = plancher_min_width
	t.plancher_max_width = plancher_max_width
	t.nombre_plancher = nombre_plancher
	t.plancher_height = plancher_height
	t.position.y = diff
	rangs.add_child(t)
	t.reset_interne()
	
	t = rang.instance()
	t.width = width
	t.height = height
	t.plancher_min_width = plancher_min_width
	t.plancher_max_width = plancher_max_width
	t.nombre_plancher = nombre_plancher
	t.plancher_height = plancher_height
	t.position.y = diff - height
	rangs.add_child(t)
	t.reset_interne()
	
	t = rang.instance()
	t.width = width
	t.height = height
	t.plancher_min_width = plancher_min_width
	t.plancher_max_width = plancher_max_width
	t.nombre_plancher = nombre_plancher
	t.plancher_height = plancher_height
	t.position.y = diff - height*2
	rangs.add_child(t)
	t.reset_interne()

func _ready():
	if not Engine.editor_hint:
		__ajoutRangs()
		joueur = get_node("joueur")
		cam = get_node("Camera2D")
		checkout = - height - plancher_height - joueur.radius
	

func setPosY():
	cam.position.y = joueur.position.y
	if joueur.position.y < checkout:
		var rangs = get_node("rangs")
		for child in rangs.get_children():
			if child.position.y > 0:
				child.position.y -= height*2
				child.reset_interne()
			else:
				child.position.y += height
		
		joueur.position.y += height


