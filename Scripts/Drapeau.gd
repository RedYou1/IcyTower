extends StaticBody2D

func toucher(qui):
	if qui.name == "joueur":
		var jeu = get_parent().get_parent()
		jeu.niveau += 1
		jeu.reset_interne()
