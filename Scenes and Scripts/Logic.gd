extends Node

class_name Logic 

var infectable = 80000000
var dead = []
var cured = []
var newInfected = []
var infected = 0
var day = 0
var factorK = 0.25

#Const
const criticalCases = 0,75
const baseFatalityRate = 0.048
const infectedStartValue = 7
const recoveryTime = 14

func _init():
	infected = infectedStartValue


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func FinishDay():
	var newInf = CalculateNewInfections()
	newInfected.push_back(newInf)
	infected += newInfected
	

func CalculateDeadAndCured():
	var dead = _CalculateDead()
	var cured = _CalculateCured()
	dead.push_back(dead)
	cured.push_back(cured)
	infectable -= dead + cured

func _CalculateDead():
	if newInfected.size() < recoveryTime:
		return 0
	else
		return newInfected[newInfected.size() - recoveryTime] * CalculateFatalityRare()

func _CalculateCured():
	if newInfected.size() < recoveryTime:
		return 0
	else
		return newInfected[newInfected.size() - recoveryTime] * (1 - CalculateFatalityRare())

func CalculateFatalityRare():
	return baseFatalityRate

func CalculateNewInfections():
	return factorK * infected * (1 - (infected / infectable))
