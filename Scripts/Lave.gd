tool
extends Node2D

export(float) var width = 1000 setget setWidth

export(float) var height = 1000 setget setHeight

func setWidth(w):
	width = w
	update()

func setHeight(h):
	height = h
	update()

func _draw():
	draw_rect(Rect2(0,0,width,height),Color.orange)
