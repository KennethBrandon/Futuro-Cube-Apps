# Tilt Color
##### By: Kenneth Brandon July 2016

Turning the cube will change the cube's color.

The app reads in the accelerometer data and translates it's values into colors.

The X accelerometer turns into red, Y into green, and Z into blue.
When X is down, red will be zero, when it is up red will be 255.

I was hoping the app could transition through more colors, but I didn't realize that you would never get a (0,0,0) with the way I transformed the data into RGB.  I may look to improve this later.
