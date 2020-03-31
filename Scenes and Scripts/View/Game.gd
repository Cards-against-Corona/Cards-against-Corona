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

var logic = load("res://Scenes and Scripts/Controller/Logic.gd").new()
var eventGenerator = load("res://Scenes and Scripts/Controller/EventGenerator.gd").new()
var Event = load("res://Scenes and Scripts/View/EinEvent.tscn")

var card
var scale_max = 10
const scaleup_factor = sqrt(10)

var day_scale = 5
const day_scaleup = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	logic.FinishDay()
	_update_graph()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _scale_up_if_necssary(current_max, current_day):
	while current_max > scale_max:
		scale_max*=scaleup_factor
	
		# Make maximum scale a n*power of ten
		var scale_pow = pow(10, floor(log(scale_max)/log(10)))
		scale_max = floor(scale_max/scale_pow)*scale_pow

	while current_day > day_scale:
		day_scale += day_scaleup

func _on_Geld_draw():
	pass # Replace with function body.

func cardweitergabe():
	logic.registerCard(card.cardModel)
	
func _update_graph():
	# set scale numbers
	_scale_up_if_necssary(
		[logic.infectedByDay.max(), logic.curedByDay.max(), logic.deadByDay.max()].max(),
		logic.day)
	
	# calculate the Graphs
	$"Control/TabContainer/COVID-19 Zahlen/Label_Scale_Tag".text = "Tag " + str(logic.day)
	var temp_points = []
	# for Covid-Screen: -200;80 -> 850;-400
	temp_points = _normalize_Graph_Points(-100, 800, 80, -350, logic.infectedByDay)
	$"Control/TabContainer/COVID-19 Zahlen/Line2D_infizierte".clear_points()
	for point in temp_points:
		$"Control/TabContainer/COVID-19 Zahlen/Line2D_infizierte".add_point(point)
	
	temp_points = _normalize_Graph_Points(-100, 800, 80, -350, logic.deadByDay)
	$"Control/TabContainer/COVID-19 Zahlen/Line2D_dead".clear_points()
	for point in temp_points:
		$"Control/TabContainer/COVID-19 Zahlen/Line2D_dead".add_point(point)
	
	temp_points = _normalize_Graph_Points(-100, 800, 80, -350, logic.curedByDay)
	$"Control/TabContainer/COVID-19 Zahlen/Line2D_Genesene".clear_points()
	for point in temp_points:
		$"Control/TabContainer/COVID-19 Zahlen/Line2D_Genesene".add_point(point)
	
	var scale_step = scale_max/5
	_update_y_label($"Control/TabContainer/COVID-19 Zahlen/Label_Scale_1", 1,
		scale_step)
	_update_y_label($"Control/TabContainer/COVID-19 Zahlen/Label_Scale_2", 2,
		scale_step)
	_update_y_label($"Control/TabContainer/COVID-19 Zahlen/Label_Scale_3", 3,
		scale_step)
	_update_y_label($"Control/TabContainer/COVID-19 Zahlen/Label_Scale_4", 4,
		scale_step)
	_update_y_label($"Control/TabContainer/COVID-19 Zahlen/Label_Scale_5", 5,
		scale_step)

func _update_y_label(label, factor, scale_step):
	label.text = str(factor * scale_step)


func _update_resource_counters():
	# Update Resource counters
	$Control/TextureRect2/VBoxContainer_Resourcen/VBoxContainer_Resourcen_innen/HBoxContainer_res_Wirtschaft/Label_res_Wirtschaft_value.text = str(logic.economy) + "%"
	$Control/TextureRect2/VBoxContainer_Resourcen/VBoxContainer_Resourcen_innen/HBoxContainer_res_Sicherheit/Label_res_Sicherheit_value.text = str(logic.security) + "%"
	$Control/TextureRect2/VBoxContainer_Resourcen/VBoxContainer_Resourcen_innen/HBoxContainer_res_Gesundheit/Label_res_Gesundheit_value.text = str(logic.healthsystem) + "%"
	$Control/TextureRect2/VBoxContainer_Resourcen/VBoxContainer_Resourcen_innen/HBoxContainer_res_Betten/Label_res_Betten_value.text = str(logic.criticalCareBeds*100/28000) + "%"
	$Control/TextureRect2/VBoxContainer_Resourcen/VBoxContainer_Resourcen_innen/HBoxContainer_res_Zufrieden/Label_res_Zufrieden_value.text = str(logic.satisfaction) + "%"

func _update_infection_counters():
	# update infection counters
	$"Control/TabContainer/COVID-19 Zahlen/Label_Infizierte".text = "Infizierte:\n" + str(int(round(logic.infectedByDay[-1])))
	$"Control/TabContainer/COVID-19 Zahlen/Label_Tote".text = "Tote:\n" + str(int(round(logic.deadByDay[-1])))
	$"Control/TabContainer/COVID-19 Zahlen/Label_Genesene".text = "Genesene:\n" + str(int(round(logic.curedByDay[-1])))
	

func _on_Button_TagEnde_pressed():
	# trigger events
	
	# enter new entries to the newsfeed
	#var temp_container = HBoxContainer.new()
	#var temp_label = Label.new()
	#temp_label.text = "TEST"
	#temp_container.addChild(temp_label)
	#$Control/TextureRect/VBoxContainer_Aktuelles/ScrollContainer_Aktuelles/VBoxContainer_Aktuelles_Scrollable.add_child(temp_container)
	
	# calculate new numbers
	logic.FinishDay()
	_update_graph()
	_update_resource_counters()
	_update_infection_counters()
	
	# get the news and make an independent copy
	var tempnews = logic.getNews()
	var thenews = tempnews.duplicate(true)
	# invert our independendt copy to show newest news first
	thenews.invert()
	
	# remove all existing news entries since we will add all of them again
	var old_news = $Control/TextureRect/VBoxContainer_Aktuelles/ScrollContainer_Aktuelles/VBoxContainer_Aktuelles_Scrollable.get_children()
	for oldie in old_news:
		oldie.queue_free()

	# enter new news into the scene. nested because the news array consists of one array per day
	for a_new in thenews:
		for a_a_new in a_new:
			var temp_UI_event = Event.instance()
			temp_UI_event.setModel(a_a_new)
			$Control/TextureRect/VBoxContainer_Aktuelles/ScrollContainer_Aktuelles/VBoxContainer_Aktuelles_Scrollable.add_child(temp_UI_event)
			
# This function normalizes the plots for infected, dead and cured to our drawing area
func _normalize_Graph_Points(frame_x_min, frame_x_max, frame_y_min, frame_y_max, input_array):
	var return_array = []
	var x_temp_px
	var y_temp_px
	var x_step_size
	# read border values
	var y_max_value = scale_max
	var y_min_value = 0
	
	var y_diff_px = frame_y_max - frame_y_min
	var y_diff_value = y_max_value - y_min_value
	
	# calculate x step size
	if input_array.size() == 1: x_step_size = frame_x_max - frame_x_min
	else:
		x_step_size = ( frame_x_max - frame_x_min ) / ( day_scale )
	
	# normalize y values and write to return
	var temp_array = input_array

	for i in temp_array.size():
		x_temp_px = frame_x_min + x_step_size * i
		if y_diff_value == 0: y_temp_px = frame_y_min
		else:
			y_temp_px =  ( ( round(temp_array[i]) - y_min_value ) / y_diff_value ) * y_diff_px + frame_y_min
		return_array.push_back(Vector2(x_temp_px, y_temp_px))
	
	return return_array


func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.set_stream(load("res://cards_corona_bg_music_loop.wav"))
	$AudioStreamPlayer.play(0)
