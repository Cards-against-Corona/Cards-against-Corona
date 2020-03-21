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
	
	# calculate new numbers
	logic.FinishDay()
	
	# calculate other values
	
	# update main window
	# update infection counters
	$"Control/TabContainer/COVID-19 Zahlen/Label_Infizierte".text = "Infizierte:\n" + str(int(round(logic.infectedByDay[-1])))
	$"Control/TabContainer/COVID-19 Zahlen/Label_Tote".text = "Tote:\n" + str(int(round(logic.deadByDay[-1])))
	$"Control/TabContainer/COVID-19 Zahlen/Label_Genesene".text = "Genesene:\n" + str(int(round(logic.curedByDay[-1])))
	
	# update other KPIs
	
	# calculate the Graphs
	
	
	var temp_points = []
	# for Covid-Screen: -200;80 -> 850;-400
	temp_points = _normalize_Graph_Points(-200, 850, 80, -400, logic.infectedByDay)
	$"Control/TabContainer/COVID-19 Zahlen/Line2D_infizierte".clear_points()
	for point in temp_points:
		$"Control/TabContainer/COVID-19 Zahlen/Line2D_infizierte".add_point(point)
	
	temp_points = _normalize_Graph_Points(-200, 850, 80, -400, logic.deadByDay)
	$"Control/TabContainer/COVID-19 Zahlen/Line2D_Tote".clear_points()
	for point in temp_points:
		$"Control/TabContainer/COVID-19 Zahlen/Line2D_Tote".add_point(point)
	
	temp_points = _normalize_Graph_Points(-200, 850, 80, -400, logic.curedByDay)
	$"Control/TabContainer/COVID-19 Zahlen/Line2D_Genesene".clear_points()
	for point in temp_points:
		$"Control/TabContainer/COVID-19 Zahlen/Line2D_Genesene".add_point(point)
	
	# enter new entries to the newsfeed
	
	# enter new entries to the eventlog

func _normalize_Graph_Points(frame_x_min, frame_x_max, frame_y_min, frame_y_max, input_array):
	var return_array = []
	var x_temp_px
	var y_temp_px
	var x_step_size
	# read border values
	var y_max_value = input_array.max()
	var y_min_value = input_array.min()
	
	var y_diff_px = frame_y_max - frame_y_min
	var y_diff_value = y_max_value - y_min_value
	
	# calculate x step size
	x_step_size = ( frame_x_max - frame_x_min ) / input_array.size()
	
	# normalize y values and write to return
	for i in input_array.size():
		x_temp_px = frame_x_min + x_step_size * i
		if y_diff_value == 0: y_temp_px = 0
		else:
			y_temp_px =  ( ( input_array[i] - y_min_value ) / y_diff_value ) * y_diff_px + frame_y_min
		return_array.push_back(Vector2(x_temp_px, y_temp_px))
	
	return return_array
