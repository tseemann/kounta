package Biotool::Getopt;

use 5.26.0;
use strict;
use Data::Dumper;
use List::Util qw(max);
use Biotool::Logger;

sub validate {
  my($self, $type, $value) = @_;
  my $valid = {
    'int'     => sub { @_[0] =~ m/^[-+]?\d+$/; },
    'bool'    => sub { @_[0] =~ m/^(0|1)$/; },
    'counter' => sub { @_[0] =~ m/^\d+$/; },
    'float'   => sub { @_[0] =~ m/^[+-]?\d+\.\d+$/; },
    'ifile'   => sub { -f @_[0] && -r _ },
    'idir'    => sub { -d @_[0] && -r _ },
    'file'    => sub { 1 },
    'dir'     => sub { 1 },
  };
  exists $valid->{$type} or err("Don't know how to validate type '$type'");
  my $ok = $valid->{$type}->($value);
  err("Paramater '$value' is not a valid $type type") unless $ok;
  return $ok; 
}

sub show_help {
  my($self, $d, $p, $err) = @_;
  select $err ? \*STDERR : \*STDOUT;
  printf "NAME\n  %s %s\n", $d->{name}, $d->{version};
  printf "SYNOPSIS\n  %s\n", $d->{desc};
  printf "USAGE\n  %s [options]\n", $d->{name};
  printf "OPTIONS\n";
  $$p{help} = { type=>'', desc=>'Show this help' };
  $$p{version} = { type=>'', desc=>'Print version and exit' };
  my @opt = sort keys %$p;
  my $width = max( map { length } @opt );
  for my $opt (@opt) {
    printf "  --%-${width}s  %-7s  %s%s\n",
      $opt,
      $$p{$opt}{type},
      $$p{$opt}{desc}||'',
      ($$p{$opt}{default} ? "[".$$p{$opt}{default}."]" : '');
  }
  exit($err ? $err : 0);
}

sub show_version {
  my($self, $d) = @_;
  printf "%s %s\n", $d->{name}, $d->{version};
  exit(0);
}

sub getopt {
  my($self, $d, $p) = @_;
#  print Dumper($p);
  my $opt = {};
  my $switch = '';
  while (my $arg = shift @ARGV) {
    #msg("Checking arg=[$arg]");
    if ($arg =~ m/^--?(\w+)(=(\S+))?$/) {
      $switch = $1;
      $switch =~ m/^(h|help)$/ and show_help($self,$d,$p);
      $switch =~ m/^(V|version)$/ and show_version($self,$d);
      exists $p->{$switch} or err("Invalid option --$switch");
      unshift @ARGV, $3 if defined $3;
      #msg("Switch=[$switch]");
      my $s = $$opt{$switch};
      $$opt{$switch}=1 if $$s{type} eq 'bool';
      $$opt{$switch}++ if $$s{type} eq 'counter';
    }
    else {
      #msg("Value=[$arg]");
      if ($switch) {
        $$opt{$switch} = $arg;
        $switch = '';
      }
      else {
        push @{ $opt->{ARGV} }, $arg;
      }
    }
  }
  
  # go back and fill in defaults
  for my $switch (keys %$p) {
    $opt->{$switch} //= $p->{$switch}{default};
    err("Option --$switch is mandatory") 
      if $p->{$switch}{need} and not defined $opt->{$switch};
    #say Dumper($p->{$switch});
    validate($self, $p->{$switch}{type}, $opt->{$switch})
      if defined $opt->{$switch};
  }
  
  return $opt;
}

1;
