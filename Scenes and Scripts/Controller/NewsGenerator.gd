class_name NewsGenerator

const INCREAESE_FACTOR = 10

var newInfectedLimit = 10
var infectedLimit = 10
var newDeadLimit = 10
var deadLimit = 10
var newCuredLimit = 10
var curedLimit = 10

func generateSpecifcNews(color: String, title: String, newsFormat: String, current, limit):
	if current > limit:
		var newNews = Action.new()
		newNews.name = title
		newNews.beschreibung = newsFormat % limit
		newNews.iconpath = "res://Assets/%s.png" % color
		print("Generated news with name: %s" % newNews.name)
		print("Generated news with description: %s" % newNews.beschreibung)
		return newNews
	return null

func generateNews(event, infected, newInfected, dead, newDead, cured, newCured):
	var news = event
	
	var infectedEvent =generateSpecifcNews(
		"Red",
		"Anzahl der Infizierten",
		"Anzahl der Infizierten übersteigt erstmals %d",
		infected,
		infectedLimit)
	if infectedEvent:
		infectedLimit *= INCREAESE_FACTOR
		news.push_back(infectedEvent)
	
	var newInfectedEvent = generateSpecifcNews(
		"Red",
		"Anzahl der neu Infizierten",
		"Anzahl der neu Infizierten übersteigt erstmals %d",
		newInfected,
		newInfectedLimit
	)
	if newInfectedEvent:
		newInfectedLimit *= 10
		news.push_back(newInfectedEvent)
	
	var deadEvent = generateSpecifcNews(
		"Leichtgrau",
		"Anzahl der insgesamt Gestorbenen",
		"Anzahl der insgesamt Gestorbenen übersteigt erstmals %d",
		dead,
		deadLimit
	)
	if deadEvent:
		deadLimit *= 10
		news.push_back(deadEvent)
		
	var newDeadEvent = generateSpecifcNews(
		"Leichtgrau",
		"Anzahl der Gestorbenen",
		"Anzahl der Gestorbenen übersteigt erstmals %d",
		newDead,
		newDeadLimit
	)
	if newDeadEvent:
		newDeadLimit *= 10
		news.push_back(newDeadEvent)
		
	
	var curedEvent = generateSpecifcNews(
		"Green",
		"Anzahl der insgesamt Geheilten",
		"Anzahl der insgesamt Geheilten übersteigt erstmals %d",
		cured,
		curedLimit
	)
	if curedEvent:
		curedLimit *= 10
		news.push_back(curedEvent)
		
	var newCuredEvent = generateSpecifcNews(
		"Green",
		"Anzahl der Geheilten",
		"Anzahl der Geheilten übersteigt erstmals %d",
		newCured,
		newCuredLimit
	)
	if newCuredEvent:
		newCuredLimit *= 10
		news.push_back(newCuredEvent)
	
	return news
