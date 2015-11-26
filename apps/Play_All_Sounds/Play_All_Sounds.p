//Play_All_Sounds.p
//By Kenneth BRandon July 2013
//This is test program to play each sound.
//Tapping on the Red Side goes to the next sound
//Tapping on the Blue Side goes to the previous sound
//Tapping on the White Side plays the current sound
//
// 

#include <futurocube>
#define NUMBER_OF_FILES 273
//new Files[NUMBER_OF_FILES][18]  //Huge File Array...  Holds all of the file names.
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
		if(CurrentSoundIndex>NUMBER_OF_FILES) CurrentSoundIndex = NUMBER_OF_FILES
		GetFileName(CurrentSoundIndex)
		printf("Loaded StoredVariables... Starting on index: %d, File: %s\r\n",CurrentSoundIndex,FileName)
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
	if(CurrentSoundIndex<NUMBER_OF_FILES)CurrentSoundIndex++
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
	GetFileName(CurrentSoundIndex)
	printf("Current index: %d, Current FileName: %s\r\n", CurrentSoundIndex,FileName)
	Quiet()
	Play(FileName)
	printf("Played: %s\r\n", FileName)
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

GetFileName(count)
{             
	if(count==1) FileName = "applebite"
	if(count==2) FileName = "ballhit"
	if(count==3) FileName = "beep"
	if(count==4) FileName = "bell1"
	if(count==5) FileName = "bell2"
	if(count==6) FileName = "bongo"
	if(count==7) FileName = "BREATH"
	if(count==8) FileName = "bubble"
	if(count==9) FileName = "bubbles"
	if(count==10) FileName = "channel"
	if(count==11) FileName = "cink1"
	if(count==12) FileName = "cink2"
	if(count==13) FileName = "cink3"
	if(count==14) FileName = "clapping"
	if(count==15) FileName = "click"
	if(count==16) FileName = "clickhigh"
	if(count==17) FileName = "clocktickfast"
	if(count==18) FileName = "COMEANDFIND"
	if(count==19) FileName = "cont_rx"
	if(count==20) FileName = "cont_tx"
	if(count==21) FileName = "cube_move"
	if(count==22) FileName = "drip"
	if(count==23) FileName = "drums"
	if(count==24) FileName = "fanfare_short"
	if(count==25) FileName = "fanfarelong"
	if(count==26) FileName = "fcvoice1"
	if(count==27) FileName = "fcvoice2"
	if(count==28) FileName = "fcvoice3"
	if(count==29) FileName = "FORTYREWRITE"
	if(count==30) FileName = "FU3"
	if(count==31) FileName = "HAVOK"
	if(count==32) FileName = "hb"
	if(count==33) FileName = "heartbeat"
	if(count==34) FileName = "hitrims"
	if(count==35) FileName = "hitrims1"
	if(count==36) FileName = "hitrims2"
	if(count==37) FileName = "hitrims3"
	if(count==38) FileName = "INSTRM2"
	if(count==39) FileName = "kap"
	if(count==40) FileName = "konec-prohra"
	if(count==41) FileName = "PAGES"
	if(count==42) FileName = "power"
	if(count==43) FileName = "sfx_loose1"
	if(count==44) FileName = "sfx_win1"
	if(count==45) FileName = "short_silence"
	if(count==46) FileName = "snd1"
	if(count==47) FileName = "soko_back"
	if(count==48) FileName = "soko_level"
	if(count==49) FileName = "soko_no_stone"
	if(count==50) FileName = "soko_start"
	if(count==51) FileName = "soko_step1"
	if(count==52) FileName = "soko_step2"
	if(count==53) FileName = "soko_stone"
	if(count==54) FileName = "soko_win"
	if(count==55) FileName = "soko_wrong"
	if(count==56) FileName = "startapp"
	if(count==57) FileName = "stone_placed"
	if(count==58) FileName = "STRANGE"
	if(count==59) FileName = "TRAPPED"
	if(count==60) FileName = "TURNPAGE"
	if(count==61) FileName = "uff"
	if(count==62) FileName = "UFO"
	if(count==63) FileName = "vyhra"
	if(count==64) FileName = "vzum"
	if(count==65) FileName = "woodblock"
	if(count==66) FileName = "wrong_move"
	if(count==67) FileName = "1"     
	if(count==68) FileName = "10"
	if(count==69) FileName = "100"     //
	if(count==70) FileName = "11"     //
	if(count==71) FileName = "12"     //
	if(count==72) FileName = "13"     //
	if(count==73) FileName = "14"	
	if(count==74) FileName = "15"     //
	if(count==75) FileName = "16"     //
	if(count==76) FileName = "17"     //
	if(count==77) FileName = "18"     //
	if(count==78) FileName = "19"     //
	if(count==79) FileName = "2"     //
	if(count==80) FileName = "20"     //
	if(count==81) FileName = "200"     //
	if(count==82) FileName = "3"     //
	if(count==83) FileName = "30"     //
	if(count==84) FileName = "300"     //
	if(count==85) FileName = "4"     //
	if(count==86) FileName = "40"     //
	if(count==87) FileName = "400"     //
	if(count==88) FileName = "5"     //
	if(count==89) FileName = "50"     //
	if(count==90) FileName = "500"     //
	if(count==91) FileName = "6"     //
	if(count==92) FileName = "60"     //
	if(count==93) FileName = "600"     //
	if(count==94) FileName = "7"     //
	if(count==95) FileName = "70"     //
	if(count==96) FileName = "700"     //
	if(count==97) FileName = "8"     //
	if(count==98) FileName = "80"     //
	if(count==99) FileName = "800"     //
	if(count==100)FileName = "9"     //
	if(count==101) FileName = "90"     //
	if(count==102) FileName = "900"     //
	if(count==103) FileName = "_a#1"     //
	if(count==104) FileName = "_a#2"     //
	if(count==105) FileName = "_a#3"     //
	if(count==106) FileName = "_a#4"     //
	if(count==107) FileName = "_a1"     //
	if(count==108) FileName = "_a2"     //
	if(count==109) FileName = "_a3"     //
	if(count==110) FileName = "_a4"     //
	if(count==111) FileName = "_c#1"     //
	if(count==112) FileName = "_c#2"     //
	if(count==113) FileName = "_c#3"     //
	if(count==114) FileName = "_c#4"     //
	if(count==115) FileName = "_c1"     //
	if(count==116) FileName = "_c2"     //
	if(count==117) FileName = "_c3"     //
	if(count==118) FileName = "_c4"     //
	if(count==119) FileName = "_c5"     //
	if(count==120) FileName = "_c_DIFFGAMES"     
	if(count==121) FileName = "_c_ESTABLISHED"    
	if(count==122) FileName = "_c_MUSTRESTART"    
	if(count==123) FileName = "_c_WAITING"     //
	if(count==124) FileName = "_c_WAITOP"     //
	if(count==125) FileName = "_ch_CHARGEDONE"    
	if(count==126) FileName = "_ch_CHARGING"     
	if(count==127) FileName = "_chordAdur"     //
	if(count==128) FileName = "_chordCdur"     //
	if(count==129) FileName = "_chordDdur"     //
	if(count==130) FileName = "_chordEdur"     //
	if(count==131) FileName = "_chordFdur"     //
	if(count==132) FileName = "_chordGdur"     //
	if(count==133) FileName = "_chordHdur"     //
	if(count==134) FileName = "_d#1"     //
	if(count==135) FileName = "_d#2"     //
	if(count==136) FileName = "_d#3"     //
	if(count==137) FileName = "_d#4"     //
	if(count==138) FileName = "_d1"     //
	if(count==139) FileName = "_d2"     //
	if(count==140) FileName = "_d3"     //
	if(count==141) FileName = "_d4"     //
	if(count==142) FileName = "_d_17"     //
	if(count==143) FileName = "_d_AFRIKA"     //
	if(count==144) FileName = "_d_CONFESS"     //
	if(count==145) FileName = "_d_DO"     //
	if(count==146) FileName = "_d_EUROBEAT"     //
	if(count==147) FileName = "_d_EXP"     //
	if(count==148) FileName = "_d_EXPECT"     //
	if(count==149) FileName = "_d_MINDFULL"     //
	if(count==150) FileName = "_d_PIANO"     //
	if(count==151) FileName = "_d_SHAN"     //
	if(count==152) FileName = "_d_THERE"     //
	if(count==153) FileName = "_e1"     //
	if(count==154) FileName = "_e2"     //
	if(count==155) FileName = "_e3"     //
	if(count==156) FileName = "_e4"     //
	if(count==157) FileName = "_e_CONNECT"     //
	if(count==158) FileName = "_e_CUBRIS"     //
	if(count==159) FileName = "_e_DREAMQUEST"     
	if(count==160) FileName = "_e_GOMOKU"     //
	if(count==161) FileName = "_e_GRAVITYCH"     
	if(count==162) FileName = "_e_GRAVITYP"     //
	if(count==163) FileName = "_e_MULTICONNECT"   
	if(count==164) FileName = "_e_MULTICUBRIS"    
	if(count==165) FileName = "_e_MULTIGOMOKU"    
	if(count==166) FileName = "_e_PIANO"     //
	if(count==167) FileName = "_e_RINGDREAM"     
	if(count==168) FileName = "_e_ROADRUNNER"     
	if(count==169) FileName = "_e_SNAKE"     //
	if(count==170) FileName = "_e_SOKOBAN"     //
	if(count==171) FileName = "_e_TRANSPORT"     
	if(count==172) FileName = "_e_TUTORIAL"     //
	if(count==173) FileName = "_e_VOLUMECNTRL"    
	if(count==174) FileName = "_f#1"     //
	if(count==175) FileName = "_f#2"     //
	if(count==176) FileName = "_f#3"     //
	if(count==177) FileName = "_f#4"     //
	if(count==178) FileName = "_f1"     //
	if(count==179) FileName = "_f2"     //
	if(count==180) FileName = "_f4"     //
	if(count==181) FileName = "_g#1"     //
	if(count==182) FileName = "_g#2"     //
	if(count==183) FileName = "_g#3"     //
	if(count==184) FileName = "_g#4"     //
	if(count==185) FileName = "_g1"     //
	if(count==186) FileName = "_g2"     //
	if(count==187) FileName = "_g3"     //
	if(count==188) FileName = "_g4"     //
	if(count==189) FileName = "_g_CRASH"     //
	if(count==190) FileName = "_g_CRASH2"     //
	if(count==191) FileName = "_g_DRAWGAME"     //
	if(count==192) FileName = "_g_FORBIDDENPLACE" 
	if(count==193) FileName = "_g_SHUFFLING"     
	if(count==194) FileName = "_g_TAPFORSHUFFLE"  
	if(count==195) FileName = "_g_TAPTOSTART"     
	if(count==196) FileName = "_g_VOLUMECNTRL"    
	if(count==197) FileName = "_h1"     //
	if(count==198) FileName = "_h2"     //
	if(count==199) FileName = "_h3"     //
	if(count==200) FileName ="_h4"     //
	if(count==201) FileName = "_h_GAMEMENU"     //
	if(count==202) FileName = "_h_NOHELP"     //
	if(count==203) FileName = "_j_CONNECTIONLOST" 
	if(count==204) FileName = "_j_NEXTLEVEL"     
	if(count==205) FileName = "_j_TAPTHREETIMES"  
	if(count==206) FileName = "_m_MENUA"     //
	if(count==207) FileName = "_m_MENUB"     //
	if(count==208) FileName = "_m_MENUC"     //
	if(count==209) FileName = "_n_channelsel"     
	if(count==210) FileName = "_n_CONNECT"     //
	if(count==211) FileName = "_n_CUBRIS"     //
	if(count==212) FileName = "_n_DREAMQUEST"     
	if(count==213) FileName = "_n_GOMOKU"     //
	if(count==214) FileName = "_n_GRAVITYCH"     
	if(count==215) FileName = "_n_GRAVITYP"     //
	if(count==216) FileName = "_n_MULTICONNECT"   
	if(count==217) FileName = "_n_MULTICUBRIS"    
	if(count==218) FileName = "_n_MULTIGOMOKU"    
	if(count==219) FileName = "_n_PIANO"     //
	if(count==220) FileName = "_n_powersel"     //
	if(count==221) FileName = "_n_reception"     
	if(count==222) FileName = "_n_RINGDREAM"     
	if(count==223) FileName = "_n_ROADRUNNER"     
	if(count==224) FileName = "_n_SNAKE"     //
	if(count==225) FileName = "_n_SOKOBAN"     //
	if(count==226) FileName = "_n_transmission"   
	if(count==227) FileName = "_n_TRANSPORT"     
	if(count==228) FileName = "_n_TUTORIAL"     //
	if(count==229) FileName = "_s_1"     //
	if(count==230) FileName = "_s_10"     //
	if(count==231) FileName = "_s_100"     //
	if(count==232) FileName = "_s_11"     //
	if(count==233) FileName = "_s_12"     //
	if(count==234) FileName = "_s_13"     //
	if(count==235) FileName = "_s_14"     //
	if(count==236) FileName = "_s_15"     //
	if(count==237) FileName = "_s_16"     //
	if(count==238) FileName = "_s_17"     //
	if(count==239) FileName = "_s_18"     //
	if(count==240) FileName = "_s_19"     //
	if(count==241) FileName = "_s_2"     //
	if(count==242) FileName = "_s_20"     //
	if(count==243) FileName = "_s_3"     //
	if(count==244) FileName = "_s_30"     //
	if(count==245) FileName = "_s_4"     //
	if(count==246) FileName = "_s_40"     //
	if(count==247) FileName = "_s_5"     //
	if(count==248) FileName = "_s_50"     //
	if(count==249) FileName = "_s_6"     //
	if(count==250) FileName = "_s_60"     //
	if(count==251) FileName = "_s_7"     //
	if(count==252) FileName = "_s_70"     //
	if(count==253) FileName = "_s_8"     //
	if(count==254) FileName = "_s_80"     //
	if(count==255) FileName = "_s_9"     //
	if(count==256) FileName = "_s_90"     //
	if(count==257) FileName = "_s_DTAPTORESTART"  
	if(count==258) FileName = "_s_SCOREIS"     //
	if(count==259) FileName = "_t_1TIME"     //
	if(count==260) FileName = "_t_2TIME"     //
	if(count==261) FileName = "_t_3TIME"     //
	if(count==262) FileName = "_t_AICH"     //
	if(count==263) FileName = "_t_MANHANDLE"     
	if(count==264) FileName = "_t_NODIR"     //
	if(count==265) FileName = "_t_TUT1"     //
	if(count==266) FileName = "_t_TUT2"     //
	if(count==267) FileName = "_t_TUT3"     //
	if(count==268) FileName = "_t_TUT4"     //
	if(count==269) FileName = "_t_TUT5"     //
	if(count==270) FileName = "_t_TUT6"     //
	if(count==271) FileName = "_t_TUT7"     //
	if(count==272) FileName = "_t_UFF"     //
	if(count==273) FileName = "_t_WALLHIT"  
	//FileName =''''
}
