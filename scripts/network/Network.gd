extends Node

var client: StreamPeerTCP
var server_address: String = "192.168.1.19"
var server_port: int = 8080

var last_connection_try: float = 0.0
var reconnect_interval: float = 10.0
var connect_timeout: float = 3.0
var timer := Timer.new()

func tcp_status():
	return client.get_status()

func _is_connected():
	return tcp_status() == StreamPeerTCP.STATUS_CONNECTED

func get_status_string():
	var status =  tcp_status()
	match status:
		StreamPeerTCP.STATUS_NONE:
			return "No connections"
		StreamPeerTCP.STATUS_CONNECTING:
			return "Connecting"
		StreamPeerTCP.STATUS_CONNECTED:
			return "Connected"
		StreamPeerTCP.STATUS_ERROR:
			return "Connection error"
		
	

func connect_to_server():
	client = StreamPeerTCP.new()
	client.set_no_delay(true) 
	var err = client.connect_to_host(server_address, server_port)
	if err == OK:
		print("Connection OK")
		last_connection_try = 0.0
	else:
		print("Failed to connect to server:", err)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if not _is_connected():
		#return
	var err = client.poll()
	if not err == OK:
		print("Failed to poll client:", err)
		return

	if _is_connected() and client.get_available_bytes() > 0:
		handle_incoming_message()

func handle_incoming_message() -> void:
	var message_length = client.get_u16()
	var raw_message = client.get_data(message_length)
	
