[![Build Status](https://travis-ci.org/tseemann/kounta.svg?branch=master)](https://travis-ci.org/tseemann/kounta)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![Don't judge me](https://img.shields.io/badge/Language-Perl_5-steelblue.svg)

# kounta
Small pure Perl5 libraries for writing command line bioinformatics tools

## Introduction

This is a Github template for my Perl based bioinformatics tools.

* search and replace `kounta` with the name of your repo
* enable TRAVIS-CI for the repo

## Quick Start

```
% kounta --version
kounta 0.1.2

% kounta --help

```

## Installation

### Conda
Install [Conda](https://conda.io/docs/) or [Miniconda](https://conda.io/miniconda.html):
```
conda install -c conda-forge -c bioconda -c defaults kounta
```

### Homebrew
Install [HomeBrew](http://brew.sh/) (Mac OS X) or [LinuxBrew](http://linuxbrew.sh/) (Linux).
```
brew install brewsci/bio/kounta
```

### Source
This will install the latest version direct from Github.
You'll need to add the kounta `bin` directory to your `$PATH`,
and also ensure all the [dependencies](#Dependencies) are installed.
```
cd $HOME
git clone https://github.com/tseemann/kounta.git
$HOME/kounta/bin/kounta --help
```

## Dependencies

* `perl` >= 5.26
* Perl modules: `Path::Tiny` `SemVer` `File::Which`

## License

kounta is free software, released under the
[GPL 3.0](https://raw.githubusercontent.com/tseemann/kounta/master/LICENSE).

## Issues

Please submit suggestions and bug reports to the
[Issue Tracker](https://github.com/tseemann/kounta/issues)

## Author

[Torsten Seemann](https://twitter.com/torstenseemann)
