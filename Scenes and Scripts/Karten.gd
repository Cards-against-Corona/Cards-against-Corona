extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var currentcard = 0
var currentgeld = 0
var currentansehen = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Schlieen_pressed():
	$"Infoübersicht".hide()
	$"Infoübersicht/Label".set_text("Dies sind die Vor- und Nachteile dieser Karte: Geld -100 Ansehen -15")
	currentansehen = 0
	currentgeld = 0
	currentcard = 0


func _on_1_pressed():
	$"Infoübersicht".show()
	currentcard = 1
	currentgeld = +5
	currentansehen = -15
	$"Infoübersicht/Label".set_text("Stehle den Bürgern ihr geliebtes Klopapier zur Instandhaltung der Wirtschaft")
	

func _on_2_pressed():
	$"Infoübersicht".show()
	currentcard = 1
	currentgeld = -15
	currentansehen = +10
	$"Infoübersicht/Label".set_text("Richte Geld für Selbstständige ein")


func _on_3_pressed():
	$"Infoübersicht".show()
	currentcard = 1
	currentgeld = 0
	currentansehen = -5
	$"Infoübersicht/Label".set_text("Richte ein Ausgangsverbot ein")
