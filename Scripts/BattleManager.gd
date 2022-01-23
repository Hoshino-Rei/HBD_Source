extends Node2D

const FREQ_MAX = 11050.0
const MIN_DB = 60

export(String, FILE, "*.tscn") var gameover_scene;
export(String, FILE, "*.tscn") var win_scene;


onready var player = $PlayerMoon;
onready var boss = $Rei/Rei_Model;
onready var music = $MusicPlayer;
onready var world = $WorldEnvironment;
onready var env = world.environment;

var dead = false;
var bdead = false;
var spectrum;

func _ready():
	spectrum = AudioServer.get_bus_effect_instance(2, 0);

func _process(_delta):
	if ((player.cur_health <= -10.0) && !dead):
		Transitions.fade_out(self, gameover_scene, 1.5, Color.black);
		dead = true;
	if (boss != null && (boss.current_health <= -10.0) && !bdead):
		Transitions.fade_out(self, win_scene, 1.5, Color.black);
		bdead = true;

	var prev_hz = 0;
	var hz = music.get_playback_position() * FREQ_MAX / 4;
	var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
	var energy = clamp((MIN_DB + linear2db(magnitude)) / MIN_DB, 0, 1)
	var modifed_energy = clamp(Utils.map_range(energy, 0.1, 1, 0, 0.05), 0, 0.05);
	env.glow_bloom = modifed_energy;
