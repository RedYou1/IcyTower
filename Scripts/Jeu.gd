tool
extends Node2D

const plancher = preload("res://Scenes/plancher.tscn")
const drapeau = preload("res://Scenes/Drapeau.tscn")
const gomba = preload("res://Scenes/Gomba.tscn")

export(float) var distance_entre_plancher = 200 setget setDistance

export(float) var width_default = 1000 setget setWidth
export(float) var plancher_min_width_default = 150 setget setPMin
export(float) var plancher_max_width_default = 300 setget setPMax
export(float) var plancher_height_default = 20 setget setPHeight
export(float) var max_distance_x = 250 setget setMaxX

export(float) var chance_normal = 1 setget setNormal
export(float) var chance_gomba = 1 setget setGomba
export(float) var chance_casser = 1 setget setCasser

var width = width_default
var height = 0
var plancher_min_width = plancher_min_width_default
var plancher_max_width = plancher_max_width_default
var plancher_height = plancher_height_default
var nombre_plancher = 5

export(int) var niveau = 1 setget setNiveau

export(bool) var reset setget reset_interne

func setMaxX(x):
	if max_distance_x != x:
		max_distance_x = x
		reset_interne()

func setCasser(g):
	if chance_casser != g:
		chance_casser = g
		reset_interne()

func setNormal(n):
	if chance_normal != n:
		chance_normal = n
		reset_interne()

func setGomba(g):
	if chance_gomba != g:
		chance_gomba = g
		reset_interne()

func setNiveau(niv):
	if niveau != niv:
		niveau = niv
		reset_interne()

func setPMin(pmw):
	if plancher_min_width_default != pmw:
		plancher_min_width_default = pmw
		reset_interne()

func setPMax(pmw):
	if plancher_max_width_default != pmw:
		plancher_max_width_default = pmw
		reset_interne()

func setWidth(w):
	if width_default != w:
		width_default = w
		reset_interne()

func setDistance(d):
	distance_entre_plancher = d
	reset_interne()

func setPHeight(h):
	plancher_height_default = h
	reset_interne()

func calc_niveau():
	var n = niveau-1
	width = width_default
	plancher_min_width = plancher_min_width_default - min(n,plancher_min_width_default-10)
	plancher_max_width = plancher_max_width_default - min(n,plancher_min_width_default-plancher_min_width)
	plancher_height = plancher_height_default
	nombre_plancher = 6 + n * 2 
	height = nombre_plancher * (distance_entre_plancher + plancher_height)
	position.y = - height

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
	randomize()
	if calc:
		calc_niveau()
	
	var intern = get_node("interne")
	
	var p = null
	
	for i in range(nombre_plancher+1):
		var w = rand_range(plancher_min_width,plancher_max_width)
		var x
		if p != null:
			x = rand_range(max(0,p.position.x-w-max_distance_x),min(width-w,p.position.x+p.width+max_distance_x))
		else:
			x = rand_range(0,width-w)
		p = plancher.instance()
		p.width = w
		p.height = plancher_height
		var py = (height-plancher_height) - i*(distance_entre_plancher+plancher_height)
		p.position = Vector2(x,py)
		
		if i < nombre_plancher and i > 1:
			
			var r = rand_range(0,chance_casser+chance_gomba+chance_normal)
			
			if r < chance_casser:
				p.casser = true
			elif r < chance_casser+chance_gomba:
				var g = gomba.instance()
				g.minX = x
				g.maxX = x+w
				g.position = Vector2(x+rand_range(0,w),py-32)
				g.dir = round(rand_range(0,1))*2-1
				intern.add_child(g)
		
		intern.add_child(p)
	
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
