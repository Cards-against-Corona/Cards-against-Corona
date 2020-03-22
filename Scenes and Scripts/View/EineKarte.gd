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
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
