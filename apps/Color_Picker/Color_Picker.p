/*
Color_Picker.p

Color Picker
By: Kenneth Brandon July 2013

This script should allow someone to add or remove 
more Red, Green, and Blue to choose a color.  
Color RGB value printed to console

Tapping on Red side will add or remove red.  
Tapping on Blue side will add or remove Blue
Tapping on Green side will add or remove green.

You can also change the speed at whcih you add or remove to each color by tapping on side 3.

It will add when the side is facing up and remove when facing down.

Change Modes by tapping on sides 4 or 5 repeadly 5 times

Wrap  Mode  (Default Mode)
           [-][+][-]       				   [4]
           [-][+][-]    				[0][2][1][3]
           [-][-][-]       				   [5]
[r][r][r]  [b][b][b]  [g][g][g]  [-][+][-]
[r][R][r]  [b][B][b]  [g][G][g]  [-][+][-]
[r][r][r]  [b][b][b]  [g][g][g]  [-][+][-]
           [-][-][-]
           [-][+][-]   ("-" are off, "+" is the resulting RGB color, 
           [-][+][-]   capital letters are the current value of R G or B.
	
Cube  Mode
           [g][g][g]       				   [4]
           [g][G][g]    				[0][2][1][3]
           [g][g][g]       				   [5]
[r][r][r]  [b][b][b]  [-][-][-]  [-][-][-]
[r][R][r]  [b][B][b]  [-][+][+]  [+][+][-]
[r][r][r]  [b][b][b]  [-][+][+]  [+][+][-]
           [-][-][-]
           [-][+][+]   ("-" are off, "+" is the resulting RGB color, 
           [-][+][+]   capital letters are the current value of R G or B.	
		 	   
*/

#include <futurocube>

#define ANIMATION_DELAY 25


new motion  //motion
new kick_side //which side that is being kicked
new sideUpOrDown // The direction of the side being kicked
new bumpSpeed =  64
new ColorRGB[3]
new Mode[1] // Mode 0 is Wrap Mode, 1 is Cube Mode
new counterModeChange =0 // Used To change modes
new tempCanvas[54]  //Used for saving state during Animation

new icon[]=[ICON_MAGIC1,ICON_MAGIC2,1,1,0xFF000000,0x77000000,0x33000000,0x00FF0000,0x00770000,0x00330000,0x0000FF00,0x00007700,0x00003300,''ballhit'',''hitrims1''] //icon,icon,menu,side,9cells,name,info

new ColorPicker_Color_var[]=[VAR_MAGIC1,VAR_MAGIC2,''CP_Colors'']
new ColorPicker_Mode_var[]=[VAR_MAGIC1,VAR_MAGIC2,''CP_Mode'']

main()
{
	ICON(icon)
	RegisterVariable(ColorPicker_Color_var)
	RegisterVariable(ColorPicker_Mode_var)
	SetIntensity(256)
	
	if (!LoadVariable(''CP_Colors'',ColorRGB) || IsGameResetRequest())
	{
		ColorRGB[0]=0  //I can't figure out syntax here... I'd like:   ColorRGB ={0,0,0}
		ColorRGB[1]=0
		ColorRGB[2]=0
		printf("Could Not Load Colors from last use... Starting with RGB: 0,0,0\r\n");
	}
	else printf("Loaded Colors from last use...\r\n");
	if(!LoadVariable(''CP_Mode'', Mode) || IsGameResetRequest())
	{
		Mode[0] = 0;
		printf("Could Not Load Mode from last use starting with Mode:0 (Wrap Mode)\r\n")
	}
	else printf("Loaded Mode: %d\r\n", Mode)
	
	DrawMode(Mode[0])
	
	new R = ColorRGB[0]
	new G = ColorRGB[1]
	new B = ColorRGB[2]
	
	DrawMyColor(R,G,B) //Draw Current Color
	
	RegAllSideTaps()
		
	for(;;)  //Main Loop!!!!
	{
		Sleep()
		motion = Motion()
		
		if(motion)
		{
			//printf("Motion! Shake: %d,  TapOkay?:%d", GetShake(), eTapSideOK()) //For Debuging
			/*if(GetShake()>90)  //Caused Bad Error... :(
			{
				ChangeMode()
			}*/
			kick_side=eTapSide();
			sideUpOrDown=IsUporDown(kick_side);
			if(kick_side == 0)
			{
				if(sideUpOrDown) R = AddColor(R)	
				else R = RemoveColor(R)
				DrawMyColor(R,G,B)
				counterModeChange =0
			}
			if((Mode[0]==0 && kick_side == 1) || (Mode[0] == 1 && kick_side==4))
			{
				if(sideUpOrDown) G = AddColor(G)	
				else G = RemoveColor(G)	
				DrawMyColor(R,G,B)	
				counterModeChange =0	
			}
			if(kick_side == 2)
			{
				if(sideUpOrDown) B = AddColor(B)	
				else B = RemoveColor(B)	
				DrawMyColor(R,G,B)	
				counterModeChange =0	
			}
			if((Mode[0] == 0 && (kick_side==4||kick_side==5))|| (Mode[0]==1 &&(kick_side==1||kick_side==5)))
			{
				counterModeChange++
				Vibrate(200)
				printf("Counter at: %d\r\n", counterModeChange)
			}
			if(kick_side==3)
			{
				counterModeChange =0
				if(sideUpOrDown) {
					if(bumpSpeed<64){
						bumpSpeed=bumpSpeed*2 
						Vibrate(bumpSpeed*10)
						Play("kap")
						DrawSpeedUpAnimation()
					}
				}
				else {
					if(bumpSpeed!=4){
						bumpSpeed = bumpSpeed/2
						Vibrate(bumpSpeed*10)
						Play("soko_back")
						DrawSlowDownAnimation()
					}
				}
				printf("BumpSpeed changed to %d.\r\n", bumpSpeed)
			}
			if(counterModeChange>4) 
			{
				printf("Mode Change!!\r\n")
				ChangeMode()
				counterModeChange =0
			}
			
			AckMotion() 
		}
	}
}
DrawSpeedUpAnimation()
{
	CanvasToArray(tempCanvas)  //Should Save current canvas in tempCanvas Array

	SetColor(0x00000000)  //Black
	DrawCross(_w(3,4),1)
	PrintCanvas()
	
	Delay(ANIMATION_DELAY)
	
	SetColor(0x40404000)  //Dim White
	DrawCross(_w(3,4),1)
	PrintCanvas()
	
	Delay(ANIMATION_DELAY)
	
	SetColor(0x80808000)  //brighter white
	DrawCross(_w(3,4),1)
	PrintCanvas()
	
	Delay(ANIMATION_DELAY)
	
	SetColor(0xFFFFFF00)  // white
	DrawCross(_w(3,4),1)
	PrintCanvas()
	
	Delay(ANIMATION_DELAY)	
	
	SetColor(0x80808000)  //brighter white
	DrawCross(_w(3,4),1)
	PrintCanvas()
	
	Delay(ANIMATION_DELAY)
	
	SetColor(0x40404000)  //Dim White
	DrawCross(_w(3,4),1)
	PrintCanvas()
	
	Delay(ANIMATION_DELAY)
	
	SetColor(0x00000000)  //Black
	DrawCross(_w(3,4),1)
	PrintCanvas()
	
	ArrayToCanvas(tempCanvas)  //Should Load current canvas in tempCanvas Array
	DrawArray(tempCanvas)		//Should draw current canvas but each time it draws dimmer.  :(
	PrintCanvas()
	
	
}
DrawSlowDownAnimation()
{
	CanvasToArray(tempCanvas),
	SetColor(0x00000000)  //Black
	DrawCross(_w(2,4),1)
	PrintCanvas()
	
	Delay(ANIMATION_DELAY)
	
	SetColor(0x40000000)  //Dim Red
	DrawCross(_w(2,4),1)
	PrintCanvas()
	
	Delay(ANIMATION_DELAY)
	
	SetColor(0x80000000)  //brighter red
	DrawCross(_w(2,4),1)
	PrintCanvas()
	
	Delay(ANIMATION_DELAY)
	
	SetColor(0xFF000000)  // red
	DrawCross(_w(2,4),1)
	PrintCanvas()
	
	Delay(ANIMATION_DELAY)	
	
	SetColor(0x80000000)  //brighter red
	DrawCross(_w(2,4),1)
	PrintCanvas()
	
	Delay(ANIMATION_DELAY)
	
	SetColor(0x40000000)  //Dim red
	DrawCross(_w(2,4),1)
	PrintCanvas()
	
	Delay(ANIMATION_DELAY)
	
	SetColor(0x00000000)  //Black
	DrawCross(_w(2,4),1)
	PrintCanvas()
	
	ArrayToCanvas(tempCanvas)  //Should Load current canvas in tempCanvas Array
	DrawArray(tempCanvas)		//Should draw current canvas but each time it draws dimmer.  :(
	PrintCanvas()
}

ChangeMode()
{
	if(Mode[0]==1) Mode[0] = 0;  				//Flips Mode
	else if(Mode[0]==0) Mode[0] = 1;    		//Flips Mode
	StoreVariable(''CP_Mode'',Mode) 	//Store Mode for next use.
	DrawMode(Mode[0])							//Draws Mode
}

DrawMode(mode) //Sets up Color Squares
{
	SetRgbColor(0,0,0)
	DrawCube()
	if(mode ==0)  //Wrap Mode
	{
		SetRgbColor(255,0,0) //Set Color Red
		DrawSide(0)  //Draw Red Side
		//printf("Draw Red square.\r\n");  //Used for Debuging
		
		SetRgbColor(0,255,0) //Set Color Green
		DrawSide(1)
		//printf("Draw Green Square.\r\n"); //Used for Debuging
		
		SetRgbColor(0,0,255) //Set Color Blue
		DrawSide(2)
	}
	else if(mode==1) //Cube Mode
	{
		SetRgbColor(255,0,0) //Set Color Red
		DrawSide(0)  //Draw Red Side
		//printf("Draw Red square.\r\n");  //Used for Debuging
		
		SetRgbColor(0,255,0) //Set Color Green
		DrawSide(4)
		//printf("Draw Green Square.\r\n"); //Used for Debuging
		
		SetRgbColor(0,0,255) //Set Color Blue
		DrawSide(2)
	}
	DrawMyColor( ColorRGB[0],ColorRGB[1],ColorRGB[2])
}

IsUporDown(side)  //Taken from example_5_animated_rubiks.p  Originally SolveDir(side)
{				//I think this determins which direction 
				//the tapped side is facing up or down. 
				//Returns 1 for up 0 for down
  new acc[3]    
  new val
  ReadAcc(acc)
  switch (side)
  {
       case 0:  val=acc[2]  
       case 1:  val=-acc[2]  
       case 2:  val=-acc[0]  
       case 3:  val=acc[0]  
       case 4:  val=acc[1]  
       case 5:  val=-acc[1]  
       default: val=0
  }
  
  if (val>150) return 0
  return 1
} 

AddColor(colorValue)  //Adds bumpSpeed(4) to the value of the color
{
	colorValue = colorValue + bumpSpeed;
	if(colorValue>255)  //Checks if the color value is greater than 255
	{
		colorValue=255
		Vibrate(400) //Vibrates to let know tried to go over 255
	}
	else 
	{
		Vibrate(50)
		Play("kap")
	}
	return colorValue
}
RemoveColor(colorValue)  //Subtracts bumpSpeed (4) to the value of the color
{
	colorValue = colorValue - bumpSpeed;
	if(colorValue<0)  //Checks if the color value is greater than 255
	{
		colorValue=0
		Vibrate(400) //Vibrates to let know tried to go over 255
	}
	else 
	{
		Vibrate(50)
		Play("soko_back")
	}
	return colorValue
}

DrawMyColor( r,  g,  b)
{
	ColorRGB[0]=r  //I can't figure out syntax here... I'd like:   ColorRGB ={r,g,b}
	ColorRGB[1]=g
	ColorRGB[2]=b
	StoreVariable(''CP_Colors'',ColorRGB) //Store Color for next use.
	if(Mode[0] ==0)
	{
		SetRgbColor(r,g,b)  //Draw Main Color Line
		DrawPoint(_w(4,5))
		DrawPoint(_w(4,4))
		DrawPoint(_w(5,4))
		DrawPoint(_w(5,5))
		DrawPoint(_w(3,1))
		DrawPoint(_w(3,4))
		DrawPoint(_w(3,7))
		
		SetRgbColor(r,0,0) //Draw Center Red Dot
		DrawPoint(_w(0,4))
		
		SetRgbColor(0,g,0) //Draw Center Green Dot
		DrawPoint(_w(1,4))
		
		SetRgbColor(0,0,b) //Draw Center Blue Dot
		DrawPoint(_w(2,4))
	}
	else if (Mode[0] ==1)
	{
		SetRgbColor(r,g,b)  //Draw Main Color Line
		DrawPoint(_w(1,3))
		DrawPoint(_w(1,4))
		DrawPoint(_w(1,6))
		DrawPoint(_w(1,7))
		DrawPoint(_w(3,4))
		DrawPoint(_w(3,5))
		DrawPoint(_w(3,7))
		DrawPoint(_w(3,8))		
		DrawPoint(_w(5,4))
		DrawPoint(_w(5,5))
		DrawPoint(_w(5,7))
		DrawPoint(_w(5,8))
		
		SetRgbColor(r,0,0) //Draw Center Red Dot
		DrawPoint(_w(0,4))
		
		SetRgbColor(0,g,0) //Draw Center Green Dot
		DrawPoint(_w(4,4))
		
		SetRgbColor(0,0,b) //Draw Center Blue Dot
		DrawPoint(_w(2,4))
	}
	
	PrintCanvas()
	printf("Drawing:  R:%d G:%D B:%D\r\n",r,g,b)
}