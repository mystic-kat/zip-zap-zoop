extends Control

# Load game scenes for different modes
var closed_world_scene = preload("res://scenes/main.tscn")
var infinite_runner_scene = preload("res://scenes/infinite_runner.tscn")
var pvp_challenge_scene = preload("res://scenes/pvp_challenge.tscn")

func _ready():
	print("Menu scene loaded!")
	print("VBoxContainer found:", $VBoxContainer != null)

	if $VBoxContainer != null:
		print("TimedPuzzleButton found:", $VBoxContainer/TimedPuzzleButton != null)
		print("EndlessRunButton found:", $VBoxContainer/EndlessRunButton != null)
		print("PvPChallengeButton found:", $VBoxContainer/PvPChallengeButton != null)
		print("SettingsButton found:", $VBoxContainer/SettingsButton != null)
		print("QuitButton found:", $VBoxContainer/QuitButton != null)
	# Connect button signals using Godot 4 syntax
	$VBoxContainer/TimedPuzzleButton.pressed.connect(_on_ClosedWorldButton_pressed)
	$VBoxContainer/EndlessRunButton.pressed.connect(_on_InfiniteRunnerButton_pressed)
	$VBoxContainer/PvPChallengeButton.pressed.connect(_on_PvPChallengeButton_pressed)
	$VBoxContainer/SettingsButton.pressed.connect(_on_SettingsButton_pressed)
	$VBoxContainer/QuitButton.pressed.connect(_on_QuitButton_pressed)

	# Update button text for clarity
	$VBoxContainer/TimedPuzzleButton.text = "Timed Puzzle Mode"  
	$VBoxContainer/EndlessRunButton.text = "Endless Run Mode"
	$VBoxContainer/PvPChallengeButton.text = "PvP Challenge Mode"

	# Apply cartoonish styling and tooltips
	for button in $VBoxContainer.get_children():
		if button is Button:
			button.set("theme_override_styles/normal", get_cartoon_style())
			button.mouse_entered.connect(func(): _on_Button_hovered(button))
			button.mouse_exited.connect(func(): _on_Button_unhovered(button))

			# Add tooltips for each mode
			if button == $VBoxContainer/ClosedWorldButton:
				button.tooltip_text = "Solve puzzles before time runs out! Avoid deadly obstacles."
			elif button == $VBoxContainer/InfiniteRunnerButton:
				button.tooltip_text = "Run endlessly, dodge obstacles, and survive as long as possible."
			elif button == $VBoxContainer/PvPChallengeButton:
				button.tooltip_text = "Compete against other players in real-time challenges."
			elif button == $VBoxContainer/SettingsButton:
				button.tooltip_text = "Adjust game settings."
			elif button == $VBoxContainer/QuitButton:
				button.tooltip_text = "Exit the game."

	# Load and display current rank and high score
	var current_rank = 5  # Fetch from saved data
	var high_score = 1500  # Fetch from saved data
	$Scoreboard/RankLabel.text = "Current Rank: #" + str(current_rank)
	$Scoreboard/ScoreLabel.text = "High Score: " + str(high_score)
	$Scoreboard/LeaderBoardButton.pressed.connect(_on_LeaderboardButton_pressed)

func get_cartoon_style():
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0.2, 0.6, 1, 1)  # Vibrant blue
	stylebox.set_corner_radius_all(20)
	stylebox.set_border_width_all(3)
	stylebox.border_color = Color(1, 1, 1, 1)  # White border
	return stylebox

func _on_Button_hovered(button):
	button.modulate = Color(1, 1, 0.5, 1)  # Yellow tint when hovered

func _on_Button_unhovered(button):
	button.modulate = Color(1, 1, 1, 1)  # Reset color

func _on_ClosedWorldButton_pressed():
	get_tree().change_scene_to_packed(closed_world_scene)

func _on_InfiniteRunnerButton_pressed():
	get_tree().change_scene_to_packed(infinite_runner_scene)

func _on_PvPChallengeButton_pressed():
	get_tree().change_scene_to_packed(pvp_challenge_scene)

func _on_SettingsButton_pressed():
	print("Settings menu to be implemented.")

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_LeaderboardButton_pressed():
	print("Leaderboard screen to be implemented.")
