tool
extends KinematicBody2D

enum directions {
	GAUCHE = -1,
	DROIT = 1
}

export(float) var minX = 0
export(float) var maxX = 0
export(float) var vitesse = 6
export(directions) var dir = directions.DROIT

func _process(delta):
	var distance = vitesse * dir
	if distance+position.x <= minX:
		distance = minX-position.x
		dir = directions.DROIT
	
	if distance+position.x >= maxX:
		distance = maxX-position.x
		dir = directions.GAUCHE
	
	var qui = move_and_collide(Vector2(distance,0))
	if qui != null:
		dir *= -1
		if qui.collider.name == "joueur":
			toucher(qui.collider)
		else:
			qui.collider.queu_free()


func toucher(qui):
	var jeu = get_parent().get_parent()
	jeu.niveau = 1
	jeu.reset_interne()
