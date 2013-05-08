a standard interface for projects that generate media such as images

it is meant to me compatible with book projects such as latex or html

as any standardization, this:

- reduces user confusion over different standars
- allows to automate stuff

# installation

this should be added as a submodule on an empty dir of your main repo as:

    DIRNAME=media-gen

    mkdir -p "$DIRNAME"
    git submodule add https://github.com/cirosantilli/media-gen "$DIRNAME"/shared
    cd "$DIRNAME"/shared
    ./install.sh

where `$DIRNAME` is arbitrary, but `media-gen` seems like a good choice to us.

and then you should add the generated files and  commit to add the submodule permanently:

    cd ..
    git add *
    git commit -m 'added media-gen to repo'

note that as explained in [this section](#media-gen-plugin), you will need to
actually install some plugins before this is of any use.

Check out [this section](#known-stable-media-gen-plugins) to find existing plugins.

# in and out

this **must not** contain media that is not generated programtically such as

- photos
- scans
- figures for which maintainers do not own the source code.

it may contain for example:

- plots generated with `gnuplot` or `matplotlib`
- figures generated with drawing programs such as `inkscape` or `gimp`

the recommended method for programatic graph generation is `python matplotlib`

# media-gen plugin

## rationale

there are many different ways to generate media, for example:

- matplotlib
- plplot
- gnuplot
- etc ...

therefore it would be impractical to ship them all on a single template,
so a plugin architecture has been developed.

each of those methods will be encapsulated in a *media-gen plugin*

therefore this repo by itself is useless without a *media-gen plugin*

what this repo does is to factor out the common boilerplate such as:

- all *media-gen plugins* will be made with a single make
- the `install.sh` script helps on the installation of media-gen plugins
## install plugin with media-gen

the process is completelly automated

do:

    install-plugin.sh

and see the help

## install plugin without media-gen

media-gen plugins can be used without media gen.

this may be a good design choice if you are only going to use one single plugin in your project.

    EMPTY_DIR="media-gen"
    PLUGIN_REPO_URL="https://github.com/cirosantilli/media-gen-plugin-matplotlib"

    cd "$(git rev-parse --show-toplevel)"
    mkdir -p "$EMPTY_DIR"
    git add submodule "$PLUGIN_REPO_URL" "$EMPTY_DIR"
    cd "$EMPTY_DIR"/shared
    ./install.sh

where `$EMPTY_DIR` is any empty directory

this will add a submodule to your git project

## examples

to understand why this is useful in a minimalistic example start with:

    git clone --recursive 

and then install the followin plugin:

either manually or witht media-gen

## interface

each *media-gen plugin* must have the following properties:

- be a git repository whose names stars with the prefix `media-gen-plugin-`, ex: `media-gen-plugin-matplotlib`

- the submodule will be put under: `./media-gen/$NAME/shared/`, where `$NAME` is an arbitrary name
    ( but which should reflect what the plugin does for your own sanity...)

- it contains an executable script `./install.sh` which installs the plugin.

    This script typically does things like:

    - creating symlinks
    - copying files
    to the right place.

    It should **not**

    - touch the git index with commands like `git add` or `git commit`.
    - make changes outside of the plugin dir

- if you `cd "./media-gen/plugins/$NAME/" && make` after installation this will generate all the media of the plugin
    and place it in the toplevel of the plugin directly under a dir called `out`, for ex: `./media-gen/plugins/$NAME/out/`

    note that currently subdirs of `out` are not supported: all files must be put directly under `out`.

    all files under `out` will be automatically symlinked with the same basename to the `./media-gen/out` directory
    where they can be used from the project.

    this means that if more than one file has the exact same basename,
    one will overwrite the other even if they come from different plugins
    so make sure you only use each basename only once!

    try to write a makefile which only makes files for which source changed reducing compilation time

    **DO NOT PUT ANYTHING INSIDE `out` SINCE IT WILL BE DELETED BY `make clean`!!!**

- in the same way of the above rule, `make clean` shall erase the `out` dir and all of its contents.


## uninstall

to uninstall a plugin:

- remove the submodule created at installation

- remove the empty dir in which the module was installed

# known stable media-gen plugins

- matplotlib: https://github.com/cirosantilli/media-gen-plugin-matplotlib
