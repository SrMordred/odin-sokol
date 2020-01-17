# odin-sokol
Odin Sokol Bindings For Odin

# Show And Tell:
1) `git clone https://github.com/SrMordred/odin-sokol sokol` inside your main folder.
2) `build_requirements.bat`, will clone [sokol](https://github.com/floooh/sokol), and build all **.lib** files needed to work with Odin. 
Using msvc tools at the moment. (*cl.exe* and *lib.exe*)
3) use `import sg "sokol/gfx"` and `import sapp "sokol/app"` into your main file and profit :)

On its current state is compiling with **SOKOL_GLCORE33**. You can tweak **build_requirements.bat** to change it for your own needs.
