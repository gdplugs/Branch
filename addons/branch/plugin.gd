tool
extends EditorPlugin

var branch_button

func _ready(): 
	get_curent_branch()

func _enter_tree():
	branch_button = Button.new()
	branch_button.text = '...'
	var _err = branch_button.connect("pressed", self, "get_curent_branch")
	if _err:
		printerr("Error while connecting to the branch button's pressed signal")
	else:
		add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, branch_button)

func _exit_tree():
	if branch_button:
		if branch_button.is_inside_tree():
			remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, branch_button)
		branch_button.queue_free() 

func get_curent_branch() -> void:
	var output = []
	OS.execute( 'git', ['rev-parse', "--abbrev-ref", 'HEAD'], true, output )
	if len(output) == 1:
		branch_button.text = output[0].strip_edges(true, true)
