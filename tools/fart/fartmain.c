/*

    fart - a build engine art file manipulation tool
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


#include "common/art.h"
#include "common/bmp.h"
#include "common/defs.h"
#include "common/flags.h"
#include "common/palette.h"

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    int i;

  // palette and art filenames
    char *palname = NULL;
    char *filename = NULL;

  // palette and art data
    char *palette = NULL;
    art_t *artfile = NULL;

  // init globals
    makeemptybitmaps = 0;

    puts("---------------------------");
    puts(" fart - (C) Joe Kennedy 07");
    puts("---------------------------");

  // parse us some arguments
    for(i = 1; i < argc; i++)
    {
        if(!strcmp(argv[i], "--void"))    // --void makes fart output gfx of
            makeemptybitmaps = 1;         // the right size but transparent
        else if(!strcmp(argv[i], "--palette"))
            palname = argv[++i];
        else if(strstr(argv[i], "-") == argv[i])
            i++;  // if unknown argument, waste this arg and the next, just in case.
        else
            filename = argv[i];
    }

    palette = loadpal(palname);
    if(!palette)
        return 0;

    artfile = loadArt(filename, palette);
    if(!artfile)
        return 0;

    exportBmps(artfile, palette);
    writeFlags(artfile, filename);

    freeArt(artfile);
    free(palette);

    return 0;

}
