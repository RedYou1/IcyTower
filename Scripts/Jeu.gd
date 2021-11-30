tool
extends Node

const plancher = preload("res://Scenes/plancher.tscn")
const drapeau = preload("res://Scenes/Drapeau.tscn")
const gomba = preload("res://Scenes/Gomba.tscn")

export(float) var width_default = 1000 setget setWidth
export(float) var height_default = 1000 setget setHeight
export(float) var plancher_min_width_default = 150 setget setPMin
export(float) var plancher_max_width_default = 300 setget setPMax
export(int) var nombre_plancher_default = 5 setget setPNb
export(float) var plancher_height_default = 20 setget setPHeight

var width = width_default
var height = height_default
var plancher_min_width = plancher_min_width_default
var plancher_max_width = plancher_max_width_default
var nombre_plancher = nombre_plancher_default
var plancher_height = plancher_height_default

export(int) var niveau = 1 setget setNiveau

export(bool) var reset setget reset_interne

func setNiveau(niv):
	niveau = niv
	reset_interne()

func setPMin(pmw):
	plancher_min_width_default = pmw
	reset_interne()

func setPMax(pmw):
	plancher_max_width_default = pmw
	reset_interne()

func setPNb(nb):
	nombre_plancher_default = nb
	reset_interne()

func setWidth(w):
	width_default = w
	get_node("DROIT").position.x = width
	reset_interne()

func setHeight(h):
	height_default = h
	get_node("DROIT").position.y = height_default
	get_node("DROIT").width = height_default
	get_node("GAUCHE").width = height_default
	reset_interne()

func setPHeight(h):
	plancher_height_default = h
	reset_interne()

func calc_niveau():
	var n = niveau-1
	width = width_default
	height = height_default + n*400
	plancher_min_width = plancher_min_width_default - min(n,plancher_min_width_default-10)
	plancher_max_width = plancher_max_width_default - min(n,plancher_min_width_default-plancher_min_width)
	nombre_plancher = nombre_plancher_default + n * 2
	plancher_height = plancher_height_default

func reset_interne(a=true):
	calc_niveau()
	var label = get_node("Label")
	label.rect_size = Vector2(width/5,(height-plancher_height)/5)
	label.text = str(niveau)
	
	var intern = get_node("interne")
	for child in intern.get_children():
		intern.remove_child(child)
	__ajoutPlancher(false)

func on_create_foo_button_pressed(a):
	reset_interne()

func __ajoutPlancher(calc=true):
	if calc:
		calc_niveau()
	
	var gauche = get_node("GAUCHE")
	gauche.width = height
	
	var droit = get_node("DROIT")
	droit.position = Vector2(width,height)
	droit.width = height
	
	var gombaNb = floor(niveau/2)
	
	var intern = get_node("interne")
	var diff = height/(nombre_plancher+1)
	
	var p = null
	
	for i in range(nombre_plancher,-1,-1):
		var w = rand_range(plancher_min_width,plancher_max_width)
		var x
		if p != null:
			x = rand_range(max(0,p.position.x-w-300),min(width-w,p.position.x+p.width+300))
		else:
			x = rand_range(0,width-w)
		p = plancher.instance()
		p.width = w
		p.height = plancher_height
		p.position = Vector2(x,i*diff)
		intern.add_child(p)
		
		if i > 1 and gombaNb > 0 and rand_range(0,1) >= .5:
			var g = gomba.instance()
			g.minX = x
			g.maxX = x+w
			g.position = Vector2(x+rand_range(0,w),i*diff-32)
			g.dir = round(rand_range(0,1))*2-1
			intern.add_child(g)
			gombaNb -= 1
	
	p = intern.get_child(intern.get_child_count()-1)
	var d = drapeau.instance()
	d.position = Vector2(p.position.x+p.width/2,p.position.y-5)
	intern.add_child(d)
	
	p = plancher.instance()
	p.width = width
	p.height = plancher_height
	p.position = Vector2(0,height-plancher_height)
	intern.add_child(p)
	
	var j = get_node("joueur")
	j.position = Vector2(p.position.x+p.width/2,p.position.y-j.radius)

func _ready():
	__ajoutPlancher()
