# JS for OS X Iconizer

** This is a cobbled together WIP and will likely not work for you for a couple reasons **

## What is it?

This is a gui application for this command line tool https://github.com/cognitom/symbols-for-sketch.

It’s built using new JavaScript for Automation capabilities in OS X Yosemite.

## What do you need to try to run it?
- My fork of Symbols for Sketch https://github.com/tylergaw/symbols-for-sketch/tree/args-for-config
I modified the project to allow for all of the options to be set via the CLI. I
have a [pull request](https://github.com/cognitom/symbols-for-sketch/pull/3) in
but it’s not clear that it will be right for the project so it may not be merged.
- Symbols for Sketch has a number of dependencies that are listed in its [readme](https://github.com/tylergaw/symbols-for-sketch/blob/args-for-config/README.md); Node, Gulp, Sketchtool.

## Why won’t it work?
I haven't been able to figure out how to package Node and Gulp with the application
so it relies on those being on the system. There is a shell script that the app calls
to run the sketch symbols gulp task. For that to work I'm `sourcing` by `.bash_profile`.
I’m doing that because the shell env needs to have my full `PATH`, otherwise it
won't find node or gulp.

Like I said, cobbled. WIP.

## What else?
If you're interested in how this is built, have a look [here](https://github.com/tylergaw/js-osx-app-examples). 
