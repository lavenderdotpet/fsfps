/*

    digest - a build engine art file creation tool
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
    int i, numtiles, flagerror;

  // palette and art filenames
    char *outname = NULL;
    char *filename = NULL;

    puts("-----------------------------");
    puts(" digest - (C) Joe Kennedy 07");
    puts("-----------------------------");

  // parse us some arguments
    for(i = 1; i < argc; i++)
    {
        if(!strcmp(argv[i], "-o"))
            outname = argv[++i];
        else if(strstr(argv[i], "-") == argv[i])
            i++;  // if unknown argument, waste this arg and the next, just in case.
        else
            filename = argv[i];
    }

    if(!filename)
    {
       puts("digest needs a flag file's name to actually do anything");
       return 0;
    }

  // if we don't have the name of an art file to output make one from flag name
    if(!outname)
       outname = makeArtName(filename);

  // load in flags and check for errors
    flagerror = readFlags(filename);

    if(!flagerror)
    {
      makeArt(outname);
      freeFlags();
    }

    return 0;

}
