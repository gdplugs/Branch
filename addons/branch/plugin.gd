@tool
extends EditorPlugin

var branch_button: Button

func _enter_tree():
	branch_button = Button.new()
	branch_button.text = "..."
	branch_button.pressed.connect(get_current_branch)
	add_control_to_container(CONTAINER_TOOLBAR, branch_button)

func _exit_tree():
	if branch_button and branch_button.is_inside_tree():
		remove_control_from_container(CONTAINER_TOOLBAR, branch_button)
		branch_button.queue_free()

func _notification(what):
	if what == NOTIFICATION_APPLICATION_FOCUS_IN:
		get_current_branch()

func get_current_branch() -> void:
	var output: Array = []
	var exit_code := OS.execute("git", ["rev-parse", "--abbrev-ref", "HEAD"], output, true)
	if exit_code == 0 and output.size() == 1:
		branch_button.text = output[0].strip_edges()