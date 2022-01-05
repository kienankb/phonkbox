# phonkbox

_"I hope you understand this is as compliment: BIG WINAMP VIBES"_

---
**phonkbox** is an on-the-fly music visualizer.  it's built in Processing, because I have less than no patience for boilerplate.  the hopes are to eventually get it running on a raspberry pi as a standalone, plug-and-play solution for visuals at live events.  that's pretty ambitious, though, and I have a track record of not finishing things, so initially I just want to make...a nice-looking visualizer.

**dependencies:**

* Processing (it's made in v4, YMMV with <v4)
* Processing's official Sound library
* some music files: drop them in `data/` and change the code to use them **OR** switch commented lines around to use a mic input (I intend on cleaning this code up)