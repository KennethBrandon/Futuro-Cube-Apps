//Play_All_Sounds.p
//By Kenneth BRandon July 2013
//This is test program to play each sound.
//Tapping on the Red Side goes to the next sound
//Tapping on the Blue Side goes to the previous sound
//Tapping on the White Side plays the current sound
//
// 

#include <futurocube>
new numberOfFiles
//new Files[numberOfFiles][18]  //Huge File Array...  Holds all of the file names.
new CurrentSoundIndex =16
new PlayAllSounds_var[]=[VAR_MAGIC1,VAR_MAGIC2,''PlayAllSounds'']
new motion  
new kick_side 
new StoredVariables[1]
new FileName{20}
new cursor 
new CurrentSide
new walker

new icon[]=[ICON_MAGIC1,ICON_MAGIC2,1,4,RED,0,0,RED,RED,0,RED,0,0,''ballhit'',''hitrims1''] //ICON_MAGIC1,ICON_MAGIC2,Menu Number,Side Number,9 cell colors,Name sound,Info/About/Description sound
main()   //Main!
{ 
    ICON(icon)
	RegisterVariable(PlayAllSounds_var)
	numberOfFiles = GetNumberOfFiles()
	printf("number of files: %d\n", numberOfFiles );
	//SetFileNames()  //Creates
	DrawMyCube()
	if (!LoadVariable(''PlayAllSounds'',StoredVariables) || IsGameResetRequest())
	{
		printf("Could not find Last file played... Will start from the beggining. \r\n")
		CurrentSoundIndex =1
	}
	else
	{
		CurrentSoundIndex = StoredVariables[0]
		if(CurrentSoundIndex>numberOfFiles) CurrentSoundIndex = numberOfFiles
		//GetFileName(CurrentSoundIndex)
		//printf("Loaded StoredVariables... Starting on index: %d, File: %s\r\n",CurrentSoundIndex,FileName)
	}


	RegAllSideTaps()
	for(;;)
	{
		Sleep()
		motion = Motion()
		cursor = GetCursor()
		CurrentSide = _side(GetCursor())
		if(CurrentSide==4||CurrentSide==5)DrawNormalMinus()  //This keeps the blue - sign horizontal 
		if(CurrentSide==1||CurrentSide==0)Draw90Minus()     // This keeps the - sign horizontal
		DrawPlayButton(CurrentSide)  //Keeps the Play button horizontal and facing the right way
		if(motion)
		{
			AckMotion()
			kick_side=eTapSide();
			DeterminWhatToDoWithMotionAndDo(kick_side)
			DoPlayAnimation()
			printf("Current Cursor: %d Current Walker: %d Current Side: %d \r\n", cursor, walker, CurrentSide)
		}
		AckMotion()
	}
}
DrawPlayButton(sideNumber)  //Side number of the top face
{
	if(sideNumber==4)
	{
		SetColor(0x00000000)
		DrawSide(1)
		SetColor(WHITE)
		DrawPoint(_w(1,0))
		DrawPoint(_w(1,3))
		DrawPoint(_w(1,4))
		DrawPoint(_w(1,6))
	}
	if(sideNumber==5)
	{
		SetColor(0x00000000)
		DrawSide(1)
		SetColor(WHITE)	
		DrawPoint(_w(1,2))
		DrawPoint(_w(1,4))
		DrawPoint(_w(1,5))
		DrawPoint(_w(1,8))
	}
	if(sideNumber==2)
	{
		SetColor(0x00000000)
		DrawSide(1)
		SetColor(WHITE)	
		DrawPoint(_w(1,0))
		DrawPoint(_w(1,1))
		DrawPoint(_w(1,2))
		DrawPoint(_w(1,4))
	}
	if(sideNumber==3)
	{
		SetColor(0x00000000)
		DrawSide(1)
		SetColor(WHITE)	
		DrawPoint(_w(1,4))
		DrawPoint(_w(1,6))
		DrawPoint(_w(1,7))
		DrawPoint(_w(1,8))
	}
	
	PrintCanvas()
}
DrawPauseButton(sideNumber)
{
	if(sideNumber==2||sideNumber==3)
	{
		SetColor(0x00000000)
		DrawSide(1)
		SetColor(WHITE)
		DrawPoint(_w(1,0))
		DrawPoint(_w(1,1))
		DrawPoint(_w(1,2))
		DrawPoint(_w(1,6))
		DrawPoint(_w(1,7))
		DrawPoint(_w(1,8))
	}
	if(sideNumber==5||sideNumber==4)
	{
		SetColor(0x00000000)
		DrawSide(1)
		SetColor(WHITE)
		DrawPoint(_w(1,0))
		DrawPoint(_w(1,3))
		DrawPoint(_w(1,6))
		DrawPoint(_w(1,2))
		DrawPoint(_w(1,5))
		DrawPoint(_w(1,8))
	}
	PrintCanvas()
}
DrawNormalMinus()
{
	SetColor(0x00000000)
	DrawSide(3)
	SetColor(BLUE)
	DrawPoint(_w(3,3))
	DrawPoint(_w(3,4))
	DrawPoint(_w(3,5))
	PrintCanvas()
	
}
Draw90Minus()
{
	SetColor(0x00000000)
	DrawSide(3)
	SetColor(BLUE)
	DrawPoint(_w(3,1))
	DrawPoint(_w(3,4))
	DrawPoint(_w(3,7))
	PrintCanvas()
}
DeterminWhatToDoWithMotionAndDo(side)
{
	printf("In function DeterminWhatToDoWithMotionAndDoit \r\n")
	if(side==2) 
	{
		IncrementAndPlay() 
	}
	if(side==1)
	{
		if(IsPlayOver())
		{
			PlayCurrent() 
		}
		else Quiet()
	}
	if(side==3) 
	{
		DecrementAndPlay() 
	}
	if(side==0||side==4||side==5)
	{
		/* I'd like to have it play the index number of the current track.    Not working */
		new string[4]
		snprintf(string,4,"%d",CurrentSoundIndex%10)
		if(CurrentSoundIndex<19)
		{
			snprintf(string,4,"%d",CurrentSoundIndex)
			Play(string)  
			WaitPlayOver()
		}
		else if(CurrentSoundIndex<100)
		{
			new Mod = CurrentSoundIndex%10
			
			snprintf(string,4,"%d",CurrentSoundIndex-Mod)
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
			new Mod100 = CurrentSoundIndex%100
			new Mod10 = Mod100%10
			snprintf(string,4,"%d",CurrentSoundIndex-Mod100)
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
}
IncrementAndPlay()
{
	//Quiet()
	if(CurrentSoundIndex<numberOfFiles)CurrentSoundIndex++
	PlayCurrent()
}
DecrementAndPlay()
{
	//Quiet()
	if(CurrentSoundIndex>1)CurrentSoundIndex--
	PlayCurrent()
}
PlayCurrent()
{
	StoredVariables[0] = CurrentSoundIndex
	StoreVariable(''PlayAllSounds'',StoredVariables) //Store current index for next use.
	//GetFileName(CurrentSoundIndex)
	//printf("Current index: %d, Current FileName: %s\r\n", CurrentSoundIndex,FileName)
	Quiet()
	PlayAtChNthFile(0,CurrentSoundIndex)
	//Play(FileName)
	printf("Played: %d\r\n", CurrentSoundIndex)
}
new r=0
new b=0
new g=0
new ToRed=1
new ToYellow=0
new ToGreen=0
new ToTeal=0
new ToPurple=0
new ToBlue=0
new BackToRed=0

DoPlayAnimation()
{
	for(;;)
	{
		Sleep()
		motion = Motion()
		if(motion) 
		{
			printf("Is Motion in Animation Loop\r\n");  //debuging
			kick_side=eTapSide();
			if(kick_side == 1 || kick_side == 2 || kick_side == 3)
			{
				Quiet() 
				printf("Motion in Animation Routine: Kick_Side: %d\r\n", kick_side)
				
				DeterminWhatToDoWithMotionAndDo(kick_side)
			}			
			AckMotion()
		}
		AckMotion()
		
		
		cursor = GetCursor()
		CurrentSide = _side(GetCursor())
		if(CurrentSide==4||CurrentSide==5)DrawNormalMinus()  //This keeps the blue - sign horizontal 
		if(CurrentSide==1||CurrentSide==0)Draw90Minus()     // This keeps the - sign horizontal
		DrawPauseButton(CurrentSide)  //Keeps the Play button horizontal and facing the right way
		
		if(ToRed)  //Should Be coming from black.. so adding up red
		{
			if(r>=255)
			{
				ToRed =0
				ToYellow =1
			}
			else r+=4
		}
		if(ToYellow) //Should be coming from red.. so adding up green
		{
			r=255
			if(g>=255)
			{
				ToYellow = 0
				ToGreen = 1
			}
			else g+=4
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
			else r-=4			
		}
		if(ToTeal) //Should be coming from green..  so adding blue
		{
			g=255
			if(b>=255)
			{
				ToTeal=0
				ToBlue=1
			}
			else b+=4
		}
		if(ToBlue) //Should be coming from teal... so droping green
		{
			b=255
			if(g<=0)
			{
				g=0
				ToBlue=0
				ToPurple=1
			}
			else g-=4
		}
		if(ToPurple) //Should be coming from blue.. so adding red
		{
			if(r>=255)
			{
				r=255
				ToPurple =0
				BackToRed =1
			}
			else r+=4
		}
		if(BackToRed) // first to red then to black
		{
			if(b<=0)
			{
				BackToRed=0
				ToYellow=1
			}
			else b-=4
		}
		if(r<0) r=0
		if(g<0) g=0
		if(b<0) b=0
		if(r>255) r=255
		if(g>255) g=255
		if(b>255) b=255
		//printf("Drawing Color R: %d G: %d B: %d\r\n",r,g,b)  //For Debuging
		if(IsPlayOver()) break
		SetRgbColor(r,g,b)
		DrawPoint(_w(0,0))
		DrawPoint(_w(0,1))
		DrawPoint(_w(0,2))
		DrawPoint(_w(0,3))
		DrawPoint(_w(0,4))
		DrawPoint(_w(0,5))
		DrawPoint(_w(0,6))
		DrawPoint(_w(0,7))
		DrawPoint(_w(0,8))
		DrawPoint(_w(4,0))
		DrawPoint(_w(4,1))
		DrawPoint(_w(4,2))
		DrawPoint(_w(4,3))
		DrawPoint(_w(4,4))
		DrawPoint(_w(4,5))
		DrawPoint(_w(4,6))
		DrawPoint(_w(4,7))
		DrawPoint(_w(4,8))
		DrawPoint(_w(5,0))
		DrawPoint(_w(5,1))
		DrawPoint(_w(5,2))
		DrawPoint(_w(5,3))
		DrawPoint(_w(5,4))
		DrawPoint(_w(5,5))
		DrawPoint(_w(5,6))
		DrawPoint(_w(5,7))
		DrawPoint(_w(5,8))
		PrintCanvas()
	}
	SetColor(0x00000000)
	DrawSide(0)
	DrawSide(4)
	DrawSide(5)
	PrintCanvas()
}


DrawMyCube()
{
	SetColor(0x00000000)
	DrawCube()
	SetIntensity(255)
	SetColor(RED)
	DrawCross(_w(2,4))
	SetColor(WHITE)
	DrawPoint(_w(1,0))
	DrawPoint(_w(1,4))
	DrawPoint(_w(1,5))
	DrawPoint(_w(1,6))
	SetColor(BLUE)
	DrawPoint(_w(3,3))
	DrawPoint(_w(3,4))
	DrawPoint(_w(3,5))
	PrintCanvas()
}
