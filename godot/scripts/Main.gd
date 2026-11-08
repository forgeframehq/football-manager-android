extends Control

var manager = {
	"name": "Alex Rivera",
	"nationality": "Spain",
	"outfit": "Classic Suit",
	"social": "@manager_alex"
}
var club = "Manchester City"
var budget: int = 80000000
var squad: Array = []
var transfer_pool: Array = []

@onready var tab_container: TabContainer = $Content/TabContainer
@onready var squad_list: VBoxContainer = $Content/TabContainer/Squad/SquadList
@onready var budget_label: Label = $Content/TabContainer/Transfers/BudgetLabel
@onready var manager_label: Label = $Content/TabContainer/Manager/ManagerInfo

func _ready() -> void:
	_load_players()
	_setup_tabs()
	_populate_squad()
	_populate_transfers()
	_update_manager_info()

func _setup_tabs() -> void:
	$BottomTabs/SquadTab.pressed.connect(func(): tab_container.current_tab = 0)
	$BottomTabs/TransfersTab.pressed.connect(func(): tab_container.current_tab = 1)
	$BottomTabs/TacticsTab.pressed.connect(func(): tab_container.current_tab = 2)
	$BottomTabs/ClubTab.pressed.connect(func(): tab_container.current_tab = 3)
	$BottomTabs/ManagerTab.pressed.connect(func(): tab_container.current_tab = 4)

func _load_players() -> void:
	squad = [
		{"name": "Kylian Mbappé", "pos": "ST", "ovr": 91, "pot": 94, "value": 180000000},
		{"name": "Erling Haaland", "pos": "ST", "ovr": 91, "pot": 93, "value": 170000000},
		{"name": "Lamine Yamal", "pos": "RW", "ovr": 90, "pot": 95, "value": 150000000},
		{"name": "Jude Bellingham", "pos": "CAM", "ovr": 90, "pot": 94, "value": 140000000},
		{"name": "Pedri", "pos": "CM", "ovr": 90, "pot": 93, "value": 120000000},
		{"name": "Rodri", "pos": "CDM", "ovr": 90, "pot": 91, "value": 110000000},
	]
	transfer_pool = [
		{"name": "Harry Kane", "pos": "ST", "ovr": 90, "pot": 90, "value": 90000000},
		{"name": "Vinícius Júnior", "pos": "LW", "ovr": 89, "pot": 92, "value": 130000000},
		{"name": "Bukayo Saka", "pos": "RW", "ovr": 88, "pot": 91, "value": 95000000},
		{"name": "Bruno Fernandes", "pos": "CAM", "ovr": 89, "pot": 89, "value": 85000000},
	]

func _populate_squad() -> void:
	for child in squad_list.get_children():
		child.queue_free()
	for p in squad:
		var card = _create_player_card(p, true)
		squad_list.add_child(card)

func _populate_transfers() -> void:
	var list = $Content/TabContainer/Transfers/TransferList
	for child in list.get_children():
		child.queue_free()
	var vbox = VBoxContainer.new()
	list.add_child(vbox)
	for p in transfer_pool:
		var card = _create_player_card(p, false)
		vbox.add_child(card)

func _create_player_card(p: Dictionary, is_squad: bool) -> PanelContainer:
	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(0, 80)
	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 12)
	panel.add_child(hbox)
	
	var name_label = Label.new()
	name_label.text = "%s  (%s)" % [p.name, p.pos]
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_label.add_theme_font_size_override("font_size", 18)
	hbox.add_child(name_label)
	
	var ovr_label = Label.new()
	ovr_label.text = str(p.ovr)
	ovr_label.add_theme_font_size_override("font_size", 22)
	ovr_label.modulate = Color(1, 0.84, 0)
	hbox.add_child(ovr_label)
	
	if not is_squad:
		var buy_btn = Button.new()
		buy_btn.text = "£%dM" % int(p.value / 1000000)
		buy_btn.pressed.connect(func(): _buy_player(p))
		hbox.add_child(buy_btn)
	
	return panel

func _buy_player(p: Dictionary) -> void:
	if budget >= p.value:
		budget -= p.value
		squad.append(p)
		transfer_pool.erase(p)
		budget_label.text = "Budget: £%dM" % int(budget / 1000000)
		_populate_squad()
		_populate_transfers()

func _update_manager_info() -> void:
	if manager_label:
		manager_label.text = "Manager: %s\nNationality: %s\nOutfit: %s\nSocial: %s\nClub: %s" % [manager.name, manager.nationality, manager.outfit, manager.social, club]
