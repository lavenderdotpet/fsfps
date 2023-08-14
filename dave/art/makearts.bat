@echo off
echo farting out the null arts to build on
rem pause
copy null\*.art .\

..\..\tools\fart tiles000.art --void
..\..\tools\fart tiles001.art --void
..\..\tools\fart tiles002.art --void
..\..\tools\fart tiles003.art --void
..\..\tools\fart tiles004.art --void
..\..\tools\fart tiles005.art --void
..\..\tools\fart tiles006.art --void
..\..\tools\fart tiles007.art --void
..\..\tools\fart tiles008.art --void
..\..\tools\fart tiles009.art --void
..\..\tools\fart tiles010.art --void
..\..\tools\fart tiles011.art --void
..\..\tools\fart tiles012.art --void
..\..\tools\fart tiles013.art --void
..\..\tools\fart tiles014.art --void
..\..\tools\fart tiles015.art --void
..\..\tools\fart tiles016.art --void
..\..\tools\fart tiles017.art --void
..\..\tools\fart tiles018.art --void
..\..\tools\fart tiles019.art --void

echo copying the contrib stuffs over the null files
rem pause
copy fd\*.bmp .\
copy joe\*.bmp .\
copy leilei\*.bmp .\
copy leilei\bpdtcd\*.bmp .\
copy leilei\oa\*.bmp .\


echo nuke the null arts we farted earlier
rem pause
del *.art

echo k, now make arts
rem pause
..\..\tools\digest tiles000.flg
..\..\tools\digest tiles001.flg
..\..\tools\digest tiles002.flg
..\..\tools\digest tiles003.flg
..\..\tools\digest tiles004.flg
..\..\tools\digest tiles005.flg
..\..\tools\digest tiles006.flg
..\..\tools\digest tiles007.flg
..\..\tools\digest tiles008.flg
..\..\tools\digest tiles009.flg
..\..\tools\digest tiles010.flg
..\..\tools\digest tiles011.flg
..\..\tools\digest tiles012.flg
..\..\tools\digest tiles013.flg
..\..\tools\digest tiles014.flg
..\..\tools\digest tiles015.flg
..\..\tools\digest tiles016.flg
..\..\tools\digest tiles017.flg
..\..\tools\digest tiles018.flg
..\..\tools\digest tiles019.flg

echo move arts to the working copy project folder 
rem pause
rem move *.art D:\projects\dave

echo clean up the remaining mess
rem pause
del *.bmp