extends Node

class_name Logic 

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

####### INTERNAL ######
# internal factor
var factorK = 0.25

#Const
const infectableStartValue = 80000000
const infectedStartValue = 7
const baseFatalityRate = 0.048
const recoveryTime = 14
const criticalCases = 0,75

func _init():
	infected = infectedStartValue
	infectable = initInfectableCount

func _ready():
	pass # Replace with function body.

# This function calculates the new infections, deads and cures per day
func FinishDay():
	var newInf = _CalculateNewInfections()
	newInfected.push_back(newInf)
	infectedByDay.push_back(infectedByDay[-1] + newInfected)
	_CalculateDeadAndCured()
	day += 1

func _CalculateDeadAndCured():
	var dead = _CalculateDead()
	var cured = _CalculateCured()
	dead.push_back(dead)
	cured.push_back(cured)
	deadByDay.push_back(deadByDay[-1] + dead)
	curedByDay.push_back(curedByDay[-1] + cured)
	infectable -= dead + cured

func _CalculateDead():
	if newInfected.size() < recoveryTime:
		return 0
	else
		return newInfected[newInfected.size() - recoveryTime] * _CalculateFatalityRare()

func _CalculateCured():
	if newInfected.size() < recoveryTime:
		return 0
	else
		return newInfected[newInfected.size() - recoveryTime] * (1 - _CalculateFatalityRare())

func _CalculateFatalityRare():
	return baseFatalityRate

func _CalculateNewInfections():
	return factorK * infectedByDay[-1] * (1 - (infectedByDay[-1] / infectable))
