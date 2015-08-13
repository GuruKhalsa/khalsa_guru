$ ->
	b_canvas = document.getElementById('battleship-canvas')
	context = b_canvas.getContext("2d")
	
	for x in [0.5..300] by 10
		context.moveTo(x, 0)
		context.lineTo(x, 700)

	for y in [0.5..700] by 10
		context.moveTo(0, y)
		context.lineTo(300, y)

	context.strokeStyle = "#eee"
	context.stroke()

	b_canvas.addEventListener("click", battleshipClick, false);

	battleshipClick = (e) ->
		cell = getCursorPosition(e)


	getCursorPosition = (e) ->
		if e.pageX != undefined && e.pageY != undefined
			x = e.pageX;
			y = e.pageY;
		else
			x = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
			y = e.clientY + document.body.scrollTop + document.documentElement.scrollTop;

