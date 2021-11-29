tool
extends Node

const plancher = preload("res://Scenes/plancher.tscn")

export(float) var width = 1000 setget setWidth
export(float) var height = 1000 setget setHeight

export(float) var plancher_min_width = 50 setget setPMin
export(float) var plancher_max_width = 200 setget setPMax
export(int) var nombre_plancher = 6 setget setPNb

export(float) var plancher_height = 20 setget setPHeight

export(int) var niveau = 1 setget setNiveau

export(bool) var reset setget reset_interne

func setNiveau(niv):
	niveau = niv
	reset_interne()

func setPMin(pmw):
	plancher_min_width = pmw
	reset_interne()

func setPMax(pmw):
	plancher_max_width = pmw
	reset_interne()

func setPNb(nb):
	nombre_plancher = nb
	reset_interne()

func setWidth(w):
	width = w
	get_node("DROIT").position.x = width
	reset_interne()

func setHeight(h):
	height = h
	get_node("DROIT").position.y = height
	get_node("DROIT").width = height
	get_node("GAUCHE").width = height
	reset_interne()

func setPHeight(h):
	plancher_height = h
	reset_interne()

func reset_interne(a=true):
	var label = get_node("Label")
	label.rect_size = Vector2(width/5,(height-plancher_height)/5)
	label.text = str(niveau)
	
	var intern = get_node("interne")
	for child in intern.get_children():
		intern.remove_child(child)
	__ajoutPlancher()

func on_create_foo_button_pressed(a):
	reset_interne()

func __ajoutPlancher():
	var intern = get_node("interne")
	var diff = height/(nombre_plancher+1)
	for i in range(1,nombre_plancher+1):
		var w = rand_range(plancher_min_width,plancher_max_width)
		var x = rand_range(0,width-w)
		var p = plancher.instance()
		p.width = w
		p.height = plancher_height
		p.position = Vector2(x,i*diff)
		intern.add_child(p)
	
	var p = plancher.instance()
	p.width = width
	p.height = plancher_height
	p.position = Vector2(0,height-plancher_height)
	intern.add_child(p)
	
	var j = get_node("joueur")
	j.position = Vector2(p.position.x+p.width/2,p.position.y-j.radius)

func _ready():
	if not Engine.editor_hint:
		__ajoutPlancher()
