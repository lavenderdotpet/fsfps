/*
Copyright (C) 1997-2001 Id Software, Inc.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  

See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

*/

// draw.c

#include "r_local.h"


image_t		*draw_chars;				// 8*8 graphic characters

//=============================================================================

/*
================
Draw_FindPic
================
*/
image_t *Draw_FindPic (char *name)
{
	image_t	*image;
	char	fullname[MAX_QPATH];

	if (name[0] != '/' && name[0] != '\\')
	{
		Com_sprintf (fullname, sizeof(fullname), "pics/%s.pcx", name);
		image = R_FindImage (fullname, it_pic);
	}
	else
		image = R_FindImage (name+1, it_pic);

	return image;
}



void	Draw_8to24 (unsigned char *palette)
{
	byte	*pal;
	unsigned r,g,b;
	unsigned v;
	int		r1,g1,b1;
	int		j,k,l,m,ind;
	unsigned short i;
	unsigned	*table;
	FILE *f;
	char s[255];
	float gamma = 0;

//
// 8 8 8 encoding
//
	pal = palette;
	table = d_8to24tabble;
	for (i=0 ; i<256 ; i++)
	{
//		Con_Printf (".");	// loop an indicator
		r = pal[0];
		g = pal[1];
		b = pal[2];



		if (r>255) r = 255;
		if (g>255) g = 255;
		if (b>255) b = 255;
		pal += 3;
		v = (255<<24) + (r<<0) + (g<<8) + (b<<16);
		*table++ = v;
		
	}


	// The 15-bit table we use is actually made elsewhere (it's palmap)

	d_8to24tabble[255] &= 0xffffff;	// 255 is transparent
	d_8to24tabble[0] &= 0x000000;	// black is black


}



// leilei - Colored Lights
byte	palmap2[64][64][64];		// Higher quality for lighting

//Sys_Error("butts");
// this is just a lookup table version of the above

int FindColor (int r, int g, int b)
{
	int		bestcolor;

	if (r > 255)r = 255;if (r < 0)r = 0;
	if (g > 255)g = 255;if (g < 0)g = 0;
	if (b > 255)b = 255;if (b < 0)b = 0;
	bestcolor = palmap2[r>>3][g>>3][b>>3];
	return bestcolor;
}




// o^_^o

/*
===============
BestColor

comes from lumpy
===============
*/


/*
=============
R_CalcPalette

=============
*/
byte		*thepalette;

void R_GetPalette (void)
{
	static qboolean modified;
	byte	palette[256][4], *in, *out;
	int		i, j;
	float	alpha, one_minus_alpha;
	vec3_t	premult;
	int		v;

	thepalette = (byte *)d_8to24table;

}

// BestColor


const byte q2_palette[256 * 3] =
{
    0,  0,  0, 15, 15, 15, 31, 31, 31, 47, 47, 47, 63, 63, 63,
   75, 75, 75, 91, 91, 91,107,107,107,123,123,123,139,139,139,
  155,155,155,171,171,171,187,187,187,203,203,203,219,219,219,
  235,235,235, 99, 75, 35, 91, 67, 31, 83, 63, 31, 79, 59, 27,
   71, 55, 27, 63, 47, 23, 59, 43, 23, 51, 39, 19, 47, 35, 19,
   43, 31, 19, 39, 27, 15, 35, 23, 15, 27, 19, 11, 23, 15, 11,
   19, 15,  7, 15, 11,  7, 95, 95,111, 91, 91,103, 91, 83, 95,
   87, 79, 91, 83, 75, 83, 79, 71, 75, 71, 63, 67, 63, 59, 59,
   59, 55, 55, 51, 47, 47, 47, 43, 43, 39, 39, 39, 35, 35, 35,
   27, 27, 27, 23, 23, 23, 19, 19, 19,143,119, 83,123, 99, 67,
  115, 91, 59,103, 79, 47,207,151, 75,167,123, 59,139,103, 47,
  111, 83, 39,235,159, 39,203,139, 35,175,119, 31,147, 99, 27,
  119, 79, 23, 91, 59, 15, 63, 39, 11, 35, 23,  7,167, 59, 43,
  159, 47, 35,151, 43, 27,139, 39, 19,127, 31, 15,115, 23, 11,
  103, 23,  7, 87, 19,  0, 75, 15,  0, 67, 15,  0, 59, 15,  0,
   51, 11,  0, 43, 11,  0, 35, 11,  0, 27,  7,  0, 19,  7,  0,
  123, 95, 75,115, 87, 67,107, 83, 63,103, 79, 59, 95, 71, 55,
   87, 67, 51, 83, 63, 47, 75, 55, 43, 67, 51, 39, 63, 47, 35,
   55, 39, 27, 47, 35, 23, 39, 27, 19, 31, 23, 15, 23, 15, 11,
   15, 11,  7,111, 59, 23, 95, 55, 23, 83, 47, 23, 67, 43, 23,
   55, 35, 19, 39, 27, 15, 27, 19, 11, 15, 11,  7,179, 91, 79,
  191,123,111,203,155,147,215,187,183,203,215,223,179,199,211,
  159,183,195,135,167,183,115,151,167, 91,135,155, 71,119,139,
   47,103,127, 23, 83,111, 19, 75,103, 15, 67, 91, 11, 63, 83,
    7, 55, 75,  7, 47, 63,  7, 39, 51,  0, 31, 43,  0, 23, 31,
    0, 15, 19,  0,  7, 11,  0,  0,  0,139, 87, 87,131, 79, 79,
  123, 71, 71,115, 67, 67,107, 59, 59, 99, 51, 51, 91, 47, 47,
   87, 43, 43, 75, 35, 35, 63, 31, 31, 51, 27, 27, 43, 19, 19,
   31, 15, 15, 19, 11, 11, 11,  7,  7,  0,  0,  0,151,159,123,
  143,151,115,135,139,107,127,131, 99,119,123, 95,115,115, 87,
  107,107, 79, 99, 99, 71, 91, 91, 67, 79, 79, 59, 67, 67, 51,
   55, 55, 43, 47, 47, 35, 35, 35, 27, 23, 23, 19, 15, 15, 11,
  159, 75, 63,147, 67, 55,139, 59, 47,127, 55, 39,119, 47, 35,
  107, 43, 27, 99, 35, 23, 87, 31, 19, 79, 27, 15, 67, 23, 11,
   55, 19, 11, 43, 15,  7, 31, 11,  7, 23,  7,  0, 11,  0,  0,
    0,  0,  0,119,123,207,111,115,195,103,107,183, 99, 99,167,
   91, 91,155, 83, 87,143, 75, 79,127, 71, 71,115, 63, 63,103,
   55, 55, 87, 47, 47, 75, 39, 39, 63, 35, 31, 47, 27, 23, 35,
   19, 15, 23, 11,  7,  7,155,171,123,143,159,111,135,151, 99,
  123,139, 87,115,131, 75,103,119, 67, 95,111, 59, 87,103, 51,
   75, 91, 39, 63, 79, 27, 55, 67, 19, 47, 59, 11, 35, 47,  7,
   27, 35,  0, 19, 23,  0, 11, 15,  0,  0,255,  0, 35,231, 15,
   63,211, 27, 83,187, 39, 95,167, 47, 95,143, 51, 95,123, 51,
  255,255,255,255,255,211,255,255,167,255,255,127,255,255, 83,
  255,255, 39,255,235, 31,255,215, 23,255,191, 15,255,171,  7,
  255,147,  0,239,127,  0,227,107,  0,211, 87,  0,199, 71,  0,
  183, 59,  0,171, 43,  0,155, 31,  0,143, 23,  0,127, 15,  0,
  115,  7,  0, 95,  0,  0, 71,  0,  0, 47,  0,  0, 27,  0,  0,
  239,  0,  0, 55, 55,255,255,  0,  0,  0,  0,255, 43, 43, 35,
   27, 27, 23, 19, 19, 15,235,151,127,195,115, 83,159, 87, 51,
  123, 63, 27,235,211,199,199,171,155,167,139,119,135,107, 87,
  159, 91, 83
};



byte BestColor (int r, int g, int b, int start, int stop)
{
	int	i;
	int	dr, dg, db;
	float gr, gg, gb;	// leilei - gamma!
	int	bestdistortion, distortion;
	int	berstcolor;
	byte	*pal;

/*
	gr = r >> 1;
	gg = g >> 1;
	gb = b >> 1;
		gr = pow(gr, 1.3f);
		gg = pow(gg, 1.3f);
		gb = pow(gb, 1.3f);


	r = gr;
	g = gg;
	b = gb;
*/
//
// let any color go to 0 as a last resort
//
		R_GetPalette();
	bestdistortion = 256*256*4;
	berstcolor = 0;


	if (r > 255) r = 255;
	if (g > 255) g = 255;
	if (b > 255) b = 255;

//	pal = (byte *)d_8to24table + start * 3;
		pal = (byte *)q2_palette + start * 3;
	for (i=start ; i<= stop ; i++)
	{
		dr = r - (int)pal[0];
		dg = g - (int)pal[1];
		db = b - (int)pal[2];
		pal += 3;
		distortion = dr*dr + dg*dg + db*db;
		if (distortion < bestdistortion)
		{
			if (!distortion)
				return i;		// perfect match

			bestdistortion = distortion;
			berstcolor = i;
		}
	}


	return berstcolor;
}


void Draw_InitRGBMap (void)
{
	int		r, g, b;
	float ra, ga, ba, ia;
	int		beastcolor;
	float mypow = 1 / 1.3;
	float mydiv = 200;
	float mysat = 1.6;

	// Make the 18-bit lookup table here
	// This is a HUGE 256kb table, the biggest there is here
	// TODO: Option to enable this 

	{
	Draw_8to24 (d_8to24table);
	for (r=0 ; r<256 ; r+=4)
	{
		for (g=0 ; g<256 ; g+=4)
		{
			for (b=0 ; b<256 ; b+=4)
			{
						// 3dfx gamma hack, trying to match the saturation and gamma of the refgl+3dfxgl combo so many q2 players are familiar with
				
					ra = pow(r / mydiv, mypow) * mydiv;
					ga = pow(g / mydiv, mypow) * mydiv;
					ba = pow(b / mydiv, mypow) * mydiv;

					ia = (ra * 0.333) + (ga * 0.333) + (ba * 0.333);
					ra = ia + (ra - ia) * mysat;
					ga = ia + (ga - ia) * mysat;
					ba = ia + (ba - ia) * mysat;
				//beastcolor = BestColor (pow(ra / mydiv, mypow) * mydiv, pow(ga / mydiv, mypow) * mydiv, pow(ba / mydiv, mypow) * mydiv, 1, 254);
					beastcolor = BestColor ((int)ra, (int)ga, (int)ba, 1, 254);
				//beastcolor = BestColor (ra, ga, ba, 1, 254);
				palmap2[r>>2][g>>2][b>>2] = beastcolor;

			}
		}
	}

	}

}




/*
===============
Draw_InitLocal
===============
*/
void Draw_InitLocal (void)
{
	draw_chars = Draw_FindPic ("conchars");
		
}






/*
================
Draw_Char

Draws one 8*8 graphics character
It can be clipped to the top of the screen to allow the console to be
smoothly scrolled off.
================
*/
void Draw_Char (int x, int y, int num)
{
	byte			*dest;
	byte			*source;
	int				drawline;	
	int				row, col;

	num &= 255;

	if (num == 32 || num == 32+128)
		return;

	if (y <= -8)
		return;			// totally off screen

//	if ( ( y + 8 ) >= vid.height )
	if ( ( y + 8 ) > vid.height )		// PGM - status text was missing in sw...
		return;

#ifdef PARANOID
	if (y > vid.height - 8 || x < 0 || x > vid.width - 8)
		ri.Sys_Error (ERR_FATAL,"Con_DrawCharacter: (%i, %i)", x, y);
	if (num < 0 || num > 255)
		ri.Sys_Error (ERR_FATAL,"Con_DrawCharacter: char %i", num);
#endif

	row = num>>4;
	col = num&15;
	source = draw_chars->pixels[0] + (row<<10) + (col<<3);

	if (y < 0)
	{	// clipped
		drawline = 8 + y;
		source -= 128*y;
		y = 0;
	}
	else
		drawline = 8;


	dest = vid.buffer + y*vid.rowbytes + x;

	while (drawline--)
	{
		if (source[0] != TRANSPARENT_COLOR)
			dest[0] = source[0];
		if (source[1] != TRANSPARENT_COLOR)
			dest[1] = source[1];
		if (source[2] != TRANSPARENT_COLOR)
			dest[2] = source[2];
		if (source[3] != TRANSPARENT_COLOR)
			dest[3] = source[3];
		if (source[4] != TRANSPARENT_COLOR)
			dest[4] = source[4];
		if (source[5] != TRANSPARENT_COLOR)
			dest[5] = source[5];
		if (source[6] != TRANSPARENT_COLOR)
			dest[6] = source[6];
		if (source[7] != TRANSPARENT_COLOR)
			dest[7] = source[7];
		source += 128;
		dest += vid.rowbytes;
	}
}

/*
=============
Draw_GetPicSize
=============
*/
void Draw_GetPicSize (int *w, int *h, char *pic)
{
	image_t *gl;

	gl = Draw_FindPic (pic);
	if (!gl)
	{
		*w = *h = -1;
		return;
	}
	*w = gl->width;
	*h = gl->height;
}

/*
=============
Draw_StretchPicImplementation
=============
*/
void Draw_StretchPicImplementation (int x, int y, int w, int h, image_t	*pic)
{
	byte			*dest, *source;
	int				v, u, sv;
	int				height;
	int				f, fstep;
	int				skip;

	if ((x < 0) ||
		(x + w > vid.width) ||
		(y + h > vid.height))
	{
		ri.Sys_Error (ERR_FATAL,"Draw_Pic: bad coordinates");
	}

	height = h;
	if (y < 0)
	{
		skip = -y;
		height += y;
		y = 0;
	}
	else
		skip = 0;

	dest = vid.buffer + y * vid.rowbytes + x;

	for (v=0 ; v<height ; v++, dest += vid.rowbytes)
	{
		sv = (skip + v)*pic->height/h;
		source = pic->pixels[0] + sv*pic->width;
		if (w == pic->width)
			memcpy (dest, source, w);
		else
		{
			f = 0;
			fstep = pic->width*0x10000/w;
			for (u=0 ; u<w ; u+=4)
			{
				dest[u] = source[f>>16];
				f += fstep;
				dest[u+1] = source[f>>16];
				f += fstep;
				dest[u+2] = source[f>>16];
				f += fstep;
				dest[u+3] = source[f>>16];
				f += fstep;
			}
		}
	}
}

/*
=============
Draw_StretchPic
=============
*/
void Draw_StretchPic (int x, int y, int w, int h, char *name)
{
	image_t	*pic;

	pic = Draw_FindPic (name);
	if (!pic)
	{
		ri.Con_Printf (PRINT_ALL, "Can't find pic: %s\n", name);
		return;
	}
	Draw_StretchPicImplementation (x, y, w, h, pic);
}

/*
=============
Draw_StretchRaw
=============
*/
void Draw_StretchRaw (int x, int y, int w, int h, int cols, int rows, byte *data)
{
	image_t	pic;

	pic.pixels[0] = data;
	pic.width = cols;
	pic.height = rows;
	Draw_StretchPicImplementation (x, y, w, h, &pic);
}

/*
=============
Draw_Pic
=============
*/
void Draw_Pic (int x, int y, char *name)
{
	image_t			*pic;
	byte			*dest, *source;
	int				v, u;
	int				tbyte;
	int				height;

	pic = Draw_FindPic (name);
	if (!pic)
	{
		ri.Con_Printf (PRINT_ALL, "Can't find pic: %s\n", name);
		return;
	}

	if ((x < 0) ||
		(x + pic->width > vid.width) ||
		(y + pic->height > vid.height))
		return;	//	ri.Sys_Error (ERR_FATAL,"Draw_Pic: bad coordinates");

	height = pic->height;
	source = pic->pixels[0];
	if (y < 0)
	{
		height += y;
		source += pic->width*-y;
		y = 0;
	}

	dest = vid.buffer + y * vid.rowbytes + x;

	if (!pic->transparent)
	{
		for (v=0 ; v<height ; v++)
		{
			memcpy (dest, source, pic->width);
			dest += vid.rowbytes;
			source += pic->width;
		}
	}
	else
	{
		if (pic->width & 7)
		{	// general
			for (v=0 ; v<height ; v++)
			{
				for (u=0 ; u<pic->width ; u++)
					if ( (tbyte=source[u]) != TRANSPARENT_COLOR)
						dest[u] = tbyte;

				dest += vid.rowbytes;
				source += pic->width;
			}
		}
		else
		{	// unwound
			for (v=0 ; v<height ; v++)
			{
				for (u=0 ; u<pic->width ; u+=8)
				{
					if ( (tbyte=source[u]) != TRANSPARENT_COLOR)
						dest[u] = tbyte;
					if ( (tbyte=source[u+1]) != TRANSPARENT_COLOR)
						dest[u+1] = tbyte;
					if ( (tbyte=source[u+2]) != TRANSPARENT_COLOR)
						dest[u+2] = tbyte;
					if ( (tbyte=source[u+3]) != TRANSPARENT_COLOR)
						dest[u+3] = tbyte;
					if ( (tbyte=source[u+4]) != TRANSPARENT_COLOR)
						dest[u+4] = tbyte;
					if ( (tbyte=source[u+5]) != TRANSPARENT_COLOR)
						dest[u+5] = tbyte;
					if ( (tbyte=source[u+6]) != TRANSPARENT_COLOR)
						dest[u+6] = tbyte;
					if ( (tbyte=source[u+7]) != TRANSPARENT_COLOR)
						dest[u+7] = tbyte;
				}
				dest += vid.rowbytes;
				source += pic->width;
			}
		}
	}
}

/*
=============
Draw_TileClear

This repeats a 64*64 tile graphic to fill the screen around a sized down
refresh window.
=============
*/
void Draw_TileClear (int x, int y, int w, int h, char *name)
{
	int			i, j;
	byte		*psrc;
	byte		*pdest;
	image_t		*pic;
	int			x2;

	if (x < 0)
	{
		w += x;
		x = 0;
	}
	if (y < 0)
	{
		h += y;
		y = 0;
	}
	if (x + w > vid.width)
		w = vid.width - x;
	if (y + h > vid.height)
		h = vid.height - y;
	if (w <= 0 || h <= 0)
		return;

	pic = Draw_FindPic (name);
	if (!pic)
	{
		ri.Con_Printf (PRINT_ALL, "Can't find pic: %s\n", name);
		return;
	}
	x2 = x + w;
	pdest = vid.buffer + y*vid.rowbytes;
	for (i=0 ; i<h ; i++, pdest += vid.rowbytes)
	{
		psrc = pic->pixels[0] + pic->width * ((i+y)&63);
		for (j=x ; j<x2 ; j++)
			pdest[j] = psrc[j&63];
	}
}


/*
=============
Draw_Fill

Fills a box of pixels with a single color
=============
*/
void Draw_Fill (int x, int y, int w, int h, int c)
{
	byte			*dest;
	int				u, v;

	if (x+w > vid.width)
		w = vid.width - x;
	if (y+h > vid.height)
		h = vid.height - y;
	if (x < 0)
	{
		w += x;
		x = 0;
	}
	if (y < 0)
	{
		h += y;
		y = 0;
	}
	if (w < 0 || h < 0)
		return;
	dest = vid.buffer + y*vid.rowbytes + x;
	for (v=0 ; v<h ; v++, dest += vid.rowbytes)
		for (u=0 ; u<w ; u++)
			dest[u] = c;
}
//=============================================================================

/*
================
Draw_FadeScreen

================
*/
void Draw_FadeScreen (void)
{
	int			x,y;
	byte		*pbuf;
	int	t;

	for (y=0 ; y<vid.height ; y++)
	{
		pbuf = (byte *)(vid.buffer + vid.rowbytes*y);
		t = (y & 1) << 1;

		for (x=0 ; x<vid.width ; x++)
		{
			if ((x & 3) != t)
				pbuf[x] = 0;
		}
	}
}
