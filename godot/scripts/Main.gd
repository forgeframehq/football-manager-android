extends Control

@onready var tabs: TabContainer = $Content/Tabs
@onready var squad_list: VBoxContainer = $Content/Tabs/Squad/SquadList
@onready var market_list: VBoxContainer = $Content/Tabs/Market/MarketList

var squad = []
var market = []

func _ready() -> void:
	_load_data()
	_setup_nav()
	_fill_squad()
	_fill_market()

func _setup_nav() -> void:
	$Bottom/OfficeBtn.pressed.connect(func(): tabs.current_tab = 0)
	$Bottom/SquadBtn.pressed.connect(func(): tabs.current_tab = 1)
	$Bottom/TacticsBtn.pressed.connect(func(): tabs.current_tab = 2)
	$Bottom/MarketBtn.pressed.connect(func(): tabs.current_tab = 3)
	$Bottom/ClubBtn.pressed.connect(func(): tabs.current_tab = 4)

func _load_data() -> void:
	squad = [
		{"name": "Havertz", "pos": "ST", "ovr": 82},
		{"name": "Saka", "pos": "RW", "ovr": 88},
		{"name": "Ødegaard", "pos": "CAM", "ovr": 88},
		{"name": "Rice", "pos": "CDM", "ovr": 86},
		{"name": "Saliba", "pos": "CB", "ovr": 89},
		{"name": "Raya", "pos": "GK", "ovr": 84},
	]
	market = [
		{"name": "Bukayo Saka", "pos": "RW", "ovr": 88, "value": 95},
		{"name": "Lamine Yamal", "pos": "RW", "ovr": 90, "value": 150},
		{"name": "Jude Bellingham", "pos": "CAM", "ovr": 90, "value": 140},
	]

func _fill_squad() -> void:
	for c in squad_list.get_children():
		c.queue_free()
	for p in squad:
		var lbl = Label.new()
		lbl.text = "%s  (%s)  OVR %d" % [p.name, p.pos, p.ovr]
		lbl.add_theme_font_size_override("font_size", 18)
		squad_list.add_child(lbl)

func _fill_market() -> void:
	for c in market_list.get_children():
		c.queue_free()
	for p in market:
		var h = HBoxContainer.new()
		var lbl = Label.new()
		lbl.text = "%s (%s) OVR %d" % [p.name, p.pos, p.ovr]
		lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h.add_child(lbl)
		var btn = Button.new()
		btn.text = "£%dM" % p.value
		h.add_child(btn)
		market_list.add_child(h)
