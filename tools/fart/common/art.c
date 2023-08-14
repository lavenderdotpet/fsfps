/*

    Copyright (C) 2007  Joe Kennedy

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#include "bmp.h"
#include "flags.h"
#include "art.h"

//
//  makeArtName(char *name)
//  - Take the flag file's name and make it into an art file's name
//
char *makeArtName(char *name)
{
   int i, extlen, len;
   char *out = strdup(name);

    // find out how many characters are after the .
   extlen = strlen(out) - (strchr(out, '.') - out) - 1;

    // compensate for files with extensions of < 3 chars long
   if(extlen < 3)
   {
      len = strlen(out);
      out = (char *)realloc(out, strlen(out) + 4 - extlen);
      out[len] = 'X';
      out[len + 1] = '\0';
   }

   memcpy(out + strlen(out) - 3, "art", 3);

   return out;
}

static char *addBmpExtension(char *root)
{
   // 5 = 3 for ext, 1 for . and 1 for NULL
   char *ret = (char *)malloc(strlen(root) + 5);

   sprintf(ret, "%s.bmp", root);
   return ret;
}

static unsigned char *getBmpData(FILE *fp, int w, int h)
{
   int i, j;
   int truewidth;
   unsigned char *ret = NULL;

   ret = (unsigned char *)realloc(ret, w * h);

   //bmp rows have null padding if width not multiple of 4
   if(w%4)
      truewidth = w + (4 - (w%4));
   else
      truewidth = w;

   for(j = 0; j < h; j++)
   {
      for(i = 0; i < truewidth; i++)
      {
         if(i < w)
            ret[(w*h) - 1 - (i + (w*j))] = fgetc(fp);
         else
            fgetc(fp);
      }
   }

   return ret;
}


//
// load an art file
//
art_t *loadArt(char *filename, char *palette)
{
    int i,j;
    int numtiles;

    if(!filename)
    {
        puts("no input art file");
        return NULL;
    }

    FILE *fp = fopen(filename, "rb");

    if(!fp)
    {
        perror(filename);
        return NULL;
    }

    art_t *newart = (art_t *)malloc(sizeof(art_t));

    newart->version = getInt32(fp);

    if(newart->version != 1)
    {
       printf("I don't think %s is a proper art file (version != 1) - aborting\n", filename);
       return NULL;
    }

    newart->numtiles = getInt32(fp);
    newart->localtilestart = getInt32(fp);
    newart->localtileend = getInt32(fp);

  // according to silverman, numtiles from the art file could be wrong,
  // so figure out how many we have here
    numtiles = newart->localtileend - newart->localtilestart + 1;

  // load in tile x widths
    newart->tilesizex = (int *)malloc(sizeof(int) * numtiles);
    for(i = 0; i < numtiles; i++)
        newart->tilesizex[i] = getInt16(fp);

  // load in tile y widths
    newart->tilesizey = (int *)malloc(sizeof(int) * numtiles);
    for(i = 0; i < numtiles; i++)
        newart->tilesizey[i] = getInt16(fp);

  // load in picanim crap
    newart->picanim = (int *)malloc(sizeof(int) * numtiles);
    for(i = 0; i < numtiles; i++)
        newart->picanim[i] = getInt32(fp);

    newart->tiledata = (unsigned char **)malloc(sizeof(unsigned char *) * numtiles);

    // load raw tile data
    for(i = 0; i < numtiles; i++)
    {
        newart->tiledata[i] = (unsigned char *)malloc(sizeof(unsigned char) * newart->tilesizex[i] * newart->tilesizey[i]);

        fread(newart->tiledata[i], 1, newart->tilesizex[i] * newart->tilesizey[i], fp);
    }

    fclose(fp);

    return newart;
}

//
//  makeArt
//      make an art file using file.h's "flat_t * flags" to find image source
//      outputs to specified filename
//
void makeArt(char *filename)
{
    int i, x, y, bmpdataoffset;
    int *tilesizex = (int *)malloc(numtiles * sizeof(int));
    int *tilesizey = (int *)malloc(numtiles * sizeof(int));

    int *picanim = (int *)malloc(numtiles * sizeof(int));
    unsigned char **tiledata = (unsigned char **)malloc(numtiles * sizeof(unsigned char *));

    char *bmpfilename = NULL;

    FILE *fp;
    FILE *bmpfile;

    fp = fopen(filename, "wb");

    if(!fp)
    {
        perror(filename);
        return;
    }

    putInt32(1, fp);
    putInt32(numtiles, fp);
    putInt32(tilestart, fp);
    putInt32(tilestart + numtiles - 1, fp);

    // load bitmaps
    for(i = 0; i < numtiles; i++)
    {
       bmpfilename = addBmpExtension(flags[i].imagename);
       bmpfile = fopen(bmpfilename, "rb");

       if(bmpfile)
       {
         fseek(bmpfile, 18, SEEK_SET);

         tilesizex[i] = getInt32(bmpfile);
         tilesizey[i] = getInt32(bmpfile);


         picanim[i] = flags[i].numframes | (flags[i].animtype << 6) | (flags[i].xoffset << 8) | (flags[i].yoffset << 16) | (flags[i].speed << 24);


         fseek(bmpfile, 0x436, SEEK_SET);

         tiledata[i] = getBmpData(bmpfile, tilesizex[i], tilesizey[i]);

         fclose(bmpfile);
       }
       else
       {
         tilesizex[i] = 0;
         tilesizey[i] = 0;
         picanim[i] = flags[i].numframes | (flags[i].animtype << 6) | (flags[i].xoffset << 8) | (flags[i].yoffset << 16) | (flags[i].speed << 24);
         tiledata[i] = NULL;
         
         perror(bmpfilename);
       }

       free(bmpfilename);
    }

    for(i = 0; i < numtiles; i++)
    {
       putInt16(tilesizex[i], fp);
    }

    for(i = 0; i < numtiles; i++)
    {
       putInt16(tilesizey[i], fp);
    }

    for(i = 0; i < numtiles; i++)
    {
       putInt32(picanim[i], fp);
    }

    for(i = 0; i < numtiles; i++)
    {
       for(x = tilesizex[i] - 1; x >= 0 ; --x)
       {
          for(y = 0; y < tilesizey[i]; ++y)
          {
            fputc(tiledata[i][(y * tilesizex[i]) + x], fp);
          }
       }

       if(tiledata[i])
          free(tiledata[i]);
    }

    free(tilesizex);
    free(tilesizey);

    free(tiledata);
    free(picanim);

    fclose(fp);
}

//
//  freeArt
//
void freeArt(art_t *art)
{
    int i, numtiles;

    numtiles = art->localtileend - art->localtilestart + 1;

    free(art->tilesizex);
    free(art->tilesizey);
    free(art->picanim);

    for(i = 0; i < numtiles; i++)
        free(art->tiledata[i]);

    free(art->tiledata);
    free(art);
}
