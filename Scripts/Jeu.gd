tool
extends Node2D

const plancher = preload("res://Scenes/plancher.tscn")
const drapeau = preload("res://Scenes/Drapeau.tscn")
const gomba = preload("res://Scenes/Gomba.tscn")

export(float) var distance_entre_plancher = 200 setget changer_distance

export(float) var longueur_default = 1000 setget changer_longueur
export(float) var plancher_min_longueur_default = 150 setget plancher_min_longueur
export(float) var plancher_max_longueur_default = 300 setget plancher_max_longueur
export(float) var plancher_hauteur_default = 20 setget changer_plancher_hauteur
export(float) var max_distance_x = 250 setget changer_max_distance_x

export(float) var chance_normal = 1 setget changer_chance_normal
export(float) var chance_gomba = 1 setget changer_chance_gomba
export(float) var chance_cassable = 1 setget changer_chance_cassable

export(int) var niveau = 1 setget changer_niveau

export(bool) var reset setget reset_interne

var longueur = longueur_default
var hauteur = 0
var plancher_min_longueur = plancher_min_longueur_default
var plancher_max_longueur = plancher_max_longueur_default
var plancher_hauteur = plancher_hauteur_default
var nombre_plancher = 5

func changer_distance(d):
	distance_entre_plancher = d
	reset_interne()

func changer_longueur(w):
	if longueur_default != w:
		longueur_default = w
		reset_interne()
		
func plancher_min_longueur(pmw):
	if plancher_min_longueur_default != pmw:
		plancher_min_longueur_default = pmw
		reset_interne()
		
func plancher_max_longueur(pmw):
	if plancher_max_longueur_default != pmw:
		plancher_max_longueur_default = pmw
		reset_interne()
		
func changer_plancher_hauteur(h):
	plancher_hauteur_default = h
	reset_interne()
	
func changer_chance_normal(n):
	if chance_normal != n:
		chance_normal = n
		reset_interne()
		
func changer_chance_gomba(g):
	if chance_gomba != g:
		chance_gomba = g
		reset_interne()
		
func changer_chance_cassable(g):
	if chance_cassable != g:
		chance_cassable = g
		reset_interne()
		
		
func changer_max_distance_x(x):
	if max_distance_x != x:
		max_distance_x = x
		reset_interne()


func changer_niveau(niv):
	if niveau != niv:
		niveau = niv
		reset_interne()

func on_create_foo_button_pressed(a):
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
	var interne = get_node("interne")
	for child in interne.get_children():
		interne.remove_child(child)
	__ajoutPlancher()

func __ajoutPlancher():
	randomize()
	calc_niveau()
	
	var label = get_node("Label")
	label.rect_size = Vector2(longueur/5,(hauteur-plancher_hauteur)/5)
	label.text = str(niveau)
	
	var lave = get_node("Lave")
	lave.position = Vector2(-hauteur,hauteur+lave.vitesse*100)
	lave.longueur = hauteur * 3
	
	var interne = get_node("interne")
	
	var p = null
	
	for i in range(nombre_plancher+1):
		var l = rand_range(plancher_min_longueur,plancher_max_longueur)
		var x
		if p != null:
			x = rand_range(max(0,p.position.x-l-max_distance_x),min(longueur-l,p.position.x+p.longueur+max_distance_x))
		else:
			x = rand_range(0,longueur-l)
		p = plancher.instance()
		p.longueur = l
		p.hauteur = plancher_hauteur
		var py = (hauteur-plancher_hauteur) - i*(distance_entre_plancher+plancher_hauteur)
		p.position = Vector2(x,py)
		
		if i < nombre_plancher and i > 1:
			
			var r = rand_range(0,chance_cassable+chance_gomba+chance_normal)
			
			if r < chance_cassable:
				p.casser = true
			elif r < chance_cassable+chance_gomba:
				var g = gomba.instance()
				g.minX = x
				g.maxX = x+l
				g.position = Vector2(x+rand_range(0,l),py-32)
				g.dir = round(rand_range(0,1))*2-1
				interne.add_child(g)
		
		interne.add_child(p)
	
	p = interne.get_child(interne.get_child_count()-1)
	var d = drapeau.instance()
	d.position = Vector2(p.position.x+p.longueur/2+16,p.position.y-p.hauteur/2-16)
	interne.add_child(d)
	
	p = plancher.instance()
	p.longueur = longueur
	p.hauteur = plancher_hauteur
	p.position = Vector2(0,hauteur-plancher_hauteur)
	interne.add_child(p)
	
	var j = get_node("joueur")
	j.position = Vector2(p.position.x+p.longueur/2,p.position.y-j.rayon)

func _ready():
	reset_interne()
