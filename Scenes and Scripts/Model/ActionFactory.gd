# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
static func generateActions(path: String):
	var file = File.new()
	file.open(path, file.READ)
	var jsonText = file.get_as_text()
	file.close()
	var resultJson = JSON.parse(jsonText)
	
	var CardsArray = []
	if resultJson.error == OK:  # If parse OK
		var data = resultJson.result
		CardsArray = data
	else:  # If parse has errors
		print("Error: ", resultJson.error)
		print("Error Line: ", resultJson.error_line)
		print("Error String: ", resultJson.error_string)
		
	var instances = []
	for card in CardsArray:
		var Instance = Action.new()
		Instance.name = card["name"]
		Instance.beschreibung = card["description"]
		Instance.iconpath = card["icon"]
		Instance.effect = card["effectivity"]
		Instance.health = card["consequence"][0]["value"]
		Instance.satisfaction = card["consequence"][1]["value"]
		Instance.economy = card["consequence"][2]["value"]
		Instance.geld = card["costs"][2]["value"]
		Instance.betten = card["costs"][0]["value"]
		Instance.security = card["costs"][1]["value"]
		instances.push_back(Instance)
		print("Neue generierte Karte")
	return instances
	
static func generateCards():
	return generateActions("res://Scenes and Scripts/cards.json")

	
static func generateEvents():
	return generateActions("res://Scenes and Scripts/events.json")
