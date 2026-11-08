extends Control

var season: int = 1
var budget: int = 50000000
var squad: Array = []
var transfer_pool: Array = []

@onready var tab_container: TabContainer = $Content/TabContainer
@onready var squad_list: VBoxContainer = $Content/TabContainer/Squad/SquadList
@onready var budget_label: Label = $Content/TabContainer/Transfers/BudgetLabel

func _ready() -> void:
	_load_players()
	_setup_tabs()
	_populate_squad()
	_populate_transfers()

func _setup_tabs() -> void:
	$BottomTabs/SquadTab.pressed.connect(func(): tab_container.current_tab = 0)
	$BottomTabs/TransfersTab.pressed.connect(func(): tab_container.current_tab = 1)
	$BottomTabs/TacticsTab.pressed.connect(func(): tab_container.current_tab = 2)
	$BottomTabs/ClubTab.pressed.connect(func(): tab_container.current_tab = 3)

func _load_players() -> void:
	# Sample real players from public EA FC 27 data
	squad = [
		{"name": "Kylian Mbappé", "pos": "ST", "ovr": 91, "pot": 94, "pac": 96, "sho": 91, "pas": 80, "dri": 92, "def": 29, "phy": 76, "value": 180000000},
		{"name": "Erling Haaland", "pos": "ST", "ovr": 91, "pot": 93, "pac": 87, "sho": 92, "pas": 71, "dri": 80, "def": 47, "phy": 89, "value": 170000000},
		{"name": "Lamine Yamal", "pos": "RW", "ovr": 90, "pot": 95, "pac": 86, "sho": 84, "pas": 87, "dri": 93, "def": 38, "phy": 61, "value": 150000000},
		{"name": "Jude Bellingham", "pos": "CAM", "ovr": 90, "pot": 94, "pac": 79, "sho": 86, "pas": 83, "dri": 88, "def": 79, "phy": 85, "value": 140000000},
		{"name": "Pedri", "pos": "CM", "ovr": 90, "pot": 93, "pac": 76, "sho": 75, "pas": 89, "dri": 91, "def": 77, "phy": 75, "value": 120000000},
	]
	transfer_pool = [
		{"name": "Harry Kane", "pos": "ST", "ovr": 90, "pot": 90, "value": 90000000},
		{"name": "Vinícius Júnior", "pos": "LW", "ovr": 89, "pot": 92, "value": 130000000},
		{"name": "Rodri", "pos": "CDM", "ovr": 90, "pot": 91, "value": 110000000},
		{"name": "Bukayo Saka", "pos": "RW", "ovr": 88, "pot": 91, "value": 95000000},
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
	panel.custom_minimum_size = Vector2(0, 72)
	var hbox = HBoxContainer.new()
	panel.add_child(hbox)
	
	var name_label = Label.new()
	name_label.text = "%s  (%s)" % [p.name, p.pos]
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(name_label)
	
	var ovr_label = Label.new()
	ovr_label.text = "OVR %d" % p.ovr
	ovr_label.add_theme_font_size_override("font_size", 18)
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
