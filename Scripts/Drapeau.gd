extends StaticBody2D

func hit(who):
	if who.name == "joueur":
		var jeu = get_parent().get_parent()
		jeu.niveau += 1
		jeu.reset_interne()
