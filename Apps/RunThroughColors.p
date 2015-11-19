/*  Run Through Colors 
By: Kenneth Brandon July 2013
This program goes smothley though the color.  

Tapping on one side will speed it up.
Tapping on an oposite side will slow it down.

Transition is Black -> Red -> Yellow -> Green -> Teal -> Blue -> Purple -> 
					   Red -> Yellow -> Green -> Teal -> Blue -> Purple -> 
					   Red -> Yellow -> Green -> Teal -> Blue -> Purple -> and on and on.
*/

#include <futurocube>
#define MAX_DELAY 150
#define MIN_DELAY 10
#define MAX_SPEED 75

new icon[]=[ICON_MAGIC1,ICON_MAGIC2,1,3,0xFF004400,0xFF004400,0xFF004400,0x4400FF00,0x4400FF00,0x4400FF00,0x0044FF00,0x0044FF00,0x0044FF00,''STRANGE'',''STRANGE''] //ICON_MAGIC1,ICON_MAGIC2,Menu Number,Side Number,9 cell colors,Name sound,Info/About/Description sound

main()
{
	ICON(icon)
	Play("STRANGE") //relaxing music...

	new r = 0
	new g = 0
	new b = 0
	new ToRed = 1     //used as bools to determin what mode we are in...
	new ToYellow = 0
	new ToGreen = 0
	new ToTeal = 0
	new ToBlue = 0
	new ToPurple = 0
	new BackToRed = 0
	
	new speed = 4			//the speed at which we go through colors
	new TappedSide = 0;		//the side number being tapped
	new delay=10			//the delay for Sleep()...  Used to slow down the transition between colors further. 
		
	RegAllSideTaps()
	for(;;)  				//Main Loop!!
	{
		if(IsPlayOver()) Play("STRANGE")   	//If the music stops, start it again
		Sleep(delay)						//Sleep between loops.
		if(Motion())						// If motion (taps) then change the speed...
		{
			TappedSide=eTapSide()
			if(TappedSide==1||TappedSide==2||TappedSide==5) //Speed it up
			{
				if(speed<MAX_SPEED && delay<=MIN_DELAY) 	//if speed isn't maxed out, and delay is low speed it up.
				{
					speed++
					Play("clickhigh")			//Play click high so user knows going faster..
				}
				else if(delay>MIN_DELAY)		// if delay is long, speed it up by shortening delay
				{
					delay-=10
					Play("clickhigh")			//Play click high so user knows going faster..
				}
				else Play("uff")				// We are fast enough... play uff to let user know we aren't going any faster
			}
			else								//Slow it down
			{
				if(speed>2) 					//if speed is not 1, slow it down
				{
					speed--
					Play("kap")					//Play kap so user knows going slower..
				}
				else if(delay<MAX_DELAY)		// if we aren't yet at our max delay slow it down more by increassing delay
				{
					delay+=10;
					Play("kap")					//Play kap so user knows going slower..
				}
				else Play("uff")				// We are slow enough... play uff to let user know we aren't going any slower
			}
			printf("Speed: %d  Delay: %d\r\n",speed, delay) // print speed and delay for debug
		}
		AckMotion()
		
		if(ToRed)  //Should Be coming from black.. so adding up red
		{
			if(r>=255)
			{
				ToRed =0
				ToYellow =1
			}
			else r+=speed
		}
		if(ToYellow) //Should be coming from red.. so adding up green
		{
			r=255
			if(g>=255)
			{
				ToYellow = 0
				ToGreen = 1
			}
			else g+=speed
		}
		if(ToGreen) //Should be coming from yellow.  so droping red
		{
			g=255
			if(r<=0) 
			{
				r=0
				ToGreen=0
				ToTeal=1
			}
			else r-=speed			
		}
		if(ToTeal) //Should be coming from green..  so adding blue
		{
			g=255
			if(b>=255)
			{
				ToTeal=0
				ToBlue=1
			}
			else b+=speed
		}
		if(ToBlue) //Should be coming from teal... so dropping green
		{
			b=255
			if(g<=0)
			{
				g=0
				ToBlue=0
				ToPurple=1
			}
			else g-=speed
		}
		if(ToPurple) //Should be coming from blue.. so adding red
		{
			if(r>=255)
			{
				r=255
				ToPurple =0
				BackToRed =1
			}
			else r+=speed
		}
		if(BackToRed) // Coming from Purple so... dropping blue
		{
			if(b<=0)
			{
				BackToRed=0
				ToYellow=1
			}
			else b-=speed
		}
		
		if(r<0) r=0  //if we dropped below 0 then make it 0....   Otherwise we get weird flickering 
		if(g<0) g=0
		if(b<0) b=0
		
		if(r>255) r=255  //if we added past 255 then make it 0....   Otherwise we get weird flickering 
		if(g>255) g=255
		if(b>255) b=255
		
		SetIntensity(255)
		SetRgbColor(r,g,b)
		DrawCube()
		PrintCanvas()
	}	
}