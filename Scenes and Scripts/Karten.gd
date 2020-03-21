extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var currentcard = 0
var currentgeld = 0
var currentansehen = 0
var Karte = preload("res://Scenes and Scripts/EineKarte.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	generate()

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


func _on_Aktivieren_pressed():
	get_parent().res_Geld += currentgeld
	get_parent().wirk_Zufriedenheit += currentansehen
	$"Infoübersicht".hide()
	$"Infoübersicht/Label".set_text("Dies sind die Vor- und Nachteile dieser Karte: Geld -100 Ansehen -15")
	currentansehen = 0
	currentgeld = 0
	currentcard = 0

func generate():
	var file = File.new()
	file.open("res://Scenes and Scripts/events.json", file.READ)
	var jsonText = file.get_as_text()
	file.close()
	var resultJson = JSON.parse(jsonText)
	var result = {}
	
	if resultJson.error == OK:  # If parse OK
		var data = resultJson.result
		print(data[0]["name"])
	else:  # If parse has errors
		print("Error: ", resultJson.error)
		print("Error Line: ", resultJson.error_line)
		print("Error String: ", resultJson.error_string)
	
	#or i in len(Array):
	#	var Instance = Karte.instance()
