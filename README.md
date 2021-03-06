# nightingale-vagrant
Just boot up a vagrant box and let it build [nightingale][] for you!

## Install

To use the vagrant configurations, you need the vagrant client and virtualbox.

Make sure, that you initiialize the nightingale-hacking submodule by either cloning this repo with the `--recursive` options or within
```sh
git submodule init
git submodule update
```

## Usage
Open a console window, go to the directory with the desired system architecture (e.g. ubuntu-64 for a 64-bit Linux build) and run `vagrant up`. It will then start a virtual machine, install the dependencies and build Nightingale, which is then returned to your environment in the dist folder within the architecture directory.

Alternatively you can run all builds in sequence by calling `make`. `make clean` will remove any traces of builds from the tree.

### Windows
The windows instance uses a box called "freaktechnik/windows-7-ngale", which is not publically available. It's a Windows 7 box, with a minimal cygwin as ssh shell, chocolatey, MSVS Express 2008 and the Windows DDK preinstalled.

[nightingale]: https://github.com/nightingale-media-player/nightingale-hacking
