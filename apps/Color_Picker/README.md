![Color Picker](images/Color-Picker-150x150.png)
# Color Picker
## By: Kenneth Brandon July 2013
This app is intended to find good color combinations.

This script should allow someone to add or remove more Red, Green, and Blue to choose a color. Color RGB value printed to console.

### Usage
* Tapping on Red side will add or remove red.  
* Tapping on Blue side will add or remove Blue.
* Tapping on Green side will add or remove green.
* Tapping on Side 3 will change the amount of color added on each tap
* Switch Modes by tapping on sides 4 or 5 repeadly 5 times
```
Wrap  Mode  (Default Mode)
           [-][+][-]       				   [4]
           [-][+][-]    				[0][2][1][3]
           [-][-][-]       				   [5]
[r][r][r]  [b][b][b]  [g][g][g]  [-][+][-]
[r][R][r]  [b][B][b]  [g][G][g]  [-][+][-]
[r][r][r]  [b][b][b]  [g][g][g]  [-][+][-]
           [-][-][-]
           [-][+][-]   ("-" are off, "+" is the resulting RGB color, 
           [-][+][-]   capital letters are the current value of R G or B.
       
       Cube  Mode
           [g][g][g]       				   [4]
           [g][G][g]    				[0][2][1][3]
           [g][g][g]       				   [5]
[r][r][r]  [b][b][b]  [-][-][-]  [-][-][-]
[r][R][r]  [b][B][b]  [-][+][+]  [+][+][-]
[r][r][r]  [b][b][b]  [-][+][+]  [+][+][-]
           [-][-][-]
           [-][+][+]   ("-" are off, "+" is the resulting RGB color, 
           [-][+][+]   capital letters are the current value of R G or B.
```
