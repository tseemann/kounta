[![Build Status](https://travis-ci.org/tseemann/kounta.svg?branch=master)](https://travis-ci.org/tseemann/kounta)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![Don't judge me](https://img.shields.io/badge/Language-Perl_5-steelblue.svg)

# kounta

## Introduction

This tool will take a bunch (N) of contigs (FASTA) or reads (FASTQ.gz)
and generate a tab-separated matrix with M rows and N+1 columns,
where M is the number unique k-mers found across the inputs, 
and the columns are the k-mer string and the counts for the N genomes.

It relies on `kmc` for efficient k-mer counting, then uses standard
Unix tools like `sort`, `paste`, `cut` and `join` to combine all the 
data into an output file without having to ever have it all in memory
at once. The more `--threads` and `--ram` you can give it, the faster 
it will run, assuming your disk can keep up.

## Quick Start

### Using contigs

```
% ls *.fna
01.fna 02.fna 03.fna 04.fna

% kounta --kmer 7 --out kmers.tsv *.fna
<snip>
Done.

% head kmers.tsv
#KMER    01.fna 02.fna 03.fna 04.fna
AAAAAAA	 0      1      2      1 
AAAAAAT  1      1      1      1
AAAAAAG  3      0      0      0
AAAAATA  0      1      1      0
etc.
```

### Using reads

```
% ls *q.gz
AX_R1.fq.gz BX_R1.fq.gz CX_R1.fq.gz DX_R1.fq.gz

% kounta --kmer 7 --threads 8 --ram 4 --out kmers.tsv *.fq.gz
<snip>
Done.

% head kmers.tsv
#KMER    AX_R1.fq.gz BX_R1.fq.gz CX_R1.fq.gz DX_R1.fq.gz
AAAAAAA	           0          45          21          33 
AAAAAAT           22          21          26          87
AAAAAAG           34           0           0           0
AAAAATA            0          91          76           0
etc.
```

## Notes

* Do not mix samples of reads and contigs, because the k-mer frequencies
will be not comparable.
* When using reads, the minimum k-mer frequency reported is `--minfreq`
* When using reads, it is recommended to only use R1, and ignore R2 as it is
normally noisier and more error-prone, and doesn't add much extra
information
* If you only want "core" k-mers, you can `grep -v -w 0 kmers.tsv > core.tsv`
 (NOTE: will removed header line)
* To binarize the results to presence/absence you can
`sed -e 's/[1-9][0-9]*/1/g' kmers.tsv > yesno.tsv`
(NOTE: will mess up header line)

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
* `kmc` >= 3.1
* GNU `parallel` >= 20160101
* GNU `sort`, `paste`, `join`, `cut`, `uniq`, `wc`

## License

kounta is free software, released under the
[GPL 3.0](https://raw.githubusercontent.com/tseemann/kounta/master/LICENSE).

## Issues

Please submit suggestions and bug reports to the
[Issue Tracker](https://github.com/tseemann/kounta/issues)

## Author

[Torsten Seemann](https://twitter.com/torstenseemann)
