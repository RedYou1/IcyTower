tool
extends KinematicBody2D


export(float) var width = 100 setget setW
export(float) var height = 20 setget setH
export(bool) var casser = false setget setCasser

export(Color) var couleurBase = Color.white setget setCouleurBase
export(Color) var couleurCasser = Color.orange setget setCouleurCasser
export(Color) var couleurCasserEnCours = Color.red

var couleur = couleurBase

func setCouleurCasser(c):
	couleurCasserEnCours = c
	if casser:
		couleur = couleurCasserEnCours
		update()

func setCouleurBase(c):
	couleurBase = c
	if not casser:
		couleur = couleurBase
		update()

func setCasser(c):
	casser = c
	if casser:
		couleur = couleurCasser
	else:
		couleur = couleurBase
	update()

func setW(_width):
	width = _width
	var col = get_node("CollisionShape2D")
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(width/2,height/2)
	col.shape = shape
	col.position = Vector2(width/2,height/2)
	update()
	
func setH(_height):
	height = _height
	var col = get_node("CollisionShape2D")
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(width/2,height/2)
	col.shape = shape
	col.position = Vector2(width/2,height/2)
	update()


func _ready():
	var col = get_node("CollisionShape2D")
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(width/2,height/2)
	col.shape = shape
	col.position = Vector2(width/2,height/2)
	update()

func hit(qui):
	if casser and qui.name == "joueur" and get_node("CasserTemps1").is_stopped():
		get_node("CasserTemps1").start()


func _draw():
	draw_rect(Rect2(0,0,width,height),couleur)


func _on_CasserTemps1_timeout():
	couleur = couleurCasserEnCours
	update()
	get_node("CasserTemps2").start()


func _on_CasserTemps2_timeout():
	queue_free()
