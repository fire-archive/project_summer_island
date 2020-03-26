extends Control

var _screenshot_directory = "user://screenshots"
var _capture_tasks = []

func _ready() -> void:
	Directory.new().make_dir(_screenshot_directory)

func _input(event) -> void:
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_F10:
			_capture()
		if event.scancode == KEY_F1:
			$DebugUI/ControlHelpPanel.visible = !$DebugUI/ControlHelpPanel.visible
		if event.scancode == KEY_F2:
			$DebugUI/Performance.visible = !$DebugUI/Performance.visible

func _capture():
	# Start thread for capturing images
	var task = Thread.new()
	task.start(self, "_capture_thread", null)
	_capture_tasks.append(task)

func _capture_thread(_arg):
	# Save image
	var image = get_viewport().get_texture().get_data()
	var path = "%s/capture_%s.png" % [_screenshot_directory, OS.get_unix_time()]
	image.flip_y()
	image.save_png(path)
	print ("Screenshot saved to: %s%s" % [OS.get_user_data_dir(), path])

func _exit_tree():
	for task in _capture_tasks:
		task.wait_to_finish()