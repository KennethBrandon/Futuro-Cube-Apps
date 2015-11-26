#pragma library -
//version of futurocube.inc ... 1.3    21.06.2013

//DS
//\section{API-Native functions}
//DS
//\subsection{ClearCanvas}
//\annotation{Clear virtual canvas}
//\syntax{ClearCanvas()} 
//\notes{This function clears virtual canvas. Usually it is used before drawing
//new picture on the cube. It is usually followed by sets of drawing functions and than by
//PrintCanvas(). This function itself does not clear LEDS on the cube!}  
//\example{ClearCanvas()}{} 
//\seealso{PrintCanvas, DrawPoint} 
//DE
native ClearCanvas() = -1;

//DS
//\subsection{PrintCanvas}
//\annotation{Print virtual canvas to the physical cube surface, turns on LEDS}
//\syntax{PrintCanvas()} 
//\notes{This function prints virtual canvas into physical cube surface. Virtual 
//canvas is not automatically cleared after this operation.}
//\example{PrintCanvas()}{}  
//\seealso{ClearCanvas, DrawPoint, FlashCanvas} 
//DE
native PrintCanvas() = -2;

//DS
//\subsection{SetIntensity} 
//\annotation{Set current intensity for all color components}
//\syntax{SetIntensity(value)}
//\param{value}{represent current intesity in range $<$0..256$>$}
//\notes{Each color component when draw onto the canvas is scaled by intensity number. 256 means 
//means no scale. Default value, which is set when
//the script starts is 128. This value reflects full and correct display of several presets colors.}
//\example{SetIntensity(30)}{} 
//\seealso{SetColorDefaults, SetColor} 
//DE
native SetIntensity(value) = -7;

//DS
//\subsection{SetColor}
//\annotation{Set the current color}
//\syntax{SetColor(value=0xffffff00)} 
//\param{value}{32 bit number, that represent the current color, see the explanation how the colors are represented} 
//\example{SetColor(cGREEN)}{}
//\examplen{SetColor(RED)}{}
//\examplen{SetColor(0xFFAB1200)}{}
//\examplen{SetColor(3)}{, set color at pallete number 3}
//\seealso{SetIntensity, SetColorDefaults}
//DE
native SetColor(value=0xffffff00) = -8;

//DS
//\subsection{Preset color definition}
//\annotation{Definition of presets colors for classic cube puzzles}
//\define{cGREEN}   {0x00640000}
//\define{cBLUE}    {0x00008000}
//\define{cRED}     {0x64000000}
//\define{cORANGE}  {0x80340000}
//\define{cMAGENTA} {0x00785C00}
//\define{cPURPLE}  {0x6C005C00}
//DE

//DS
//\subsection{Basic color definition}
//\annotation{Definition of basic colors}
//\define{RED}      {0xFF000000}
//\define{GREEN}    {0x00FF0000}
//\define{BLUE}     {0x0000FF00}
//\define{WHITE}    {0xFFFFFF00}
//DE


#define cGREEN   0x00640000
#define cBLUE    0x00008000
#define cRED     0x64000000
#define cORANGE  0x80340000
#define cMAGENTA 0x00785C00
#define cPURPLE  0x6C005C00

#define RED      0xFF000000
#define GREEN    0x00FF0000
#define BLUE     0x0000FF00
#define WHITE    0xFFFFFF00

//DS
//\subsection{SetRgbColor(r,g,b)}
//\annotation{Set the current color by each color component}
//\syntax{SetRgbColor(r,g,b)} 
//\param{r}{red component of the color $<$0..255$>$}
//\param{g}{green component of the color $<$0..255$>$}
//\param{b}{blue component of the color $<$0..255$>$}
//\example{SetRgbColor(120,0,40)}{}
//\seealso{SetColor}
//DE
native SetRgbColor(r,g,b) = -11;


//DS
//\subsection{DrawPoint}
//\annotation{Draw point of current color to virtual canvas}
//\syntax{DrawPoint(wi)}
//\param{wi}{walker or square index} 
//\notes{Draw spot with current color to place defined by walker or index} 
//\example{DrawPoint(wi)}{}
//\examplen{DrawPoint(23)}{, draw to square index 23}
//\examplen{DrawPoint(\_w(4,2))}{, draw to side 4, square 2}
//\seealso{DrawSide, DrawSquare, DrawCross} 
//DE
native DrawPoint(wi) = -9;

//DS
//\subsection{DrawPC}
//\annotation{Draw point with given color and intensity}
//\syntax{DrawPC(wi, color, int=128)}
//\param{wi}{walker or square index} 
//\param{color}{requested color} 
//\param{int}{requested intensity} 
//\notes{Draw spot with given color and intensity to place defined by walker or index.
//Given values do not modify current color and current intensity. They apply just for
//one call of this function.} 
//\example{DrawPC(GetCursor(),WHITE)}{, draw white spot at cursor}
//\examplen{DrawPC(2,cORANGE,256)}{, draw to square index 2 cORANGE with max intensity}
//\seealso{DrawPoint, DrawSide, DrawSquare, DrawCross} 
//DE

native DrawPC(wi,color,int=128) = -32;


//DS
//\subsection{DrawSide}
//\annotation{Fill side with current color to virtual canvas}
//\syntax{DrawSide(side)}
//\param{side}{side number} 
//\notes{Fill given side with current color.} 
//\example{DrawSide(\_side(wlk))}{, fill side defined by walker wlk}
//\example{DrawSide(\_side(27))}{, fill side defined by square index 27, that is side 3}
//\example{DrawSide(4)}{, fill side 4}
//\seealso{DrawSide, DrawSquare, DrawCross} 
//DE
native DrawSide(side) = -10;


//DS
//\subsection{DrawSquare}
//\annotation{Draw square 3x3 with current color around center spot}
//\syntax{DrawSquare(wi)}
//\param{wi}{walker or square index}
//\notes{Draws square around center spot of preset color. Center spot is defined by walker or square index} 
//\example{DrawSquare(wlk)}{, draw square with center of wlk}
//\examplen{DrawSquare(27)}{, draw square with center of square index 27}
//\examplen{DrawSquare(\_w(4,2))}{, draw square around center spot side 4 square 2}
//\seealso{DrawPoint, DrawSide, DrawCross} 
//DE
native DrawSquare(w) = -12; //NI

//DS
//\subsection{DrawCube}
//\annotation{Fill cube with current color to virtual canvas}
//\syntax{DrawCube()}
//\notes{Fill cube current color.} 
//\example{DrawCube()}{}
//\seealso{DrawSide, DrawSquare, DrawCross} 
//DE
native DrawCube()=-25;


//DS
//\subsection{DrawCross}
//\annotation{Draw cross of specified length}
//\syntax{DrawCross(wi, length=1)}
//\param{wi}{walker or square index}
//\param{length}{length of the arm of the cross}
//\notes{Draw cross with center spot defined by walker or index with preset color and attributes.} 
//\example{DrawCross(wlk)}{, draws cross with center wlk with length=1}
//\examplen{DrawCross(23,2)}{, draws cross on index 23 with length=2}
//\examplen{DrawCross(\_w(2,2),3)}{, draws cross with center side 2, square 2 and length=3}
//\seealso{DrawSide, DrawPoint, DrawCross} 
//DE
native DrawCross(w,length=1) = -13; //NI

//DS
//\subsection{PushCanvas}
//\annotation{Push virtual canvas to Push Pop Array}
//\syntax{PushCanvas(ppindex=0)} 
//\param{ppindex}{push pop array number, default is zero}  
//\returns{Funtion returns error code as function Push}
//\notes{This function internally uses Push, so the ppindex array must be initialized!} 
//\example{PushCanvas()}{, push canvas to array with index 0}
//\examplen{PushCanvas(1)}{, push canvas to array with index 1}
//\seealso{PopCanvas, Push, Pop, PushPopInit} 
//DE
native PushCanvas(ppindex=0)=-14;

//DS
//\subsection{PopCanvas}
//\annotation{Pop virtual canvas from Push Pop Array}
//\syntax{PushCanvas(ppindex=0)} 
//\param{ppindex}{push pop array number, default is zero}  
//\returns{Funtion returns error code as function Pop}
//\notes{This function internally uses Pop, so the ppindex array must be initialized!} 
//\example{PopCanvas()}{, pop canvas from array with index 0}
//\examplen{PopCanvas(1)}{, pop canvas to array with index 1}
//\seealso{PushCanvas, Push, Pop, PushPopInit} 
//DE
native PopCanvas(ppindex=0)=-15;


//DS
//\subsection{CanvasToArray}
//\annotation{Store virtual canvas to array}
//\syntax{CanvasToArray(arr[],size=sizeof arr)} 
//\param{arr[]}{destination array}
//\param{size}{size of the array, must be 54, otherwise  exception is reised}
//\returns{Funtion always returns 0}
//\notes{This function basically copies virtual canvas to user array.} 
//\example{CanvasToArray(temp)}{, stores canvas to array temp}
//\seealso{ArrayToCanvas, Push, Pop, PushPopInit} 
//DE
native CanvasToArray(arr[],size=sizeof arr)=-16;

//DS
//\subsection{ArrayToCanvas}
//\annotation{Load virtual canvas from array}
//\syntax{ArrayToCanvas(arr[],size=sizeof arr)} 
//\param{arr[]}{source array}
//\param{size}{size of the array, must be 54, otherwise  exception is reised}
//\returns{Funtion always returns 0}
//\notes{This function basically copies user array to virtual canvas.} 
//\example{ArrayToCanvas(temp)}{, store array temp to canvas}
//\seealso{CanvasToArray, Push, Pop, PushPopInit} 
//DE
native ArrayToCanvas(arr[],size=sizeof arr)=-17;

//DS
//\subsection{DrawArray}
//\annotation{Draw array to virtual canvas}
//\syntax{DrawArray(arr[],size=sizeof arr)} 
//\param{arr[]}{source array}
//\param{size}{size of the array, must be 54, otherwise  exception is reised}
//\returns{Funtion always returns 0}
//\notes{This function draws user array to virtual canvas. That means it really 
//uses all drawing procedure and preset drawing style.} 
//\example{DrawArray(temp)}{, draw array temp to canvas}
//\seealso{SetDrawDefaults, SetDrawStyle} 
//DE
native DrawArray(arr[],size=sizeof arr)=-18;

//DS
//\subsection{PrintCnv}
//\annotation{Debug function, print virtual canvas values to terminal}
//\syntax{PrintCnv()} 
//\example{PrintCnv()}{}
//\seealso{PrintArray, printf} 
//DE
native PrintCnv()=-19;

//DS
//\subsection{SetDrawDefaults}
//\annotation{Set all draw properties to its default states}
//\syntax{SetDrawDefaults()} 
//\notes{This function sets: Intensity: 128, Color to 0x80340000, Blend to 50 percent
// and drawing style to STD. This funtion does not affect pallete settings.} 
//\example{SetDrawDefaults()}{}
//\seealso{SetDrawStyle} 
//DE
native SetDrawDefaults()=-20;

//DS
//\subsection{Drawing style definition}
//\annotation{Drawing styles definition and explanation}
//\define{STD}         {0, standard - new color overrides everything}
//\define{ADD}         {1, addition - colors are added (and clipped) by components} 
//\define{SUB}         {2, substitution - colors are substitued (and clipped) by components}
//\define{MSKA}      {3, MASKING by color A}
//\define{MSKB}      {4, MASKING by color B}
//\define{MSKADD}      {5, MASKING by color A plus addition}
//\define{BLD}         {6, blending colors by blend value}
//DE


#define STD        0
#define ADD        1
#define SUB        2
#define MSKA       3
#define MSKB       4
#define MSKADD   5
#define BLD        6

//DS
//\subsection{SetDrawStyle}
//\annotation{Set draw style for all drawing functions}
//\syntax{SetDrawStyle(style,blend=50)} 
//\param{style}{style from style definition}
//\param{blend}{blend percentage value used for BLD style $<$0..100$>$}
//\notes{Set up style is than used for all drawings and is used accordingly.} 
//\example{SetDrawStyle(ADD)}{, set draw style to addition}
//\examplen{SetDrawStyle(BLD,20)}{, set draw style to blending, 20 and 80 percent}
//\seealso{SetPallete, SetDrawDefaults} 
//DE
native SetDrawStyle(style,blend=50)=-21;


//DS
//\subsection{SetPalette}
//\annotation{Fill the palette with given color}
//\syntax{SetPalette(index,color)} 
//\param{index}{index in palette, not zero!, range $<$1..255$>$}
//\param{color}{color that will be stored at given index}
//\notes{Palette at index zero have to contain zero value for color, therefore
//index zero is not accessible. By starting script, palette values are reset to zeroes as well.} 
//\example{SetPalette(1,WHITE)}{, set palette with index 1 to value WHITE}
//\examplen{SetPalette(2,0xABCD1100}{, set palette with index 2 to value 0xABCD1100}
//DE
native SetPalette(index,color)=-22;

//DS
//\subsection{PaletteFromArray}
//\annotation{Fill the palette with values from array}
//\syntax{PaletteFromArray(arr[],size=sizeof array)} 
//\param{arr}{source array}
//\param{size}{size of array, maximum size is 255}
//\notes{This function set up palette from array, index 0 from array is stored into
//index 1 in palette. Index 0 in palette is allways 0.} 
//\example{new parr[3]=\{WHITE,BLUE,RED\}}{}
//\examplen{PaletteFromArray(parr)}{, set palette from parr}
//DE
native PaletteFromArray(arr[],size=sizeof arr)=-33


//DS
//\subsection{FlashCanvas}
//\annotation{Prints virtual canvas to LEDS with fading attributes}
//\syntax{FlashCanvas(step=1,diff=3,exclusive=0)} 
//\param{step}{Indicates occurrence of fade towards frame counter, 
//value 1 means proceed with fade every new frame, value 2 means every second frame...}
//\param{diff}{indicate what value will be subtracted from each color component every step}
//\param{exclusive}{if the parameter is set to 1, than LEDS are updated only if their value
//was zero. That means if they were for example still fading from previous call, their values
//are not overriden}
//\notes{This function is usually used for some graphical effects, where canvas is not needed 
//to be updated so often}
//\example{FlashCanvas}{}
//\seealso{PrintCanvas, ClearCube}
//DE
native FlashCanvas(step=1,diff=3,exclusive=0)=-23;

//DS
//\subsection{Flicker type definition}
//\annotation{Flicker types definition and explanation}
//\define{FLICK\_STD} {0, flickering min-$>$max,max-$>$min,...}
//\define{FLICK\_RAZ} {1, flickering min-$>$max,min-$>$max,...}
#define FLICK_STD   0
#define FLICK_RAZ   1

//DS
//\subsection{DrawFlicker}
//\annotation{Draw cursor type blinking spot}
//\syntax{DrawFlicker(wi,speed=20,type=0,phase=0)} 
//\param{wi}{walker or spot index}
//\param{speed}{blinking speed, each frame this value is used to adjust the spot}
//\param{type}{type of flicker, FLICK\_STD or FLICK\_RAZ}
//\param{phase}{this value adjust phase of blinking, it can be in range $<$-127..127$>$}
//\notes{In order to make this function work properly, it must be called repeatedly during
//drawing. It actually just draw a spot of current color, but it calculates its intensity
//by given values and current frame counter. Therefore it creates nicely blinking spot on
//virtual canvas.}
//\example{DrawFlicker(GetCursor()}{}
//\seealso{GetCursor}
//DE
native DrawFlicker(wi,speed=20,type=0,phase=0)=-24;

//DS
//\subsection{AdjCanvasPoint}
//\annotation{Adjust intensity of the already drawed point}
//\syntax{AdjCanvasPoint(wi,pint)} 
//\param{wi}{walker or spot index}  
//\param{pint}{percentage of new intensity, 0 means no change $<$-100..300$>$}  
//\notes{This function changes intensity of point which is already drawn. So the color
//component might not be in correct ratio if the change is big.} 
//\example{AdjCanvasPoint(GetCursor(),-20)}{, decrease intensity under cursor to 20 percent} 
//\seealso{AdjCanvas, AdjArray} 
//DE
native AdjCanvasPoint(wi,pint)=-26;

//DS
//\subsection{AdjCanvas}
//\annotation{Adjust intensity of the virtual canvas}
//\syntax{AdjCanvas(pint)} 
//\param{pint}{percentage of new intensity, 0 means no change $<$-100..300$>$}  
//\example{AdjCanvas(-20)}{, decrease intensity of all canvas to 20 percent} 
//\seealso{AdjCanvasPoint, AdjArray} 
//DE
native AdjCanvas(pint)=-27;

//DS
//\subsection{AdjArray}
//\annotation{Adjust intensity of the array}
//\syntax{AdjArray(arr[],pint,sindex=0,count=sizeof arr,size=sizeof arr)} 
//\param{arr}{array to be adjusted}  
//\param{pint}{percentage of new intensity, 0 means no change $<$-100..300$>$}  
//\param{sindex}{start index in array}  
//\param{count}{number of cells to adjust in array}  
//\param{size}{size of array}  
//\example{AdjArray(arr,-50)}{, decrease intensity of arr to 50 percent} 
//\examplen{AdjArray(arr,50,20,2)}{, decrease intensity of arr[20] and arr[21] to 50 percent} 
//DE
native AdjArray(arr[],pint,sindex=0,count=sizeof arr,size=sizeof arr)=-28;

//DS
//\subsection{ReadCanvas}
//\annotation{Read color from virtual canvas}
//\syntax{ReadCanvas(wi)} 
//\param{wi}{walker or spot index}  
//\returns{Color that contains virtual canvas at given position.}
//\example{col=ReadCanvas(2)}{, read the canvas color from square index 2} 
//\seealso{ReadRGBLed} 
//DE
native ReadCanvas(wi)=-29;

//DS
//\subsection{ReadRGBLed}
//\annotation{Read actuall RGB color that is currently displayed}
//\syntax{ReadRGBLed(wi)} 
//\param{wi}{walker or spot index}  
//\returns{Color that is in reality diaplayed on cube surface at the moment of calling the function.}
//\example{col=ReadRGBLed(2)}{, read the RGB led color from square index 2} 
//\seealso{ReadCanvas} 
//DE
native ReadRGBLed(wi)=-30;

//DS
//\subsection{ClearCube}
//\annotation{Clear all RGB leds on the cube}
//\syntax{ClearCube()} 
//\notes{The visible result is same is if sequence ClearCanvas() and PrintCanvas() would be called, however virtual
//canvas is not modified. This function is useful as example with FlashCanvas(), because it access surface directly.}
//\example{ClearCube()}{} 
//\seealso{ReadRGBLed} 
//DE
native ClearCube()=-31;

//DS
//\subsection{DrawTail}
//\annotation{Debug function for displaying direction of walker}
//\syntax{DrawTail(w)} 
//\example{DrawTails(w)}{} 
//DE
native DrawTail(w)=-34;

native RotateCanvasRGB(r,g,b)=-35;

//DS
//\subsection{Motion pattern type list definition}
//\annotation{Definition of basic motion pattern}
//\define{TAP\_GENERIC}    {5, generic tap any direction}
//\define{SHAKING}         {8, shaking side to side}
//\define{TAP\_XPLUS}          {9, side tap in X+ axes (side 3)}
//\define{TAP\_XMINUS}       {10, side tap in X- axes (side 2)}
//\define{TAP\_YPLUS}          {11, side tap in Y+ axes (side 4)}
//\define{TAP\_YMINUS}       {12, side tap in Y- axes (side 5)}
//\define{TAP\_ZPLUS}          {13, side tap in Z+ axes (side 0)}
//\define{TAP\_ZMINUS}       {14, side tap in Z- axes (side 1)}
//\define{TAP\_DOUBLE}       {15, double tap flag}
//DE


#define TAP_GENERIC    5
#define SHAKING        8
#define TAP_XPLUS          9
#define TAP_XMINUS       10
#define TAP_YPLUS          11
#define TAP_YMINUS       12
#define TAP_ZPLUS          13
#define TAP_ZMINUS       14
#define TAP_DOUBLE       15

//DS
//\subsection{RegMotion}
//\annotation{Register specific motion pattern for recognition}
//\syntax{RegMotion(type)} 
//\param{type}{motion type from pattern type list}  
//\notes{Motion type is defined basically by position of bit in motion mask. Later, if new motion
//is detected, output from Motion() function has corresponding bit set to logic 1.
//By calling RegMotion(...) consequently, another pattern is added.} 
//\example{RegMotion(TAP\_GENERIC)}{, registers TAP\_GENERIC} 
//\seealso{Motion, AckMotion, RegAllSideTaps, UnregAllMotion} 
//DE                         
native RegMotion(value) = -50;


//DS
//\subsection{SetDoubleTapLength}
//\annotation{Set maximum length of double tap detection in milliseconds}
//\syntax{SetDoubleTapLength(max\_ms=700)} 
//\param{max\_ms}{maximum length in milliseconds for double tap detection}  
//\notes{Window for double tap detection is set from 50ms to user defined value.
//Standard length in 700ms, minimum length for double tap detection is 100ms.} 
//\example{SetDoubleTapLength(200)}{, sets double tap detection length to 200ms} 
//\examplen{SetDoubleTapLength()}{, sets double tap detection length to 700ms}
//\seealso{Motion, AckMotion} 
//DE                         
native SetDoubleTapLength(max_ms=700)=-66;


//DS
//\subsection{Motion}
//\annotation{Detects if any registered motion pattern has been recognized}
//\syntax{type=Motion()} 
//\returns{This function returns number, that has set bits at positions, that corresponds to
//recognized registered motion pattern.}
//\notes{If for example more than one pattern is registered, than output from this function should
//be tested for each pattern separately. The typical way is to use predefined macro \_is, which is 
//testing, if the bit on its specified position is set or reset.} 
//\example{motion=Motion()}{, variable motion holds information about recognized patterns}
//\examplen{if (motion) \{...\} }{if there is any motion, we should handle it ...}
//\examplen{if (\_is(motion,TAP\_XPLUS)) \{...\} }{if there is specifically TAP\_XPLUS, we should do ... }
//\seealso{RegMotion, AckMotion, RegAllSideTaps, UnregAllMotion} 
//DE
native Motion() = -51;

//DS
//\subsection{AckMotion}
//\annotation{Acknowledge reception of recognized motion patterns}
//\syntax{AckMotion()} 
//\notes{This function tells to the system, you have received and served all recognized
//motion patterns previously obtained from Motion() and therefore any new motion pattern
//can be recognized. If this function is not called, bits on output from Motion() remain
//set if as there is still some pattern presented.} 
//\example{AckMotion()}{} 
//\seealso{RegMotion,Motion,RegAllSideTaps,UnregAllMotion} 
//DE
native AckMotion() = -52;

//DS
//\subsection{RegAllSideTaps}
//\annotation{Register taps to all sides}
//\syntax{RegAllSideTaps()} 
//\notes{This function does exactly same as one would call several times RegMotion with all 
//side taps parameters. TAP\_GENERIC is not registered!} 
//\example{RegAllSideTaps()}{} 
//\seealso{RegAllTaps} 
//DE
native RegAllSideTaps() = -53;

//DS
//\subsection{UnregMotion}
//\annotation{Unregister specified motion pattern}
//\syntax{UnregMotion(type)} 
//\param{type}{motion type from pattern type list}  
//\notes{This function does exactly opposite than RegMotion} 
//\example{UnregMotion(TAP\_GENERIC)}{} 
//\seealso{RegMotion} 
//DE
native UnregMotion(value=0) = -54;

//DS
//\subsection{UnregAllMotion}
//\annotation{Deregister all motion pattern}
//\syntax{UnregAllMotion()} 
//\notes{After this function is called, there will no pattern recognized} 
//\example{UnregAllMotion()}{} 
//\seealso{RegMotion} 
//DE
native UnregAllMotion() = -55;

//DS
//\subsection{GetTapSide}
//\annotation{Gives back number of side, that has been tapped}
//\syntax{result=GetTapSide(\&side)} 
//\param{\&side}{variable side will contain number of sied that has been tap to}
//\returns{Function returns 1 if the tap to side has been recognized, otherwise 0}
//\notes{Function fill the side variable with value 0 to 5 according which side has
//been tapped. Function reads Motion(), so for correct operation side taps must be 
//registered. If you call AckMotion() prior this function, result will become 0.} 
//\example{if (GetTapSide(side)) \{...work with side...\}}{} 
//DE
native GetTapSide(&side) = -56;

//DS
//\subsection{RegAllTaps}
//\annotation{Register generic tap and all side taps.}
//\syntax{RegAllTaps()} 
//\notes{This function register generic tap and all sides taps.} 
//\example{RegAllTaps()}{} 
//\seealso{RegAllSideTaps} 
//DE
native RegAllTaps() = -60; //NI


#define   TAP_TO_UNKNOWN    0
#define   TAP_TO_SIDE       1
#define     TAP_TO_TOP        2
#define     TAP_TO_BOT        3

//DS
//\subsection{GetTapType}
//\annotation{Decision between side, top and bottom tap}
//\syntax{res=GetTapType(topside\_wi)} 
//\param{topside\_wi}{walker or index from which is used for information, which side points towards top}  
//\returns{One of the following results is returned:}
//\param{0}{no decision can be made, perhaps no side tap has been detected}
//\param{1}{tap to gravity side has been detected}
//\param{2}{tap to gravity top has been detected}
//\param{3}{tap to gravity bottom has been detected}
//\notes{This function same as GetTapSide reads Motion() to retrieve pattern info.
//Than it combines this motion pattern info with user input which side is pointing up and
//returns type of gravity tap.} 
//\example{res=GetTapType(GetCursor())}{} 
//DE
native GetTapType(topside_wi) = -57; 

//DS
//\subsection{Easy Tap Type Detection}
//\annotation{Easier to use set of functions for tap type Detection}
//\syntax{eTapSideOK()}
//\notes{Check if is detected any valid SIDE TAP. It is usually called before eTapSide() to confirm
//correct results. If for example TAP\_GENERIC would be registered as well. eTapSide() might give wrong
//output, because if function does not know, it gives back 0.}
//\syntax{eTapSide()}
//\notes{Gives back number of side that has been tapped. If motion pattern do not include any specific taps, it
//returns 0 as well. That is why it is good to use eTapSideOK(). If only sides taps are registered, than there is
//no problem.}
//\syntax{eTapToSide()}
//\notes{Returns 1, if last tap was to side. It takes top side from acc data, past=4}
//\syntax{eTapToTop()}
//\notes{Returns 1, if last tap was to top. It takes top side from acc data, past=4}
//\syntax{eTapToBot()}
//\notes{Returns 1, if last tap was to bottom. It takes top side from acc data, past=4}
//\example{if (eTapSideOK()) \{side=eTapSide();... work with side..\}}{} 
//\examplen{if (eTapToTop) \{...\}}{}
//DE 

native eTapToSide()=-61;
native eTapToTop()=-62;
native eTapToBot()=-63;
native eTapSide()=-64;
native eTapSideOK()=-65;


//DS
//\subsection{IsStill}
//\annotation{Detection of general movements}
//\syntax{res=IsStill()} 
//\returns{This functions returns 1 if there is some noticeable movements or 0 if the cube
//is still.}
//\notes{This function has no special parameters, it is simpler version of GetShake(), that
//can be use for more complicated situations.} 
//\example{res=IsStill()}{} 
//\seealso{GetShake} 
//DE
native IsStill() = -58;

//DS
//\subsection{GetShake}
//\annotation{Detection of shaking in percentage scale}
//\syntax{res=GetShake()} 
//\returns{This function returns values in range $<$0..100$>$} 
//\notes{Value changes depending on how long and how much the cube is "shaken".
//The value constantly rises up while the shaking is in progress and when it ends
//, it goes quickly down to 0} 
//\example{res=GetShake()}{} 
//\seealso{IsStill} 
//DE
native GetShake() = -59;    //NI


//DS
//\subsection{Sleep}
//\annotation{Gives control to system and waits until new game accelerometer data arrives}
//\syntax{Sleep(value=0)} 
//\notes{This function is essential for cooperative multitasking. It should be called
//after all events are processed. If the program does not call this function regularly
//system can block the task for non-cooperative behavior.} 
//\example{Sleep()}{, most general use of sleep, waits for new data, gives time to system} 
//\examplen{Sleep(100)}{, same as Delay(100)}
//\seealso{Delay} 
//DE
native Sleep(value=0) = -200;

//DS
//\subsection{Delay}
//\annotation{Delays script by given millisecond}
//\syntax{Delay(value=1000)} 
//\param{value}{delay time in milliseconds}  
//\notes{This function delays at least given millisecond. Internally uses Sleep()
//so the delay is fully cooperative.} 
//\example{Delay()}{delays for 1 secs}
//\examplen{Delay(100)}{delays for 100 milliseconds}
//\seealso{} 
//DE
native Delay(value=1000) = -201;

//DS
//\subsection{SetTimer}
//\annotation{Sets in milliseconds one of 10 countdown timers}
//\syntax{SetTimer(timer=1,value=1000)} 
//\param{timer}{0,1,2..9 - available timer}  
//\notes{This function sets one of 10 available countdown timers
//to value that represents millisecond. From that point counter is
//counting down to zero. This function also resumes the timer if was paused.} 
//\example{SetTimer()}{, set timer 0 to value 1000 milliseconds} 
//\examplen{SetTimer(1,200)}{, set timer 1 to value 200 milliseconds} 
//\seealso{GetTimer, PauseTimer, ResumeTimer} 
//DE
native SetTimer(timer=0,value=1000) = -202;

//DS
//\subsection{GetTimer}
//\annotation{Returns value of one of 10 countdown timers}
//\syntax{res=GetTimer(timer=0)} 
//\param{timer}{0,1,2..9 - available timer}  
//\returns{Current value of the timer, no lower than 0}
//\example{res=GetTimer}{, returns value of timer 0}
//\examplen{res=GetTimer(2)}{, returns value of timer 2}
//\examplen{if (!TimerGet(0))}{}
//\seealso{SetTimer, PauseTimer, ResumeTimer} 
//DE
native GetTimer(timer=0) = -203;

//DS
//\subsection{PauseTimer}
//\annotation{Pause one of the 10 countdown timers}
//\syntax{PauseTimer(timer=0)} 
//\param{timer}{0,1,2..9 - available timer}  
//\notes{Timer remains paused until ResumeTimer() or SetTimer() function is called.}
//\example{PauseTimer()}{, pause timer 0}
//\examplen{PauseTimer(2)}{, pause  timer 2}
//\seealso{SetTimer, ResumeTimer} 
//DE
native PauseTimer(timer=0)=-217;

//DS
//\subsection{ResumeTimer}
//\annotation{Resume one of the 10 countdown timers}
//\syntax{ResumeTimer(timer=0)} 
//\param{timer}{0,1,2..9 - available timer}  
//\example{ResumeTimer()}{, resume timer 0}
//\examplen{ResumeTimer(2)}{, resume  timer 2}
//\seealso{SetTimer, PauseTimer} 
//DE
native ResumeTimer(timer=0)=-218;

//DS
//\subsection{printf}
//\annotation{Debug function for text output}
//\syntax{printf(const format[], {Fixed,\_}:...)} 
//\param{const format[]}{array with formatting text}  
//\param{...}{variable arguments used to feed into formatting text}  
//\notes{This function works similar as standard printf function, only
//there is just subset of format specifiers} 
//\param{\%{}s}{inserts a string that can be either packed or unpacked} 
//\param{\%{}d}{signed integer number}
//\param{\%{}x}{hexadecimal number}
//\param{\%{}X}{hexadecimal number}
//\param{\%{}c}{character}
//\example{printf("\%{}s\bl{}r\bl{}n",data)}{}
//\examplen{printf("\%{}s\bl{}r\bl{}n",data)}{}
//\examplen{printf("this is \%{}d, this is text \%{}s\bl{}r\bl{}n",number, data)}{}
//\examplen{printf("0x\%{}08x\bl{}r\bl{}n",hexnumber)}{}
//\seealso{snprintf} 
//DE
native printf(const format[], {Fixed,_}:...)=-204;

//DS
//\subsection{snprintf}
//\annotation{Formatting output into unpacked string}
//\syntax{snprintf(dest[],size=sizeof dest,const format[], \{Fixed,\_\}:...)} 
//\param{dest[]}{string array where to store formatted output}  
//\param{size}{size of output array}
//\param{const format[]}{{string array with formatting text}}
//\param{...}{variable arguments used to feed into formatting text}  
//\notes{This function works same as printf with exception that it stores the output
//into destination. Size of destination must be specified and usually is retrieved
//during runtime by leaving standard value.} 
//\example{snprintf(dest,"My name is \%{}s\bl{}r\bl{}n",\_,name)}{, \_ stands for sizeof dest and it is filled automatically in runtime} 
//\seealso{printf} 
//DE
native snprintf(dest[],size=sizeof dest,const format[], {Fixed,_}:...)=-205;

//?DS
//\subsection{number}
//\annotation{convert decimal number in text into integer}
//\syntax{res=number(source[],pos=0,\&value)} 
//\param{source}{packed or unpacked string array}  
//\param{pos}{position of first character where to start conversion, position starts from zero}
//\param{\&ok}{place where to store of operation was successful}
//\returns{If conversion was OK, that it returns 1, otherwise 0}
//\notes{This function can decoded only decimal numbers, hexadecimal
//numbers are not supported.} 
//\example{n="This is 10", if (number(n,8,value) \{...\}}{} 
//\seealso{printf, snprintf} 
//DE
//native number(source[],pos=0,&value)=-206; //NI

//DS
//\subsection{cellset}
//\annotation{Sets the array of predefined constant}
//\syntax{cellset(arr[],val=0,size=sizeof arr)} 
//\param{arr[]}{array to be filled by val}  
//\param{val}{value used for filling}
//\param{size}{size of array}
//\notes{This is similar function to memset. It basically put value into
//every cell in array. Size of array can be automatically inserted in runtime
//by using standard value.} 
//\example{cellset(playground,20)}{, fills whole playground array by value 20}
//\examplen{cellset(playground,20,3)}{, fills first 3 cells by value 20}
//\seealso{cellcopy} 
//DE
native cellset(arr[],val=0,size=sizeof arr)=-207; //NI

//DS
//\subsection{cellcopy}
//\annotation{Copying one array to another with using memmove}
//\syntax{cellcopy(dest[],source[],index=0,numcells=sizeof source,maxlength=sizeof dest)} 
//\param{dest}{destination array}  
//\param{source}{source array}
//\param{index}{index of cell in source from where to start copy}
//\param{numbytes}{number of cells to copy}
//\param{maxlength}{size of the destination}
//\notes{This function copies cells from one array to another. If last 3 parameters
//are left defalt it performs safe array to array copy. This function internally uses
//memmove, so arrays can overlap.} 
//\example{cellcopy(dest,source}{, tries to whole source to max size of dest}
//\examplen{cellcopy(dest,source,2,10,\_}{, tries copy whole 10 cells from source at index 2, 
//but maximum up to size of dest, however size of source might be violated}
//\examplen{cellcopy(dest,source,\_,10}{, same as above from index 0}
//\seealso{cellset} 
//DE
native cellcopy(dest[],source[],index=0,numcells=sizeof source,maxlength=sizeof dest)=-208;

//DS
//\subsection{PushPopInit}
//\annotation{Initialization of Push Pop Arrays}
//\syntax{PushPopInit(arr[],ppindex=0,size=sizeof arr)} 
//\param{arr}{array that will be used as Push Pop Array}  
//\param{ppindex}{index of available PPArray arbiter, $<$0..3$>$}  
//\param{size}{size of array to be stored into arbiter as initial size}  
//\notes{Before any usage of Push, Pop or PushCanvas, PopCanvas, array must be initialized!} 
//\example{PushPopInit(arr)}{, initialized arbiter with index 0 with array arr}
//\examplen{PushPopInit(temp,1)}{, initialized arbiter with index 1 with array temp}
//\seealso{Push, Pop} 
//DE
native PushPopInit(arr[],ppindex=0,size=sizeof arr)=-209;

//DS
//\subsection{Push}
//\annotation{Push array into Push Pop Array}
//\syntax{Push(arr[],ppindex=0,size=sizeof arr)} 
//\param{arr}{array that is going to be pushed in}  
//\param{ppindex}{index of available PPArray arbiter, $<$0..3$>$}  
//\param{size}{size of pushed array}  
//\returns{Returns 1 if operation was successful, otherwise exception is raised.}
//\notes{If the Push Pop Array if full, simply part of oldest items are thrown away and lost.
//This must be considered as possible effect and be careful about that.} 
//\example{Push(arr)}{, push arr into initialized array with index 0}
//\examplen{Push(temp,1)}{, push temp into initialized array with index 1}
//\seealso{Pop, PPReady} 
//DE
native Push(arr[],ppindex=0,size=sizeof arr)=-210;


//DS
//\subsection{Pop}
//\annotation{Pop array from Push Pop Array}
//\syntax{Push(arr[],ppindex=0,size=sizeof arr)} 
//\param{arr}{array that is going to be popped}  
//\param{ppindex}{index of available PPArray arbiter, $<$0..3$>$}  
//\param{size}{size of popped array}  
//\returns{Returns 1 if operation was successful, otherwise exception is raised.}
//\notes{If the Push Pop Array if empty or more than available cells are popped, 
//excpetion is raised as well!} 
//\example{Pop(arr)}{, pop arr from initialized array with index 0}
//\examplen{Pop(temp,1)}{, pop temp from initialized array with index 1}
//\seealso{Push, PPReady} 
//DE
native Pop(arr[],ppindex=0,size=sizeof arr)=-211;

//DS
//\subsection{PPReady}
//\annotation{Number of ready cells for Pop in Push Pop Array}
//\syntax{PPReady(ppindex=0)} 
//\param{ppindex}{index of PPArray arbiter, $<$0..3$>$}  
//\returns{Number of available cells to pop.}
//\notes{If there is possibility to call Pop without being sure about
//available cells, than this function should be use to check it. Otherwise
//exception will be raised if Pop is performed on empty or not enough filled
//PPArray.} 
//\example{if (PPReady() \{Pop(arr);...\}}{} 
//\seealso{} 
//DE
native PPReady(ppindex=0)=-212; //NI


//DS
//\subsection{PPFree}
//\annotation{Number of free cells for Push in Push Pop Array}
//\syntax{PPFree(ppindex=0)} 
//\param{ppindex}{index of PPArray arbiter, $<$0..3$>$}  
//\returns{Number of free cells to push.}
//\notes{Using this function is ensured that oldest Push will 
//not be thrown away.}
//\example{if (PPFree() \{Push(arr);...\}}{} 
//\seealso{PPReady} 
//DE
native PPFree(ppindex=0)=-213; //NI


//DS
//\subsection{STEP definition}
//\annotation{Defined values for step types}
//\define{STEP\_NOTHING}{0}
//\define{STEP\_FIRST}{1}  
//\define{STEP\_FORWARD}{2}
//\define{STEP\_BACKWARDS}{3}
//\define{STEP\_RIGHT}{4}
//\define{STEP\_LEFT}{5}
//\define{STEP\_UPRIGHT}{6}
//\define{STEP\_UPLEFT}{7}
//\define{STEP\_DOWNRIGHT}{8}
//\define{STEP\_DOWNLEFT}{9}
//\define{STEP\_HEAD}{10}
//DE

#define    STEP_NOTHING         0
#define    STEP_FIRST           1  
#define    STEP_FORWARD         2
#define    STEP_BACKWARDS       3
#define    STEP_RIGHT           4
#define    STEP_LEFT            5
#define    STEP_UPRIGHT         6
#define    STEP_UPLEFT          7
#define    STEP_DOWNRIGHT       8
#define    STEP_DOWNLEFT        9
#define    STEP_HEAD           10


//DS
//\subsection{TURNS definition}
//\annotation{Defined values for turn types}
//\param{TURN\_RIGHT}{0}
//\param{TURN\_LEFT}{1}           
//DE

#define TURN_RIGHT  0
#define TURN_LEFT   1           

//DS
//\subsection{\_w}
//\annotation{Creates initialized walker with its default direction}
//\syntax{\_w(side,square=-1)}
//\param{side}{side number or index number of square} 
//\param{square}{square number}
//\returns{Returns initialized walker with its default direction.} 
//\notes{Input to this function can be either side and square number or just square index. Second case is used if
//square argument is used with its default value.}
//\example{walk=\_w(4)}{, initialized walk to square index number 4}
//\examplen{walk=\_w(4,3)}{, initialized walk to side 4, square 3}
//\seealso{WalkerMove, WalkerTurn}
//DE
native _w(side,square=-1)=-118;  //NI

//DS
//\subsection{WalkerMove}
//\annotation{Move walker on the cubic surface}
//\syntax{WalkerMove(\&w,step=STEP\_FORWARD)}
//\param{w}{walker that will be moved} 
//\param{step}{type of move to proceed with}
//\returns{This function return 1 if the walker went over the edge, otherwise returns 0.}
//\notes{The step parameter is one step types.}
//\example{WalkerMove(walk)}{, move walk one step forward}
//\examplen{WalkerMove(walk,STEP\_RIGHT)}{, move walk one step to the right without turning}
//\seealso{WalkerTurn}
//DE
native WalkerMove(&w,step=STEP_FORWARD)=-101;

//DS
//\subsection{WalkerTurn}
//\annotation{Turns walker to the right or left}
//\syntax{WalkerTurn(\&w,step=TURN\_RIGHT)} 
//\param{w}{walker to be turned} 
//\param{step}{type of turn to proceed} 
//\returns{This function returns always return 0.} 
//\notes{The step parameter may be one of these:}
//\param{TURN\_RIGHT}{turns walker to the right} 
//\param{TURN\_LEFT}{turns walker to the left}
//\example{WalkerTurn(walk)}{turns walk to the right}
//\examplen{WalkerTurn(walk),TURN\_LEFT)}{turns walk to the left}
//\seealso{WalkerPlace, WalkerMove}
//DE
native WalkerTurn(&w,step=TURN_RIGHT)=-102;

//DS
//\subsection{WalkerDiff}
//\annotation{Calculates distance in 2D coordinate system and hint the next step}
//\syntax{WalkerDiff(wa,wb,\&dx,\&dy)} 
//\param{wa}{walker or index of spot A}  
//\param{wb}{walker or index of spot B}
//\param{dx}{place where to store difference in x coordinate}
//\param{dy}{place where to store difference in y coordinate}
//\returns{Immediate return value gives step type how to wa should continue to meet wb.}
//\param{STEP\_NOTHING}{walkers are at same spot or at opposite sides!!!!!}
//\param{STEP\_ ...}{if walker wa proceed with this step, he will be closer to wb}
//\notes{Dx and dy will contain values that represent number of steps in each direction
//that walker wa would have to make to reach wb in order dx and dy. If wa would continue
//by given suggested step and than ask for another one, finally it would reach wb. 
//Returned step is determined by highest absolute value between dx and dy. Dx relates to
//STEP\_FORWARD and STEP\_BACKWARDS, while dy is STEP\_LEFT and STEP\_RIGHT. If wa is on 
//opposite side of wb, than STEP\_NOTHING is performed and returned.}
//\example{WalkerDiff(23, GetCursor(),dx,dy)}{, difference from index 23 to actuall cursor} 
//\seealso{WalkerStepTo, GetCursor, ReadAcc}
//DE
native WalkerDiff(wa,wb,&dx,&dy)=-103;

//DS
//\subsection{WalkerStepTo}
//\annotation{Easier version of WalkerDiff}
//\syntax{WalkerStepTo(\&wa,wb)} 
//\param{wa}{walker that will be moved towards wb}  
//\param{wb}{target walker or spot index for direction}  
//\returns{Function returns same step that walker wa perfomed inside the function.}
//\notes{If wa is on opposite side of wb, than STEP\_NOTHING is performed and returned.} 
//\example{WalkerStepTo(player,GetCursor()}{, moves player towards the cursor} 
//\seealso{WalkerDiff} 
//DE
native WalkerStepTo(&wa,wb)=-108;


//DS
//\subsection{OppositeStep}
//\annotation{gives opposite step} 
//\syntax{OppositeStep(step)} 
//\param{step}{type of step to obtain its opposite}  
//\returns{Returns type of step that is exact opposite}
//\example{move\_back=OppositeStep(last\_step)}{}  
//DE
native OppositeStep(step)=-105;

//DS
//\subsection{GetSymmetrySquare}
//\annotation{Returns central symmetric point}
//\syntax{GetSymmetrySquare(wi)}
//\param{wi}{walker or spot index} 
//\returns{Returns walker placed on central symmetric square to the input} 
//\notes{Returned walker has its default orientation}
//\example{s=GetSymmetrySpot(w)}{}
//\examplen{s=GetSymmetrySpot(\_w(2,4))}{}
//DE
native GetSymmetrySquare(wi)=-106;

//DS
//\subsection{WalkerTap}
//\annotation{Moves walker based on recognized taps toward side that has been tapped} 
//\syntax{WalkerTap(\&w,\&up\_down\_flag)}
//\param{w}{walker to be moved} 
//\returns{Returns value that is related to the result of the move, also it fills
//up\_down\_flag by: -1 tap was from opposite side or 1 - tap was from the same side,
//note that at two above cases function returns 0 and no move has been proceed, it
//is up to user to decide what to do in such cases.}
//\param{0}{no move, either taps has not been recognized or is not registered,
//or the tap was either from same or opposite side}
//\param{1}{walker moved 1 step towards the tap side}
//\param{2}{walker moved 1 step towards the tap side and went over the edge}
//\notes{For proper work of this function, all sidetaps must be registered, because inside
//this function is motion output is read. Also walker itself is being turned to look towards
//the tap!} 
//\example{result=WalkerTap(w,up\_down)}{}
//\seealso{WalkerDirUp} 
//DE
native WalkerTap(&w,&up_down_flag)=-107;


//DS
//\subsection{WalkerGetDir}
//\annotation{Retreive direction vector from walker}
//\syntax{WalkerGetDir(wlk,vect[3])} 
//\param{wlk}{walker for examination}  
//\param{vect[3]}{vector of size 3, where to store direction vector}   
//\notes{This function unpack direction vector from the structure of walker.} 
//\example{WalkerGetDir(wlk,dir)}{, retrieves direction vector form wlk into dir} 
//\seealso{WalkerSetDir} 
//DE
native WalkerGetDir(w,vect[3])=-111;

//DS
//\subsection{WalkerSetDir}
//\annotation{Tries to apply to walker given direction vector}
//\syntax{res=WalkerSetDir(\&wlk,vect[3])} 
//\param{wlk}{walker or index to be modified }  
//\returns{Returns 1 if operation was successful or 0 if the operation failed, that
//means for example that this direction vector can not be forced into current spot.}
//\notes{None all of the direction vectors can be forced to every spot over the cube,
//that is one should be careful to using this function and also that is why this function
//returns 0 when the operation fails.} 
//\example{new vect[3]=[1,0,0]; WalkerSetDir(wlk,vect)}{} 
//\seealso{WalkerGetDir} 
//DE
native WalkerSetDir(&w,vect[3])=-112;        

//DS
//\subsection{WalkerGetNorm}
//\annotation{Retreive normal vector from walker}
//\syntax{WalkerGetNorm(wlk,vect[3])} 
//\param{wlk}{walker for examination}  
//\param{vect[3]}{vector of size 3, where to store normal vector}   
//\notes{This function unpack normal vector from the structure of walker.} 
//\example{WalkerGetNorm(wlk,norm)}{retrieves normal vector form wlk into norm} 
//DE
native WalkerGetNorm(w,vect[3])=-113;         


//DS
//\subsection{WalkerDirUp}
//\annotation{Modifies walker direction to look up according to accelerometer output}
//\syntax{WalkerDirUp(\&w,all\_dirs=1,treshold=50,past=0)} 
//\param{w}{walker to be modified}  
//\param{all\_dirs}{if set to 1, walker direction will be update all around,
//if set to 0, only turns to left and right will be allowed}
//\param{treshold}{gives minimum threshold for gravity, which is usually applied on top side}
//\param{past}{how old accelerometer data to use}
//\returns{This function returns value that represent what happen to walker.}
//\param{0}{no turn and acc data below threshold}
//\param{1}{no turn but acc over threshold}
//\param{2}{turn according to all\_dirs}
//\notes{This function works with accelerometer data, so it is possible to add threshold
//that must be overcome to perform the turn. This is useful is the change of direction
//is happening on the top side, where the biggest acceleration is masked.} 
//\example{WalkerDirUp(w)}{, update walker w} 
//\examplen{WalkerDirUp(w,0,100)}{, update walker w only to turn right, left with threshold 100}
//\seealso{WalkerTap} 
//DE
native WalkerDirUp(&w,all_dirs=1,treshold=50,past=0)=-116;

//DS
//\subsection{WalkerCompareDir}
//\annotation{Campares direction vectors of two walkers}
//\syntax{WalkerCompareDir(wa,wb)} 
//\param{wa}{walker a to compare with walker b}  
//\param{wb}{walker b to compare with walker a}  
//\returns{Returned number reflects relation between two direction vectors}
//\param{0}{Direction vectors are perpendicular} 
//\param{1}{Directions are same} 
//\param{-1}{Directions are opposite} 
//\example{WalkerCompareDir(wlka,wlkb)}{} 
//DE
native WalkerCompareDir(w1,w2)=-117;


//DS
//\subsection{WalkerBuddy}
//\annotation{Check walker neighborhood and step suggestion}
//\syntax{WalkerBuddy(wa,wb,\&step)} 
//\param{wa}{source walker for neighborhood check}  
//\param{wb}{walker to check if in neighborhood}
//\param{step}{place where suggested step will be stored}
//\returns{This function returns value that represent relation between wa and wb.}
//\param{0}{wa is on same spot as wb}
//\param{1}{wa must do perpendicular step to reach wb}
//\param{2}{wa must do diagonal step to reach wb}
//\param{3}{wa is too far to reach wb in one signle step}
//\notes{This function checks if wb is in close neighborhood to wa. It also suggest
//step which wa can perform to reach spot if wb. In case wb is too far away form wa
//number 3 is returned and step is filled by STEP\_NONE.} 
//\example{if (WalkerBuddy(wa,wb,step)<3) \{...\}}{, if wb close to wa do ...} 
//\examplen{WalkerBuddy(wa,wb,step)}{, if wb close to wa, put the step into step}
//\seealso{WalkerTap} 
//DE
native WalkerBuddy(wa,wb,&step)=-114;          

  
//DS
//\subsection{Play}
//\annotation{Plays sound resource from file system}
//\syntax{Play(song\{\})} 
//\param{song\{\}}{name of the the sound resource from file system}  
//\notes{This function starts to play given file name immediately on first
//free audio channel. If no channel is free, it override the channel, that 
//has the oldest track to play} 
//\example{Play("myvoice")}{} 
//\seealso{SetAudioForce} 
//DE
native Play(song{}) = -150

//DS
//\subsection{SetAudioForce}
//\annotation{Enables forcing audio to channel 0}
//\syntax{SetAudioForce(value)} 
//\param{value}{1 - enables audio force, 0 - disable audio force}  
//\notes{This function can enable audio force on channel zero, after enabling,
//channel zero is not used for overriding when new play command is invoked. It is
//used to force play audio data at situation where more resources are mixed and
//one sound must be completely played without interruption. To use channel zero with
//forcing function Play must have in its song name at the beginning character "@"} 
//\example{SetAudioForce(1)}{}
//\examplen{Play("@forcesong")}{}
//\seealso{Play} 
//DE
native SetAudioForce(value) = -151

//DS
//\subsection{SetVolume}
//\annotation{Sets audio playback volume}
//\syntax{SetVolume(value)} 
//\param{value}{level of volume from range $<$0,32768$>$}  
//\notes{This overrides current volume settings. Recommended maximum 
//number is 20000} 
//\example{SetVolume(5000)}{} 
//\seealso{Play} 
//DE
native SetVolume(value) = -152

//DS
//\subsection{Melody}
//\annotation{Play ring tone melody}
//\syntax{Melody(song\{\})} 
//\param{song\{\}}{string array containing ring tone melody}  
//\notes{This plays standard ring tone melody, which is automatically generated
//and system uses Play() for sending notes to output} 
//\example{mel="name:d=4,o=5,b=125:p,8p,16b,16a,b"}{}
//\example{Melody(mel)}{, starts to play mel} 
//\seealso{Play} 
//DE
native Melody(song{})= -153

//DS
//\subsection{WaitPlayOver}
//\annotation{Wait until any play in progress is over}
//\syntax{WaitPlayOver()} 
//\notes{This function cooperatively blocks the program until current playback is over.} 
//\example{WaitPlayOver()}{} 
//\seealso{WaitMelodyOver} 
//DE
native WaitPlayOver()=-154;


//DS
//\subsection{WaitMelodyOver}
//\annotation{Wait until current melody in progress is over}
//\syntax{WaitMelodyOver()} 
//\notes{This function blocks the program until current melody playback is over.
//It differs from previous function, because in melody playback can be played pauses, which
//would appear as the playback is over in case the previous function would be used} 
//\example{WaitMelodyOver()}{} 
//\seealso{WaitPlayOver} 
//DE
native WaitMelodyOver()=-155

//DS
//\subsection{IsPlayOver}
//\annotation{Check is playback is in progress}
//\syntax{IsPlayOver()} 
//\notes{This function returns 1 if there is no playback in progress, otherwise 
//returns 0.} 
//\example{if (IsPlayOver()) \{...\}}{} 
//\seealso{IsMelodyOver} 
//DE
native IsPlayOver()=-157;

//DS
//\subsection{IsMelodyOver}
//\annotation{Check is generation of ring tone melody is in progress}
//\syntax{IsMelodyOver()} 
//\notes{This function returns 1 if there is no ring tone generation in progress, otherwise 
//returns 0.} 
//\example{if (IsMelodyOver()) \{...\}}{} 
//\seealso{IsPlayOver} 
//DE
native IsMelodyOver()=-158;

//DS
//\subsection{Quiet}
//\annotation{Stops all current playback with melody generation.}
//\syntax{Quiet()} 
//\notes{This function stops all ongoing playbacks and also melody generation.} 
//\example{Quiet()}{} 
//DE
native Quiet()=-156 
 
//DS
//\subsection{ReadAcc}
//\annotation{Retreive accelerometer game data}
//\syntax{ReadAcc(data[3],past=5)} 
//\param{data}{3 cell size vector for storing acc data}  
//\param{past}{how deep in acc buffer reach into history $<$0,50$>$}  
//\notes{When there is any motion like tap or so, it is much
//better to take data before this even happened, because they
//reflects to situation when user wanted to do some action. 
//recommended and standard value is 4, that means data are 32 ms old.} 
//\example{ReadAcc(data)}{, reads 32 ms old acceleration data} 
//\examplen{ReadAcc(data,0)}{, reads newest acceleration data}
//\seealso{GetCursor} 
//DE
native ReadAcc(data[3],past=4)=-215;  

//DS
//\subsection{GetCursor}
//\annotation{Retreiveing of gravity cursor}
//\syntax{cursor=GetCursor(past=4)} 
//\param{past}{tells how old data from accelerometer used to cursor computation}  
//\returns{This function return walker on spot that relates to gravity
//cursor with default orientation}
//\example{cusor=GetCursor()}{, standard cursor}
//\examplen{cusor=GetCursor(0)}{, cursor from newest data}
//\seealso{ReadAcc} 
//DE
native GetCursor(past=4)=- 216;

//DS
//\subsection{GetMsecs}
//\annotation{Miliseconds from system start}
//\syntax{res=GetMsecs()} 
//\returns{Number of milliseconds from system start}
//\example{res=GetMsecs()}{} 
//\seealso{GetAppMsecs} 
//DE
native GetMsecs()=-230;

//DS
//\subsection{GetAppMsecs}
//\annotation{Miliseconds from application start}
//\syntax{res=GetAppMsecs()} 
//\returns{Number of milliseconds from application start}
//\example{res=GetAppMsecs()}{} 
//\seealso{GetMsecs} 
//DE
native GetAppMsecs()=-231;

//DS
//\subsection{StartGameMenu}
//\annotation{Start of the game menu}
//\syntax{StartGameMenu()} 
//\notes{This function immediately starts game menu.} 
//\example{StartGameMenu()}{} 
//DE
native StartGameMenu()=-232;

//DS
//\subsection{SetRndSeed}
//\annotation{Set random seed into random generator.}
//\syntax{SetRndSeed(seed)} 
//\param{seed}{seed to random generator}  
//\example{SetRandomSeed(500)}{} 
//\seealso{GetRnd} 
//DE
native SetRndSeed(seed)=-233;

//DS
//\subsection{GetRnd}
//\annotation{Read value from random generator}
//\syntax{GetRnd(size)} 
//\param{size}{defines output size}  
//\returns{Returns (value\%size)}
//\notes{This function returns value from random generator with its modulo operation 
//over given size} 
//\example{GetRnd(3)}{, gives back numbers in range $<$0,2$>$} 
//\seealso{SetRndSeed} 
//DE
native GetRnd(size)=-234;

//DS
//\subsection{SetRandomizeFlag}
//\annotation{Enables or disables randomizing by accelerometer}
//\syntax{SetRandomizeFlag(flag)} 
//\param{flag}{1 - enables randomizing (default), 0 - disables randomizing}  
//\notes{Regulary the random number generator is irregularly read according
//lowest bits at accelerometer output. But at some case is necessary that generator is
//predictable, in this is by disabling randomizing by accelerometer results
//in stable sequence of data from same random seed.} 
//\example{SetRandomizeFlag(1)}{} 
//\seealso{GetRnd, SetRndSeed} 
//DE
native SetRandomizeFlag(flag)=-235;

//DS
//\subsection{SetStillClick}
//\annotation{Enables or disables still\_click feature}
//\syntax{SetStillClick(value)} 
//\param{value}{1 - enables, 0 - disables (default)}  
//\notes{Still\_click feature if enabled, waits for cube to be still, before 
//any motion is recognized. In such case, user usually not do any phantom "clicks"
//when for example transfers cube from hand to hand, but before tapping, he must
//hod the cube very still.} 
//\example{SetStillClick(1)}{} 
//DE
native SetStillClick(value)=-237;

//?DS
//\subsection{AddActiveTime}
//\annotation{Adding active time for script}
//\syntax{AddActiveTime()} 
//\notes{This function adds 1 minute of active time. When no movements is detected
//than after 10 minutes cube hibernates and waits for game menu. If script for example
//wants to perform alarm functionality, he needs to add active times to prevent this,
//because in hibernation, script is terminated. Note that when the scripts does not
//light anything nor play, power consumption is very low} 
//\example{AddActiveTime}{adds 1 minute to active time} 
//\seealso{} 
//DE
native AddActiveTime()=-238;


//?DS
//\subsection{ModeSelect}
//\annotation{Easy selection of number in range <1,6>}
//\syntax{ModeSelect(maxmode)} 
//\param{maxmode}{Number in range <1,6>}  
//\returns{selected mode}
//\notes{This function offer simple selection of modes, level and so on.
//As example if maxmode is 6, there is number on each side and user can
//select one side rotating it to top and tan tap from top to confirm selection} 
//\example{ModeSelect(6)}{} 
//\seealso{DrawScore,SayScore} 
//DE
native ModeSelect(maxmode)=-239;

//DS
//\subsection{SCORE definition}
//\annotation{Defined values for score types.}
//\define{SCORE\_NORMAL}{0}
//\define{SCORE\_WINNER}{1}
//\define{SCORE\_LOSER}{2}
//DE                           

#define		SCORE_NORMAL		0
#define 	SCORE_WINNER		1
#define		SCORE_LOSER		  2

//DS
//\subsection{Score}
//\annotation{Display and announce reached score}
//\syntax{Score(score,flag=SCORE\_NORMAL,voice=1,double\_tap=1)} 
//\param{score}{actual score to display $<$0,999$>$}  
//\param{flag}{score color version type from SCORE definition}  
//\param{voice}{if set to 1, score is announced}
//\param{double\_tap}{if set to 1, function is waiting for double tap to restart
//and also voice "double tap to restart the game" is announced}
//\notes{This function draws score on the cube without using standard drawing method.
//It is recommended to use it at the end of game without any other drawing. Color scheme
//is selected by score definition type. It can announce the score by voice and it also can
//wait for double tap to restart the game. To draw the score in standard way, see the example
//bellow.} 
//\define{SCORE\_NORMAL}{blue score - middle range}
//\define{SCORE\_WINNER}{colorfull score - high range}
//\define{SCORE\_LOSER}{red score - low range}
//\example{Score(199)}{, draw 199 in NORMAL colors, announces the score and
//waits for double tap}
//DE
native Score(score,flag=SCORE_NORMAL,voice=1,double_tap=1)=-240;

//DS
//\subsection{DrawScore}
//\annotation{Example of drawing score at regular way}
//\begin{verbatim}
////this function draws up to three digit number, same as score
//draw_score(side,number)
//{
// new walker=_w(side,0)  //creates walker with default direction at square 0 
// new i
// new h=number/100
// number%=100
// new t=number/10
// number%=10
// new o=number
// 
// if (h) DrawDigit(walker,h)
// for (i=0;i<3;i++) WalkerMove(walker,STEP_BACKWARDS)
// if (h || t ) DrawDigit(walker,t)
// for (i=0;i<3;i++) WalkerMove(walker,STEP_RIGHT)
// DrawDigit(walker,o)
//}
//\end{verbatim}
//DE





//DS
//\subsection{DrawDigit}
//\annotation{Draw digit with font 3x3}
//\syntax{DrawDigit(w,digit)} 
//\param{w}{walker from where it starts to draw line by line}
//\param{digit}{digit to draw $<$0..9$>$}
//\notes{This function draws digit by preset color and attributes. Drawing starts
//from the walker position and continues to the right and down. Font is 3x3.} 
//\example{DrawDigit(wlk,5)}{} 
//DE
native DrawDigit(w,digit)=-242;

//DS
//\subsection{IsGameResetRequest}
//\annotation{Game reset request from user}
//\syntax{IsGameResetRequest()} 
//\notes{Function returns positive value if during script start user tapped three times
//to the icon. This function is usually used with puzzles that stores their state in variables.} 
//\example{if (IsGameResetRequest()) \{...init game...\}}{} 
//DE
native IsGameResetRequest()=-219;

//DS
//\subsection{Vibrate}
//\annotation{Vibrate for given amount of milliseconds}
//\syntax{Vibrate(msec=100)}
//\param{msec}{number of milliseconds for vibration} 
//\notes{Maximum number of milliseconds is 5000. Each time this function is called, 
//vibration is block for double amount of time. Vibrate(150) blocks another call
//within next 300 milliseconds.} 
//\example{Vibrate(150)}{, vibrates for 150 milliseconds} 
//DE
native Vibrate(msec=100)=-220;


//DS
//\subsection{ICON magics}
//\annotation{Defined values for ICON magics}
//\define{ICON\_MAGIC1}{0x78948396}
//\define{ICON\_MAGIC2}{0xAABBEEDD}
//DE

#define ICON_MAGIC1  0x78948396
#define ICON_MAGIC2  0xAABBEEDD


//DS
//\subsection{ICON}
//\annotation{Insertion of icon and sound information into code}
//\syntax{ICON(icon[])} 
//\param{icon}{array that defines icon and sound resources}  
//\notes{This function uses array icon and therefore it is not removed form the
//code during optimization. Array for icon must have special format to be recognized
//by the cube. Icon itself is colorful icon that replaces selected game
//at the game menu and by its taping, user script selected and started. Icon has
//mandatory length and MAGIC fields. Additionally into icon array are added two names
//of sound file that are used as name and explanation.}
//\define{ICON\_MAGIC1}{icon MAGIC1}
//\define{ICON\_MAGIC2}{icon MAGIC2}
//\param{menu}{menu number $<$0..2$>$, on which game menu shall the icon appear, blue menu is
//menu number 0}
//\param{side}{absolute side $<$0..5$>$, on which side at selected menu the icon shall appear}
//\param{9 cells}{nine colors that represent the icon on 3x3 matrix}
//\param{name}{unpacked name of sound file that represents the name of the script in menu}
//\param{expl}{unpacked name of sound file that represents the explanation of the script in menu}
//\begin{verbatim}
//...
//icon[]=[ICON_MAGIC1,ICON_MAGIC2,1,1,
//        RED,BLUE,RED,BLUE,RED,BLUE,GREEN,GREEN,GREEN,
//        ''INSTMR2'',''UFO'']
//...
//icon[]=[ICON_MAGIC1,ICON_MAGIC2,1,1,
//        RED,BLUE,RED,BLUE,RED,BLUE,GREEN,GREEN,GREEN,
//        '''','''']
//
//ICON(icon)
//...
//\end{verbatim}
//\notes{Second example shows case when sounds resources are not setup. If you do not want
//to have them, you should add there empty unpacked strings for correct operation. NOTE THAT
//ARRAY "icon" MUST BE DEFINED IN GLOBAL NAME SPACE!!! Otherwise the icon might be wrongly 
//recognized in bytecode.}
//\examplen{ICON(icon)}{, icon is used and will be recognized in byte code by the cube} 
//DE
native ICON(icon[])=-243;


//DS
//\subsection{PrintArray}
//\annotation{Debug function, print array values to terminal}
//\syntax{PrintArray()} 
//\example{PrintArray()}{}
//\seealso{PrintCnv, printf} 
//DE
native PrintArray(arr[],size=sizeof arr)=-244;


//DS
//\subsection{VARIABLE magics}
//\annotation{Defined values for VARIABLE magics}
//\define{VAR\_MAGIC1}{0x12AAF0B5}
//\define{VAR\_MAGIC2}{0x190203BD}
//DE
#define VAR_MAGIC1	 0x12AAF0B5
#define VAR_MAGIC2	 0x190203BD

//how to register
//new _var[]=[VAR_MAGIC1,VAR_MAGIC2,''MYVAR'']  //(name up to 24 chars, must be more than > 6)
//RegisterVariable(_var);  now the variable will not be erased if found in RAM, FLASH or MYCUBE

//max variable size is 2004 bytes (513 cells), you can register up to 10, but I recommend to use just one
//in one script..because variable is in reality stored in flash only if..you use different named 
//variable or you switch off the cube. Variable is design to be updated often, because is stored 
//in ram until really needed to put into flash (done automatically). 


//DS
//\subsection{RegisterVariable}
//\annotation{Register named variable array to notify system to keep the variable active.}
//\syntax{RegisterVariable(var[])} 
//\param{var}{array that contains VAR\_MAGIC1, VAR\_MAGIC2 and variable name, variable name
//must be longer than 6 characters and shorter than 24 characters}  
//\notes{Variable array must have specified format in order to be correctly registered,
//if the variable is not registered, it will be erased from the system ad unused one. 
//NOTE THAT ARRAY "var" MUST BE DEFINED IN GLOBAL NAME SPACE!!! Otherwise the variable might be wrongly 
//recognized in bytecode.} 
//\begin{verbatim}
//...
//var[]=[VAR_MAGIC1,VAR_MAGIC2,''my_variable_name'']
//RegisterVariable(var)
//...
//\end{verbatim}
//\seealso{StoreVariable, LoadVariable} 
//DE
native RegisterVariable(var[])=-245;


//DS
//\subsection{StoreVariable}
//\annotation{Stores given array as named variable}
//\syntax{StoreVariable(name[],arr[],size=sizeof arr)} 
//\param{name}{name of the registered variable}  
//\param{arr[]}{array af data to be stored}
//\param{size}{size of the array, maximum is 501 cells}
//\notes{Variable is store into non-volatile memory over buffer in RAM. As long
//as the script is using same one variable, it can store it as many times as needed.
//Write into non-volatile memory is performed when different variable is used or
//if the cube is switched off. One script should not use more than one variable.
//If does so, number of writing to non-volatile memory is limited to 5/5secs and total limit 20/script.} 
//\example{StoreVariable(''my\_variable\_name'',data)}{, stores data as named variable}
//\seealso{LoadVariable, RegisterVariable} 
//DE
native StoreVariable(name[],arr[],size=sizeof arr)=-246;


//DS
//\subsection{LoadVariable}
//\annotation{Load data of named variable to given array}
//\syntax{LoadVariable(name[],arr[],size=sizeof arr)} 
//\param{name}{name of the registered variable}  
//\param{arr[]}{destination array}
//\param{size}{size of the array, maximum is 501 cells}
//\returns{This function returns 1 if variable has been loaded or 0 if there is
//problem or variable does not yet exists.}
//\example{LoadVariable(''my\_variable\_name'',data)}{, load named variable to data}
//\seealso{SaveVariable, RegisterVariable} 
//DE
native LoadVariable(name[],arr[],size=sizeof arr)=-247;

//DS
//\subsection{Restart}
//\annotation{Restart current script}
//\syntax{Restart()} 
//\example{Restart()}{, script will be restarted} 
//DE
native  Restart()=-229;

//DS
//\subsection{CollisionTest}
//\annotation{Test two arrays for collisions}
//\syntax{CollisionTest(source1[],source2[],dest[],val=1;sizes1=sizeof source1,sizes2=sizeof source2,sized=sizeof dest)} 
//\param{source1}{first source array for collision test}  
//\param{source2}{second source array for collision test}  
//\param{dest}{destination array to store result from collision test}  
//\param{val}{value indicating collision to be stored into destination array}  
//\param{sizes}{sizes of all arrays that must be same}  
//\returns{Function returns number of collision points.}
//\notes{Destination array is cleared prior the operation. Collision is performed
//by easy condition if (source1[index] \&\& source2[index]) \{dest[index]=val\}}
//\example{if (CollisionTest(a,b)) \{....\}}{, test number of collision points with using dest} 
//\examplen{if (CollisionTest(a,b,dest,WHITE)) \{....\}}{, test number of collision points and stores WHITE into dest}
//DE
native CollisionTest(source1[],source2[],dest[]=0,val=1,sizes1=sizeof source1,sizes2=sizeof source2,sized=sizeof dest)=-221;


//DS
//\subsection{ApiVer}
//\annotation{Version of current API}
//\syntax{res=ApiVer()} 
//\returns{Actuall version of API}
//\example{res=ApiVer()}{, retrieve version of API} 
//DE
native ApiVer()=-250;


//DS
//\subsection{Useful macros}
//\annotation{Useful defined macros}
//\define{INDEX\_MASK}{0x000000FF, mask for retrieving index}
//\define{\_i(val)}{(val\&INDEX\_MASK), index macro}
//\define{\_is(data,bit)}{(data\&(1<<bit)), test bit macro}
//\define{\_side(index)}{(index/9)}
//\define{\_square(index)}{(index\%9)}
//\define{abs(val)}{((val) < 0 ? -(val) : (val))}
//\define{min(a,b)}{(a < b ? a : b)}
//\define{max(a,b)}{(a > b ? a : b)}
//DE


//DS
//\subsection{Macros examples}
//\annotation{Typical situation where macros are used}
//\begin{verbatim}
//playground[_i(GetCursor())]=1           //conversion of cursor
//                                        //square to array index
//
//playground[_i(walker)]=1                //conversion of walker
//                                        //square to array index
//
//if (_side(prev)!=_side(GetCursor())     //test for different sides
//
//if (_i(prev)!=_i(GetCursor())           //test for different indexes
//                                        //of squares
//
//if (_square(prev)!=_square(GetCursor()) //test for different squares
//                                        //numbers
//
//w=_w(_side(GetCursor()),4)              //center walker w at side
//                                        //given by cursor
//
//if (_is(motion,TAP_DOUBLE))             //test if double tap flag
//                                        //is set up
// 
//\end{verbatim}
//DE


#define INDEX_MASK   (0x000000FF)
#define _i(%1)       (%1&INDEX_MASK)
#define _is(%1,%2)   (%1&(1<<%2))
#define _side(%1)    (_i(%1)/9)
#define _square(%1)  (_i(%1) % 9)
#define abs(%1)      ((%1) < 0 ? -(%1) : (%1))
#define min(%1,%2)   (%1 < %2 ? %1 : %2)
#define max(%1,%2)   (%1 > %2 ? %1 : %2)

//DS
//\section{Release notes}
//\subsection{SDK manual}
//\annotation{Release notes for SDK maual document version 1.4}
//\param{+}{multiple script support from FW 4.5 and RFC 0.8}
//\param{-}{removed "setpawn" and "setpawnstd" commands, that become obsolete for FW 4.5}
//\param{+}{new command "setpawnauto" that replaces previous two mentioned for FW 4.5}
//\param{+}{new command "pdir" that lists all installed scripts for FW 4.5}
//\param{+}{new commands "pawneraseflash" and "pawnerasemycube" for FW 4.5}
//\annotation{Release notes for SDK maual document version 1.3}
//\param{+}{varpawnrease changed to varpawnerase}
//\subsection{futurocube.inc}
//\annotation{Release notes for futurocube.inc version 1.2}
//\param{*}{No change in API}
//\param{-}{Removed refferences to WalkerInit, it was previous version of \_w}
//\param{+}{SCORE\_LOOSER changed to SCORE\_LOSER}
//\param{+}{Updated info about Score and added example how to draw score in regular way}
//\param{+}{Added macros examples}
//\param{+}{Added important note to ICON and RegisterVariable}
//DE

  

