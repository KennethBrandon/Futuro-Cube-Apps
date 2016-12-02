/*  Tilt Color 
By: Kenneth Brandon Dec 2016
This program will let you change colors by tilting the cube.
Tapping on the sides will let you change the speed of animation, pattern of animation, and the song that is played
*/

#include <futurocube>
#define LOG_FREQUENCY 400 // log once every 400 loops
#define SONG_MAX 16

new icon[] = [ICON_MAGIC1, ICON_MAGIC2, 1, 3, 0x6666ff, 0x050555, 0x6666ff, 0x050555, 0x6666ff, 0x050555, 0x6666ff, 0x050555, 0x6666ff, ''HAVOK'',''HAVOK'', ''Tilt Color'', ''By: Kenneth Brandon'', ''Tilt the cube to change to color, tap the sides to change animation and music''] //ICON_MAGIC1,ICON_MAGIC2,Menu Number,Side Number,9 cell colors,Name sound,Info/About/Description soundx

new data[3] //holds accelerometer data

new red = 0 
new green = 0
new blue = 0

new flickrPhaseMultiplier = 50 //index to modulate the flicker animation
new flickrSpeed = 20 // index to change speed of flicker
new songIndex = 1

new tiltColorVar[] = [VAR_MAGIC1, VAR_MAGIC2, ''tilt_color'']
new storedVariables[3] //to hold current animation pattern between app uses

main() {
	ICON(icon)
	RegisterVariable(tiltColorVar)
	restoreState()
	RegAllSideTaps()
	new loopCount = 0
	for(;;)  				//Main Loop!!
	{
		Sleep()	//Sleep between loops.

		if(IsPlayOver()) playSong() ///If the music stops, start it again

		if(Motion()) consumeTaps(eTapSide()) //if there is motion then we deal with the motion
		
		AckMotion()

		ReadAcc(data)  //read in accelerometer data 

		calculateColorFromData()

		logAccelerometerDataAndColors(loopCount)
		
		drawCube()

		loopCount++;
	}	
}

restoreState() {
	if (!LoadVariable(''tilt_color'', storedVariables) || IsGameResetRequest()) { //if it doesn't have values then load initial values
		flickrPhaseMultiplier = 50 
		flickrSpeed = 20 
		songIndex = 1
	}
	else {
		flickrPhaseMultiplier = storedVariables[0] 
		flickrSpeed = storedVariables[1] 
		songIndex = storedVariables[2]
	}
}

saveState() {
	storedVariables[0] = flickrPhaseMultiplier
	storedVariables[1] = flickrSpeed
	storedVariables[2] = songIndex
    StoreVariable(''tilt_color'', storedVariables);
}

calculateColorFromData() {
	red = (data[0] + 255) / 2   //calculate rgb colors from accelerometer data
	green = (data[1] + 255) / 2
	blue = (data[2] + 255) / 2

	//darkens colors a bit as they were too white
	red = red - 25 //don't darken red as much because red seemed dimmer than green and blue
	green = green - 45 
	blue = blue - 45

	red = validate(red)
	blue = validate(blue)
	green = validate(green)
}

drawCube() {
	SetIntensity(255)
	SetRgbColor(red, green, blue)
	DrawCube()
	drawFlicker()
	PrintCanvas()
}

drawFlicker() {
	new j = 0
	for (j=0; j<54; j++)
	{
		DrawFlicker(_w(j), flickrSpeed, FLICK_STD, j * flickrPhaseMultiplier)
	}
}

validate(color) {
	if(color < 0) color = 0	//values can be below zero and greater that 255 when more force than gravity is acting on the cube
	if(color > 255) color = 255
	return color
}

consumeTaps(tappedSide) {
	if(tappedSide == 1) {
		Play("clickhigh")
		flickrPhaseMultiplier++
	}
	else if(tappedSide == 0) {
		Play("kap")		
		flickrPhaseMultiplier--
		if(flickrPhaseMultiplier < 0) flickrPhaseMultiplier = 0
	}
	else if(tappedSide == 4) {
		Play("woodblock")
		flickrSpeed++
	}
	else if(tappedSide == 5) {
		Play("drip")		
		flickrSpeed--
		if(flickrSpeed < 1) flickrSpeed = 1
	}
	else if(tappedSide == 2 || tappedSide == 3) {
		songIndex++
		if(songIndex >= SONG_MAX) songIndex = 0
		Quiet()
	}
	saveState()
	printf("flicker phase: %d flicker speed: %d song index: %d\r\n", flickrPhaseMultiplier, flickrSpeed, songIndex)
}

playSong() { //rotates song depending on index
	switch(songIndex){
		case 0: Quiet()
		case 1: Play("COMEANDFIND")
		case 2: Play("STRANGE")
		case 3: Play("_d_EUROBEAT")
		case 4: Play("INSTRM2")
		case 5: Play("UFO")
		case 6: Play("HAVOK")
		case 7: Play("FORTYREWRITE")
		case 8: Play("FU3")
		case 9: Play("_d_THERE")
		case 10: Play("_d_SHAN")
		case 11: Play("_d_PIANO")
		case 12: Play("_d_MINDFULL")
		case 13: Play("_d_EXPECT")
		case 14: Play("_d_EXP")
		case 15: Play("_d_CONFESS")
	}
}

logAccelerometerDataAndColors(loopCount) {
	if(loopCount % LOG_FREQUENCY == 0) { //logs once every 100 loops...
		printf("raw (x,y,z) data: (%d, %d, %d)   ", data[0], data[1], data[2])
		printf("calculated rgb:  (%d, %d, %d)\r\n", red, green, blue)
	}	
}
