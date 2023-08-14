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


#include "palette.h"
#include <string.h>

char *loadpal(char *filename)
{
    int i;
    FILE *fp;
    char *palette = NULL;
    int buildpal = 0;       // is the palette a build format palette?
    
    if(filename == NULL)
    {
        fp = fopen("PALETTE.DAT", "rb");

        if(!fp)
        {
           puts(" No palette found.\n\tUse --palette to specify palette location or put a PALETTE.DAT in the fart dir.");
           return NULL;
        }
        
        fclose(fp);
        
        filename = "PALETTE.DAT";
    }
   
    // load palette
    fp = fopen(filename, "rb");
    
    if(!fp)
    {
        perror(filename);
        return NULL;
    }
   
    // check if it's a build palette
    if((!strcmp(filename + strlen(filename) - 3, "DAT")) || (!strcmp(filename + strlen(filename) - 3, "dat")))
        buildpal = 1;
   
    palette = (char *)malloc(768);
    
    // if it's a build format palette we need to mul each r, g and b value by 4
    if(buildpal)
        for(i = 0; i < 768; i++)    
            palette[i] = fgetc(fp) * 4;
    else
        fread(palette, 1, 768, fp);

    fclose(fp);
    
    printf("loaded palette: %s\n", filename);
    
    return palette;
}

