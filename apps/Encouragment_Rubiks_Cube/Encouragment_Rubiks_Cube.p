/*
Kens_Rubiks_Cube.p

Changes from example_5_animated_rubiks.p:
1. Correct colors and color scheem
2. Added Solve Music
3. Added encouragment for steps of the solve
4. 

	Modified from:
	example_5_animated_rubiks.p

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

new colors[]=[KEN_BLUE,KEN_GREEN,KEN_YELLOW,KEN_WHITE,KEN_RED,KEN_ORANGE] //My Colors.   

new icon[]=[ICON_MAGIC1,ICON_MAGIC2,0,2,BLUE,0x20970000,0xFF740000,0xFFA36700,0xFFA36700,RED,0xFF1C0000,0x20970000,0xFF740000,''ballhit'',''hitrims1''] //ICON_MAGIC1,ICON_MAGIC2,Menu Number,Side Number,9 cell colors,Name sound,Info/About/Description sound
// My favorite colors found using Color Picker by: Kenneth Brandon
// Red: R:255 G:0 B:0
// Orange: R:255 G:28 B:0  
// Yellow: R:255 G:116 B:0
// White: R:255 G:255 B:255  or R:255 G:119 B:95
// Blue: R:0 G:0 B:255
// Green: R:0 G:255 B:0 or R:32 G:151 B:0
// new colors[]=[cBLUE,cGREEN,cORANGE,cMAGENTA ,cRED,cPURPLE] Original colors

new g_cube[54]
new g_solvedCube[54]
new g_Motion
new g_Kick_Side
new g_DirectionDecide
//new g_Encouragment[7]  An array for seeing if we have checked for encouragment.  Encouragment [0] is for cross. [1-4] is for f2l pairs [5] is for f2l 6 is for oll and 7 is for solved
new g_NeedsCrossEncouragment = 1
new g_NeedsF2LEncouragment =1
new g_NeedsOLLEncouragment =1

new rubik_var[]=[VAR_MAGIC1,VAR_MAGIC2,''animated_rubiks'']


CubeInit()
{
  PaletteFromArray(colors)
  new i
  if (!LoadVariable(''animated_rubiks'',g_cube) || IsGameResetRequest())
  {
   for (i=0;i<54;i++) g_cube[i]=_side(i)+1
  }
  
  for(i=0;i<54;i++) 
  {
	g_solvedCube[i]= _side(i)+1
	printf("Solved Cube index:%d value:%d\r\n",i,g_solvedCube[i])
  }
}

Draw()
{
  ClearCanvas()
  DrawArray(g_cube)
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
    CubeInit()
    Draw()
                            
    for (;;)
    {
     Sleep()
     g_Motion=Motion()
     
       
     if (g_Motion) 
        {
         g_Kick_Side=eTapSide();
         g_DirectionDecide=SolveDir(g_Kick_Side);
         if (g_DirectionDecide!=-1) 
         {
          if (g_DirectionDecide) Play("kap") 
          else Play("soko_back")
          TransformSide(g_Kick_Side,g_DirectionDecide)
          StoreVariable(''animated_rubiks'',g_cube)
		  if(IsCubeSolved())
		  {
			Play("clapping")
			printf("Cube solved! Played clapping\r\n")
		  }
		  if(g_NeedsCrossEncouragment) IsCross()
		  if(g_NeedsF2LEncouragment) IsF2L()
		  if(g_NeedsOLLEncouragment) IsOLL()
		  /*  To be implemented************************************************************
		  if(IsF2LPair())EncouragePair()
		  if(IsF2L())EncourageF2L()
		  if(IsOLL())EncourageOLL()
		  if(IsSolved())EncourageSolved() */
         }
         else Vibrate(100)
         AckMotion() 
        }
    }
}
IsOLL()
{

}
new ArrayOfNonF2L[21]
IsF2L()
{
	//Check Side:0 BLUE F2L  indexes are 0,1,2,3,4,5,6,7,8,42,43,44,39,40,41,27,28,30,31,33,34,455,46,47,48,49,50,19,20,22,23,25,26 
	new i =0
	new isF2L =1
	GetNonF2LArray(0)
	if(IsF2LFromIndexsOfNonF2L(ArrayOfNonF2L)) DrawEncourageF2L(0)
	GetNonF2LArray(1)
	if(IsF2LFromIndexsOfNonF2L(ArrayOfNonF2L)) DrawEncourageF2L(1)
	GetNonF2LArray(2)
	if(IsF2LFromIndexsOfNonF2L(ArrayOfNonF2L)) DrawEncourageF2L(2)
	GetNonF2LArray(3)
	if(IsF2LFromIndexsOfNonF2L(ArrayOfNonF2L)) DrawEncourageF2L(3)
	GetNonF2LArray(4)
	if(IsF2LFromIndexsOfNonF2L(ArrayOfNonF2L)) DrawEncourageF2L(4)
	GetNonF2LArray(5)
	if(IsF2LFromIndexsOfNonF2L(ArrayOfNonF2L)) DrawEncourageF2L(5)

}
IsF2LFromIndexsOfNonF2L(NonF2L[])
{
	new i =0
	new k = 0
	new isF2L = 0
	printf("Starting Search for F2L\r\n")
	for(i=0;i<54;i++)
	{
		if(g_cube[i]!=g_solvedCube[i]) 
		{
			printf("Index:%d Current Cube:%d Solved Cube:%d\r\n",i,g_cube[i],g_solvedCube[i])
			isF2L = 0
			for(k=0;k<21;k++)
			{	
				//printf("Checking if(%d==%d).  If so incrementing isF2L:%d\r\n",i,ArrayOfNonF2L[k],isF2L)
				if(i == ArrayOfNonF2L[k]) isF2L++
			}
			if(isF2L<=0) 
			{
				printf("No F2L found because of index:%d.\r\n",i)
				return 0
			}
		}
	}	
	printf("F2L Done!!!!\r\n")
	return 1
}
GetNonF2LArray(sideNumber)
{
	new Indexes[21] 
	if(sideNumber==0)//Blue
	{
		Indexes[0] = 36
		Indexes[1] = 37
		Indexes[2] = 38
		Indexes[3] = 29
		Indexes[4] = 32
		Indexes[5] = 35
		Indexes[6] = 51
		Indexes[7] = 52
		Indexes[8] = 53
		Indexes[9] = 18
		Indexes[10] = 21
		Indexes[11] = 24
		Indexes[12] = 9
		Indexes[13] = 10
		Indexes[14] = 11
		Indexes[15] = 12
		Indexes[16] = 13
		Indexes[17] = 14
		Indexes[18] = 15
		Indexes[19] = 16
		Indexes[20] = 17
	}
	if(sideNumber==1)//Green
	{
		Indexes[0]  = 0
		Indexes[1]  = 1
		Indexes[2]  = 2
		Indexes[3]  = 3
		Indexes[4]  = 4
		Indexes[5]  = 5
		Indexes[6]  = 6
		Indexes[7]  = 7
		Indexes[8]  = 8
		Indexes[9]  = 42
		Indexes[10] = 43
		Indexes[11] = 44
		Indexes[12] = 45
		Indexes[13] = 46
		Indexes[14] = 47
		Indexes[15] = 20
		Indexes[16] = 23
		Indexes[17] = 26
		Indexes[18] = 27
		Indexes[19] = 30
		Indexes[20] = 33
	}
	if(sideNumber==2)//Yellow
	{
		Indexes[0]  = 2
		Indexes[1]  = 5
		Indexes[2]  = 8
		Indexes[3]  = 27
		Indexes[4]  = 28
		Indexes[5]  = 29
		Indexes[6]  = 30
		Indexes[7]  = 31
		Indexes[8]  = 32
		Indexes[9]  = 33
		Indexes[10] = 34
		Indexes[11] = 35
		Indexes[12] = 47
		Indexes[13] = 50
		Indexes[14] = 53
		Indexes[15] = 9
		Indexes[16] = 12
		Indexes[17] = 15
		Indexes[18] = 44
		Indexes[19] = 41
		Indexes[20] = 38
	}
	if(sideNumber==3)//White
	{
		Indexes[0]  = 18
		Indexes[1]  = 19
		Indexes[2]  = 20
		Indexes[3]  = 21
		Indexes[4]  = 22
		Indexes[5]  = 23
		Indexes[6]  = 24
		Indexes[7]  = 25
		Indexes[8]  = 26
		Indexes[9]  = 0
		Indexes[10] = 3
		Indexes[11] = 6
		Indexes[12] = 36
		Indexes[13] = 39
		Indexes[14] = 42
		Indexes[15] = 45
		Indexes[16] = 48
		Indexes[17] = 51
		Indexes[18] = 11
		Indexes[19] = 14
		Indexes[20] = 17
	}
	if(sideNumber==4)//Red
	{
		Indexes[0]  = 45
		Indexes[1]  = 46
		Indexes[2]  = 47
		Indexes[3]  = 48
		Indexes[4]  = 49
		Indexes[5]  = 50
		Indexes[6]  = 51
		Indexes[7]  = 52
		Indexes[8]  = 53
		Indexes[9]  = 6
		Indexes[10] = 7
		Indexes[11] = 8
		Indexes[12] = 24
		Indexes[13] = 25
		Indexes[14] = 26
		Indexes[15] = 33
		Indexes[16] = 34
		Indexes[17] = 35
		Indexes[18] = 15
		Indexes[19] = 16
		Indexes[20] = 17
	}
	if(sideNumber==5)//Orange
	{
		Indexes[0]  = 36
		Indexes[1]  = 37
		Indexes[2]  = 38
		Indexes[3]  = 39
		Indexes[4]  = 40
		Indexes[5]  = 41
		Indexes[6]  = 42
		Indexes[7]  = 43
		Indexes[8]  = 44
		Indexes[9]  = 0
		Indexes[10] = 1
		Indexes[11] = 2
		Indexes[12] = 27
		Indexes[13] = 28
		Indexes[14] = 29
		Indexes[15] = 9
		Indexes[16] = 10
		Indexes[17] = 11
		Indexes[18] = 18
		Indexes[19] = 19
		Indexes[20] = 20
	}
	ArrayOfNonF2L = Indexes
}

DrawEncourageF2L(sideNumber)
{
	Play("startapp")
	
	printf("Starting F2L flash Side Number: %d\r\n",sideNumber)
	new temp[54]
	PushPopInit(temp)
	PushCanvas(0)
	new i=0
	for(i=0;i<1600;i++)
	{
		if(sideNumber==0)
		{
			SetColor(KEN_BLUE)
			DrawFlicker(_w(0))//,20,1,i)
			DrawFlicker(_w(1))//,20,1,i)
			DrawFlicker(_w(3))//,20,1,i)
			DrawFlicker(_w(4))//,20,1,i)
			DrawFlicker(_w(5))//,20,1,i)
			DrawFlicker(_w(6))//,20,1,i)
			DrawFlicker(_w(7))//,20,1,i)
			DrawFlicker(_w(8))//,20,1,i)
			SetColor(KEN_RED)
			DrawFlicker(_w(39))//,20,1,i)
			DrawFlicker(_w(40))//,20,1,i)
			DrawFlicker(_w(41))//,20,1,i)
			DrawFlicker(_w(42))//,20,1,i)
			DrawFlicker(_w(43))//,20,1,i)
			DrawFlicker(_w(44))//,20,1,i)
			SetColor(KEN_WHITE)
			DrawFlicker(_w(27))//,20,1,i)
			DrawFlicker(_w(28))//,20,1,i)
			DrawFlicker(_w(30))//,20,1,i)
			DrawFlicker(_w(31))//,20,1,i)
			DrawFlicker(_w(33))//,20,1,i)
			DrawFlicker(_w(34))//,20,1,i)
			SetColor(KEN_ORANGE)
			DrawFlicker(_w(45))//,20,1,i)
			DrawFlicker(_w(46))//,20,1,i)
			DrawFlicker(_w(47))//,20,1,i)
			DrawFlicker(_w(48))//,20,1,i)
			DrawFlicker(_w(49))//,20,1,i)
			DrawFlicker(_w(50))//,20,1,i)
			SetColor(KEN_YELLOW)
			DrawFlicker(_w(19))//,20,1,i)
			DrawFlicker(_w(20))//,20,1,i)
			DrawFlicker(_w(22))//,20,1,i)
			DrawFlicker(_w(23))//,20,1,i)
			DrawFlicker(_w(25))//,20,1,i)
			DrawFlicker(_w(26))//,20,1,i)
			PrintCanvas()
		}
		if(sideNumber==1) //Green
		{
			SetColor(KEN_GREEN)
			DrawFlicker(_w(9))//,20,1,i)
			DrawFlicker(_w(10))//,20,1,i)
			DrawFlicker(_w(11))//,20,1,i)
			DrawFlicker(_w(12))//,20,1,i)
			DrawFlicker(_w(13))//,20,1,i)
			DrawFlicker(_w(14))//,20,1,i)
			DrawFlicker(_w(15))//,20,1,i)
			DrawFlicker(_w(16))//,20,1,i)
			SetColor(KEN_RED)
			DrawFlicker(_w(39))//,20,1,i)
			DrawFlicker(_w(40))//,20,1,i)
			DrawFlicker(_w(41))//,20,1,i)
			DrawFlicker(_w(36))//,20,1,i)
			DrawFlicker(_w(37))//,20,1,i)
			DrawFlicker(_w(38))//,20,1,i)
			SetColor(KEN_WHITE)
			DrawFlicker(_w(29))//,20,1,i)
			DrawFlicker(_w(28))//,20,1,i)
			DrawFlicker(_w(32))//,20,1,i)
			DrawFlicker(_w(31))//,20,1,i)
			DrawFlicker(_w(35))//,20,1,i)
			DrawFlicker(_w(34))//,20,1,i)
			SetColor(KEN_ORANGE)
			DrawFlicker(_w(51))//,20,1,i)
			DrawFlicker(_w(52))//,20,1,i)
			DrawFlicker(_w(53))//,20,1,i)
			DrawFlicker(_w(48))//,20,1,i)
			DrawFlicker(_w(49))//,20,1,i)
			DrawFlicker(_w(50))//,20,1,i)
			SetColor(KEN_YELLOW)
			DrawFlicker(_w(19))//,20,1,i)
			DrawFlicker(_w(18))//,20,1,i)
			DrawFlicker(_w(22))//,20,1,i)
			DrawFlicker(_w(21))//,20,1,i)
			DrawFlicker(_w(25))//,20,1,i)
			DrawFlicker(_w(24))//,20,1,i)
			PrintCanvas()
		}
		if(sideNumber==2) //YELLOW
		{
			SetColor(KEN_YELLOW)
			DrawFlicker(_w(18))//,20,1,i)
			DrawFlicker(_w(19))//,20,1,i)
			DrawFlicker(_w(20))//,20,1,i)
			DrawFlicker(_w(21))//,20,1,i)
			DrawFlicker(_w(22))//,20,1,i)
			DrawFlicker(_w(23))//,20,1,i)
			DrawFlicker(_w(24))//,20,1,i)
			DrawFlicker(_w(25))//,20,1,i)
			SetColor(KEN_RED)
			DrawFlicker(_w(36))//,20,1,i)
			DrawFlicker(_w(37))//,20,1,i)
			DrawFlicker(_w(39))//,20,1,i)
			DrawFlicker(_w(40))//,20,1,i)
			DrawFlicker(_w(42))//,20,1,i)
			DrawFlicker(_w(43))//,20,1,i)
			SetColor(KEN_GREEN)
			DrawFlicker(_w(10))//,20,1,i)
			DrawFlicker(_w(11))//,20,1,i)
			DrawFlicker(_w(13))//,20,1,i)
			DrawFlicker(_w(14))//,20,1,i)
			DrawFlicker(_w(16))//,20,1,i)
			DrawFlicker(_w(17))//,20,1,i)
			SetColor(KEN_ORANGE)
			DrawFlicker(_w(45))//,20,1,i)
			DrawFlicker(_w(46))//,20,1,i)
			DrawFlicker(_w(48))//,20,1,i)
			DrawFlicker(_w(49))//,20,1,i)
			DrawFlicker(_w(51))//,20,1,i)
			DrawFlicker(_w(52))//,20,1,i)
			SetColor(KEN_BLUE)
			DrawFlicker(_w(0))//,20,1,i)
			DrawFlicker(_w(1))//,20,1,i)
			DrawFlicker(_w(3))//,20,1,i)
			DrawFlicker(_w(4))//,20,1,i)
			DrawFlicker(_w(6))//,20,1,i)
			DrawFlicker(_w(7))//,20,1,i)
			PrintCanvas()
		}
		if(sideNumber==3) //WHITE
		{
			SetColor(KEN_WHITE)
			DrawFlicker(_w(27))//,20,1,i)
			DrawFlicker(_w(28))//,20,1,i)
			DrawFlicker(_w(29))//,20,1,i)
			DrawFlicker(_w(30))//,20,1,i)
			DrawFlicker(_w(31))//,20,1,i)
			DrawFlicker(_w(32))//,20,1,i)
			DrawFlicker(_w(33))//,20,1,i)
			DrawFlicker(_w(34))//,20,1,i)
			SetColor(KEN_RED)
			DrawFlicker(_w(38))//,20,1,i)
			DrawFlicker(_w(37))//,20,1,i)
			DrawFlicker(_w(41))//,20,1,i)
			DrawFlicker(_w(40))//,20,1,i)
			DrawFlicker(_w(44))//,20,1,i)
			DrawFlicker(_w(43))//,20,1,i)
			SetColor(KEN_GREEN)
			DrawFlicker(_w(10))//,20,1,i)
			DrawFlicker(_w(9))//,20,1,i)
			DrawFlicker(_w(13))//,20,1,i)
			DrawFlicker(_w(12))//,20,1,i)
			DrawFlicker(_w(16))//,20,1,i)
			DrawFlicker(_w(15))//,20,1,i)
			SetColor(KEN_ORANGE)
			DrawFlicker(_w(47))//,20,1,i)
			DrawFlicker(_w(46))//,20,1,i)
			DrawFlicker(_w(50))//,20,1,i)
			DrawFlicker(_w(49))//,20,1,i)
			DrawFlicker(_w(53))//,20,1,i)
			DrawFlicker(_w(52))//,20,1,i)
			SetColor(KEN_BLUE)
			DrawFlicker(_w(2))//,20,1,i)
			DrawFlicker(_w(1))//,20,1,i)
			DrawFlicker(_w(5))//,20,1,i)
			DrawFlicker(_w(4))//,20,1,i)
			DrawFlicker(_w(8))//,20,1,i)
			DrawFlicker(_w(7))//,20,1,i)
			PrintCanvas()
		}
		if(sideNumber==4) //RED
		{
			SetColor(KEN_RED)
			DrawFlicker(_w(36))//,20,1,i)
			DrawFlicker(_w(37))//,20,1,i)
			DrawFlicker(_w(38))//,20,1,i)
			DrawFlicker(_w(39))//,20,1,i)
			DrawFlicker(_w(40))//,20,1,i)
			DrawFlicker(_w(41))//,20,1,i)
			DrawFlicker(_w(42))//,20,1,i)
			DrawFlicker(_w(43))//,20,1,i)
			DrawFlicker(_w(44))//,20,1,i)
			SetColor(KEN_WHITE)
			DrawFlicker(_w(27))//,20,1,i)
			DrawFlicker(_w(28))//,20,1,i)
			DrawFlicker(_w(29))//,20,1,i)
			DrawFlicker(_w(30))//,20,1,i)
			DrawFlicker(_w(31))//,20,1,i)
			DrawFlicker(_w(32))//,20,1,i)
			SetColor(KEN_GREEN)
			DrawFlicker(_w(10))//,20,1,i)
			DrawFlicker(_w(9))//,20,1,i)
			DrawFlicker(_w(13))//,20,1,i)
			DrawFlicker(_w(12))//,20,1,i)
			DrawFlicker(_w(11))//,20,1,i)
			DrawFlicker(_w(14))//,20,1,i)
			SetColor(KEN_YELLOW)
			DrawFlicker(_w(18))//,20,1,i)
			DrawFlicker(_w(19))//,20,1,i)
			DrawFlicker(_w(20))//,20,1,i)
			DrawFlicker(_w(21))//,20,1,i)
			DrawFlicker(_w(22))//,20,1,i)
			DrawFlicker(_w(23))//,20,1,i)
			SetColor(KEN_BLUE)
			DrawFlicker(_w(2))//,20,1,i)
			DrawFlicker(_w(1))//,20,1,i)
			DrawFlicker(_w(5))//,20,1,i)
			DrawFlicker(_w(4))//,20,1,i)
			DrawFlicker(_w(3))//,20,1,i)
			DrawFlicker(_w(0))//,20,1,i)
			PrintCanvas()
		}
		if(sideNumber==5) //ORANGE
		{
			SetColor(KEN_ORANGE)
			DrawFlicker(_w(45))//,20,1,i)
			DrawFlicker(_w(46))//,20,1,i)
			DrawFlicker(_w(47))//,20,1,i)
			DrawFlicker(_w(48))//,20,1,i)
			DrawFlicker(_w(49))//,20,1,i)
			DrawFlicker(_w(50))//,20,1,i)
			DrawFlicker(_w(51))//,20,1,i)
			DrawFlicker(_w(52))//,20,1,i)
			DrawFlicker(_w(53))//,20,1,i)
			SetColor(KEN_WHITE)
			DrawFlicker(_w(33))//,20,1,i)
			DrawFlicker(_w(34))//,20,1,i)
			DrawFlicker(_w(35))//,20,1,i)
			DrawFlicker(_w(30))//,20,1,i)
			DrawFlicker(_w(31))//,20,1,i)
			DrawFlicker(_w(32))//,20,1,i)
			SetColor(KEN_GREEN)
			DrawFlicker(_w(15))//,20,1,i)
			DrawFlicker(_w(16))//,20,1,i)
			DrawFlicker(_w(13))//,20,1,i)
			DrawFlicker(_w(12))//,20,1,i)
			DrawFlicker(_w(17))//,20,1,i)
			DrawFlicker(_w(14))//,20,1,i)
			SetColor(KEN_YELLOW)
			DrawFlicker(_w(24))//,20,1,i)
			DrawFlicker(_w(25))//,20,1,i)
			DrawFlicker(_w(26))//,20,1,i)
			DrawFlicker(_w(21))//,20,1,i)
			DrawFlicker(_w(22))//,20,1,i)
			DrawFlicker(_w(23))//,20,1,i)
			SetColor(KEN_BLUE)
			DrawFlicker(_w(7))//,20,1,i)
			DrawFlicker(_w(6))//,20,1,i)
			DrawFlicker(_w(5))//,20,1,i)
			DrawFlicker(_w(4))//,20,1,i)
			DrawFlicker(_w(3))//,20,1,i)
			DrawFlicker(_w(8))//,20,1,i)
			PrintCanvas()
		}
	}
	PopCanvas(0)
	PrintCanvas()
	//g_NeedsF2LEncouragment = 0
}

IsCross()
{
	if(CheckCross(0)) DrawEncourageCross(0)
	if(CheckCross(1)) DrawEncourageCross(1)
	if(CheckCross(2)) DrawEncourageCross(2)
	if(CheckCross(3)) DrawEncourageCross(3)
	if(CheckCross(4)) DrawEncourageCross(4)
	if(CheckCross(5)) DrawEncourageCross(5)
}
CheckCross(sideNumber)
{	//For Cross on side 0 (Blue): indexes of cross are: 1,3,4,5,7,43,30,49,23
	if(g_cube[1]==g_solvedCube[1] && g_cube[3]==g_solvedCube[3]&& g_cube[4]==g_solvedCube[4]&& g_cube[5]==g_solvedCube[5]&& g_cube[7]==g_solvedCube[7]&& g_cube[43]==g_solvedCube[43]&& g_cube[30]==g_solvedCube[30]&& g_cube[46]==g_solvedCube[46]&& g_cube[23]==g_solvedCube[23])
	{ 
		printf("Found Blue Cross on side 0\r\n");
		if(sideNumber==0) return 1
	}
	//For Cross on side 1 (Green): indexes of cross are: 10,12,13,14,16 32,52,41,21
	if(g_cube[10]==g_solvedCube[10] && g_cube[12]==g_solvedCube[12]&& g_cube[13]==g_solvedCube[13]&& g_cube[14]==g_solvedCube[14]&& g_cube[16]==g_solvedCube[16]&& g_cube[32]==g_solvedCube[32]&& g_cube[52]==g_solvedCube[52]&& g_cube[37]==g_solvedCube[37]&& g_cube[21]==g_solvedCube[21])
	{ 
		printf("Found Green Cross on side 1\r\n");
		if(sideNumber==1) return 1
	}
	//For Cross on side 2 (Yellow): indexes of cross are: 19,21,22,23,25,3,48,39,14
	if(g_cube[19]==g_solvedCube[19] && g_cube[21]==g_solvedCube[21]&& g_cube[22]==g_solvedCube[22]&& g_cube[23]==g_solvedCube[23]&& g_cube[25]==g_solvedCube[25]&& g_cube[3]==g_solvedCube[3]&& g_cube[48]==g_solvedCube[48]&& g_cube[39]==g_solvedCube[39]&& g_cube[14]==g_solvedCube[14])
	{ 
		printf("Found Yellow Cross on side 2\r\n");
		if(sideNumber==2) return 1
	}
	//For Cross on side 3 (WHITE): indexes of cross are: 28,30,31,32,34,41,12,50,5
	if(g_cube[28]==g_solvedCube[28] && g_cube[30]==g_solvedCube[30]&& g_cube[31]==g_solvedCube[31]&& g_cube[32]==g_solvedCube[32]&& g_cube[34]==g_solvedCube[34]&& g_cube[41]==g_solvedCube[41]&& g_cube[12]==g_solvedCube[12]&& g_cube[50]==g_solvedCube[50]&& g_cube[5]==g_solvedCube[5])
	{ 
		printf("Found White Cross on side 3\r\n");
		if(sideNumber==3) return 1
	}
	//For Cross on side 4 (RED): indexes of cross are: 37, 39,40,41,43,1,28,10,19
	if(g_cube[37]==g_solvedCube[37] && g_cube[39]==g_solvedCube[39]&& g_cube[40]==g_solvedCube[40]&& g_cube[41]==g_solvedCube[41]&& g_cube[43]==g_solvedCube[43]&& g_cube[1]==g_solvedCube[1]&& g_cube[28]==g_solvedCube[28]&& g_cube[10]==g_solvedCube[10]&& g_cube[19]==g_solvedCube[19])
	{ 
		printf("Found RED Cross on side 4\r\n");
		if(sideNumber==4) return 1
	}
	//For Cross on side 5 (Orange): indexes of cross are: 46,48,49,50,52,7,34,16,25
	if(g_cube[46]==g_solvedCube[46] && g_cube[48]==g_solvedCube[48]&& g_cube[49]==g_solvedCube[49]&& g_cube[50]==g_solvedCube[50]&& g_cube[52]==g_solvedCube[52]&& g_cube[7]==g_solvedCube[7]&& g_cube[34]==g_solvedCube[34]&& g_cube[16]==g_solvedCube[16]&& g_cube[25]==g_solvedCube[25])
	{ 
		printf("Found Orange Cross on side 5\r\n");
		if(sideNumber==5) return 1
	}
	return 0
}
DrawEncourageCross(sideNumber)
{
	Play("startapp")
	new i =0
	
	printf("Starting cross flash Side Number: %d\r\n",sideNumber)
	new temp[54]
	PushPopInit(temp)
	PushCanvas(0)
	for(i=0;i<1600;i++)
	{
		if(sideNumber==0)
		{
			SetColor(KEN_BLUE)
			DrawFlicker(_w(1))//,20,1,i)
			DrawFlicker(_w(3))//,20,1,i)
			DrawFlicker(_w(4))//,20,1,i)
			DrawFlicker(_w(5))//,20,1,i)
			DrawFlicker(_w(7))//,20,1,i)
			SetColor(KEN_RED)
			DrawFlicker(_w(40))//,20,1,i)
			DrawFlicker(_w(43))//,20,1,i)
			SetColor(KEN_WHITE)
			DrawFlicker(_w(30))//,20,1,i)
			DrawFlicker(_w(31))//,20,1,i)
			SetColor(KEN_ORANGE)
			DrawFlicker(_w(46))//,20,1,i)
			DrawFlicker(_w(49))//,20,1,i)
			SetColor(KEN_YELLOW)
			DrawFlicker(_w(23))//,20,1,i)
			DrawFlicker(_w(22))//,20,1,i)
			PrintCanvas()
		}
		if(sideNumber==1)
		{
			SetColor(KEN_GREEN)
			DrawFlicker(_w(10))//,20,1,i)
			DrawFlicker(_w(12))//,20,1,i)
			DrawFlicker(_w(13))//,20,1,i)
			DrawFlicker(_w(14))//,20,1,i)
			DrawFlicker(_w(16))//,20,1,i)
			SetColor(KEN_RED)
			DrawFlicker(_w(37))//,20,1,i)
			DrawFlicker(_w(40))//,20,1,i)
			SetColor(KEN_WHITE)
			DrawFlicker(_w(31))//,20,1,i)
			DrawFlicker(_w(32))//,20,1,i)
			SetColor(KEN_YELLOW)
			DrawFlicker(_w(22))//,20,1,i)
			DrawFlicker(_w(21))//,20,1,i)
			SetColor(KEN_ORANGE)
			DrawFlicker(_w(52))//,20,1,i)
			DrawFlicker(_w(49))//,20,1,i)
			PrintCanvas()
		}
		if(sideNumber==2)  //YELLOW SIDE
		{
			SetColor(KEN_YELLOW)
			DrawFlicker(_w(19))//,20,1,i)
			DrawFlicker(_w(21))//,20,1,i)
			DrawFlicker(_w(22))//,20,1,i)
			DrawFlicker(_w(23))//,20,1,i)
			DrawFlicker(_w(25))//,20,1,i)
			SetColor(KEN_RED)
			DrawFlicker(_w(39))//,20,1,i)
			DrawFlicker(_w(40))//,20,1,i)
			SetColor(KEN_GREEN)
			DrawFlicker(_w(13))//,20,1,i)
			DrawFlicker(_w(14))//,20,1,i)
			SetColor(KEN_BLUE)
			DrawFlicker(_w(3))//,20,1,i)
			DrawFlicker(_w(4))//,20,1,i)
			SetColor(KEN_ORANGE)
			DrawFlicker(_w(48))//,20,1,i)
			DrawFlicker(_w(49))//,20,1,i)
			PrintCanvas()
		}
		if(sideNumber==3)  //WHITE SIDE
		{
			SetColor(KEN_WHITE)
			DrawFlicker(_w(28))//,20,1,i)
			DrawFlicker(_w(30))//,20,1,i)
			DrawFlicker(_w(31))//,20,1,i)
			DrawFlicker(_w(32))//,20,1,i)
			DrawFlicker(_w(34))//,20,1,i)
			SetColor(KEN_RED)
			DrawFlicker(_w(41))//,20,1,i)
			DrawFlicker(_w(40))//,20,1,i)
			SetColor(KEN_GREEN)
			DrawFlicker(_w(12))//,20,1,i)
			DrawFlicker(_w(13))//,20,1,i)
			SetColor(KEN_BLUE)
			DrawFlicker(_w(5))//,20,1,i)
			DrawFlicker(_w(4))//,20,1,i)
			SetColor(KEN_ORANGE)
			DrawFlicker(_w(46))//,20,1,i)
			DrawFlicker(_w(49))//,20,1,i)
			PrintCanvas()
		}
		if(sideNumber==4)  //RED SIDE
		{
			SetColor(KEN_RED)
			DrawFlicker(_w(37))//,20,1,i)
			DrawFlicker(_w(39))//,20,1,i)
			DrawFlicker(_w(40))//,20,1,i)
			DrawFlicker(_w(41))//,20,1,i)
			DrawFlicker(_w(43))//,20,1,i)
			SetColor(KEN_WHITE)
			DrawFlicker(_w(28))//,20,1,i)
			DrawFlicker(_w(31))//,20,1,i)
			SetColor(KEN_GREEN)
			DrawFlicker(_w(10))//,20,1,i)
			DrawFlicker(_w(13))//,20,1,i)
			SetColor(KEN_BLUE)
			DrawFlicker(_w(1))//,20,1,i)
			DrawFlicker(_w(4))//,20,1,i)
			SetColor(KEN_YELLOW)
			DrawFlicker(_w(19))//,20,1,i)
			DrawFlicker(_w(22))//,20,1,i)
			PrintCanvas()
		}
		if(sideNumber==5)  //Orange SIDE
		{
			SetColor(KEN_ORANGE)
			DrawFlicker(_w(46))//,20,1,i)
			DrawFlicker(_w(48))//,20,1,i)
			DrawFlicker(_w(49))//,20,1,i)
			DrawFlicker(_w(50))//,20,1,i)
			DrawFlicker(_w(52))//,20,1,i)
			SetColor(KEN_WHITE)
			DrawFlicker(_w(34))//,20,1,i)
			DrawFlicker(_w(31))//,20,1,i)
			SetColor(KEN_GREEN)
			DrawFlicker(_w(16))//,20,1,i)
			DrawFlicker(_w(13))//,20,1,i)
			SetColor(KEN_BLUE)
			DrawFlicker(_w(7))//,20,1,i)
			DrawFlicker(_w(4))//,20,1,i)
			SetColor(KEN_YELLOW)
			DrawFlicker(_w(25))//,20,1,i)
			DrawFlicker(_w(22))//,20,1,i)
			PrintCanvas()
		}
	}
	PopCanvas(0)
	PrintCanvas()
	g_NeedsCrossEncouragment = 0
}
IsCubeSolved()
{
	new i
	new bSolved =1
	for(i=0; i<54; i++) 
	{
		if(g_cube[i]!=g_solvedCube[i]) bSolved=0
	}
	return bSolved
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
   temp=g_cube[belt[0]]
   for (i=0;i<(lenght-1);i++)
    g_cube[belt[i]]=g_cube[belt[i+1]]
   g_cube[belt[lenght-1]]=temp
  }
  else
  {
   temp=g_cube[belt[lenght-1]]
   for (i=lenght-1;i>0;i--)
    g_cube[belt[i]]=g_cube[belt[i-1]]
   g_cube[belt[0]]=temp
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