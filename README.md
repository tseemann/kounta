[![CI](https://github.com/tseemann/kounta/workflows/CI/badge.svg)](https://github.com/tseemann/kounta/actions)
[![GitHub release](https://img.shields.io/github/release/tseemann/kounta.svg)](https://github.com/tseemann/kounta/releases)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Conda](https://img.shields.io/conda/dn/bioconda/kounta.svg)](https://anaconda.org/bioconda/kounta)
[![Language: Perl 5](https://img.shields.io/badge/Language-Perl%205-blue.svg)](https://www.perl.org/)

# kounta

Build a multi-genome unique k-mer count matrix

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
`sed -e '1 ! s/[1-9][0-9]*/1/g' kmers.tsv > yesno.tsv`
(NOTE: will mess up header line)

## Installation

```
conda install -c conda-forge -c bioconda kounta
```

## License

kounta is free software, released under the
[GPL 3.0](https://raw.githubusercontent.com/tseemann/kounta/master/LICENSE).

## Issues

Please submit suggestions and bug reports to the
[Issue Tracker](https://github.com/tseemann/kounta/issues)

## Author

[Torsten Seemann](https://tseemann.github.io/)


