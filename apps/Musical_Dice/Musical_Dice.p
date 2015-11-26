/**Musical_Dice.p
* By Kenneth Brandon Nov 2015
* This app allows someone to tap on a side and play a musical note
* Notes are aranged in a chromatic scale starting with taping side 1 while side 1 is up
**/
#include <futurocube>
//icon array fromat: ICON_MAGIC1,ICON_MAGIC2,Menu Number,Side Number,9 cell colors,Name sound,Description sound
new icon[]=[ICON_MAGIC1,ICON_MAGIC2,1,4,  
	0,cPURPLE,cPURPLE,cPURPLE,cPURPLE,0,cPURPLE,cPURPLE,0, //colors for menu icon
	''_c1'',''_c2''] // name, and description 
main()   
{ 
    ICON(icon)
	RegAllSideTaps()
	new currentSide
	new kickSide
	for(;;) 
	{
		Sleep()
		currentSide = _side(GetCursor());
		if(Motion()) {
			kickSide=eTapSide()
			PlayNote(ConvertToDiceNumber(currentSide), ConvertToDiceNumber(kickSide))
			SetTimer(kickSide, 1000);  //sets timer to draw flicker for 1 second on the side that was kicked
		} 
		AckMotion()
		DrawMyCube(currentSide) 
	}
}

ConvertToDiceNumber(side) {
	switch(side) {
		case 0: return 0
		case 1: return 5
		case 2: return 1
		case 3: return 4
		case 4: return 3
		case 5: return 2
	}
	return 0;
}

PlayNote(upSide, kickSide){
	new fileName{20}
	switch(upSide)
	{
		case 0:
			switch(kickSide){
				case 0: fileName = "_c1"
				case 1: fileName = "_c#1"
				case 2: fileName = "_d1"
				case 3: fileName = "_d#1"
				case 4: fileName = "_e1"
				case 5: fileName = "_f1"
			}
		case 1:
			switch(kickSide){
				case 0: fileName = "_f#1"
				case 1: fileName = "_g1"
				case 2: fileName = "_g#1"
				case 3: fileName = "_a1"
				case 4: fileName = "_a#1"
				case 5: fileName = "_h1"
			}
		case 2:
			switch(kickSide){
				case 0: fileName = "_c2"
				case 1: fileName = "_c#2"
				case 2: fileName = "_d2"
				case 3: fileName = "_d#2"
				case 4: fileName = "_e2"
				case 5: fileName = "_f2"
			}
		case 3:
			switch(kickSide){
				case 0: fileName = "_f#2"
				case 1: fileName = "_g2"
				case 2: fileName = "_g#2"
				case 3: fileName = "_a2"
				case 4: fileName = "_a#2"
				case 5: fileName = "_h2"
			}
		case 4:
			switch(kickSide){
				case 0: fileName = "_c3"
				case 1: fileName = "_c#3"
				case 2: fileName = "_d3"
				case 3: fileName = "_d#3"
				case 4: fileName = "_e3"
				case 5: fileName = "_f3"
			}
		case 5:
			switch(kickSide){
				case 0: fileName = "_f#3"
				case 1: fileName = "_g3"
				case 2: fileName = "_g#3"
				case 3: fileName = "_a3"
				case 4: fileName = "_a#3"
				case 5: fileName = "_h3"
			}
	}
	Play(fileName);
}

DrawMyCube(upSide)
{
	switch(upSide){
		case 0: SetColor(cPURPLE)
		case 1: SetColor(cGREEN)
		case 2: SetColor(cBLUE)
		case 3: SetColor(cRED)
		case 4: SetColor(cORANGE)
		case 5: SetColor(cMAGENTA)
	}
	//side 1
	if(GetTimer(0)>0) DrawFlicker(_w(0,4))	
	else  DrawPoint(_w(0,4))

	//side 2
	if(GetTimer(2)>0){
		DrawFlicker(_w(2,2))
		DrawFlicker(_w(2,6))
	} else {
		DrawPoint(_w(2,2))
		DrawPoint(_w(2,6))
	}
	
	//side 3
	if(GetTimer(5)>0){
		DrawFlicker(_w(5,2))
		DrawFlicker(_w(5,4))
		DrawFlicker(_w(5,6))
	} else {
		DrawPoint(_w(5,2))
		DrawPoint(_w(5,4))
		DrawPoint(_w(5,6))
	}
	
	//side 4
	if(GetTimer(4)>0){
		DrawFlicker(_w(4,0))
		DrawFlicker(_w(4,2))
		DrawFlicker(_w(4,6))
		DrawFlicker(_w(4,8))
	} else{ 
		DrawPoint(_w(4,0))
		DrawPoint(_w(4,2))
		DrawPoint(_w(4,6))
		DrawPoint(_w(4,8))
	}

	//side 5
	if(GetTimer(3)>0){
		DrawFlicker(_w(3,0))
		DrawFlicker(_w(3,2))
		DrawFlicker(_w(3,4))
		DrawFlicker(_w(3,6))
		DrawFlicker(_w(3,8))
	} else {
		DrawPoint(_w(3,0))
		DrawPoint(_w(3,2))
		DrawPoint(_w(3,4))
		DrawPoint(_w(3,6))
		DrawPoint(_w(3,8))
	}

	//side 6
	if(GetTimer(1)>0){
		DrawFlicker(_w(1,0))
		DrawFlicker(_w(1,2))
		DrawFlicker(_w(1,3))
		DrawFlicker(_w(1,5))
		DrawFlicker(_w(1,6))
		DrawFlicker(_w(1,8))
	} else {
		DrawPoint(_w(1,0))
		DrawPoint(_w(1,2))
		DrawPoint(_w(1,3))
		DrawPoint(_w(1,5))
		DrawPoint(_w(1,6))
		DrawPoint(_w(1,8))
	}
	PrintCanvas()
}