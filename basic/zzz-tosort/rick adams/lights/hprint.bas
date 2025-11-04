
	' Fix HPRINT bug with zero-length strings
	poke &HE010, &H26
	poke &HE011, &H02
	poke &HE012, &H32
	poke &HE013, &H62
	poke &HE014, &H10
	poke &HE015, &H8E
	poke &HE016, &HFE
	poke &HE017, &H19
	poke &HE018, &H39
	poke &HEF68, &HBD
	poke &HEF69, &HE0
	poke &HEF6A, &H10
	poke &HEF6B, &H12

	' Make HPRINT destructive
	poke &HF015, &H21

	' Make HPRINT nondestructive
	'poke $HF015, &HAA


