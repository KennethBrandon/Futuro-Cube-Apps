/*
Rubiks_Cube_With_Correct_Colors.p
Edited from: example_5_animated_rubiks.p
Edited By: Kenneth Brandon (http://KennethBrandon.com)
Changes made:
1. Correct colors and color scheme
2. Added Solve Music
3. Added Solve Animation
4. Added colorful Icon
5. Added Shake to Scramble
6. Added custom sounds
7. Added High Scores!
This example shows simple implementation of rubik's cube with animated rotations.
Direction of rotation is determined by inclination of tapped side. solveDir function
reads accelerometer data and compares with threshold for direction.
Also each move is stored into variable, so the progress is never lost.
*/
#include <futurocube>
#define  SPEED_STEP 10
#define  ACC_TRESHOLD 60
//My colors for the Rubik's Cube
#define KEN_BLUE 0x0000FF00
#define KEN_GREEN 0x20970000
#define KEN_YELLOW 0xFF740000
#define KEN_WHITE 0xFFA36700
#define KEN_ORANGE 0xFF1C0000
#define KEN_RED 0xFF000000
#define SOLVING 0
#define FREEPLAY  1
#define SOLVED 2
#define SCRAMBLING 3
#define INSPECTION_LESSTHAN_8 4
#define INSPECTION_MORETHAN_8 5
#define INSPECTION_MORETHAN_12 6
#define INSPECTION_MORETHAN_15 7
#define INSPECTION 8
new colors[]=[KEN_BLUE,KEN_GREEN,KEN_YELLOW,KEN_WHITE,KEN_RED,KEN_ORANGE]
new icon[]=[ICON_MAGIC1,ICON_MAGIC2,0,0,BLUE,0x20970000,0xFF740000,0xFFA36700,0xFFA36700,RED,0xFF1C0000,0x20970000,0xFF740000,''rubiks_cube'',''rubiks_desc'',ICON_MAGIC3,''RUBIKS CUBE'' ,1,3,SCORE_BEST_IS_MIN|SCORE_PRIMARY_TIME|SCORE_SECONDARY_POINTS|SCORE_DISP_PTIME_MS|SCORE_DISP_SECONDARY] //ICON_MAGIC1,ICON_MAGIC2,Menu Number,Side Number,9 cell colors,Name sound,Info/About/Description sound
new cube[54] 
new solvedCube[54] // This will hold a solved cube.
new storedVariable[57] //cube + move count + isRacing + currentTime
new isRacing = false;
new rubik_var[]=[VAR_MAGIC1,VAR_MAGIC2,''rubiks_with_Kens_Colors'']
new moveCount = 0
new solutionTime
new startTimerOnFirstMove = false
new previousTime
new previousTapDirection
new isSolved = false
new isWinner = false
new add2Sec = false
new cubeState = FREEPLAY
new inspectState = INSPECTION_LESSTHAN_8
cubeInit()
{
    PaletteFromArray(colors)
    loadState()
    new i
    for(i=0;i<54;i++) solvedCube[i]= _side(i)+1 //Creates a solved Cube
}
saveState(){
    new i
    for(i=0; i<54; i++)storedVariable[i] = cube[i]
    storedVariable[54] = moveCount
    storedVariable[55] = isRacing
    storedVariable[56] = previousTime + GetIncTimer()
    StoreVariable(''rubiks_with_Kens_Colors'',storedVariable);
}
loadState(){
    new i
    if (!LoadVariable(''rubiks_with_Kens_Colors'',storedVariable) || IsGameResetRequest())
    {
        for (i=0;i<54;i++) cube[i]=_side(i)+1
        moveCount = 0;
        isRacing = false
        previousTime = 0;
        cubeState = FREEPLAY
    }
    else 
    {
        for (i=0;i<54;i++) cube[i] = storedVariable[i]
        moveCount = storedVariable[54]
        isRacing = storedVariable[55]
        previousTime = storedVariable[56]
    }
}
draw(drawFlicker)
{
    ClearCanvas()
    if(drawFlicker){
        new j = 0
        for (j=0;j<54;j++)
        {
            if (j==0) SetColor(KEN_BLUE)
            if (j==9) SetColor(KEN_GREEN)
            if (j==18) SetColor(KEN_YELLOW)
            if (j==27) SetColor(KEN_WHITE)
            if (j==36) SetColor(KEN_RED)
            if (j==45) SetColor(KEN_ORANGE)
            DrawFlicker(_w(j),20,FLICK_STD,j*2)
        }
    }
    else {
        DrawArray(cube)
    }
    PrintCanvas()
}
solveDir(side)
{
    new acc[3]
    new val
    ReadAcc(acc)
    switch (side)
    {
        case 0: val=acc[2]
        case 1: val=-acc[2]
        case 2: val=-acc[0]
        case 3: val=acc[0]
        case 4: val=acc[1]
        case 5: val=-acc[1]
        default: val=0
    }
    if (val>150) return 0
    return 1
}
main()
{
    ICON(icon)
    EnablePreciseTiming() //enabled perciseTiming
    RegisterVariable(rubik_var)
    RegAllSideTaps()
    RegMotion(SHAKING)
    cubeInit()
    isSolved = isCubeSolved()
    draw(false)
    if(isSolved) Play("shake_to_scramble")
    new motion = 0;
    new lastDuration = 0;
    for (;;)
    {
        Sleep()
        motion=Motion()
        if(cubeState == INSPECTION){
            lastDuration = doInspection(lastDuration);
        }
        else lastDuration = 0;
        if (motion)
        {
            new kick_side=eTapSide();
            new dirdecide=solveDir(kick_side);
            if (dirdecide!=-1)
            {
                if(cubeState == INSPECTION){
                    cubeState = SOLVING
                }
                if(startTimerOnFirstMove)
                {
                    SetIncTimer(0,0) //our main game timer
                    startTimerOnFirstMove = false
                }
                playTwist();
                if(isWinner&&isSolved)Quiet() //turn off winning music
                if(previousTapDirection != kick_side) moveCount++; //only increment move count if move is on a new side.
                printf("move count: %d\n", moveCount);
                transformSide(kick_side,dirdecide)
                saveState()
                isSolved = isCubeSolved();
                if(isRacing && isSolved) {
                    isWinner = true
                    solutionTime=GetIncTimer() + previousTime; //Got solution time which is the current time + previous run times
                    if(add2Sec) solutionTime+=2000;
                    printf("solutionTime: %d\n", solutionTime);
                    new scoreVar = SetScore(CMD_SET_BEST_SCORE,solutionTime,solutionTime,moveCount)
                    if (scoreVar==1) {
                        //checks if high score!
                        printf("best time! %d\n", solutionTime)
                        AnnounceBestScore()
                    }
                    draw(false)
                    playSolvedCongrats(solutionTime, moveCount)
                    printf("result of setting score: %d\n", scoreVar)
                    isRacing = false //Checks for Solved Cube and if it's solved plays sound and animation.
                    add2Sec = false
                    previousTime = 0
                }

                if(isWinner&& isSolved) Play("_d_EUROBEAT")
            }
            else Vibrate(100)
            previousTapDirection = kick_side;

            if (_is(motion,SHAKING)){ 
                previousTime = 0
                if(!isRacing){
                    Play("inspection_time")
                    cubeState=SCRAMBLING
                    scramble()
                    moveCount = 0
                    saveState()
                    startTimerOnFirstMove = true
                    isRacing = true
                    SetTimer(0,17000)
                    cubeState=INSPECTION
                    add2Sec = false
                    inspectState = INSPECTION_LESSTHAN_8
                }
                else{
                    Play("vzum")
                    cube = solvedCube
                    cubeState = FREEPLAY
                    moveCount = 0
                    isRacing = false
                    saveState
                    draw(true)
                }
            }
            AckMotion()
        }
        draw(isSolved&&isWinner)
    }
}
playTwist(){
    new i = GetRnd(6);
    switch(i){
        case 0: Play("twist1")
        case 1: Play("twist2")
        case 2: Play("twist3")
        case 3: Play("twist4")
        case 4: Play("twist5")
        case 5: Play("twist6")
    }
}
scramble(){
    new i =0;
    new side = GetRnd(6)
    new direction = GetRnd(2)
    for (i = 0; i < 3; ++i)
    {
        side = GetRnd(6)
        direction = GetRnd(2)
        transformSide(side, direction)
        playTwist();
        Delay(300)
    }
    for(i=0; i<35; i++){
        side = GetRnd(6)
        direction = GetRnd(3)
        printf("Side: %d Direction: %d \n", side, direction);
        if(direction==2){
            transformSide(side, direction)
            transformSide(side, direction)
            playTwist();
        }
        else transformSide(side, direction)
    }
}
isCubeSolved()  //Returns 1 if cube is solved. Returns 0 if cube is not solved.
{
    new i =0
    for(i=0;i<54;i++)
    {
        if(cube[i] != solvedCube[i]) //Checks if cube doesn't match solved cube.
        {
            return 0
        }
    }
    return 1 //Cube must be solved
}
playSolvedCongrats(ms, moves)
{
    new seconds = (ms / 1000) % 60 ;
    new minutes = ((ms / (1000*60)) % 60);
    new hours   = ((ms / (1000*60*60)) % 24);
    if(add2Sec) { 
        Play("2s_penelty"); 
        WaitPlayOver()
    }
    Play("you_solved_in")
    WaitPlayOver()
    if(hours>0){
        playNumber(hours)
        if(hours ==1)Play("hour")
        else Play("hours")
        WaitPlayOver()
    }
    if(minutes>0){
        playNumber(minutes)
        if(minutes ==1)Play("min")
        else Play("mins")
        WaitPlayOver()
    }

    if(seconds>0){
        playNumber(seconds)
        Play("seconds")
        WaitPlayOver()
    }

    Play("with")
    WaitPlayOver()
    playNumber(moves)
    WaitPlayOver()
    Play("moves")
    WaitPlayOver()
    printf("Cube solved in %dh, %dm, %ds\n", hours, minutes, seconds)

}
new const _t_side_top[6][12]=[[45,46,47,33,30,27,44,43,42,20,23,26],
[53,52,51,24,21,18,36,37,38,29,32,35],
[51,48,45,06,03,00,42,39,36,11,14,17],
[47,50,53,15,12,09,38,41,44,02,05,08],
[18,19,20,00,01,02,27,28,29,09,10,11],
[08,07,06,26,25,24,17,16,15,35,34,33]]
new const _t_side_rot[8]=[3,6,7,8,5,2,1,0]
makeShift(belt[],lenght,dir=1)
{
    new temp
    new i
    if (dir==1)
    {
        temp=cube[belt[0]]
        for (i=0;i<(lenght-1);i++)
        cube[belt[i]]=cube[belt[i+1]]
        cube[belt[lenght-1]]=temp
    }
    else
    {
        temp=cube[belt[lenght-1]]
        for (i=lenght-1;i>0;i--)
        cube[belt[i]]=cube[belt[i-1]]
        cube[belt[0]]=temp
    }
}
transformSide(side, dir)
{
    new bbelt[8]
    new i
    for (i=0;i<8;i++) bbelt[i]=side*9+_t_side_rot[i]
    makeShift(_t_side_top[side],12,dir)
    draw(false)
    Delay(SPEED_STEP)
    makeShift(bbelt,8,dir)
    draw(false)
    Delay(SPEED_STEP)
    makeShift(_t_side_top[side],12,dir)
    draw(false)
    Delay(SPEED_STEP)
    makeShift(bbelt,8,dir)
    draw(false)
    Delay(SPEED_STEP)
    makeShift(_t_side_top[side],12,dir)
    draw(false)
}
doInspection(lastDuration){
    new duration = 17000 - GetTimer()
    if(duration%12000 ==0 && duration!=lastDuration) Play("clickhigh")
    else if(duration%13000 ==0 && duration!=lastDuration) Play("clickhigh")
    else if(duration%14000 ==0 && duration!=lastDuration) Play("clickhigh")
    else if(duration%15000 ==0 && duration!=lastDuration) Play("bongo")
    else if(duration%16000 ==0 && duration!=lastDuration) Play("bongo")
    else if(duration%17000 ==0 && duration!=lastDuration) {Play("uff"); WaitPlayOver();}
    else if(duration%1000 ==0 && duration!=lastDuration) Play("ballhit")
    if(inspectState == INSPECTION_LESSTHAN_8){
        if(duration>8000){
            inspectState = INSPECTION_MORETHAN_8
            Play("8_seconds")
        }
    }
    if(inspectState == INSPECTION_MORETHAN_8){
        if(duration>12000){
            inspectState = INSPECTION_MORETHAN_12
            Play("go")
        }
    }
    if(inspectState == INSPECTION_MORETHAN_12){
        if(duration>15000){
            inspectState = INSPECTION_MORETHAN_15
            add2Sec = true;
        }
    }
    if(inspectState == INSPECTION_MORETHAN_15){
        if(duration >=17000){
            isRacing = false
            cubeState = FREEPLAY
            startTimerOnFirstMove = false
            Play("dnf")
        }
    }
    return duration
}
playNumber(number){
    new string[4]
    snprintf(string,4,"%d",number%10)
    if(number<19)
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