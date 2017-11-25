/*  Color Tilt Game
By: Kenneth Brandon Dec 2016
This program will let you change colors by tilting the cube.
Try to match the color in the middle

Updated Ocotber 2017
Added timing and high scores
*/

#include <futurocube>
#define LOG_FREQUENCY 500 // log once every 500 loops
#define SONG_MAX 2//16
#define COLOR_ACCURACY 20
#define FREE_PLAY 0
#define PLAY 1
#define GAME_LENGTH 20000 // 20s
#define AWARDED_TIME 1500 //1.5s

new icon[] = [ICON_MAGIC1, ICON_MAGIC2, 
    1, 3, 
    0x6666ff, 0x6666ff, 0x6666ff, 
    0x6666ff, 0xCC003300, 0x6666ff, 
    0x6666ff, 0x6666ff, 0x6666ff, ''color_tilt'',''color_t_description'',ICON_MAGIC3,''Color Tilt'',1,0,SCORE_BEST_IS_MAX|SCORE_PRIMARY_POINTS] //ICON_MAGIC1,ICON_MAGIC2,Menu Number,Side Number,9 cell colors,Name sound,Info/About/Description soundx

new data[3] //holds accelerometer data
new rgb [3] //holds rgb color for the tilt color
new colorToFind[3] //holds rgb color for the target color in the middle of each side
new gameState = FREE_PLAY
new colorsFound = 0  //score
new tapSoundLength = 1000 //starts at 1s per "tap" and as your run out of time the "tap" sound length gets smaller so the "taps" speed up

main() {
    ICON(icon)
    EnablePreciseTiming() 
    RegMotion(TAP_GENERIC)
    Play("_g_TAPTOSTART")
    for(;;) //Main Loop!!
    {
        Sleep() //Sleep between loops.

        if(Motion()) consumeTaps() //if there is motion then we deal with the motion
        
        AckMotion()

        ReadAcc(data)  //read in accelerometer data 

        calculateColorFromData()
        
        drawCube()

        if(gameState == PLAY){
            checkForColorMatch()
            
            checkTimeAndGameOver()
        }
    }   
}

startGame(){
    gameState = PLAY
    Play("ballhit")
    colorsFound = 0  //resets to 0 found colors
    tapSoundLength = 1000 //resets to 1 second between tap sounds
    getRandomColor()
    SetIncTimer(0,0) //our main game timer
    SetTimer(0,tapSoundLength) //our tap timer. play tap every second to start
}

gameOver(){
    Play("uff")
    WaitPlayOver()
    checkHighScore()

    Play("_s_SCOREIS")
    WaitPlayOver()

    playNumber(colorsFound)
    WaitPlayOver()

    Play("_g_TAPTOSTART")
    gameState = FREE_PLAY

    printf("GAME OVER!!! Colors found: %d\n", colorsFound)
}
checkHighScore(){
    new scoreVar = SetScore(CMD_SET_BEST_SCORE,colorsFound)
    printf("High score var: %d\n", scoreVar)
    if (scoreVar==1) {
        //checks if high score!
        printf("High Score!! %d\n", colorsFound)
        if(colorsFound>0) AnnounceBestScore()
    }
}
checkForColorMatch(){
    if(isColorMatch()){
        colorsFound++
        printf("Colors found: %d \n", colorsFound)
        Play("found")
        animateColorMatch()
        getRandomColor()
    }
}

isColorMatch(){  //returns true if each channel is less than the COLOR_ACCURACY value
    return abs(colorToFind[0] - rgb[0]) < COLOR_ACCURACY && abs(colorToFind[1] - rgb[1]) < COLOR_ACCURACY && abs(colorToFind[2] - rgb[2]) < COLOR_ACCURACY 
}

checkTimeAndGameOver(){
    new timeElapsed = GetIncTimer()
    new actualGameLength = AWARDED_TIME*colorsFound +GAME_LENGTH;

    if(timeElapsed > actualGameLength){
        gameOver()
    }
    else if (timeElapsed>actualGameLength*8/10){
        tapSoundLength = 200
    }
    else if (timeElapsed>actualGameLength*6/10){
        tapSoundLength = 400
    }
    else if (timeElapsed>actualGameLength*4/10){
        tapSoundLength = 600
    }
    else if (timeElapsed>actualGameLength*2/10){
        tapSoundLength = 800
    }
    if(GetTimer(0)<=0){
        Play("ballhit")   // plays tap sound
        SetTimer(0,tapSoundLength)  //sets the timer for the next time to play the tap sound. 
    }
}

animateColorMatch(){  //todo: integrate this with the drawCube method so the loops don't keep the tap sound timer from being played
    new i = 0
    for(i = 0; i < 40; i++){
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

    if(gameState == PLAY) drawCenters()
    if(gameState == FREE_PLAY) drawFreePlayAnimation()

    PrintCanvas() //turns on leds
}

drawFreePlayAnimation() {
    new j = 0
    for (j=0; j<54; j++)
    {
        DrawFlicker(_w(j), 15, FLICK_STD, j * 60)
    }
}

drawCenters(){
    SetRgbColor(colorToFind[0], colorToFind[1], colorToFind[2])
    DrawPoint(_w(0, 4))
    DrawPoint(_w(1, 4))
    DrawPoint(_w(2, 4))
    DrawPoint(_w(3, 4))
    DrawPoint(_w(4, 4))
    DrawPoint(_w(5, 4))
}

validate(color) {
    if(color < 0) color = 0 //values can be below zero and greater that 255 when more force than gravity is acting on the cube
    if(color > 255) color = 255
    return color
}

consumeTaps() {
    printf("[%d,%d,%d]\r\n", rgb[0], rgb[1], rgb[2]) //used to find colors found in getRandomColor
    if(gameState == FREE_PLAY){
        startGame()
    }
    Quiet()
}

getRandomColor(){
    new lastRed = colorToFind[0]
    while(abs(lastRed-colorToFind[0])<50){  // looping untill next color's red channel is at least 50 different
        new randomNumber = GetRnd(25)
        printf("Random color: %d\n",randomNumber );
        switch(randomNumber){ //picked random colors that I tested are easily achievable
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
            case 24: colorToFind = [74,51,0]
        }
        printf("colorToFind: %d,%d,%d \n", colorToFind[0], colorToFind[1], colorToFind[2])
    }
}

playNumber(number){
    new string[4]
    snprintf(string,4,"%d",number%10)
    if(number<20)
    {
        snprintf(string,4,"%d",number)
        Play(string)  
        WaitPlayOver()
    }
    else if(number<100)
    {
        new Mod = number%10
        
        snprintf(string,4,"%d",number-Mod)
        Play(string)
        WaitPlayOver()
        if(Mod!=0) 
        {
            snprintf(string,4,"%d",Mod)
            Play(string)
            WaitPlayOver()
        }
    }
    else
    {
        new Mod100 = number%100
        new Mod10 = Mod100%10
        snprintf(string,4,"%d",number-Mod100)
        Play(string)
        WaitPlayOver()
        if(Mod100!=0)
        {               
            if(Mod100<20) 
            {
                snprintf(string,4,"%d",Mod100)
                Play(string)
            }
            else
            {
                snprintf(string,4,"%d",Mod100-Mod10)
                Play(string)
                WaitPlayOver()
                if(Mod10!=0)
                {
                    snprintf(string,4,"%d",Mod10)
                    Play(string)
                    WaitPlayOver()
                }
            }
        }
    }
}
