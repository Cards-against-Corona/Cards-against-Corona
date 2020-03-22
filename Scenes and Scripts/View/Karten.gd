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
var CardViews


var Karte = preload("res://Scenes and Scripts/View/EineKarte.tscn")
var ActionFactory = preload("res://Scenes and Scripts/Model/ActionFactory.gd")

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
	$"Infoübersicht/Label".set_text(Instance.cardModel.beschreibung)
	$"Infoübersicht/Sprite/Effekt".set_text(String(Instance.cardModel.effect))
	$"Infoübersicht/Sprite/Beschreibung".set_text(Instance.cardModel.beschreibung)
	$"Infoübersicht/Sprite/Name".set_text(Instance.cardModel.name)
	$"Infoübersicht/Sprite/Sprite".set_texture(load(Instance.cardModel.iconpath))
	Health = Instance.cardModel.health
	Befriedigung = Instance.cardModel.satisfaction
	Wirtschaft = Instance.cardModel.economy
	Geldkosten = Instance.cardModel.geld
	Bettkosten = Instance.cardModel.betten    #Keine echten Kosten nur values
	Seckosten = Instance.cardModel.security   #              "
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
	CardViews = []
	var cardModels = ActionFactory.generateCards()
	for card in cardModels:
		var cardView = Karte.instance()
		cardView.setModel(card)
		
		cardView.connect("pressed", self, "Button_pressed", [cardView])
		$ScrollContainer/HBoxContainer.add_child(cardView)
		CardViews.push_back(cardView)
