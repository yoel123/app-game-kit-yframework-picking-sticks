

//player points
global points = 0
//player rank
global rank as string
rank = "none"

//create text
global points_txt = 1
global rank_txt = 2
CreateText ( points_txt, "points" )
CreateText ( rank_txt, "rank" )
SetTextPosition ( points_txt, 50, 10 )
SetTextPosition ( rank_txt, 250, 10 )
SetTextSize ( points_txt, 30 )
SetTextSize ( rank_txt, 30 )



function game_update()
	update_txt()
endfunction


function update_txt()
	SetTextString(points_txt,"points: "+str(points))
	SetTextString(rank_txt,"rank: "+rank)
	
	if points>10 then rank = "stick picker"
	if points>20 then rank = "pro stick picker"
	if points>30 then rank = "master stick picker"
	if points>40 then rank = "no life"
	
endfunction
