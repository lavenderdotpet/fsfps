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
#include <string.h>

//
//  makeBmpName
//      returns a (char *) to a bitmap in the format ART#####.bmp
//      where ##### is made from the number specified in the arg
//
char *makeBmpName(int number)
{
    int i;
    char *out = strdup("ART00000.bmp");
    char *istr = (char *)malloc(6);
    istr[5] = '\0';

    sprintf(istr, "%d", number);

    for(i = 0; i < strlen(istr); i++)
    {
        out[strlen(out) - strlen(istr) - 4 + i] = istr[i];
    }

    free(istr);

    return out;
}

//
//  saveBmp
//      Saves a bitmap from art format (column based) data
//
static void saveBmp(int w, int h, unsigned char *data, char *filename, char *palette)
{
    int i, j;

    FILE *fp = fopen(filename, "wb");

    fputs("BM", fp); // magic letters
    putInt32((1078 + (w * h)), fp);   // file size
    putInt32(0, fp);       // reserved
    putInt32(0x0436, fp);  // offset of bitmap data
    putInt32(40, fp);    // header size

    putInt32(w, fp);    // width and height
    putInt32(h, fp);

    fputc(1, fp);
    fputc(0, fp);    // number of planes

    fputc(8, fp);
    fputc(0, fp);    // bpp

    putInt32(0, fp);    // compression#
    putInt32(w*h, fp); // bmp data size

    putInt32(0x1, fp);    // hres
    putInt32(0x1, fp);    // hvres

    putInt32(256, fp);    // colors
    putInt32(0, fp);    // important colors

    for(i = 0; i < 256; i++)
    {
        fputc(palette[(3 * i) + 2], fp);  // Blue
        fputc(palette[(3 * i) + 1], fp);  // Green
        fputc(palette[(3 * i)], fp);  // Red

        fputc(0, fp);  // Padding
    }

    //
    // write out bitmap data
    //
    for(i = h - 1; i >= 0; i--)
    {
        for(j = 0; j < w; j++)
        {
            if(makeemptybitmaps)
                fputc(255, fp);
            else
                fputc(data[(h * j) + i], fp);
        }

        // NULL padding
        if((w % 4))
            for(j = 0; j < (4 - (w % 4)); j++)
                fputc(0, fp);
    }

    fclose(fp);
}

//
//  exportBmps
//      Exports all the grpahic data from an art file as bitmaps
//
void exportBmps(art_t *art, char *palette)
{
    int i;
    int numtiles = art->localtileend - art->localtilestart + 1;
    char *bmpname;

    for(i = 0; i < numtiles; i++)
    {
        // ignore 0x0 gfx
        if(art->tilesizex[i] && art->tilesizey[i])
        {
            bmpname = makeBmpName(art->localtilestart + i);
            saveBmp(art->tilesizex[i], art->tilesizey[i], art->tiledata[i], bmpname, palette);
            free(bmpname);
        }
    }
}

