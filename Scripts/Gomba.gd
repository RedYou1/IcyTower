tool
extends KinematicBody2D

enum directions {
	GAUCHE = -1,
	DROIT = 1
}

export(float) var minX = 0
export(float) var maxX = 0
export(float) var speed = 5
export(directions) var dir = directions.DROIT

func _process(delta):
	var s = speed * dir
	if s+position.x <= minX:
		s = minX-position.x
		dir = directions.DROIT
	
	if s+position.x >= maxX:
		s = maxX-position.x
		dir = directions.GAUCHE
	
	var col = move_and_collide(Vector2(s,0))
	if col != null:
		dir *= -1
		if col.collider.name == "joueur":
			hit(col.collider)


func hit(qui):
	var jeu = get_parent().get_parent()
	jeu.niveau = 1
	jeu.reset_interne()
