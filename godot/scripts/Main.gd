extends Control

var season: int = 1
var wins: int = 0
var losses: int = 0
var squad: Array = []

@onready var info_label: Label = $VBox/Info
@onready var log_label: RichTextLabel = $VBox/Log

func _ready() -> void:
	generate_squad()
	update_info()
	$VBox/ViewSquad.pressed.connect(_on_view_squad)
	$VBox/Simulate.pressed.connect(_on_simulate)
	$VBox/NextSeason.pressed.connect(_on_next_season)

func generate_squad() -> void:
	squad.clear()
	var positions = ["GK", "DEF", "DEF", "DEF", "DEF", "MID", "MID", "MID", "FWD", "FWD", "FWD"]
	var names = ["Alex", "Jordan", "Sam", "Taylor", "Casey", "Morgan", "Riley", "Jamie", "Drew", "Quinn"]
	for i in 11:
		var p = {
			"name": names[randi() % names.size()] + " " + char(65 + randi() % 26),
			"rating": 65 + randi() % 25,
			"position": positions[i]
		}
		squad.append(p)

func update_info() -> void:
	var avg = 0
	if squad.size() > 0:
		for p in squad:
			avg += p.rating
		avg /= squad.size()
	info_label.text = "Season: %d\nRecord: %dW - %dL\nTeam Avg: %d" % [season, wins, losses, avg]

func _on_view_squad() -> void:
	var text = "[b]Your Squad:[/b]\n"
	for p in squad:
		text += "%s (%s) - %d\n" % [p.name, p.position, p.rating]
	log_label.text = text

func _on_simulate() -> void:
	var my_avg = 0
	for p in squad:
		my_avg += p.rating
	my_avg /= max(1, squad.size())
	var opp_avg = 65 + randi() % 25
	var my_goals = maxi(0, int((my_avg - 60) / 8.0) + randi() % 4)
	var opp_goals = maxi(0, int((opp_avg - 60) / 8.0) + randi() % 4)
	var result = "DRAW"
	if my_goals > opp_goals:
		wins += 1
		result = "[color=green]WIN![/color]"
	elif my_goals < opp_goals:
		losses += 1
		result = "[color=red]LOSS[/color]"
	log_label.text = "Match Result: %s\nScore: %d - %d\nYour Avg: %d | Opp: %d" % [result, my_goals, opp_goals, my_avg, opp_avg]
	update_info()

func _on_next_season() -> void:
	season += 1
	for p in squad:
		if randf() > 0.5:
			p.rating = mini(95, p.rating + randi() % 3)
	wins = 0
	losses = 0
	update_info()
	log_label.text = "[b]New season started![/b] Squad improved slightly."
