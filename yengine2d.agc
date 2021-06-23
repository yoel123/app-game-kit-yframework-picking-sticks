
global count = 0

global current_world as yworld
global current_worldi //current world index

/*
its not ideal but to get current world you need:

worlds[current_worldi]

agk dosnt use refrences for vriables every var is its own place in the memory and dosnt point to another var
*/

global ysprite_count = 0
global yimg_count = 0
global ytxt_count = 0

global yimgs as yimg[]

global worlds as yworld[]
global timers as ytimer[]

global ydebug as string
ydebug="debug:"

////////////////////////types/////////////////////////

TYPE yentity
	id as integer
	src as integer
	rindex as integer
	ytype as String
	pos as ypoint
	speed as float
	yactive
	alpha
	rotation as float
	frame
	yints as integer[]
	ystrings as String[]
	yfloats as float[]
ENDTYPE

TYPE ypoint
	x as float
	y as float
	z as float
ENDTYPE

TYPE ytimer
	name as string
	end_time as float
	duration as float
	is_done 
ENDTYPE

TYPE yworld
	name as String
	yentitys as yentity[]
	rindex
ENDTYPE

TYPE yimg
	name as String
	id
ENDTYPE

////////////////////////end types/////////////////////////



/////////////////engine funcs/////////////////////////////////////

function yengineupdate()
	
	update_ytimers()
	yworldupdate()
	myupdate()
	
endfunction  //yengineupdate

/////////////////end engine funcs/////////////////////////////////////

/////////////////////world funcs///////////////////////////////

//GetSpriteExists
//SetSpriteActive
//GetSpriteActive


function newyworld(name as string)
	
	nw as yworld
	nw.name = name
	nw.rindex = worlds.length+1
	worlds.insert(nw)
	
endfunction nw //newyworld

function changeworld(n as string)

	//hide all worlds sprites
	for i = 0 to worlds.length
		//ydebug = ydebug+str(worlds.length)
		for j = 0 to worlds[i].yentitys.length
			SetSpriteVisible(worlds[i].yentitys[j].id,0)
			//ydebug = ydebug+"--"+str(worlds[i].yentitys[j].id) + "--"
		next j		
	next i
	
	//change world
	for i = 0 to worlds.length
		//find name and set current world to this world
		if worlds[i].name = n then  current_worldi = i
	next i

	//show new world sprtes
	for i = 0 to worlds[current_worldi].yentitys.length
		SetSpriteVisible(worlds[current_worldi].yentitys[i].id,1)
		//ydebug = ydebug +"xx"+ str(current_world.yentitys[i].id)+" xx"
	next i
endfunction //changeworld

//add entity to current world
function yadd(e ref as yentity)
	worlds[current_worldi].yentitys.insert(e)
endfunction //yadd

//recycle (if you want to save memory and use an existing entity)
function recycle(wn as string,ne ref as yentity)
	
	e as yentity
	w as  yworld
	wi = current_worldi
	w = worlds[wi]

	for i = 0 to w.yentitys.length
		e = worlds[wi].yentitys[i] //current entity

		
		if e.yactive = 0 and e.ytype = ne.ytype
			ne.rindex = e.rindex //pass worlds entity array the index to new entity
			worlds[wi].yentitys[i] = ne
			exitfunction
		endif
		
	next i
	//cant recycle? just add it
	yaddw(wn,ne)
	
endfunction //recycle

function yrec(wn as string,ne ref as yentity)
	recycle(wn,ne)
endfunction

//entity count returns current worlds entity count
function yentity_c()
	ret = worlds[current_worldi].yentitys.length
endfunction ret

//add entity to a spesific world
function yaddw(w as string,e ref as yentity)
	
	for i = 0 to worlds.length
		//find name and add entity current world to this world
		if worlds[i].name = w 
			e.rindex = worlds[i].yentitys.length+1 // save the yentitys array index
			worlds[i].yentitys.insert(e)
		endif 
	next i
	
endfunction //yaddw

function yremovew(w as string,e ref as yentity)
	
		
	for i = 0 to worlds.length
		//find name and add entity current world to this world
		if worlds[i].name = w and worlds[i].yentitys.length <>  -1 and GetSpriteExists(e.id)
		//	worlds[i].yentitys.remove(e.rindex)
			worlds[i].yentitys[e.rindex].yactive = 0
			DeleteSprite(e.id)
		endif
	next i
	
endfunction //end yremovew 

function yworldupdate()
	//shortcuts (to get data they are not refrences)
	e as yentity
	w as  yworld
	wi = current_worldi
	w = worlds[wi]
	//print("wi"+str(wi))
	//loop all entities in current world
	for i = 0 to w.yentitys.length
		e = worlds[wi].yentitys[i] //current entity
		if GetSpriteExists(e.id) then update_yentity_custom(e)
		//if the entity sprite exists update entity
		if GetSpriteExists(e.id)
			update_yentity(worlds[wi].yentitys[i]) //e dosnt hold refrence	
		endif
	next i

endfunction //yworldupdate



/////////////////////end world funcs///////////////////////////////

////////////////////////entity funcs///////////////////////////////////

function newyentity(x as float,y as float,speed as float,src_id)
	//incrament sprite count
	inc ysprite_count
	//create new entity and populate its atts
	ne as yentity
	ne.pos.x = x
	ne.pos.y = y
	ne.speed = speed
	ne.id = ysprite_count //give it some id
	ne.src = src_id //image id
	ne.ytype = "entity"
	ne.yactive = 1
	//create sprite
	CreateSprite(ne.id,src_id)
	//set start pos
	SetSpritePosition(ne.id,ne.pos.x,ne.pos.y)
	
endfunction ne //newyentity

function update_yentity(e ref as yentity)
//	SetSpritePosition(e.id,e.pos.x,e.pos.y)
	//add rotation and alpha
endfunction yimg_count//update_yentity

function move_by(e ref as yentity,sx as float,sy as float)
		//no refrences so have to use current_world itself
		i = current_worldi
		worlds[i].yentitys[e.rindex].pos.x = worlds[i].yentitys[e.rindex].pos.x +sx
		worlds[i].yentitys[e.rindex].pos.y = worlds[i].yentitys[e.rindex].pos.y +sy
		SetSpritePosition(e.id,e.pos.x+sx,e.pos.y+sy)
		//print(e.pos.x)
endfunction //tst

function move_byp(e ref as yentity,sx as float,sy as float)
		//no refrences so have to use current_world itself
		i = current_worldi
		SetSpritePhysicsVelocity( e.id, sx, sy )
		worlds[i].yentitys[e.rindex].pos.x = getspritex(e.id)
		worlds[i].yentitys[e.rindex].pos.y =  getspritey(e.id)
		
		//print(e.pos.x)
endfunction //tst

function move_to(e as yentity,t as yentity)
	
	x as float
	y as float
	tx as float
	ty as float
	
	x = e.pos.x
	y = e.pos.y
	
	tx = t.pos.x
	ty = t.pos.y
	
	if x > tx then move_by(e,-e.speed,0)
	if x < tx then move_by(e,e.speed,0)
	if y < ty then move_by(e,0,e.speed)
	if y > ty then move_by(e,0,-e.speed)
 
	
endfunction //end move_to

function get_by_type(t as string)
	
	es as yentity[]
	for i = 0 to worlds[current_worldi].yentitys.length
		//if type and active
		if t = worlds[current_worldi].yentitys[i].ytype  and worlds[current_worldi].yentitys[i].yactive=1
			 es.insert(worlds[current_worldi].yentitys[i])
		endif
	next i
endfunction es

function hit_test(e ref as yentity,t as string)
	ret as yentity
	es as yentity[]
	es = get_by_type(t)
	for i = 0 to es.length
		//print(str(e.id)+" "+ str(es[i].id))
		if GetSpriteExists(e.id)
			if GetSpriteCollision( e.id, es[i].id ) =1 then ret = es[i]
		endif
	next i
endfunction ret

function is_clicked(e ref as yentity)
	ret = 0
    if ( GetPointerPressed ( ) = 1 )
        sid = GetSpriteHit ( GetPointerX ( ), GetPointerY ( ) )
        if sid = e.id then ret = 1
    endif
endfunction ret //end is_clicked

function ise(e ref as yentity)
	ret = GetSpriteExists(e.id)
endfunction ret

//change entity intager val
function ei_change(e as yentity,pos,yval)
	i = current_worldi
	worlds[i].yentitys[e.rindex].yints[pos] = worlds[i].yentitys[e.rindex].yints[pos]+yval
endfunction

//set entity int
function ei_set(e as yentity,pos,yval)
	i = current_worldi
	worlds[i].yentitys[e.rindex].yints[pos] = yval
endfunction

//set entity string
function es_set(e as yentity,pos,yval as string)
	i = current_worldi
	worlds[i].yentitys[e.rindex].ystrings[pos] = yval
endfunction

function sx(e ref as yentity,x as float)
	i = current_worldi
	worlds[i].yentitys[e.rindex].pos.x = x
	SetSpritePosition(e.id,x,e.pos.y)
endfunction

function sy(e ref as yentity,y as float)
	i = current_worldi
	worlds[i].yentitys[e.rindex].pos.y = y
	SetSpritePosition(e.id,e.pos.x,y)
endfunction


////////////////////////end entity funcs///////////////////////////////////

/////////////////////////util funcs//////////////////////////

function yaddimg(src)
	inc yimg_count
	//load img
	//(yimg_count,src)
endfunction yimg_count//tst

//timer funcs
function add_ytimer(name as string,secs as float)
	t as ytimer
	t.name = name
	t.end_time = GetSeconds ( )+secs
	t.duration = secs
	t.is_done=0
	timers.insert(t)
endfunction

function update_ytimers()
	
	for i = 0 to timers.length
		if timers[i].end_time < Timer ( ) then timers[i].is_done = 1
	next i
	
	
endfunction

function is_done_ytimer(name as string,yrepeat)
	ret = 0
	for i = 0 to timers.length
		if timers[i].name = name and timers[i].is_done =1
			ret = 1
			if yrepeat
				//reset timer
				timers[i].is_done = 0
				timers[i].end_time = Timer ( )+timers[i].duration
			endif
		endif
	next i
endfunction ret

function edit_timer(name as string,secs as float)
	
		for i = 0 to timers.length
		if timers[i].name = name 
			//reset timer
			timers[i].duration= secs
			timers[i].end_time = Timer ( )+timers[i].duration
		endif
	next i
endfunction
/*
add_ytimer("bla",5)
//in update
    if is_done_ytimer("bla",1) =1 then print("timer done")
print(is_done_ytimer("bla",1))
*/

///////joysticks////

function joystick_angle(jn)
	
	joystickX# = GetVirtualJoystickX (jn )
    joystickY# = GetVirtualJoystickY ( jn )

	angle# = ATan2( joystickY#, joystickX# ) 
endfunction angle#

/////////////////////////end util funcs//////////////////////////

function tst()
	Print("tst")
endfunction //tst
