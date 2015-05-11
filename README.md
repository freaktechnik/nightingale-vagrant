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

[nightingale]: https://github.com/nightingale-media-player/nightingale-hacking
