h1. dotfiles

This repo is based on the work of Todd Werth (http://github.com/twert). I modified it in the way, that i use ZSH
instead of Bash.

!http://www.infinitered.com/blog_extras/command_line_fx/kb_control_wide_short_bw2.jpg!

h2. File and directory structure

I store all my command-line files in a folder (cl), then under that folder there are 3 sub-folders (cl/bin cl/etc cl/doc), to keep them organized away from all my other files.  I link (etc/link) the dot files to the root of my home folder, so I prefer to store them without the . (gitignore rather than .gitignore), then I add the dot in the link.  So if you use one, make sure you put the dot back.

  * ~
  ** dotfiles
  *** bin
  *** etc
  **** vim
  **** zsh.d
          
h2. Installation

Just run the ./install script to link everything in place. You need to have the Highline gem installed (http://highline.rubyforge.org/).

h2. A word of warning

I use this on Mac OS X mainly and on CentOS or Ubuntu systems from time to time. I'm not a pro Vim user so that's what
I completely took from Todd (thanks for that!). I will work on all the files from time to time and try to keep up with
changes on Todds repo regarding none-ZSH issues, but don't blame me if somethings doesn't work as expected ;-) If you
improve anything or fix a problem please let me know, thanks.

Hope this will be helpful for some folks.