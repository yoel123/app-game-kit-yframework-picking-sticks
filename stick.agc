

function create_stick()
	s as yentity
	s = newyentity(0,0,0,stick_img)
	s.ytype = "stick"
	
	random_pos(s)

endfunction s


function update_stick(e as yentity)
	
endfunction


function random_pos(e as yentity)
	x = random(1,300)
	y = random(1,300)
	setspritex(e.id,x)
	setspritey(e.id,y)
endfunction

