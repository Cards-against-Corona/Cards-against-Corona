extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Health
var Befriedigung
var Wirtschaft
var Bettkosten
var Geldkosten
var Seckosten
var Instanz


var Karte = preload("res://Scenes and Scripts/View/EineKarte.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	generate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Schlieen_pressed():
	$"Infoübersicht".hide()
	$"Infoübersicht/Label".set_text("Dies sind die Vor- und Nachteile dieser Karte: Geld -100 Ansehen -15")
	Health = 0
	Befriedigung = 0
	Wirtschaft = 0
	Geldkosten = 0
	Bettkosten = 0
	Seckosten = 0
	$"Infoübersicht/Sprite/Control/Gesundheitswesen_status/status_arrow_up".hide()
	$"Infoübersicht/Sprite/Control/Gesundheitswesen_status/status_arrow_down".hide()
	$"Infoübersicht/Sprite/Control/Zufriedenheit_status/status_arrow_up".hide()
	$"Infoübersicht/Sprite/Control/Zufriedenheit_status/status_arrow_down".hide()
	$"Infoübersicht/Sprite/Control/wirtschaft_status/status_arrow_up".hide()
	$"Infoübersicht/Sprite/Control/wirtschaft_status/status_arrow_down".hide()
	$"Infoübersicht/Sprite/Control/Sicherheitskräfte_status/status_arrow_up".hide()
	$"Infoübersicht/Sprite/Control/Sicherheitskräfte_status/status_arrow_down".hide()
	$"Infoübersicht/Sprite/Control/intensivbetten_status/status_arrow_up".hide()
	$"Infoübersicht/Sprite/Control/intensivbetten_status/status_arrow_down".hide()

func Button_pressed(Instance):
	Instanz = Instance
	$"Infoübersicht".show()
	$"Infoübersicht/Label".set_text(Instance.Beschreibung)
	$"Infoübersicht/Sprite/Effekt".set_text(Instance.Effekt)
	$"Infoübersicht/Sprite/Beschreibung".set_text(Instance.Beschreibung)
	$"Infoübersicht/Sprite/Name".set_text(Instance.Name)
	Health = Instance.UrsacheHealth
	Befriedigung = Instance.UrsacheBefriedigung
	Wirtschaft = Instance.UrsacheWirtschaft
	Geldkosten = Instance.Geldkosten
	Bettkosten = Instance.Bettenkosten    #Keine echten Kosten nur values
	Seckosten = Instance.Securitykosten   #              "
	if int(Health) > 0:
		$"Infoübersicht/Sprite/Control/Gesundheitswesen_status/status_arrow_up".show()
	elif int(Health) < 0:
		$"Infoübersicht/Sprite/Control/Gesundheitswesen_status/status_arrow_down".show()
	else:
		pass
	if int(Befriedigung) > 0:
		$"Infoübersicht/Sprite/Control/Zufriedenheit_status/status_arrow_up".show()
	elif int(Befriedigung) < 0:
		$"Infoübersicht/Sprite/Control/Zufriedenheit_status/status_arrow_down".show()
	else:
		pass
	if int(Geldkosten) > 0:
		$"Infoübersicht/Sprite/Control/wirtschaft_status/status_arrow_up".show()
	elif int(Geldkosten) < 0:
		$"Infoübersicht/Sprite/Control/wirtschaft_status/status_arrow_down".show()
	else:
		pass
	if int(Seckosten) > 0:
		$"Infoübersicht/Sprite/Control/Sicherheitskräfte_status/status_arrow_up".show()
	elif int(Seckosten) < 0:
		$"Infoübersicht/Sprite/Control/Sicherheitskräfte_status/status_arrow_down".show()
	else:
		pass
	if int(Bettkosten) > 0:
		$"Infoübersicht/Sprite/Control/intensivbetten_status/status_arrow_up".show()
	elif int(Bettkosten) < 0:
		$"Infoübersicht/Sprite/Control/intensiv_status/status_arrow_down".show()
	else:
		pass

func _on_Aktivieren_pressed():
	$"Infoübersicht".hide()
	$"Infoübersicht/Label".set_text("Dies sind die Vor- und Nachteile dieser Karte: Geld -100 Ansehen -15")
	get_parent().card = Instanz
	get_parent().cardweitergabe()
	$ScrollContainer/HBoxContainer.remove_child(Instanz)


func generate():
	var file = File.new()
	file.open("res://Scenes and Scripts/cards.json", file.READ)
	var jsonText = file.get_as_text()
	file.close()
	var resultJson = JSON.parse(jsonText)
	var CardsArray
	if resultJson.error == OK:  # If parse OK
		var data = resultJson.result
		CardsArray = data
	else:  # If parse has errors
		print("Error: ", resultJson.error)
		print("Error Line: ", resultJson.error_line)
		print("Error String: ", resultJson.error_string)
	for i in len(CardsArray):
		var Instance = Karte.instance()
		var Name = CardsArray[i]["name"]
		var Beschreibung = CardsArray[i]["description"]
		var iconpath = CardsArray[i]["icon"]
		var Effekt = CardsArray[i]["effectivity"]
		var health = CardsArray[i]["consequence"][0]["value"]
		var satisfaction = CardsArray[i]["consequence"][1]["value"]
		var economy = CardsArray[i]["consequence"][2]["value"]
		var geld = CardsArray[i]["costs"][2]["value"]
		var betten = CardsArray[i]["costs"][0]["value"]
		var security = CardsArray[i]["costs"][1]["value"]
		Instance.Bettenkosten = betten
		Instance.Securitykosten = security
		Instance.Geldkosten = geld
		Instance.UrsacheBefriedigung = satisfaction
		Instance.UrsacheWirtschaft = economy
		Instance.UrsacheHealth = health
		Instance.Name = Name
		Instance.Beschreibung = Beschreibung
		Instance.Effekt = Effekt
		Instance.iconpath = iconpath
		Instance.connect("pressed", self, "Button_pressed", [Instance])
		$ScrollContainer/HBoxContainer.add_child(Instance)
