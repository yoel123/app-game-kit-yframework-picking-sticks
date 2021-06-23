

function create_player(x as float,y as float,s as float)
	
	p as yentity
	p = newyentity(x,y,s,player_img)
	p.ytype = "player"
	
	//config player spritemap
	SetSpriteAnimation ( p.id, 36, 36, 20 ) 
	//newyentity creates an agk sprite its id is saved on id (p.id in this case) 
	
	
	//change sprite frame to third frame
	SetSpriteFrame( p.id, 3)
		
	
endfunction p 


function update_player(e as yentity)
	control_player(e)
	pick_stick(e)
endfunction

function control_player(e as yentity)
   
   eid = e.id
   
   x = GetSpriteX(eid)
   y = GetSpriteY(eid)
   speed = e.speed
   
   key=GetRawKeyState(38) ` Up arrow
   if key=1
		setspritey(eid,y-speed)
		SetSpriteFrame( eid, 1)
   endif

   key=GetRawKeyState(40) ` Down
   if key=1
		setspritey(eid,y+speed)
		SetSpriteFrame( eid, 3)
   endif

   key=GetRawKeyState(37) `Left
   if key=1 
		setspritex(eid,x-speed)
		SetSpriteFrame( eid, 4)
   endif

    key=GetRawKeyState(39) `Right
    if key=1 
		setspritex(eid,x+speed)
		SetSpriteFrame( eid, 2)
    endif
	
endfunction

function pick_stick(e as yentity)
	
	t as yentity
	t =  hit_test(e,"stick")
	if ise(t) //ise = is entity
		random_pos(t)
		inc points
	endif
endfunction
