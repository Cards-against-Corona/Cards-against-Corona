extends TextureButton

var cardModel : Action

func setModel(initialCardModel: Action):
	cardModel = initialCardModel

# Called when the node enters the scene tree for the first time.
func _ready():
	$Handlung.set_text(cardModel.name)
	$"Effektivität".set_text(str(cardModel.effect))
	$Beschreibung.set_text(cardModel.beschreibung)
	#$Sprite.set_texture(cardModel.iconpath)
	if int(cardModel.health) > 0:
		$"Control/Gesundheitswesen_status/up".show()
	elif int(cardModel.health) < 0:
		$"Control/Gesundheitswesen_status/down".show()
	else:
		pass
	if int(cardModel.satisfaction) > 0:
		$"Control/Zufriedenheit_status/up".show()
	elif int(cardModel.satisfaction) < 0:
		$"Control/Zufriedenheit_status/down".show()
	else:
		pass
	if int(cardModel.geld) > 0:
		$"Control/wirtschaft_status/up".show()
	elif int(cardModel.geld) < 0:
		$"Control/wirtschaft_status/down".show()
	else:
		pass
	if int(cardModel.security) > 0:
		$"Control/Sicherheitskräfte_status/up".show()
	elif int(cardModel.security) < 0:
		$"Control/Sicherheitskräfte_status/down".show()
	else:
		pass
	if int(cardModel.betten) > 0:
		$"Control/intensivbetten_status/up".show()
	elif int(cardModel.betten) < 0:
		$"Control/intensivbetten_status/down".show()
	else:
		pass

