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

#include "flags.h"
#include <string.h>

static char *animtypes[5] = { "NoAnm", "Oscil", "AnmFd", "AnmBk", NULL };

static int clipValue(int value, int min, int max)
{
    if(value > max)
        return max;
    else if(value < min)
        return min;
    else
        return value;
}

static int getIntAnimtype(char *strtype)
{
    int i;

    for(i = 0; i < 4; i++)
    {
        if(!strcmp(animtypes[i], strtype))
            return i;
    }

    return 4;

}

//
//  makeFlagName(char *artname)
//  - Take the art file's name and make it into a flag file name
//
static char *makeFlagName(char *artname)
{
    int i, extlen, len;
    char *out = strdup(artname);
    char *extension = "flg";

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

    memcpy(out + strlen(out) - 3, "flg", 3);

    return out;
}

//
//  readFlags
//      Reads flags from file and sticks them in the global flag_t *flags.
//      This code sucks, i should rewrite it.
//
int readFlags(char *filename)
{

    char test[256];
    char name[256];
    char line[256];
    char animtype[6];
    int linenumber = 0;
    int numframes, xoffset, yoffset, speed, currenttile = 0;

    FILE *fp = fopen(filename, "rb");

    if(!fp)
    {
        perror(filename);
        return -1;
    }

    while(!feof(fp))
    {
        memset(line, '\0', 256);
        fgets(line, 255, fp);

        // clean some crap up
        memset(name, '\0', 256);
        memset(animtype, '\0', 6);

        memset(test, '\0', 256);
        sscanf(line, "%s", test);

        linenumber++;

        // ignore empty lines
        if(test[0] != '\0')
        {

            if((line[0] == '#') || (test[0] == '#'))  // comment, ignore
            {
                ;
            }
            else if(strstr(line, "numtiles"))   // get number of gfx
            {
                sscanf(line, "%*s %d", &numtiles, &numtiles);
                flags = realloc(flags, numtiles * sizeof(flag_t));
            }
            else if(strstr(line, "tilestart"))   // start number of gfx
            {
                sscanf(line, "%*s %d", &tilestart, &tilestart);
            }
            else    // get gfx info
            {
                if(!flags)
                {
                    puts("numtiles either not there or not found yet. Assuming 256 tiles.");
                    flags = realloc(flags, 256 * sizeof(flag_t));
                }

                sscanf(line, "%s %d %s %d %d %d", name, &numframes, animtype, &xoffset, &yoffset, &speed);

            // Setup flag values, do clipping
                flags[currenttile].imagename = strdup(name);


            // Animtype should be between 0 and 3, when getIntAnimtype returns 4
            // the animtype was invalid.
                flags[currenttile].animtype = getIntAnimtype(animtype);
                if(flags[currenttile].animtype == 4)
                {
                    printf("Line %d : Bad animtype %s. defaulting to NoAnm\n", linenumber, animtype);
                    flags[currenttile].animtype = 0;
                }

            // clip values to sane ones
                flags[currenttile].speed = clipValue(speed, 0, 16);
                flags[currenttile].xoffset = clipValue(xoffset, 0, 255);
                flags[currenttile].yoffset = clipValue(yoffset, 0, 255);
                flags[currenttile].numframes = clipValue(numframes, 0, 63);

                currenttile++;
            }
        }
    }

    printf("loaded flags from %s\n", filename);

    fclose(fp);

    return 0;
}

void writeFlags(art_t *art, char *filename)
{
    int i, numtiles;
    int numberframes, animtype, xoffset, yoffset, speed;
    char *bmpname;
    char *name = (char *)malloc(9);
    name[8] = 0;

    // make art filename into flag filename
    char *flagfilename = NULL;
    char *flagextension = "flg";

    flagfilename = makeFlagName(filename);

    FILE *fp = fopen(flagfilename, "wb");

    numtiles = art->localtileend - art->localtilestart + 1;

    fprintf(fp, "# generated by fart from %s\r\n", filename);
    fprintf(fp, "# file name - numframes - anim type - x offset - y offset - anim speed\r\n");
    fprintf(fp, "numtiles %d\r\n", numtiles);
    fprintf(fp, "tilestart %d\r\n", art->localtilestart);

    for(i = 0; i < numtiles; i++)
    {
        bmpname = makeBmpName(art->localtilestart + i);
        strncpy(name, bmpname, 8);

        free(bmpname);

        numberframes = art->picanim[i] & 0x3F;
        animtype = (art->picanim[i] >> 6) & 0x3;
        xoffset = (art->picanim[i] >> 8) & 0xFF;
        yoffset = (art->picanim[i] >> 16) & 0xFF;
        speed = (art->picanim[i] >> 24) & 0xF;

        fprintf(fp, "%s   %d   %s   %d   %d   %d\r\n", name, numberframes, animtypes[animtype], xoffset, yoffset, speed);
    }

    printf("saved flags to  %s\n", flagfilename);

    free(flagfilename);
    free(name);

    fclose(fp);
}

void freeFlags()
{
    int i;

    if(flags)
    {
        for(i = 0; i < numtiles; i++)
        {
            if(flags[i].imagename)
                free(flags[i].imagename);
        }

        free(flags);
    }
}


