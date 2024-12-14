extends RichTextLabel

var socket : StreamPeerTCP
var buffer = []
var max_lines = 250
var screen_width = 80
var screen_height = 25
var screen_buffer = [] 
var cursor_position = Vector2(0, 0)
var cell_template = {
	char = " ",              # Le caractère à afficher
	color = "white",          # Couleur du texte
	bgcolor = "black",        # Couleur de fond
	bold = false,             # Gras
	underline = false         # Souligné
}

var is_graphic_mode = false

const ANSI_TO_BB = {
	# Couleurs texte
	30: "black",
	31: "red",
	32: "green",
	33: "yellow",
	34: "blue",
	35: "magenta",
	36: "cyan",
	37: "white",
	
	# Couleurs de fond
	40: "black",
	41: "red",
	42: "green",
	43: "yellow",
	44: "blue",
	45: "magenta",
	46: "cyan",
	47: "white",
	
	## Styles
	#1: "[b]",         # Gras
	#4: "[u]",         # Souligné
	#5: "[blink]",     # Clignotant
	#7: "[inverse]",   # Inversé (simulé en inversant les couleurs)
	#8: "[hidden]",    # Texte masqué
	#
	## Réinitialisation
	#0: "[/color][/bgcolor][/b][/u][/blink][/inverse][/hidden]"
}

func ansi_color_256_to_hex(index: int) -> String:
	# Couleurs fixes (0-15)
	var basic_colors = [
		"#000000", "#800000", "#008000", "#808000", "#000080", "#800080", "#008080", "#c0c0c0",
		"#808080", "#ff0000", "#00ff00", "#ffff00", "#0000ff", "#ff00ff", "#00ffff", "#ffffff"
	]

	if index < 16:
		return basic_colors[index]

	# Couleurs de la cube 6x6x6 (16-231)
	elif index >= 16 and index < 232:
		var r = ((index - 16) / 36) % 6 * 51
		var g = ((index - 16) / 6) % 6 * 51
		var b = (index - 16) % 6 * 51
		return Color(r / 255.0, g / 255.0, b / 255.0).to_html()

	# Couleurs de la gamme de gris (232-255)
	elif index >= 232 and index < 256:
		var gray = (index - 232) * 10 + 8
		return Color(gray / 255.0, gray / 255.0, gray / 255.0).to_html()

	# Par défaut, retourne noir si l'index est invalide
	return "#000000"


func replace_with_line_drawing(text: String) -> String:
	var line_drawing_map = {
		"j": "┘",
		"k": "┐",
		"l": "┌",
		"m": "└",
		"q": "─",
		"x": "│",
		"t": "├",
		"u": "┤",
		"w": "┴",
		"v": "┬",
		"n": "┼"
	}
	var result = ""
	for char in text:
		if line_drawing_map.has(char):
			result += line_drawing_map[char]
		else:
			result += char
	return result

func render_screen() -> String:
	var bbcode_text = ""
	var current_color = ""
	var current_bgcolor = ""
	$".".text = ""

	for row in screen_buffer:
		for cell in row:
				
			#bbcode_text += "[color=%s]" % [cell["color"]]
			#bbcode_text += "[bgcolor=%s]" % [cell["bgcolor"]]
			##
			#if cell.bold:
				#bbcode_text += "[b]"
			#if cell.underline:
				#bbcode_text += "[u]"
#
			#bbcode_text += cell.char
#
			#if cell.underline:
				#bbcode_text += "[/u]"
			#if cell.bold:
				#bbcode_text += "[/b]"
			#
			#bbcode_text += "[/bgcolor]"
			#bbcode_text += "[/color]"
			push_color(cell["color"])
			push_bgcolor(cell["bgcolor"])
			if cell.bold:
				push_bold()
			add_text(cell.char)
			if cell.bold:
				pop()
			pop()
			pop()
		add_text("\n")
		bbcode_text += "\n"
	return bbcode_text.strip_edges()



func clear_screen():
	initialize_screen()
	return
	for i in range(screen_height):
		screen_buffer[i] = " ".repeat(screen_width)
	cursor_position = Vector2(0, 0)

func clear_from_cursor():
	var row = cursor_position.y
	var col = cursor_position.x

	# Efface la ligne courante à partir du curseur
	screen_buffer[row] = screen_buffer[row].substr(0, col) + " " * (screen_width - col)

	# Efface toutes les lignes suivantes
	for i in range(row + 1, screen_height):
		screen_buffer[i] = " " * screen_width

func clear_to_cursor():
	var row = cursor_position.y
	var col = cursor_position.x

	# Efface la ligne courante jusqu'au curseur
	screen_buffer[row] = " " * col + screen_buffer[row].substr(col)

	# Efface toutes les lignes précédentes
	for i in range(row):
		screen_buffer[i] = " " * screen_width

func initialize_screen():
	cursor_position.x = 0
	cursor_position.y = 0
	for y in range(screen_height):
		var row = []
		for x in range(screen_width):
			row.append(cell_template.duplicate())
		screen_buffer.append(row)
	
var current_style = {
	"color": "white",
	"bgcolor": "black",
	"bold": false,
	"underline": false
}

func update_screen_with_text(text: String):
	for char in text:
		if char == '\n':
			# Passe à la ligne suivante
			cursor_position.x = 0
			cursor_position.y += 1
			if cursor_position.y >= screen_height:
				cursor_position.y = screen_height - 1
		else:
			if cursor_position.y < screen_height and cursor_position.x < screen_width:
				var cell = screen_buffer[cursor_position.y][cursor_position.x]
				#if char == "":
					#char = " "
				cell.char = char
				cell.color = current_style["color"]
				cell.bgcolor = current_style["bgcolor"]
				cell.bold = current_style["bold"]
				cell.underline = current_style["underline"]
				# Déplace le curseur
				cursor_position.x += 1
				if cursor_position.x >= screen_width:
					cursor_position.x = 0
					cursor_position.y += 1
					if cursor_position.y >= screen_height:
						cursor_position.y = screen_height - 1



func ansi_to_bbcode(ansi_text: String):
	var regex = RegEx.new()
	regex.compile(r"\033\[(\d+(;\d+)*)?([A-Za-z])|\033\((.)")  # Ajoute le mode graphique


	var last_index = 0
	var matches = regex.search_all(ansi_text)

	for match in matches:
		var start = match.get_start()
		var end = match.get_end()

		# Ajoute le texte brut avant la séquence ANSI
		if start > last_index:
			var raw_text = ansi_text.substr(last_index, start - last_index)
			if is_graphic_mode:
				raw_text = replace_with_line_drawing(raw_text)
			update_screen_with_text(raw_text)

		# Analyse la séquence ANSI
		var codes = match.get_string(1).split(";")
		var command = match.get_string(3)
		if match.get_string(0).begins_with("\\033("):
			var mode = match.get_string(4)
			if mode == "0":
				is_graphic_mode = true  # Active le mode graphique
			elif mode == "B":
				is_graphic_mode = false  # Désactive le mode graphique
		elif command == "H":  # Déplacement absolu
			var row = codes[0].to_int() - 1
			var col = codes[1].to_int() - 1 if codes.size() > 1 else 0
			cursor_position = Vector2(clamp(col, 0, screen_width - 1), clamp(row, 0, screen_height - 1))
		elif command == "A":  # Monte le curseur
			cursor_position.y = max(0, cursor_position.y - codes[0].to_int())
		elif command == "B":  # Descend le curseur
			cursor_position.y = min(screen_height - 1, cursor_position.y + codes[0].to_int())
		elif command == "C":  # Avance le curseur
			cursor_position.x = min(screen_width - 1, cursor_position.x + codes[0].to_int())
		elif command == "D":  # Recule le curseur
			cursor_position.x = max(0, cursor_position.x - codes[0].to_int())
		elif command == "J":  # Effacement (tout ou partiel)
			if codes[0] == "2":  # Efface tout l'écran
				clear_screen()
			elif codes[0] == "0":  # Efface du curseur à la fin
				print("clear to end")
				clear_from_cursor()
			elif codes[0] == "1":  # Efface du curseur au début
				print("clear from end")
				clear_to_cursor()
		elif command == "m":  # Styles et couleurs
			for code in codes:
				var code_int = int(code)
				if code_int in ANSI_TO_BB:  # Couleurs texte et fond
					if code_int < 40:
						current_style["color"] = ANSI_TO_BB[code_int]
					elif code_int >= 40 and code_int < 50:
						current_style["bgcolor"] = ANSI_TO_BB[code_int]
				elif code_int == 1:
					current_style["bold"] = true
				elif code_int == 4:
					current_style["underline"] = true
				elif code_int == 0:  # Réinitialisation
					current_style = {
						"color": "white",
						"bgcolor": "black",
						"bold": false,
						"underline": false
					}
			

		last_index = end

	# Ajoute le texte brut après la dernière séquence ANSI
	if last_index < ansi_text.length():
		update_screen_with_text(ansi_text.substr(last_index))
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_screen()
	socket = StreamPeerTCP.new()
	if socket.connect_to_host("192.168.1.19", 8080) == OK:
		print("Connected to htop server")
	else:
		print("Failed to connect to server")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	socket.poll()
	if socket.get_available_bytes() > 0:
		
		var data = socket.get_utf8_string(socket.get_available_bytes())
		ansi_to_bbcode(data)
		#$".".bbcode_text = render_screen()
		render_screen()
		#if data.find("[2J") == -1:
			#print("clear")
			#buffer = []
		#var lines = data.split("\n")
		#print(lines.size())
		#for line in lines:
			#buffer.append(line)
			#if buffer.size() > max_lines:
				#buffer.pop_front()  # Supprime les lignes les plus anciennes
		#print(buffer.size())
		#var bbcode_output = ansi_to_bbcode("\n".join(buffer))
		#$".".bbcode_text = bbcode_output
