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
# count of critical care beds
var criticalCareBeds = 0

#Ressources and Costs
var economy = 0
var economyByDay = []
var security = 0
var securityByDay = []
var healthsystem = 0
var healthsystemByDay = []
var criticalCare = 0
var criticalCareByDay = []
var satisfaction = 0
var satisfactionByDay = []

####### INTERNAL ######
# internal factor
var factorK = 0.25
var infectedByDayInternal = []
var registeredCards = []
var registeredEvents = []

#Const
const infectableStartValue = 80000000
const infectedStartValue = 7
const criticalCareBedStartValue = 28000
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

func _ready():
	pass # Replace with function body.

func registerCard(name):
	#instant costs
	pass

func registerEvent(name):
	pass

# This function calculates the new infections, deads and cures per day
func FinishDay():
	print(day)
	var newInf = _CalculateNewInfections()
	newInfected.push_back(newInf)
	infectedByDayInternal.push_back(infectedByDay[-1] + newInfected[-1])
	_CalculateDeadAndCured()
	infectedByDay.push_back(infectedByDayInternal[-1] - dead[-1] - cured[-1])
	day += 1

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
