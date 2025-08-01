/// @description Insert description here

//Get inputs
getControls();

//X Movement
	//Direction
	moveDir = rightKey - leftKey; //Movement direction, left or right


	//Get xspd
	xspd = moveDir * moveSpd;

	//X collision
	var _subPixel = .5;
	if (place_meeting (x + xspd, y, oWall))
	{
		////First check if there is a slope to go up
		//if !place_meeting(x + xpsd,y - abs(xspd)-1, oWall )
		//{
			
		//}
		
		//Scoot up to wall precisely
		var _pixelCheck = _subPixel * sign(xspd);
		while !place_meeting ( x + _pixelCheck, y, oWall)
		{
			x += _pixelCheck;	
		}
	
		//Set xspd to zero to "collide"
		xspd = 0;
	}

	//Move
	x += xspd;
	
//Y Movement
	//Gravity
	yspd += grav;
	
	//Cap falling speed
	if (yspd > termVel) { yspd = termVel; };
	
	//Jump //This will become limited after I finish the tutorial, for now I'll comment the code out
	if (jumpKeyBuffered && jLimit == 0)
	{
		//Reset the buffer
		jumpKeyBuffered = false;
		jumpKeyBufferTimer = 0;
		
		//Increase jump counter
		jLimit++;
		
		//Set the jump hold timer
		jumpHoldTimer = jumpHoldFrames;
		onGround = false;
		myFloorPlat = noone;
	}
	//Cut off the jump by releasing the jump button
	if (!jumpKey)
	{
		jumpHoldTimer = 0;
	}
	//Jump based on the timer/holding the button
	if (jumpHoldTimer > 0)
	{
		//Constantly set the yspd to be jumping speed
		yspd = jspd;
		
		//Count down the timer
		jumpHoldTimer--;
	}
	
	
	//Floor Y collision
	
	//Check for solid and semisolid platforms under me
	var _clampYspd = max(0, yspd);
	var _list = ds_list_create(); // Create a DS list to store all of the objects we run into
	var _array = array_create(0);
	array_push( _array, oWall, oSemiSolidWall);
	
	//Do the actual check and add objects to list
	var _listSize = instance_place_list(x, y+1 + _clampYspd + termVel, _array, _list, false );
	
	//Loop through the colliding instances and only return one if it's top is below the player
	for(var i = 0; i < _listSize; i++)
	{
		//Get an instance of oWall or oSemiSolidWall from the list
		var _listInst = _list[| i];
		
		//Avoid magnestism
		if (_listInst.yspd <= yspd || instance_exists(myFloorPlat))
		&& ( _listInst.yspd > 0 || place_meeting( x, y+1 + _clampYspd, _listInst))
		{
			//Return a solid wall or any semisolid walls that are below the player
			if (_listInst.object_index == oWall
			|| object_is_ancestor(_listInst.object_index, oWall)
			|| floor(bbox_bottom) <= ceil( _listInst.bbox_top - _listInst.yspd))
			{
				//Return the highest wall object
				if (!instance_exists(myFloorPlat)
				|| _listInst.bbox_top + _listInst.yspd <= myFloorPlat.bbox_top + myFloorPlat.yspd //OR statement inside the if
				|| _listInst.bbox_top + _listInst.yspd <= bbox_bottom)
				{
					myFloorPlat = _listInst;
					resetTimer = 0;
				}
		}
	}
	}
	//Destroy the DS list to avoid a memory leak
	ds_list_destroy(_list);
	
	//One last check to make sure the floor platform is actually below us
	if (instance_exists(myFloorPlat) && !place_meeting(x, y + termVel, myFloorPlat))
	{
		myFloorPlat = noone;
		
	}
	
	//Land on the ground platform if there is one
	if (instance_exists(myFloorPlat))
	{
		//Scoot up to our wall precisely
		var _subPixel = .5;
		while !place_meeting(x, y + _subPixel, myFloorPlat) && !place_meeting(x, y, oWall)
		{
			y+= _subPixel;
		};
		//Make sure we don"t end up below the top of a semisolid
		if (myFloorPlat.object_index == oSemiSolidWall || object_is_ancestor(myFloorPlat.object_index, oSemiSolidWall))
		{
			while place_meeting(x, y, myFloorPlat)
			{
				y -= _subPixel;
			};
		}
		//Floor the y variable
		y = floor(y);
		
		//Collide with the ground
		yspd = 0;
		onGround = true;
	}


	//Move
	y += yspd;
	
//Final moving platform collisions and movement
	//X - moveplatXspd and collision
	//Geth the moveplatXspd
	moveplatXspd = 0;
	if (instance_exists(myFloorPlat)) 
	{
		moveplatXspd = myFloorPlat.xspd;	
	};
	
	//Move with moveplatXspd
	if place_meeting (x + moveplatXspd, y, oWall)
	{
		//Scoot up to the wall precisely
		var _subPixel = .5;
		var _pixelCheck = _subPixel * sign(moveplatXspd);
		while !place_meeting ( x + _pixelCheck, y, oWall)
		{
			x += _pixelCheck;	
		}
	
		//Set moveplatXspd to zero to "collide"
		moveplatXspd = 0;
	}

	//Move
	x += moveplatXspd;

	//Y - Snap myself to myFloorPlat
	if (instance_exists(myFloorPlat) 
	&& (myFloorPlat.yspd != 0
	|| myFloorPlat.object_index == oMovePlat
	|| object_is_ancestor(myFloorPlat.object_index, oMovePlat)
	|| myFloorPlat.object_index == oSemiSolidMovePlat
	|| object_is_ancestor(myFloorPlat.object_index, oSemiSolidMovePlat)))
	{
		//Snap to the top of the floor platform (un-floor our y variable)
		if (!place_meeting(x, myFloorPlat.bbox_top, oWall) 
		&& myFloorPlat.bbox_top >= bbox_bottom - termVel)
		{
			y = myFloorPlat.bbox_top;
		}
		
		//Going up into a solid wall while on a semisolid platform
		if (myFloorPlat.yspd < 0 && place_meeting(x, y + myFloorPlat.yspd, oWall))
		{
			//Get pushed down through the semisolid floor platform
			if (myFloorPlat.object_index == oSemiSolidWall || object_is_ancestor(myFloorPlat.object_index, oSemiSolidWall))
			{
				//Get pushed down
				var _subPixel = .25;
				while place_meeting(x, y + myFloorPlat.yspd, oWall)
				{
					y += _subPixel;
				};
				//If we got pushed into a solid wall while going downwards, push ourselves back out
				while place_meeting(x, y, oWall)
				{
					y -= _subPixel;
				};
				y = round(y);
			}
			
			//Cancel the myFloorPlat variable
			onGround = false;
			
		}
	}
	
//Animations
//Changing the animations based on directions and speeds
if (xspd > 0 && onGround = true)
{
	sprite_index = sSlimeRightAnimation;
	lastAnim = 1;
}
else if (xspd < 0 && onGround = true)
{
	sprite_index = sSlimeLeftAnimation;
	lastAnim = 2;
}
else if (xspd > 0 && yspd < 0 || lastAnim == 1 && yspd < 0 || lastAnim == 9 && yspd < 0 || lastAnim == 0 && yspd < 0)
{
	sprite_index = sSlimeJumpRightAnimation;
	lastAnim = 3;
}
else if (xspd < 0 && yspd < 0 || lastAnim == 2 && yspd < 0 || lastAnim == 10 && yspd < 0)
{
	sprite_index = sSlimeJumpLeftAnimation;
	lastAnim = 4;
}
else if (xspd > 0 && yspd > 0 || lastAnim == 3 && yspd > 0)
{
	sprite_index = sSlimeFallingRightAnimation;
	lastAnim = 5;
}
else if (xspd < 0 && yspd > 0 || lastAnim == 4 && yspd > 0)
{
	sprite_index = sSlimeFallingLeftAnimation;
	lastAnim = 6;
}
else if (lastAnim == 5 && yspd == 0 )
{
	sprite_index = sSlimeLandingRightAnimation;
	pauseAnim++;
	lastAnim = 7;
}
else if (lastAnim == 6 && yspd == 0)
{
	sprite_index = sSlimeLandingLeftAnimation;
	pauseAnim++;
	lastAnim = 8;
}
else if (lastAnim == 7 && xspd == 0 && image_index == 2 || lastAnim == 1 && xspd == 0)
{
	sprite_index = sSlimeIdleRightAnimation;
	pauseAnim = 0;
	lastAnim = 9;
}
else if (lastAnim == 8 && xspd == 0 && image_index == 2 || lastAnim == 2 && xspd == 0)
{
	sprite_index = sSlimeIdleLeftAnimation;
	pauseAnim = 0;
	lastAnim = 10;
}

if yspd = termVel && !instance_exists(myFloorPlat)
{
	resetTimer++;
}

//Reset progress
if (resetKey && room == Room1 || resetKey && room == Room2 || resetTimer >= 100 || resetKey && room == Room3 || resetKey && room == Room4 || resetKey && room == Room5)
{
	oPlayer.x = 16;
	oPlayer.y = 240;
	jLimit = 0;
	resetTimer = 0;
}