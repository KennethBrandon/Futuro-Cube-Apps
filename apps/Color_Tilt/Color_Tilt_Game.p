/*  Color Tilt Game
By: Kenneth Brandon Dec 2016
This program will let you change colors by tilting the cube.
Try to match the color in the middle
*/

#include <futurocube>
#define LOG_FREQUENCY 500 // log once every 500 loops
#define SONG_MAX 2//16
#define COLOR_ACCURACY 20

new icon[] = [ICON_MAGIC1, ICON_MAGIC2, 1, 3, 0x6666ff, 0x050555, 0x6666ff, 0x050555, 0x6666ff, 0x050555, 0x6666ff, 0x050555, 0x6666ff, ''warning2'',''warning2'', ''Color Tilt'', ''By: Kenneth Brandon'', ''Tilt the cube to change to color, tap the sides to change animation and music''] //ICON_MAGIC1,ICON_MAGIC2,Menu Number,Side Number,9 cell colors,Name sound,Info/About/Description soundx

new data[3] //holds accelerometer data
new rgb [3] //holds rgb color for the tilt color
new colorToFind[3] //holds rgb color for the target color in the middle of each side
new songIndex = 1

main() {
	ICON(icon)
	RegAllSideTaps()
	getRandomColor()
	new loopCount = 0
	for(;;) //Main Loop!!
	{
		Sleep()	//Sleep between loops.

		if(IsPlayOver()) playSong() //If the music stops, start it again

		if(Motion()) consumeTaps(eTapSide()) //if there is motion then we deal with the motion
		
		AckMotion()

		ReadAcc(data)  //read in accelerometer data 

		calculateColorFromData()

		if(isColorMatch()){
			Play("warning2")
			animateColorMatch()
			getRandomColor()
		}
		
		drawCube()

		loopCount++;
	}	
}

isColorMatch(){  //returns true if each channel is less than the COLOR_ACCURACY value
	return abs(colorToFind[0] - rgb[0]) < COLOR_ACCURACY && abs(colorToFind[1] - rgb[1]) < COLOR_ACCURACY && abs(colorToFind[2] - rgb[2]) < COLOR_ACCURACY 
}

animateColorMatch(){
	new i = 0
	for(i = 0; i < 80; i++){
		Sleep()
		SetRgbColor(colorToFind[0], colorToFind[1], colorToFind[2])
		new j = 0
		for (j = 0; j < 54; j++)
		{
			DrawFlicker(_w(j), 15, FLICK_STD, 55)
		}
		PrintCanvas()
	}
}

calculateColorFromData() {
	rgb[0] = (data[0] + 255) / 2   //calculate rgb colors from accelerometer data
	rgb[1] = (data[1] + 255) / 2
	rgb[2] = (data[2] + 255) / 2

	//darkens colors a bit as they were too white
	rgb[0] = rgb[0] - 25 //don't darken red as much because red seemed dimmer than green and blue
	rgb[1] = rgb[1] - 45 
	rgb[2] = rgb[2] - 45

	rgb[0] = validate(rgb[0])
	rgb[1] = validate(rgb[1])
	rgb[2] = validate(rgb[2])
}

drawCube() {
	SetIntensity(255)
	SetRgbColor(rgb[0], rgb[1], rgb[2])
	DrawCube() //draws cube

	//draws centers
	SetRgbColor(colorToFind[0], colorToFind[1], colorToFind[2])
	DrawPoint(_w(0, 4))
	DrawPoint(_w(1, 4))
	DrawPoint(_w(2, 4))
	DrawPoint(_w(3, 4))
	DrawPoint(_w(4, 4))
	DrawPoint(_w(5, 4))
	PrintCanvas() //turns on leds
}

validate(color) {
	if(color < 0) color = 0	//values can be below zero and greater that 255 when more force than gravity is acting on the cube
	if(color > 255) color = 255
	return color
}

consumeTaps(tappedSide) {
	printf("[%d,%d,%d]\r\n", rgb[0], rgb[1], rgb[2]) //used to find colors found in getRandomColor
	songIndex++
	if(songIndex >= SONG_MAX) songIndex = 0
	Quiet()
}

playSong() { //rotates song depending on index
	switch(songIndex){
		case 0: Quiet()
		case 1: Play("COMEANDFIND") //removed a bunch of songs found in color_tilt
	}
}

// getRandomColor(){
// 	colorToFind[0]= GetRnd(155)
// 	colorToFind[1]= GetRnd(155)
// 	colorToFind[2]= GetRnd(155)
// 	printf("New Color To find: (%d, %d, %d)\r\n", colorToFind[0], colorToFind[1], colorToFind[2])
// }
getRandomColor(){
	new lastRed = colorToFind[0]
	while(abs(lastRed-colorToFind[0])<50){  // looping untill next color's red channel is at least 50 different
		switch(GetRnd(19)){ //picked random colors that I tested are easily achievable
			case 0: colorToFind = [194,4,78]
			case 1: colorToFind = [117,36,0]
			case 2: colorToFind = [207,138,48]
			case 3: colorToFind = [60,123,0]
			case 4: colorToFind = [57,27,183]
			case 5: colorToFind = [143,0,68]
			case 6: colorToFind = [161,4,6]
			case 7: colorToFind = [25,0,76]
			case 8: colorToFind = [199,38,141]
			case 9: colorToFind = [0,88,98]
			case 10: colorToFind = [128,192,30]
			case 11: colorToFind = [174,135,0]
			case 12: colorToFind = [140,45,0]
			case 13: colorToFind = [24,176,56]
			case 14: colorToFind = [156,143,0]
			case 15: colorToFind = [183,148,147]
			case 16: colorToFind = [19,140,150]
			case 17: colorToFind = [136,202,86]
			case 18: colorToFind = [143,0,76]
			case 19: colorToFind = [154,0,33]  
			case 20: colorToFind = [97,200,38]
			case 21: colorToFind = [70,165,165]
			case 22: colorToFind = [83,27,191]
			case 23: colorToFind = [188,32,9]
		}
	}
}
