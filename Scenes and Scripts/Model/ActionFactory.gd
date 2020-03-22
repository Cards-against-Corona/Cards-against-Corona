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
		Instance.health = 0
		Instance.satisfaction = 0
		Instance.economy = 0
		for consequence in card["consequence"]:
			var target = consequence["target"]
			var value = consequence["value"]
			if target == "HEALTH_SYSTEM":
				Instance.health = value
			elif target == "SATISFACTION":
				Instance.satisfaction = value
			elif target == "ECONOMY":
				Instance.economy = value
		
		Instance.geld = 0 # deprecated
		Instance.betten = 0
		Instance.security = 0
		if card.has('cost'):
			for cost in card["costs"]:
				if cost["target"] == "CRITICAL_CARE_BEDS":
					Instance.betten = cost["value"]
				elif cost["target"] == "SECURITY_RESSOURCES":
					Instance.security = cost["value"]
		instances.push_back(Instance)
		print("Neue generierte Karte")
	return instances
	
static func generateCards():
	return generateActions("res://Scenes and Scripts/cards.json")

	
static func generateEvents():
	return generateActions("res://Scenes and Scripts/events.json")
