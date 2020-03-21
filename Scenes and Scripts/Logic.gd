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
# count of critical care beds
var criticalCareBeds = 0

####### INTERNAL ######
# internal factor
var factorK = 0.25

#Const
const infectableStartValue = 80000000
const infectedStartValue = 7
const criticalCareBedStartValue = 28000
const baseFatalityRate = 0.048
const recoveryTime = 14
const criticalCasesFactor = 0.75

func _init():
	#init day zero
	infectedByDay.push_back(infectedStartValue)
	dead.push_back(0)
	deadByDay.push_back(0)
	cured.push_back(0)
	curedByDay.push_back(0)
	infectable = infectableStartValue
	criticalCareBeds = criticalCareBedStartValue

func _ready():
	pass # Replace with function body.

# This function calculates the new infections, deads and cures per day
func FinishDay():
	var newInf = _CalculateNewInfections()
	newInfected.push_back(newInf)
	infectedByDay.push_back(infectedByDay[-1] + newInfected[-1])
	_CalculateDeadAndCured()
	day += 1

func _CalculateDeadAndCured():
	var _dead = _CalculateDead()
	var _cured = _CalculateCured()
	dead.push_back(_dead)
	cured.push_back(_cured)
	deadByDay.push_back(deadByDay[-1] + _dead)
	curedByDay.push_back(curedByDay[-1] + _cured)
	infectable -= _dead + _cured

func _CalculateDead():
	if newInfected.size() < recoveryTime:
		return 0
	else:
		return newInfected[newInfected.size() - recoveryTime + 1] * _CalculateFatalityRate()

func _CalculateCured():
	if newInfected.size() < recoveryTime:
		return 0
	else:
		return newInfected[newInfected.size() - recoveryTime + 1] * (1 - _CalculateFatalityRate())

func _CalculateFatalityRate():
	var criticalCases = newInfected[newInfected.size() - recoveryTime + 1] * criticalCasesFactor
	if criticalCareBeds - criticalCases > 0:
		return baseFatalityRate
	else:
		var criticalCaseWithoutBed = criticalCareBeds - criticalCases
		var fatalityFactor = 100 / newInfected[newInfected.size() - recoveryTime + 1] * criticalCaseWithoutBed / 100
		return baseFatalityRate + fatalityFactor

func _CalculateNewInfections():
	return factorK * infectedByDay[-1] * (1 - (infectedByDay[-1] / infectable))
