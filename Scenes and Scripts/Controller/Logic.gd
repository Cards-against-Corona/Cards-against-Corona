extends Node

class_name Logic 

# Consequences
enum Ressources {CRITICAL_CARE_BEDS, SECURITY_RESSOURCES, CASH}
enum Consequences {HEALTH_SYSTEM, SATISFACTION, ECONOMY}

#stored as daily new deads
var dead = []
#stored as max deads by day
var deadByDay = []
#stored as daily new cured
var cured = []
#stored as max cured by day
var curedByDay = []
#stored as daily new infected
var newInfected = []
#stored as max infected by day
var infectedByDay = []
# current day
var day = 0
# whole population without dead and cured people
var infectable = 0

#Ressources and Costs
var economy = 0
var economyByDay = []
var security = 0
var securityByDay = []
var healthsystem = 0
var healthsystemByDay = []
var satisfaction = 0
var satisfactionByDay = []
# count of critical care beds
var criticalCareBeds = 0
var criticalCareBedsByDay = []

####### INTERNAL ######
# Generators
var eventGenerator: EventGenerator
var newsGenerator: NewsGenerator

# internal factor
var factorK = 0.25
var infectedByDayInternal = []
var playedCards = []
var registeredEvents = []
var playedEvents = []
var news = []

#Const
const infectableStartValue = 80000000
const infectedStartValue = 7
const criticalCareBedStartValue = 28000
const securityStartValue = 100
const economyStartValue = 100
const healthsystemStartValue = 100
const satisfactionStartValue = 100
const baseFatalityRate = 0.048
const recoveryTime = 14
const criticalCasesFactor = 0.75

func _init():
	#init day zero
	newInfected.push_back(infectedStartValue)
	infectedByDay.push_back(infectedStartValue)
	dead.push_back(0)
	deadByDay.push_back(0)
	cured.push_back(0)
	curedByDay.push_back(0)
	infectable = infectableStartValue
	criticalCareBeds = criticalCareBedStartValue
	security = securityStartValue
	economy = economyStartValue
	healthsystem = healthsystemStartValue
	satisfaction = satisfactionStartValue

	eventGenerator = EventGenerator.new()
	newsGenerator = NewsGenerator.new()

func _ready():
	pass # Replace with function body.

# This function calculates the new infections, deads and cures per day
func FinishDay():
	var newInf = _CalculateNewInfections()

	var event = eventGenerator.generateEvent()
	newInfected.push_back(newInf)
	infectedByDayInternal.push_back(infectedByDay[-1] + newInfected[-1])
	_CalculateDeadAndCured()
	infectedByDay.push_back(infectedByDayInternal[-1] - dead[-1] - cured[-1])
	addResourceStatistics()
	day += 1
	handleEvents()
	var newNews = newsGenerator.generateNews(event,
		infectedByDay[-1], newInf,
		deadByDay[-1], dead[-1],
		curedByDay[-1], cured[-1])
	registerEvent(newNews)
	news.push_back(newNews)

func getNews():
	return news

func registerCard(action):
	#instant costs
	handleCostsOrConsequences(action)
	#daily costs currently not implemented
	playedCards.push_back(action)

func registerEvent(action):
	for a in action:
		registeredEvents.push_back(a)

func handleEvents():
	for i in range(registeredEvents.size()):
		var eventAction = registeredEvents.pop_front()
		handleCostsOrConsequences(eventAction)
		playedEvents.push_back(eventAction)

func handleCostsOrConsequences(obj):
	if obj.betten != 0 and criticalCareBeds > 0:
		var changeValue = 100 / criticalCareBeds * int(obj.betten)
		if (criticalCareBeds + changeValue < 0):
			criticalCareBeds = 0
		else:
			criticalCareBeds += changeValue
	
	if obj.security != 0 and security > 0:
		var changeValue = 100 / security * int(obj.security)
		if (security + changeValue < 0):
			security = 0
		else:
			security += changeValue
	
	if obj.economy != 0 and economy > 0:
		var changeValue = 100 / economy * int(obj.economy)
		if (economy + changeValue < 0):
			economy = 0
		else:
			economy += changeValue
	
	if obj.satisfaction != 0 and satisfaction > 0:
		var changeValue = 100 / satisfaction * int(obj.satisfaction)
		if (satisfaction + changeValue < 0):
			satisfaction = 0
		else:
			satisfaction += changeValue
	
	if obj.health != 0 and healthsystem > 0:
		var changeValue = 100 / healthsystem * int(obj.health)
		if (healthsystem + changeValue < 0):
			healthsystem = 0
		else:
			healthsystem += changeValue
	

func addResourceStatistics():
		criticalCareBedsByDay.push_back(criticalCareBeds)
		securityByDay.push_back(security)
		economyByDay.push_back(economy)
		satisfactionByDay.push_back(satisfaction)
		healthsystemByDay.push_back(healthsystem)

############## Calculation infected ##############

func _CalculateDeadAndCured():
	var _dead = _CalculateDead()
	var _cured = _CalculateCured()
	dead.push_back(_dead)
	cured.push_back(_cured)
	deadByDay.push_back(deadByDay[-1] + _dead)
	curedByDay.push_back(curedByDay[-1] + _cured)
	infectable -= (_dead + _cured)

func _CalculateDead():
	if newInfected.size() <= recoveryTime:
		return 0
	else:
		return newInfected[newInfected.size() - recoveryTime - 1] * _CalculateFatalityRate()

func _CalculateCured():
	if newInfected.size() <= recoveryTime:
		return 0
	else:
		return newInfected[newInfected.size() - recoveryTime - 1] * (1.0 - _CalculateFatalityRate())

func _CalculateFatalityRate():
	var criticalCases = newInfected[newInfected.size() - recoveryTime - 1] * criticalCasesFactor
	if criticalCareBeds - criticalCases > 0:
		return baseFatalityRate
	else:
		var criticalCaseWithoutBed = (criticalCareBeds - criticalCases) * -1
		var fatalityFactor = ((100 / infectedByDay[newInfected.size() - recoveryTime - 1]) * criticalCaseWithoutBed) / 100
		return baseFatalityRate + fatalityFactor

func _CalculateNewInfections():
	var _populationFactor = (infectedByDay[-1] / infectable)
	if _populationFactor > 1:
		_populationFactor = 1
	var _result = factorK * infectedByDay[-1] * (1 - _populationFactor)
	return _result
