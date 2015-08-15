# Document.ready? do
#   Element.find('.home-post a').html = '<h1>Hi there!</h1>'
# end


Document.ready? do
	require 'ostruct'

	Element.class_eval do
		def prepend(child_element_type, message)
			parent_id = self.id
			if Element.find("\##{parent_id}").children.length < 1
				Element.find("\##{parent_id}").append("<#{child_element_type}>#{message}</#{child_element_type}>")
			else
				parent = `document.getElementById(#{parent_id})`
				child = `document.createElement(#{child_element_type})`
				`#{child}.appendChild(document.createTextNode(#{message}))`
				`#{parent}.insertBefore(#{child}, #{parent}.firstChild)`
			end
		end
	end

	class BattleshipLog
		attr_accessor :log

		def initialize(log_selector)
			@log = Element.find(log_selector)
		end
	end

	class GameBoard
	  attr_reader :height, :width, :canvas, :context, :max_x, :max_y
	  attr_accessor :board, :previous_guesses, :ships
	 
	  CELL_HEIGHT = 35
	  CELL_WIDTH  = 40
	 
	  def initialize
	    @height  = 350                  
	    @width   = 400	 		
	    @max_x   = (height / CELL_HEIGHT).floor           
	    @max_y   = (width / CELL_WIDTH).floor
	    @letter_lookup = {'A' => 0, 'B' => 1, 'C' => 2, 'D' => 3, 'E' => 4, 'F' => 5, 'G' => 6, 'H' => 7, 'I' => 8, 'J' => 9}
	    @previous_guesses = []
			@ships = []
			@board = [[' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],[' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],[' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],[' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],[' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],[' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],[' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],[' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],[' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],[' ',' ',' ',' ',' ',' ',' ',' ',' ',' ']]
	  end

	  def set_cardinal_variables(cardinal_direction)
			direction_operator = cardinal_direction =~ /^[SE]$/ ? :+ : :-
			boundary_comparison = cardinal_direction =~ /^[SE]$/ ? :> : :<
			boundary_limit = cardinal_direction =~ /^[SE]$/ ? 9 : 0
			axis = cardinal_direction =~ /^[NS]$/ ? origin_row : origin_column
		end

		def placement_valid?(ship, origin, cardinal_direction)
			cardinal_direction = cardinal_direction.upcase
			origin = origin.upcase

			return false if !cardinal_direction.match(/^[NSEW]$/) || !origin.match(/^[A-J][0-9]$/)
			
			origin_row = @letter_lookup[origin[0]] 
			origin_column = origin[1].to_i
			direction_operator = cardinal_direction =~ /^[SE]$/ ? :+ : :-
			# comparison = cardinal_direction =~ /^[SE]$/ ? :> : :<
			# axis = cardinal_direction =~ /^[NS]$/ ? origin_row : origin_column
			placement_values = []
			ship_length = ship.length - 1
			
			# return false if axis.method(direction_operator).ship_length

			case cardinal_direction
			when 'N'
				return false if origin_row - ship_length < 0
			when 'S'
				return false if origin_row + ship_length > 9
			when 'E'
				return false if origin_column + ship_length > 9
			when 'W'
				return false if origin_column - ship_length < 0
			else
				return false
			end		

			ship.length.times do |distance|
				if cardinal_direction.match(/^[NS]$/)
					placement_values << @board[origin_row.method(direction_operator).(distance)][origin_column]
				else
					placement_values << @board[origin_row][origin_column.method(direction_operator).(distance)]
				end
			end

			placement_values.include?('@') ? false : true
		end

		def create_canvas
			el = Element.new(:canvas)
			el.id = canvas_id
			`#{el}.prependTo( "#battleship-map-container" )`
			@canvas = `document.getElementById(#{canvas_id})`
			`#{canvas}.className = 'battleship-canvas'`
			@context = `#{canvas}.getContext('2d')`
		end
	 
	  def draw_canvas
	    `#{canvas}.width  = #{width}`
	    `#{canvas}.height = #{height}`
	 
	    x = 0.5
	    until x >= width do
	      `#{context}.moveTo(#{x}, 0)`
	      `#{context}.lineTo(#{x}, #{height})`
	      x += CELL_WIDTH
	    end
	 
	    y = 0.5
	    until y >= height do
	      `#{context}.moveTo(0, #{y})`
	      `#{context}.lineTo(#{width}, #{y})`
	      y += CELL_HEIGHT
	    end
	 
	    `#{context}.strokeStyle = "black"`
	    `#{context}.stroke()`
	  end
	 
	  def canvas_id
	    'battleship-canvas'
	  end

	  def get_cursor_position(event)
	    puts event.page_x
	    puts event.page_y
	    p event
	    `console.log(#{event})`
	    if (event.page_x && event.page_y)
	      x = event.page_x;
	      y = event.page_y;
	    else
	      doc = Opal.Document[0]
	      x = e[:clientX] + doc.scrollLeft + doc.documentElement.scrollLeft;
	      y = e[:clientY] + doc.body.scrollTop + doc.documentElement.scrollTop;
	    end
	 		
	 		ruby_canvas = Element.find("##{canvas_id}")
	 		

	    # p x -= ruby_canvas.css('margin-left').to_i
	    # p y -= ruby_canvas.css('margin-top').to_i
	    x -= `#{canvas}.offsetLeft`
    	y -= `#{canvas}.offsetTop`
	 
	    x = (x / CELL_WIDTH).floor
	    y = (y / CELL_HEIGHT).floor
	 
	    Coordinates.new(x: x, y: y)
	  end

	  def fill_cell(x, y, color)
		  x *= CELL_WIDTH;
		  y *= CELL_HEIGHT;
		  `#{context}.fillStyle = #{color}`
		  `#{context}.fillRect(#{x.floor+1}, #{y.floor+1}, #{CELL_WIDTH-1}, #{CELL_HEIGHT-1})`
		end
		 
		def unfill_cell(x, y)
		  x *= CELL_WIDTH;
		  y *= CELL_HEIGHT;
		  `#{context}.clearRect(#{x.floor+1}, #{y.floor+1}, #{CELL_WIDTH-1}, #{CELL_HEIGHT-1})`
		end

		def add_mouse_event_listener
			# .prop('onclick',null).off('click');
		  Element.find("##{canvas_id}").on :click do |event|
		    coords = get_cursor_position(event)
		    x, y   = coords.x, coords.y
		    fill_cell(x, y, '#000')
		  end
		 
		  Element.find("##{canvas_id}").on :dblclick do |event|
		    coords = get_cursor_position(event)
		    x, y   = coords.x, coords.y
		    unfill_cell(x, y)
		  end
		end
	 
	end

	class Coordinates < OpenStruct; end

	class Ship
		def initialize(name, length)
			@coordinates = []
			@name = name
			@length = length
			@hits = 0
			@sunk = false
		end
		
		attr_accessor :name, :length, :coordinates, :hits, :sunk
	end

	class PlayerBoard < GameBoard
		def initialize
			super
		end

		def canvas_id
	    'player-battleship-canvas'
	  end

		# def place_ship(ship)
		# 	valid_placement = false
		# 	until valid_placement
		# 		puts "Please enter the coordinates (ex. E9) where you'd like to place your #{ship.name} (length: #{ship.length})"
		# 		origin = gets.chomp.upcase

		# 		puts "Which direction would you like your #{ship.name} (length: #{ship.length}) to face (N,S,E,W)?"
		# 		cardinal_direction = gets.chomp.upcase

		# 		origin_row = @letter_lookup[origin[0]].to_i
		# 		origin_column = origin[1].to_i
				
		# 		if placement_valid?(ship, origin, cardinal_direction)
		# 			valid_placement = true
		# 		else
		# 			puts 'Invalid placement, please select a new location'
		# 		end
		# 	end
		# 	direction = cardinal_direction.match(/^[SE]$/) ? '+' : '-'
		# 	ship.length.times do |distance|
		# 		if cardinal_direction.match(/^[NS]$/)
		# 			row = origin_row.method(direction).(distance)
		# 			col = origin_column
		# 			@board[row][col] = '@'
		# 			ship.coordinates << [row, col]
		# 		else
		# 			row = origin_row
		# 			col = origin_column.method(direction).(distance)
		# 			@board[row][col] = '@'	
		# 			ship.coordinates << [row, col]
		# 		end
		# 	end
		# end

		# def place_ships
		# 	ships = [['destroyer', 2],['submarine', 3],['frigate', 3],['battleship', 4],['aircraft_carrier', 5]]
		# 	ships.each do |ship|
		# 		@ships += Ship.new(ship[0], ship[1])
		# 	end

		# 	@ships.each do |ship|
		# 		display
		# 		place_ship
		# 	end

		# 	display
		# end

		def place_ship(ship)
			valid_placement = false
			until valid_placement
				origin = "#{@letter_lookup.key(rand(0..9))}#{rand(0..9)}"
				cardinal_directions = ['N','S','E','W']
				cardinal_direction = cardinal_directions[rand(0..3)]

				origin_row = @letter_lookup[origin[0]].to_i
				origin_column = origin[1].to_i
				
				if placement_valid?(ship, origin, cardinal_direction)
					valid_placement = true
				end
			end
			direction = cardinal_direction.match(/^[SE]$/) ? '+' : '-'
			ship.length.times do |distance|
				if cardinal_direction.match(/^[NS]$/)
					@board[origin_row.method(direction).(distance)][origin_column] = '@'
					fill_cell(origin_column, (origin_row.method(direction).(distance)), '#636363')
					ship.coordinates << [origin_row.method(direction).(distance), origin_column]
				else
					@board[origin_row][origin_column.method(direction).(distance)] = '@'
					fill_cell((origin_column.method(direction).(distance)), origin_row, '#636363')
					ship.coordinates << [origin_row, origin_column.method(direction).(distance)]
				end
			end
		end

		def place_ships(log)
			destroyer = Ship.new('destroyer', 2)
			submarine = Ship.new('submarine', 3)
			frigate = Ship.new('frigate', 3)
			battleship = Ship.new('battleship', 4)
			aircraft_carrier = Ship.new('aircraft carrier', 5)
			@ships += [destroyer, submarine, frigate, battleship, aircraft_carrier]

			# gameboard.display
			place_ship(aircraft_carrier)
			# gameboard.display
			place_ship(battleship)
			# gameboard.display
			place_ship(frigate)
			# gameboard.display
			place_ship(submarine)
			# gameboard.display
			place_ship(destroyer)
			# gameboard.display
			# Element.find('#battleship-log').append('<h3>User placement complete</h3>')

			# puts battleship_log = `document.getElementById('battleship-log')`
			# puts log_entry = `document.createElement("h3")`
			# puts `#{log_entry}.appendChild(document.createTextNode("Testing 1 2"))`
			# `#{battleship_log}.insertBefore(#{log_entry}, #{battleship_log}.firstChild)`
			
			# def prepend(parent_id, child_element_type, message)
			# 	if Element.find("\##{parent_id}").children.length < 1
			# 		Element.find("\##{parent_id}").append("<#{child_element_type}>#{message}</#{child_element_type}>")
			# 	else
			# 		parent = `document.getElementById(#{parent_id})`
			# 		child = `document.createElement(#{child_element_type})`
			# 		`#{child}.appendChild(document.createTextNode(#{message}))`
			# 		`#{parent}.insertBefore(#{child}, #{parent}.firstChild)`
			# 	end
			# end

			log.prepend('h4', 'Your ships have been placed automatically')
			

			

		end


		def consecutive_hits(row_index, col_index, cardinal_direction, count=0)
			count_impact = {0 => 0, 1 => 3, 2 => 4, 3 => 2, 4 => -1}
			begin
				if @board[row_index][col_index] != 'X'
					return 0
				else
					case cardinal_direction
					when 'N'
						return 1 + consecutive_hits(row_index - 1, col_index, 'N', count)
					when 'S'
						return 1 + consecutive_hits(row_index + 1, col_index, 'S', count)
					when 'E'
						return 1 + consecutive_hits(row_index, col_index + 1, 'E', count)
					when 'W'
						return 1 + consecutive_hits(row_index, col_index - 1, 'W', count)
					else
					end
				end
			rescue NoMethodError
				return 0
			end
		end

		def attacked(gameboard, computer, computer_display, log)
			valid_guess = false
			until valid_guess
				if !gameboard.board.flatten.include?('X')
					coordinates = "#{@letter_lookup.key(rand(0..9))}#{rand(0..9)}"
					if !coordinates.match(/^[A-J][0-9]$/)
						next
					end
					row_index = @letter_lookup[coordinates[0..0]].to_i
					col_index = coordinates[1..1].to_i

					# if @previous_guesses.include?(coordinates)
					# 	puts 'Already Guessed, try again.'
					# 	next
					if @board[row_index][col_index] == '@'
						@board[row_index][col_index] = 'X'
						gameboard.board[row_index][col_index] = 'X'
						fill_cell(col_index, row_index, '#df7020')
						@ships.each do |ship|
							if ship.coordinates.include?([row_index, col_index])
								ship.hits += 1
							end
							if ship.hits == ship.length
								log.prepend('h4', "Your #{ship.name} was sunk")
								ship.sunk = true
								ship.coordinates.each do |coords|
									@board[coords[0]][coords[1]] = 'x'
									gameboard.board[coords[0]][coords[1]] = 'x'
									fill_cell(coords[1], coords[0], 'red')
								end
								if @ships.all?{|ship| ship.sunk}
									Element.find('#battleship-log').hide
									Element.find('#battleship-map-container').hide
									container = Element.find('#battleship-container')
									lose_header = Element.new(:h1)
									lose_header.class_name = 'battleship-complete-header'
									lose_header.text = "You Lose"
									lose_header.append_to(container)
									# Element.find('#battleship-container').after('<h1>You Lose</h1>')
									Element.find('.try-again-link').show
								end
							end
						end
						@ships.reject!{|ship| ship.sunk }
						@previous_guesses << [coordinates, true]
						valid_guess = true
					elsif @board[row_index][col_index] == ' '
						@board[row_index][col_index] = '~'
						gameboard.board[row_index][col_index] = '~'
						fill_cell(col_index, row_index, '#20dfdd')
						@previous_guesses << [coordinates, false]
						valid_guess = true
					end
				else
					direction_lookup = ['N','S','E','W']
					direction = direction_lookup[rand(0..3)]
					
					# Consider possible directions with a key of coordinates in an array and the value the same.  ex.  {[3,5] => 1}
					possible_guesses = {}

					gameboard.board.each_with_index do |row, row_index|
						break if valid_guess
						row.each_with_index do |val, col_index|
							break if valid_guess
							if val == 'X'
								possible_directions = {}
								if row_index < 9 && gameboard.board[row_index + 1][col_index] == ' '
									possible_directions['S'] = 1
								end
								if row_index > 0 && gameboard.board[row_index - 1][col_index] == ' '
									possible_directions['N'] = 1
								end
								if col_index < 9 && gameboard.board[row_index][col_index + 1] == ' '
									possible_directions['E'] = 1
								end
								if col_index > 0 && gameboard.board[row_index][col_index - 1] == ' '
									possible_directions['W'] = 1
								end							

								# I may be able to combine the section above and below putting all of the logic in the consecutive hits function.
								# I need to write the logic that will determine how each hit length will effect the ranking of the possible directions
								weighted_directions = possible_directions.each_with_object({}) do |(key, value), h|
									if key == 'N'
										h[key] = value + consecutive_hits(row_index + 1, col_index, 'S')
									elsif key == 'S'
										h[key] = value + consecutive_hits(row_index - 1, col_index, 'N')
									elsif key == 'E'
										h[key] = value + consecutive_hits(row_index, col_index - 1, 'W')
									elsif key == 'W'
										h[key] = value + consecutive_hits(row_index, col_index + 1, 'E')
									end
								end
								#next if 'N' and 'S' || 'E' and 'W' == 'X'
								#measure the length of the partial ship 
								next if !possible_directions || possible_directions.empty?

								possible_guesses[[row_index, col_index]] = weighted_directions

							end
						end
					end

					best_guess = {}
					max_rank = 0
					possible_guesses.each do |guess, directions|
						top_rank = directions.values.max
						top_direction = directions.select{|k,v| v == top_rank}.keys.sample
						if top_rank == max_rank
							switch_guess = [true,false].sample
						end
						if top_rank > max_rank || switch_guess
							best_guess = {guess => top_direction}
							max_rank = top_rank
						end

						# {[1, 8]=>{"S"=>1, "N"=>1, "E"=>1, "W"=>1}, [2, 8]=>{"S"=>1, "N"=>5, "E"=>1, "W"=>1}}
					end
					p possible_guesses
					p best_guess
					
					row_index = best_guess.keys.first[0]
					col_index = best_guess.keys.first[1]
					case best_guess.values.first
					when 'N'
						if @board[row_index - 1][col_index] == '@'
							@board[row_index - 1][col_index] = 'X'
							gameboard.board[row_index - 1][col_index] = 'X'
							fill_cell(col_index, row_index - 1, '#df7020')
							@ships.each do |ship|
								if ship.coordinates.include?([row_index - 1, col_index])
									ship.hits += 1
								end
								if ship.hits == ship.length
									log.prepend('h4', "Your #{ship.name} was sunk")
									ship.sunk = true
									ship.coordinates.each do |coords|
										@board[coords[0]][coords[1]] = 'x'
										gameboard.board[coords[0]][coords[1]] = 'x'
										fill_cell(coords[1], coords[0], 'red')
									end
									if @ships.all?{|ship| ship.sunk}
										Element.find('#battleship-log').hide
										Element.find('#battleship-map-container').hide
										container = Element.find('#battleship-container')
										lose_header = Element.new(:h1)
										lose_header.class_name = 'battleship-complete-header'
										lose_header.text = "You Lose"
										lose_header.append_to(container)
										Element.find('.try-again-link').show
									end
								end
							end
							@ships.reject!{|ship| ship.sunk }
						else
							@board[row_index - 1][col_index] = '~'
							gameboard.board[row_index - 1][col_index] = '~'
							fill_cell(col_index, row_index - 1, '#20dfdd')
						end
						@previous_guesses << ["#{@letter_lookup.key(row_index-1)}#{col_index}", true]
						valid_guess = true
						next
					when 'S'
						if @board[row_index + 1][col_index] == '@'
							@board[row_index + 1][col_index] = 'X'
							gameboard.board[row_index + 1][col_index] = 'X'
							fill_cell(col_index, row_index + 1, '#df7020')
							@ships.each do |ship|
								if ship.coordinates.include?([row_index + 1, col_index])
									ship.hits += 1
								end
								if ship.hits == ship.length
									log.prepend('h4', "Your #{ship.name} was sunk")
									ship.sunk = true
									ship.coordinates.each do |coords|
										@board[coords[0]][coords[1]] = 'x'
										gameboard.board[coords[0]][coords[1]] = 'x'
										fill_cell(coords[1], coords[0], 'red')
									end
									if @ships.all?{|ship| ship.sunk}
										Element.find('#battleship-log').hide
										Element.find('#battleship-map-container').hide
										container = Element.find('#battleship-container')
										lose_header = Element.new(:h1)
										lose_header.class_name = 'battleship-complete-header'
										lose_header.text = "You Lose"
										lose_header.append_to(container)
										Element.find('.try-again-link').show
									end
								end
							end
							@ships.reject!{|ship| ship.sunk }
						else
							@board[row_index + 1][col_index] = '~'
							gameboard.board[row_index + 1][col_index] = '~'
							fill_cell(col_index, row_index + 1, '#20dfdd')
						end
						@previous_guesses << ["#{@letter_lookup.key(row_index-1)}#{col_index}", true]
						valid_guess = true
						next
					when 'E'
						if @board[row_index][col_index + 1] == '@'
							@board[row_index][col_index + 1] = 'X'
							gameboard.board[row_index][col_index + 1] = 'X'
							fill_cell(col_index + 1, row_index, '#df7020')
							@ships.each do |ship|
								if ship.coordinates.include?([row_index, col_index + 1])
									ship.hits += 1
								end
								if ship.hits == ship.length
									log.prepend('h4', "Your #{ship.name} was sunk")
									ship.sunk = true
									ship.coordinates.each do |coords|
										@board[coords[0]][coords[1]] = 'x'
										gameboard.board[coords[0]][coords[1]] = 'x'
										fill_cell(coords[1], coords[0], 'red')
									end
									if @ships.all?{|ship| ship.sunk}
										Element.find('#battleship-log').hide
										Element.find('#battleship-map-container').hide
										container = Element.find('#battleship-container')
										lose_header = Element.new(:h1)
										lose_header.class_name = 'battleship-complete-header'
										lose_header.text = "You Lose"
										lose_header.append_to(container)
										Element.find('.try-again-link').show
									end
								end
							end
							@ships.reject!{|ship| ship.sunk }
						else
							@board[row_index][col_index + 1] = '~'
							gameboard.board[row_index][col_index + 1] = '~'
							fill_cell(col_index + 1, row_index, '#20dfdd')
						end
						@previous_guesses << ["#{@letter_lookup.key(row_index)}#{col_index+1}", true]
						valid_guess = true
						next
					when 'W'
						if @board[row_index][col_index - 1] == '@'
							@board[row_index ][col_index - 1] = 'X'
							gameboard.board[row_index][col_index - 1] = 'X'
							fill_cell(col_index - 1, row_index, '#df7020')
							@ships.each do |ship|
								if ship.coordinates.include?([row_index, col_index - 1])
									ship.hits += 1
								end
								if ship.hits == ship.length
									log.prepend('h4', "Your #{ship.name} was sunk")
									ship.sunk = true
									ship.coordinates.each do |coords|
										@board[coords[0]][coords[1]] = 'x'
										gameboard.board[coords[0]][coords[1]] = 'x'
										fill_cell(coords[1], coords[0], 'red')
									end
									if @ships.all?{|ship| ship.sunk}
										Element.find('#battleship-log').hide
										Element.find('#battleship-map-container').hide
										container = Element.find('#battleship-container')
										lose_header = Element.new(:h1)
										lose_header.class_name = 'battleship-complete-header'
										lose_header.text = "You Lose"
										lose_header.append_to(container)
										Element.find('.try-again-link').show
									end
								end
							end
							@ships.reject!{|ship| ship.sunk }
						else
							@board[row_index][col_index - 1] = '~'
							gameboard.board[row_index][col_index - 1] = '~'
							fill_cell(col_index - 1, row_index, '#20dfdd')
						end
						@previous_guesses << ["#{@letter_lookup.key(row_index)}#{col_index-1}", true]
						valid_guess = true
						next
					else
					end
				end
			end
			computer.attacked(computer_display, self, gameboard, log)
		end
	end

	class ComputerBoard < GameBoard
		def initialize
			super
		end

		def canvas_id
	    'computer-battleship-canvas'
	  end

		def place_ship(ship)
			valid_placement = false
			until valid_placement
				origin = "#{@letter_lookup.key(rand(0..9))}#{rand(0..9)}"
				cardinal_directions = ['N','S','E','W']
				cardinal_direction = cardinal_directions[rand(0..3)]

				origin_row = @letter_lookup[origin[0]].to_i
				origin_column = origin[1].to_i
				
				if placement_valid?(ship, origin, cardinal_direction)
					valid_placement = true
				end
			end
			direction = cardinal_direction.match(/^[SE]$/) ? '+' : '-'
			ship.length.times do |distance|
				if cardinal_direction.match(/^[NS]$/)
					@board[origin_row.method(direction).(distance)][origin_column] = '@'
					ship.coordinates << [origin_row.method(direction).(distance), origin_column]
				else
					@board[origin_row][origin_column.method(direction).(distance)] = '@'
					ship.coordinates << [origin_row, origin_column.method(direction).(distance)]
				end
			end
		end

		def place_ships(log)
			destroyer = Ship.new('destroyer', 2)
			submarine = Ship.new('submarine', 3)
			frigate = Ship.new('frigate', 3)
			battleship = Ship.new('battleship', 4)
			aircraft_carrier = Ship.new('aircraft carrier', 5)
			@ships += [destroyer, submarine, frigate, battleship, aircraft_carrier]

			# gameboard.display
			place_ship(aircraft_carrier)
			# gameboard.display
			place_ship(battleship)
			# gameboard.display
			place_ship(frigate)
			# gameboard.display
			place_ship(submarine)
			# gameboard.display
			place_ship(destroyer)
			# gameboard.display
			log.prepend('h4', 'Opponent placement complete')
		end

		def attacked(gameboard, player, player_display, log)
			coordinates_valid = false
			# until coordinates_valid
			Element.find("##{canvas_id}").on :click do |event|
				Element.find("##{canvas_id}").prop('onclick',nil).off('click')
		    coordinates = gameboard.get_cursor_position(event)
		    row_index, col_index   = coordinates.x, coordinates.y

				if @board[row_index][col_index] == '@'
					@board[row_index][col_index] = 'X'
					gameboard.board[row_index][col_index] = 'X'
					gameboard.fill_cell(row_index, col_index, '#df7020')
					@ships.each do |ship|
						if ship.coordinates.include?([row_index, col_index])
							ship.hits += 1
						end
						if ship.hits == ship.length
							log.prepend('h4', "Opponent's #{ship.name} was sunk")
							ship.sunk = true
							ship.coordinates.each do |coords|
								@board[coords[0]][coords[1]] = 'X'
								gameboard.board[coords[0]][coords[1]] = 'X'
								gameboard.fill_cell(coords[0], coords[1], 'red')
							end
							
							if @ships.all?{|ship| ship.sunk}
								Element.find('#battleship-log').hide
								Element.find('#battleship-map-container').hide
								container = Element.find('#battleship-container')
								win_header = Element.new(:h1)
								win_header.class_name = 'battleship-complete-header'
								win_header.text = "You Win"
								win_header.append_to(container)
								if `window.location.search.replace("?", "")`.include?('opal')
									opal_header = Element.new(:p)
									opal_header.text = 'Thank you so much for considering me for the Junior Front-end Engineer position at Opal!  Please give me a call (503-997-0227) or send me an email (gk@khalsa.guru) so I can demonstrate the creativity and work ethic I can bring to Opal.  Thank you again for your time and consideration'
									opal_header.class_name = 'battleship-opal-header'
									opal_header.append_to(container)
								end
								# Element.find('#battleship-container').after('<h1>You Lose</h1>')
								Element.find('.try-again-link').show
							end
							log.prepend('h4', "You Win!") if @ships.all?{|ship| ship.sunk}
						end
					end
					@ships.reject!{|ship| ship.sunk}

					@previous_guesses << [coordinates, true]
					coordinates_valid = true

				elsif @board[row_index][col_index] == ' '
					@board[row_index][col_index] = '~'
					gameboard.board[row_index][col_index] = '~'
					gameboard.fill_cell(row_index, col_index, '#20dfdd')
					@previous_guesses << [coordinates, false]
					coordinates_valid = true
				else
					# log.prepend('h4', "Already guessed.")
				end
				player.attacked(player_display, self, gameboard, log)
			end
			# end
		end
	end

 
	log = BattleshipLog.new('#battleship-log').log

	# grid.fill_cell(9,5)
	# grid.add_mouse_event_listener

	player = PlayerBoard.new
	player.create_canvas
	player.draw_canvas
	player.place_ships(log)

	player_display = GameBoard.new

	computer_display = ComputerBoard.new
	computer_display.create_canvas
	computer_display.draw_canvas

	computer = ComputerBoard.new
	computer.place_ships(log)
	

	# until computer.ships.empty? || player.ships.empty?
		computer.attacked(computer_display, player, player_display, log)
		# computer_display.display
		# if computer.ships.empty?
		# 	p 'You win!'
		# 	break
		# end
		# player.attacked(player_display)
		# player.display
		# if player.ships.empty?
		# 	p 'You lose!'
		# 	break
		# end
	# end


end