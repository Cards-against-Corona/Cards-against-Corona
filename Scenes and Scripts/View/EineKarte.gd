extends TextureButton


var Name
var Effekt
var Beschreibung
var iconpath
var UrsacheHealth
var UrsacheBefriedigung
var UrsacheWirtschaft
var Bettenkosten
var Geldkosten
var Securitykosten


# Called when the node enters the scene tree for the first time.
func _ready():
	$Handlung.set_text(Name)
	$"Effektivität".set_text(str(Effekt))
	$Beschreibung.set_text(Beschreibung)
	#$Sprite.set_texture(iconpath)
	if int(UrsacheHealth) > 0:
		$"Control/Gesundheitswesen_status/up".show()
	elif int(UrsacheHealth) < 0:
		$"Control/Gesundheitswesen_status/down".show()
	else:
		pass
	if int(UrsacheBefriedigung) > 0:
		$"Control/Zufriedenheit_status/up".show()
	elif int(UrsacheBefriedigung) < 0:
		$"Control/Zufriedenheit_status/down".show()
	else:
		pass
	if int(Geldkosten) > 0:
		$"Control/wirtschaft_status/up".show()
	elif int(Geldkosten) < 0:
		$"Control/wirtschaft_status/down".show()
	else:
		pass
	if int(Securitykosten) > 0:
		$"Control/Sicherheitskräfte_status/up".show()
	elif int(Securitykosten) < 0:
		$"Control/Sicherheitskräfte_status/down".show()
	else:
		pass
	if int(Bettenkosten) > 0:
		$"Control/intensivbetten_status/up".show()
	elif int(Bettenkosten) < 0:
		$"Control/intensivbetten_status/down".show()
	else:
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
