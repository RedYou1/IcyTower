tool
extends Node2D

const plancher = preload("res://Scenes/plancher.tscn")
const drapeau = preload("res://Scenes/Drapeau.tscn")
const gomba = preload("res://Scenes/Gomba.tscn")

export(float) var distance_entre_plancher = 200 setget changerDistance

export(float) var longueur_default = 1000 setget changerlongueur
export(float) var plancher_min_longueur_default = 150 setget changerPMin
export(float) var plancher_max_longueur_default = 300 setget changerPMax
export(float) var plancher_hauteur_default = 20 setget changerPhauteur
export(float) var max_distance_x = 250 setget changerMaxX

export(float) var chance_normal = 1 setget changerNormal
export(float) var chance_gomba = 1 setget changerGomba
export(float) var chance_casser = 1 setget changerCasser

var longueur = longueur_default
var hauteur = 0
var plancher_min_longueur = plancher_min_longueur_default
var plancher_max_longueur = plancher_max_longueur_default
var plancher_hauteur = plancher_hauteur_default
var nombre_plancher = 5

export(int) var niveau = 1 setget changerNiveau

export(bool) var reset setget reset_interne

func changerMaxX(x):
	if max_distance_x != x:
		max_distance_x = x
		reset_interne()

func changerCasser(g):
	if chance_casser != g:
		chance_casser = g
		reset_interne()

func changerNormal(n):
	if chance_normal != n:
		chance_normal = n
		reset_interne()

func changerGomba(g):
	if chance_gomba != g:
		chance_gomba = g
		reset_interne()

func changerNiveau(niv):
	if niveau != niv:
		niveau = niv
		reset_interne()

func changerPMin(pmw):
	if plancher_min_longueur_default != pmw:
		plancher_min_longueur_default = pmw
		reset_interne()

func changerPMax(pmw):
	if plancher_max_longueur_default != pmw:
		plancher_max_longueur_default = pmw
		reset_interne()

func changerlongueur(w):
	if longueur_default != w:
		longueur_default = w
		reset_interne()

func changerDistance(d):
	distance_entre_plancher = d
	reset_interne()

func changerPhauteur(h):
	plancher_hauteur_default = h
	reset_interne()

func calc_niveau():
	var n = niveau-1
	longueur = longueur_default
	plancher_min_longueur = plancher_min_longueur_default - min(n,plancher_min_longueur_default-10)
	plancher_max_longueur = plancher_max_longueur_default - min(n,plancher_min_longueur_default-plancher_min_longueur)
	plancher_hauteur = plancher_hauteur_default
	nombre_plancher = 6 + n * 2 
	hauteur = nombre_plancher * (distance_entre_plancher + plancher_hauteur)
	position.y = - hauteur

func reset_interne(a=true):
	calc_niveau()
	
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
	
	var label = get_node("Label")
	label.rect_size = Vector2(longueur/5,(hauteur-plancher_hauteur)/5)
	label.text = str(niveau)
	
	var lave = get_node("Lave")
	lave.position = Vector2(-hauteur,hauteur+lave.vitesse*100)
	lave.longueur = hauteur * 3
	
	var intern = get_node("interne")
	
	var p = null
	
	for i in range(nombre_plancher+1):
		var w = rand_range(plancher_min_longueur,plancher_max_longueur)
		var x
		if p != null:
			x = rand_range(max(0,p.position.x-w-max_distance_x),min(longueur-w,p.position.x+p.longueur+max_distance_x))
		else:
			x = rand_range(0,longueur-w)
		p = plancher.instance()
		p.longueur = w
		p.hauteur = plancher_hauteur
		var py = (hauteur-plancher_hauteur) - i*(distance_entre_plancher+plancher_hauteur)
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
	d.position = Vector2(p.position.x+p.longueur/2+16,p.position.y-p.hauteur/2-16)
	intern.add_child(d)
	
	p = plancher.instance()
	p.longueur = longueur
	p.hauteur = plancher_hauteur
	p.position = Vector2(0,hauteur-plancher_hauteur)
	intern.add_child(p)
	
	var j = get_node("joueur")
	j.position = Vector2(p.position.x+p.longueur/2,p.position.y-j.rayon)

var joueur

func _ready():
	__ajoutPlancher()
	joueur = get_node("joueur")


