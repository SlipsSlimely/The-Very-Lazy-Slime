/// @description General Player movement

depth = -30;

//control setup
controlsSetup();

//Animation control
lastAnim = 0;
pauseAnim = 0;

//Moving
moveDir = 0;
moveSpd = 1.5;
xspd = 0;
yspd = 0;


//Jumping
grav = .275; //Fall speed, increases per frame until it reaches the cap
termVel = 4; //Max fall speed
jspd = -3.15; //Jump Speed
jLimit = 0; //Jump limiter, the crux of the game
jumpCount = 0;
jumpHoldTimer = 0;
jumpHoldFrames = 18;
onGround = true;

//Reset variable
resetTimer = 0;

//Moving Platforms
myFloorPlat = noone;
moveplatXspd = 0;