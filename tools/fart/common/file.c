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


#include "file.h"

int getInt16(FILE *fp)
{
    int ret = 0, i;

    for(i = 0; i < 2; i++)
       if(!feof(fp))
          ret |= (fgetc(fp) << (8 * i));

    return ret;
}


int getInt32(FILE *fp)
{
    int ret = 0, i;

    for(i = 0; i < 4; i++)
      if(!feof(fp))
          ret |= (fgetc(fp) << (8 * i));

    return ret;
}

void putInt32(int value, FILE *fp)
{

    fputc((value >> 0) & 0xFF , fp);
    fputc((value >> 8) & 0xFF , fp);
    fputc((value >> 16) & 0xFF, fp);
    fputc((value >> 24) & 0xFF, fp);
}

void putInt16(int value, FILE *fp)
{
    fputc((value >> 0) & 0xFF , fp);
    fputc((value >> 8) & 0xFF , fp);
}
