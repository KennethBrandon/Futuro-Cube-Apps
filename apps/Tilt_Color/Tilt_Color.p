/*  Run Through Colors 
By: Kenneth Brandon Nov 2016
Hopefully this program will let you change colors by tilting the cube
*/

#include <futurocube>

new icon[]=[ICON_MAGIC1,ICON_MAGIC2,1,3,0xFF004400,0xFF004400,0xFF004400,0x4400FF00,0x4400FF00,0x4400FF00,0x0044FF00,0x0044FF00,0x0044FF00,''HAVOK'',''HAVOK''] //ICON_MAGIC1,ICON_MAGIC2,Menu Number,Side Number,9 cell colors,Name sound,Info/About/Description sound
new TappedSide
new data[3]
new loops = 0
new past = 0
main()
{
	ICON(icon)
	Play("HAVOK")
		
	RegAllSideTaps()
	for(;;)  				//Main Loop!!
	{
		if(IsPlayOver()) Play("HAVOK")///If the music stops, start it again
		Sleep()						//Sleep between loops.

		if(Motion())// If motion (taps) then change the past to test if it adds a delay when grabing accelerometer data...
		{
			TappedSide=eTapSide()
			if(TappedSide==1||TappedSide==2||TappedSide==5) 
			{
				Play("clickhigh")
				past++
			}
			else								
			{
				Play("kap")		
				past--
			}

			printf("past: %d\r\n", past)
		}
		ReadAcc(data, past)  //read in accelerometer data 

		new red = (data[0] + 255) / 2   //calculate rgb colors from accelerometer data
		new green = (data[1] + 255) / 2
		new blue = (data[2] + 255) / 2

		//darkens colors a bit as they were too white
		red = red - 35
		green = green - 35 
		blue = blue - 36

		if(red < 0) red = 0	//values can be below zero and greater that 255 when more force than gravity is acting on the cube
		if(blue < 0) blue = 0
		if(green < 0) green = 0
		if(red > 255) red = 255
		if(green > 255) green = 255
		if(blue > 255) blue = 255

		if(loops % 400 == 0) { //logs once every 100 loops...
			printf("raw (x,y,z) data: (%d, %d, %d)   ", data[0], data[1], data[2])
			printf("calculated rgb:  (%d, %d, %d)  \r\n", red,green,blue)
		}	

		AckMotion()
		
		SetIntensity(255)
		SetRgbColor(red,green,blue)
		DrawCube()
		PrintCanvas()
		loops++;
	}	
}