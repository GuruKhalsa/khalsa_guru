
$ ->
	if $(window).width() < 1000
		$('#battleship').hide()
		$('.container').append("<h3 class='thin-window-error'>Your browser window is not wide enough to view this content.  Please open this page on a larger screened device or expand your browser window and reload the page.  Apologies for the inconvenience.</h3>")
		console.log('Window too small')
	else
		width_modifier = $('#battleship').width()/40

		changeLine = (time_modifier, existing_text, new_text) ->
			setTimeout ->
				text = $('#battleship').text()
				$('#battleship').text(text.replace(existing_text, new_text))
			, 100 * (width_modifier + time_modifier)

		blink = (time_delay) ->
			changeLine(time_delay, '=( °w° )=\n', '=( ^w^ )=\n')
			changeLine(time_delay + 2, '=( ^w^ )=\n', '=( °w° )=\n')

		for n in [1..width_modifier]
			setTimeout ->
				text = $('#battleship').text()
				$('#battleship').text(text.replace(/\n/g, "\n "))
			, 100 * n

		 $('#battleship').css(
										'-webkit-transform' : "rotate(-5deg)",
										'-moz-transform' : "rotate(-5deg)",
										'-ms-transform' : "rotate(-5deg)",
										'transform' : "rotate(-5deg)");
										## @-moz-keyframes spin { 100% { -moz-transform: rotate(360deg); } }
										## @-webkit-keyframes spin { 100% { -webkit-transform: rotate(360deg); } }
										## @keyframes spin { 100% { -webkit-transform: rotate(360deg); transform:rotate(360deg); } });

		setTimeout ->
			$('#battleship').css(
										'-webkit-transform' : "rotate(10deg)",
										'-moz-transform' : "rotate(10deg)",
										'-ms-transform' : "rotate(10deg)",
										'transform' : "rotate(10deg)");
		, 100 * (width_modifier/4)

		setTimeout ->
			$('#battleship').css(
										'-webkit-transform' : "rotate(0deg)",
										'-moz-transform' : "rotate(0deg)",
										'-ms-transform' : "rotate(0deg)",
										'transform' : "rotate(0deg)");
		, 100 * (width_modifier/2)

		changeLine(5, ' \\/   _', '/\\_/\\ _')

		changeLine(10, ' /\\\n', '/\\_/\\\n')
		changeLine(10, '  /\\_/\\ _\n', '=( °w° )=\n')

		changeLine(14, '=( °w° )=\n', '=( ^w^ )=\n')
		changeLine(16, '=( ^w^ )=\n', '=( °w° )=\n')

		changeLine(40, '  /\\_/\\\n', '=( °w° )=\n')
		changeLine(40, '_/\n', '_/                    /\\_/\\\n')
		changeLine(40, '-         =( °w° )=', '-           )   (  //')

		changeLine(45, '|-\n', '|-                       /\\_/\\\n')
		changeLine(45, '_/                    /\\_/\\\n', '_/                  =( °w° )=\n')
		changeLine(45, '_              =( °w° )=', '_                )   (  //')
		changeLine(45, '-           )   (  //', '-          (__ __)//')

		setTimeout ->
			i = 0
			while i <= 10000
				blink(i)
				i += 40
		, 100 * (width_modifier + 45)

		changeLine(55, '|||\n', '|||          ／￣￣￣￣￣￣\\\n')
		changeLine(55, "++\'\n", "++\'        |  Hi FINE!  |\n")
		changeLine(55, '|-                       /\\_/\\', '|-      \\___________ >   /\\_/\\')

		changeLine(75, '\\/\n','\\/      ／￣￣￣￣￣￣￣￣￣￣￣‾\\\n')
		changeLine(75, "---\n","---     \| I'm here to tell you \|\n")
		changeLine(75, "\| \[\n", "\| \[   \| why you should hire  \|\n")
		changeLine(75, "\|\|\|          ／￣￣￣￣￣￣\\","\|\|\|   \| Guru Khalsa to work  \|")
		changeLine(75, "++\'        \|  Hi FINE!  \|", "++\'   \\      with you      /")
		changeLine(75, "\|-      \\___________ >","\|- \\________________ >")

		changeLine(115, "\| I'm here to tell you \|", "\|    He's creative,    \|")
		changeLine(115, "\| why you should hire  \|", "\|  hardworking, loves  \|")
		changeLine(115, "\| Guru Khalsa to work  \|", "\|  to code and explore \|")
		changeLine(115, "\\      with you      /", "\\  new technologies  /")

		changeLine(155, "\|    He's creative,    \|", "\|                      \|")
		changeLine(155, "\|  hardworking, loves  \|", "\|   And he likes to    \|")
		changeLine(155, "\|  to code and explore \|", "\|   play ping pong     \|")
		changeLine(155, "\\  new technologies  /", "\\                    /")
		changeLine(155, "  =( °w° )=", "_ =( °w° )=")
		changeLine(155, "     )   (", "(_)==)   (")

		changeLine(195, "\|                      \|", "\|  Check out some of   \|")
		changeLine(195, "\|   And he likes to    \|", "\|  his projects below  \|")
		changeLine(195, "\|   play ping pong     \|", "\|  to see more of his  \|")
		changeLine(195, "\\                    /", "\\   work in action   /")

		
		
		changeLine(220, "\|  Check out some of   \|", "\|     And play me      \|")
		changeLine(220, "\|  his projects below  \|", "\|     at a game of     \|")
		changeLine(220, "\|  to see more of his  \|", "\|   HTML5 Battleship   \|_____")
		changeLine(220, "\\   work in action   /", "\\     he created.    _/   Φ \\_")
		changeLine(220, "_ =( °w° )=", "  =( °w° )=")
		changeLine(220, "(_)==)   (", "     )   (")
		changeLine(220, ">   /\\_/\\", "> ---------")

		changeLine(250, "\|     And play me      \|", "\|   If you can beat    \|")
		changeLine(250, "\|     at a game of     \|", "\|    me, I'll show     \|")
		changeLine(250, "\|   HTML5 Battleship   \|", "\|    you a special     \|")
		changeLine(250, "\\     he created.    _/", "\\      message!      _/")


		setTimeout ->
			$('#battleship').after("<ul id='opal-project-list' class='list-unstyled'><li><a href='http://www.embrence.com' target='_blank'>Embrence</a></li><li><a href='http://www.triumpic.com' target='_blank'>Triumpic</a></li>")
		, 100 * (width_modifier + 195)

		setTimeout ->
			$('#battleship').after("<a href='/battleship?fine=true' target='_blank' class='opal-battleship-btn btn btn-default'>Play Battleship</a>")
		, 100 * (width_modifier + 220)



	