@echo off
REM VARIABLES
set LIBPATH=..

set RENDERER=SOKOL_GLCORE33 


REM #################################################
REM #################################################
REM #################################################


REM CLONE/UPDATE SOKOL
@echo on
git clone https://github.com/floooh/sokol sokol_source
cd c_sokol
git pull
cd ..

REM BUILD LIBS
cl /D%RENDERER% /Z7 /c /EHa  app/app.c /Foapp/sokol_app.obj 
lib /ERRORREPORT /OUT:%LIBPATH%/sokol_app.lib app/sokol_app.obj  

cl /D%RENDERER% /Z7 /c /EHa  gfx/gfx.c /Fogfx/sokol_gfx.obj 
lib /ERRORREPORT /OUT:%LIBPATH%/sokol_gfx.lib gfx/sokol_gfx.obj opengl32.lib gdi32.lib user32.lib glu32.lib

cl /D%RENDERER% /Z7 /c /EHa  time/time.c /Fotime/sokol_time.obj 
lib /ERRORREPORT /OUT:%LIBPATH%/sokol_time.lib time/sokol_time.obj
