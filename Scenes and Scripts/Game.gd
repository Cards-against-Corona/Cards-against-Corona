extends Node2D


# Globale Variablen
# Gesamtbevölkerung 80 Millionen
var Gesamtbevoelkerung = 80000000

# Gameplay-Resourcen: Mehr ist besser. Kann als freie Kapazitäten verstanden werden
# Gewährleistung der Grundversorgung der Bevölkerung in Prozent
var res_Grundversorgung = 100
# Polizei kann zum Erzwingen von Maßnahmen benutzt werden
var res_Polizei = 184631
# Budget
var res_Geld = 100
# Restkapazität des Gesundheitswesens, in Krankenhausbetten
var res_Gesundheitswesen = 100

# Gameplay-Metriken (aka Auswirkungen): Zustand des Landes
# Zustand der Wirtschaft: Mehr ist besser, in Prozent
var wirk_Wirtschaft = 100
# Zufriedenheit der Bevölkerung: Mehr ist besser, in Prozent
var wirk_Zufriedenheit = 100
# Anzahl der Infizierten: Weniger ist besser, in absoluten Zahlen
var wirk_Infizierte = 1
# Anzahl der Verstorbenen: Weniger ist besser, in absoluten Zahlen
var wirk_Tote = 0
# Anzahl der Gesunden
var wirk_Gesunde = 0

var logic = load("res://Scenes and Scripts/Logic.gd").new()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_Geld_draw():
	pass # Replace with function body.


func _on_Button_TagEnde_pressed():
	# trigger events?
	logic.FinishDay()
	
	print(logic.newInfected[-1])
	
	# calculate infection counts --> mit Mechanikern koordinieren
	 # TESTARRAY
	#var arr = [1, 2, 3]
	
	# calculate other values
	
	# update main window
	# update infection counters
	$"Control/TabContainer/COVID-19 Zahlen/Label_Infizierte".text = "Infizierte:\n" + str(int(round(logic.infectedByDay[-1])))
	$"Control/TabContainer/COVID-19 Zahlen/Label_Tote".text = "Tote:\n" + str(int(round(logic.deadByDay[-1])))
	$"Control/TabContainer/COVID-19 Zahlen/Label_Genesene".text = "Genesene:\n" + str(int(round(logic.curedByDay[-1])))
	
	# update other KPIs
	
	# calculate the Graphs
	# for Covid-Screen: -200;80 -> 750;400
	
	# arr wird durch werte z.B. Anzahl infizierte ersetzt
	#var y_max = arr.max()
	#var y_min = arr.min()
		
	
	#for y in range(arr.size()):
	#	print(y)
	
	# enter new entries to the newsfeed
	
	# enter new entries to the eventlog
