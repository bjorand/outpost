

#extends TextEdit
#
#var terminal_text = "coucou"
#@export var websocket_url = "ws://localhost:8080/ws"
#var socket = WebSocketPeer.new()
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	## Initiate connection to the given URL.
	#var err = socket.connect_to_url(websocket_url)
	#if err != OK:
		#print("Unable to connect")
		#set_process(false)
	#else:
		## Wait for the socket to connect.
		#await get_tree().create_timer(2).timeout
#
		## Send data.
		#socket.send_text("Test packet")
		#
		#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	## Call this in _process or _physics_process. Data transfer and state updates
	## will only happen when calling this function.
	#socket.poll()
	#var state = socket.get_ready_state()
	#
	#
	#if state == WebSocketPeer.STATE_OPEN:
		#while socket.get_available_packet_count():
			#terminal_text += socket.get_packet().get_string_from_utf8()
			#self.text = terminal_text
	#elif state == WebSocketPeer.STATE_CLOSING:
		#pass
	#elif state == WebSocketPeer.STATE_CLOSED:
		## The code will be -1 if the disconnection was not properly notified by the remote peer.
		#var code = socket.get_close_code()
		#print("WebSocket closed with code: %d. Clean: %s" % [code, code != -1])
		#set_process(false) # Stop processing.
#
#
##func _input(event):
	##print(event)
	##
	##if event is InputEventKey and event.pressed:
		##print(event)
		##var chars = OS.get_keycode_string(event.physical_keycode)
		##if chars:
			##socket.get_peer(1).put_packet(chars.to_utf8())  # Envo
