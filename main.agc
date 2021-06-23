
// Project: picking sticks 
// Created: 2021-05-20

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "picking sticks" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts


#insert "yengine2d.agc"
#insert "player.agc"
#insert "stick.agc"
#insert "game_world.agc"


//load imgs
global stick_img = 1

global player_img = 2


LoadImage(stick_img,"stick.png")
LoadImage(player_img,"stick_picker.png")


//init vars
gamew as yworld
menuw as yworld

//worlds
gamew = newyworld("game")
menuw = newyworld("menu")

//entities
player as yentity
stick as yentity

player = create_player(20,20,5)
stick = create_stick()

yaddw("game",player)
yaddw("game",stick)


changeworld("game")



do
    

    yengineupdate()
    Sync()
loop

function myupdate()
	
	if worlds[current_worldi].name="game"
		game_update()
	endif
	
endfunction	//end myupdate


function update_yentity_custom(e as yentity)
	
	if e.ytype = "player" and e.yactive then update_player(e)
	
	if e.ytype = "stick" and e.yactive then update_stick(e)
	
endfunction //endd update_yentity_custom



