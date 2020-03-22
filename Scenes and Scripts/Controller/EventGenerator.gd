class_name EventGenerator

var Logic
var ActionFactory = preload("res://Scenes and Scripts/Model/ActionFactory.gd")

var events
var rng

func _init():
	events = ActionFactory.generateEvents()
	rng = RandomNumberGenerator.new()
	
func generateEvent():
	var eventNum = rng.randi_range(0, events.size() - 1)
	var event = events[eventNum]
	return [event]
