
	dim a(6, 6)

	' Reset machine on BREAK
	pclear 1
	on brk goto 6000

	' Modify HPRINT
	include "hprint.bas"

	' Double speed poke
	poke &hffd9, 0

	' Init graphics
	hscreen 2
	palette 0, 0  	' 0 black
	palette 1, 63	' 1 white
	palette 2, 22	' 2 green
	'palette 3, 54	' 3 yellow
	'palette 4, 7	' 4 grey
	'palette 5, 31	' 5 cyan

	' Clear screen
10	hcls 0

	' Title
	hcolor 5 ' cyan
	hprint (0, 0), "Lights Out Puzzle"
	hprint (27, 0), "by Rick Adams"

	' Seed the random number generator
	r = rnd(-timer)

	' Start game with zero moves
	m = 0

	' Generate puzzle grid
	n = 13
	gosub 1000
	gosub 2000

	'Draw puzzle grid
	gosub 4000

	' Highlight puzzle square
	i = 1
	j = 1
100	gosub 3000

	' Is joystick fire button pushed?
	if button(0) <> 0 then
		sound 1, 1
		gosub 7000
	end if

	' Did player win yet?
	if n > 0 then
		goto 100
	end if

	' Play again?
	gosub 5000
	goto 10

	' Clear puzzle grid
1000	for x = 1 to 5
		for y = 1 to 5
			a(x, y) = 0
		next
	next
	return

	' Generate puzzle grid
2000	for k = 1 to 5
		i = int(5 * rnd(0) + 1)
		j = int(5 * rnd(0) + 1)
		gosub 8000
	next
	return

	' Highlight puzzle square at i, j
3000	t = (t + 1) and 7
	x = 117 + (i - 1) * 16
	y = 53 + (j - 1) * 16
	if t and 4 then
		hline (x, y)-(x + 12, y + 12), preset, b
	else
		hcolor 1 ' white
		hline (x, y)-(x + 12, y + 12), pset, b
		i = int(joystk(0) / 14) + 1
		j = int(joystk(1) / 14) + 1
	end if
	return

	' Draw puzzle grid
4000	n = 0
	for j0 = 1 to 5
		y = 53 + (j0 - 1) * 16
		for i0 = 1 to 5
			x = 117 + (i0 - 1) * 16

			' Outline
			c = hpoint(x, y)
			if c <> 1 then
				hcolor 1 ' white
				hline (x, y)-(x + 12, y + 12), pset, b
			end if

			' Is light on or off?
			c = hpoint(x + 1, y + 1)
			if a(i0, j0) < 0 and c <> 2 then

				' Turn light on
				hcolor 2 ' green
				hline (x + 1, y + 1)-(x + 11, y + 11), pset, bf

			end if
			if a(i0, j0) = 0 and c <> 0 then

				' Turn light off
				hline (x + 1, y + 1)-(x + 11, y + 11), preset, bf

			end if

			' Count lights
			if a(i0, j0) < 0 then
				n = n + 1
			end if

		next
	next

	' CUrrent game status
	hcolor 1 ' white
	hprint (0, 3), str$(n) + " lights," + str$(m) + " moves. (0 lights to win!)    "
	m = m + 1

	return

	' Play again?
5000	hcolor 1 ' white
	hprint (16, 20), "You win!"
	hcolor 5 ' cyan
	hprint (6, 24), "Press any key to play again"
	exec &hadfb ' Block until key is pressed
	c$ = inkey$
	return

	' Reset the machine
6000	poke &h71, 0
	exec &h8c1b

	' Make a move
7000	gosub 8000

	' Update entire board
	gosub 4000

	return

	' Toggle lights centered on i, j
8000	a(i, j) = not a(i, j)
	a(i - 1, j) = not a(i - 1, j)
	a(i + 1, j) = not a(i + 1, j)
	a(i, j - 1) = not a(i, j - 1)
	a(i, j + 1) = not a(i, j + 1)
	return
