/*
Rubiks_Cube_With_Correct_Colors.p
Edited from: example_5_animated_rubiks.p
Edited By: Kenneth Brandon  (http://KennethBrandon.com)

Changes made:
1. Correct colors and color scheme
2. Added Solve Music
3. Added Solve Animation
4. Added colorful Icon

This example shows simple implementation of rubik's cube with animated rotations.
Direction of rotation is determined by inclination of tapped side. SolveDir function
reads accelerometer data and compares with threshold for direction.  
Also each move is stored into variable, so the progress is never lost.   

*/

#include <futurocube>

#define   SPEED_STEP    10
#define   ACC_TRESHOLD  60


//My colors for the Rubik's Cube
#define	KEN_BLUE 	0x0000FF00
#define	KEN_GREEN 	0x20970000
#define KEN_YELLOW	0xFF740000
#define	KEN_WHITE	0xFFA36700
#define	KEN_ORANGE	0xFF1C0000
#define	KEN_RED		0xFF000000


new colors[]=[KEN_BLUE,KEN_GREEN,KEN_YELLOW,KEN_WHITE,KEN_RED,KEN_ORANGE] 
new icon[]=[ICON_MAGIC1,ICON_MAGIC2,1,2,BLUE,0x20970000,0xFF740000,0xFFA36700,0xFFA36700,RED,0xFF1C0000,0x20970000,0xFF740000,''ballhit'',''hitrims1''] //ICON_MAGIC1,ICON_MAGIC2,Menu Number,Side Number,9 cell colors,Name sound,Info/About/Description sound

new cube[54]
new solvedCube[54]  // This will hold a solved cube.
new motion
new kick_side
new dirdecide
new isRacing = false;
new rubik_var[]=[VAR_MAGIC1,VAR_MAGIC2,''rubiks_with_Kens_Colors'']


CubeInit()
{
  PaletteFromArray(colors)
  new i
  if (!LoadVariable(''rubiks_with_Kens_Colors'',cube) || IsGameResetRequest())
  {
   for (i=0;i<54;i++) cube[i]=_side(i)+1
  } 
  for(i=0;i<54;i++) solvedCube[i]= _side(i)+1  //Creates a solved Cube
}

Draw()
{
  ClearCanvas()
  DrawArray(cube)
  PrintCanvas()
}
 
SolveDir(side)
{
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
 
main() 
{                       
	ICON(icon)
    RegisterVariable(rubik_var)
    RegAllSideTaps()
    RegMotion(SHAKING)
    CubeInit()
    Draw()
                            
    for (;;)
    {
     Sleep()
     motion=Motion()
     
       
     if (motion) 
        {
         kick_side=eTapSide();
         dirdecide=SolveDir(kick_side);
         if (dirdecide!=-1) 
         {
          if (dirdecide) Play("kap") 
          else Play("soko_back")
          TransformSide(kick_side,dirdecide)
          StoreVariable(''rubiks_with_Kens_Colors'',cube)
		      if(isRacing && IsCubeSolved()) {
            PlaySolvedAnimation() 
            isRacing = false //Checks for Solved Cube and if it's solved plays sound and animation.
          }
         }
         else Vibrate(100)
         AckMotion() 
        }
        if (_is(motion,SHAKING)){
          Play("bubbles")
          if(!isRacing){
            Scramble()
            isRacing = true;
          }
          else{
            cube = solvedCube
            StoreVariable(''rubiks_with_Kens_Colors'',cube)
            Draw()
          }
        }
    }

}
Scramble(){
  new i =0;

    new side = GetRnd(6)
    new direction = GetRnd(2)
    for (i = 0; i < 3; ++i)
    { 
      side = GetRnd(6)
     direction = GetRnd(2)
      TransformSide(side, direction)
      Delay(300)  
    }

  for(i=0; i<35; i++){
    side = GetRnd(6)
    direction = GetRnd(3)
    printf("Side: %d Direction: %d \n", side, direction);
    if(direction==2){
      TransformSide(side, direction)
      TransformSide(side, direction)
    }
    else TransformSide(side, direction)
  }
}
IsCubeSolved()   //Returns 1 if cube is solved.  Returns 0 if cube is not solved.
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
PlaySolvedAnimation()
{
	Play("clapping")
	printf("Cube solved! Played clapping\r\n")
	new i =0
	new temp[54]  // For PushPop intialization 
	PushPopInit(temp)  
	PushCanvas(0) 	//Pushes the current cube before animation
	for(i=0;i<1400;i++)
	{
		SetColor(KEN_BLUE)  
		DrawFlicker(_w(0),10,0,0)
		DrawFlicker(_w(1),10,0,0)
		DrawFlicker(_w(2),10,0,0)
		DrawFlicker(_w(3),10,0,0)
		DrawFlicker(_w(4),10,0,0)
		DrawFlicker(_w(5),10,0,0)
		DrawFlicker(_w(6),10,0,0)
		DrawFlicker(_w(7),10,0,0)
		DrawFlicker(_w(8),10,0,0)
		SetColor(KEN_GREEN)
		DrawFlicker(_w(9),10,0,0)
		DrawFlicker(_w(10),10,0,0)
		DrawFlicker(_w(11),10,0,0)
		DrawFlicker(_w(12),10,0,0)
		DrawFlicker(_w(13),10,0,0)
		DrawFlicker(_w(14),10,0,0)
		DrawFlicker(_w(15),10,0,0)
		DrawFlicker(_w(16),10,0,0)
		DrawFlicker(_w(17),10,0,0)
		SetColor(KEN_YELLOW)
		DrawFlicker(_w(18),10,0,0)
		DrawFlicker(_w(19),10,0,0)
		DrawFlicker(_w(20),10,0,0)
		DrawFlicker(_w(21),10,0,0)
		DrawFlicker(_w(22),10,0,0)
		DrawFlicker(_w(23),10,0,0)
		DrawFlicker(_w(24),10,0,0)
		DrawFlicker(_w(25),10,0,0)
		DrawFlicker(_w(26),10,0,0)
		SetColor(KEN_WHITE)
		DrawFlicker(_w(27),10,0,0)
		DrawFlicker(_w(28),10,0,0)
		DrawFlicker(_w(29),10,0,0)
		DrawFlicker(_w(30),10,0,0)
		DrawFlicker(_w(31),10,0,0)
		DrawFlicker(_w(32),10,0,0)
		DrawFlicker(_w(33),10,0,0)
		DrawFlicker(_w(34),10,0,0)
		DrawFlicker(_w(35),10,0,0)
		SetColor(KEN_RED)
		DrawFlicker(_w(36),10,0,0)
		DrawFlicker(_w(37),10,0,0)
		DrawFlicker(_w(38),10,0,0)
		DrawFlicker(_w(39),10,0,0)
		DrawFlicker(_w(40),10,0,0)
		DrawFlicker(_w(41),10,0,0)
		DrawFlicker(_w(42),10,0,0)
		DrawFlicker(_w(43),10,0,0)
		DrawFlicker(_w(44),10,0,0)
		SetColor(KEN_ORANGE)
		DrawFlicker(_w(45),10,0,0)
		DrawFlicker(_w(46),10,0,0)
		DrawFlicker(_w(47),10,0,0)
		DrawFlicker(_w(48),10,0,0)
		DrawFlicker(_w(49),10,0,0)
		DrawFlicker(_w(50),10,0,0)
		DrawFlicker(_w(51),10,0,0)
		DrawFlicker(_w(52),10,0,0)
		DrawFlicker(_w(53),10,0,0)
		PrintCanvas()
	}
	PopCanvas(0)  //Gets the state before animation
	PrintCanvas()
}

new const _t_side_top[6][12]=[[45,46,47,33,30,27,44,43,42,20,23,26],
                              [53,52,51,24,21,18,36,37,38,29,32,35],
                              [51,48,45,06,03,00,42,39,36,11,14,17],
                              [47,50,53,15,12,09,38,41,44,02,05,08],
                              [18,19,20,00,01,02,27,28,29,09,10,11],
                              [08,07,06,26,25,24,17,16,15,35,34,33]]

new const _t_side_rot[8]=[3,6,7,8,5,2,1,0]

MakeShift(belt[],lenght,dir=1)
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
	
TransformSide(side, dir)
{
  new bbelt[8]
  new i
  for (i=0;i<8;i++) bbelt[i]=side*9+_t_side_rot[i]
  
  MakeShift(_t_side_top[side],12,dir)
  Draw()
  Delay(SPEED_STEP)
  MakeShift(bbelt,8,dir)
  Draw()
  Delay(SPEED_STEP)
  MakeShift(_t_side_top[side],12,dir)
  Draw()
  Delay(SPEED_STEP)
  MakeShift(bbelt,8,dir)
  Draw()
  Delay(SPEED_STEP)
  MakeShift(_t_side_top[side],12,dir)
  Draw()
}	