# phonkbox

_"I hope you understand this is as compliment: BIG WINAMP VIBES"_

---
**phonkbox** is an on-the-fly music visualizer.  it's built in Processing, because I have less than no patience for boilerplate.  the hopes are to eventually get it running on a raspberry pi as a standalone, plug-and-play solution for visuals at live events.  that's pretty ambitious, though, and I have a sketchy-at-best track record of finishing things, so initially I just want to make...a nice-looking visualizer.

![20220104-224135](https://user-images.githubusercontent.com/5369336/148172311-22c4b3a3-ce02-434e-81b6-0be303898282.png)

**dependencies:**

* Processing (it's made in v4, YMMV with <v4)
* Processing's official Sound library
* some music files: drop them in `data/` and change the code to use them **OR** switch commented lines around to use a mic input (I intend on cleaning this code up)

**roadmap:**

* clean up input interface (start with args to control mic vs audio file)
* more complex visualizations
* set up an interface to control viz elements while running (a web server, potentially)
