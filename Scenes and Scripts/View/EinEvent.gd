extends VBoxContainer

var eventModel : Action

func setModel(initialEventModel: Action):
	eventModel = initialEventModel

# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/TextureRect.set_texture(load(eventModel.iconpath))
	$HBoxContainer/Label.set_text(eventModel.name + "\n\n" +eventModel.beschreibung)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
