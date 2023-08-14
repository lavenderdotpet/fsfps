models/fx/ShotflashStreak
{
	cull disable
	{
		clampMap models/fx/flash_sg
		blendFunc GL_ONE GL_ONE	

	}
}

models/fx/ShotflashSprite.001
{
//	deformVertexes autoSprite
	{
		clampMap models/fx/flash_sg
		blendFunc GL_ONE GL_ONE
		tcMod rotate 86
	}
}

models/props/smoking
{
	deformVertexes autoSprite
	{
		clampmap models/props/smoking
		blendFunc blend
		//blendFunc add
		rgbGen lightingdiffuse
	tcMod rotate 16
	}
}
models/fx/mgunflashStreak
{
	cull disable
//deformVertexes autoSprite2

	{
		clampMap models/fx/flash_mg
		blendFunc GL_ONE GL_ONE	

	}
}

rifFlashStreak
{
	cull disable
//deformVertexes autoSprite2

	{
		clampMap models/fx/flash_rf
		blendFunc GL_ONE GL_ONE	

	}
}

models/fx/mgunflashSprite
{
//	deformVertexes autoSprite
	{
		clampMap models/fx/flash_mg
		blendFunc GL_ONE GL_ONE
		tcMod rotate 144
	}
	{
		clampMap models/fx/flash_mg
		blendFunc GL_ONE GL_ONE
		tcMod rotate -344
	}
}

models/fx/flashStreak
{
	cull disable
	{
		clampMap models/fx/flash_p
		blendFunc GL_ONE GL_ONE	

	}
}

models/fx/flashSprite
{
//	deformVertexes autoSprite
	{
		clampMap models/fx/flash_p
		blendFunc GL_ONE GL_ONE
		tcMod rotate 86
	}
}



models/vehicle/boat/glass
{
	//dp_water 0.1 0.1 9 17  0 0 0  1 1 1  0.7
	{
		map models/vehicle/boat/glass
		blendfunc add
		tcMod environment
		rgbGen lightingDiffuse
	}
}



models/vehicle/boat/boatyj
{
	dp_water 0.9 0.1 9 17  1 1 1  0 0 0  0.7
	{
		map models/vehicle/boat/boaty
		rgbGen lightingDiffuse
	}
}

