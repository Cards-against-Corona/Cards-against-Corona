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

var cardModel : Action

func setModel(initialCardModel: Action):
	cardModel = initialCardModel

# Called when the node enters the scene tree for the first time.
func _ready():
	$Handlung.set_text(cardModel.name)
	$"Effektivität".set_text(str(cardModel.effect))
	$Beschreibung.set_text(cardModel.beschreibung)
	#$Sprite.set_texture(iconpath)
	

