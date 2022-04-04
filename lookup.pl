#!/usr/bin/env perl
use strict;
use warnings;
use Term::ANSIColor;
use v5.10.0;
no warnings 'experimental';

my $composurePath = ($ENV{'XDG_DATA_HOME'} || $ENV{'HOME'} . '/.local') . '/composure';
my $referenceColor = $ENV{'COMPOSURE_REFERENCE_COLOR'} || 'bold bright_red';
my @funcs = glob($composurePath . '/*.inc') or die "Cannot find composure files: $!";

my %groupsSeen = ();
my $groupFilter;

sub main {
  my $command = shift;
  
  my %actions = ( 
    glossary => \&glossary,
    reference => \&reference
  );

  $actions{$command}(@_) || die "Unknown command: $command";
}

sub glossary {
  my $groupFilter = shift;
  foreach my $func (@funcs) {
    my ($name, $about, $groupsRef, undef, undef) = extract_metadata_from_file($func);

    my %groupsHash = map { $_ => 1 } @$groupsRef;
    if ($groupFilter && !exists($groupsHash{$groupFilter})) {
      next;
    }
    if (!$about) {
      $about = "No description provided.";
    } 
    print colorize($referenceColor, $name) . ": " . colorize('bright_white', $about) . "\n";
  }

  print colorize('bold bright_white', "\ngroups defined: ") . join(', ', sort(keys(%groupsSeen))) . "\n";
  return 1;
} 

sub reference {
  my $func = shift;
  my $funcPath = $composurePath . '/' . $func . '.inc';
  my ($name, $about, $groupsRef, $examplesRef, $paramsRef) = extract_metadata_from_file($funcPath);

  say colorize($referenceColor, $name) . ": " . colorize('bright_white', $about);
  if (scalar @$paramsRef > 0) {
    say colorize('dark white', 'params:');
    foreach my $param (@$paramsRef) {
      say $param;
    }
  }
  if (scalar @$examplesRef > 0) {
    say colorize('dark white', 'examples:');
    foreach my $example (@$examplesRef) {
      say $example;
    }
  }
  if (scalar @$groupsRef > 0) {
    say colorize('dark white', 'groups') . ": " . join(' ', sort(@$groupsRef)) . "\n";
  }
  return 1;
}

sub rm_quotes {
  my $str = shift;
  return substr($str, 1, -1); # chop leading/trailing quote chars
}

sub extract_metadata_from_file {
  my $file = shift;

  open my $info, $file or die "Could not open $file: $!";
  my $fname = (split('/', $file))[-1];
  my $name = (split '.inc', $fname)[0];
  my $about;
  my @groups = ();
  my @params = ();
  my @examples = ();
  my @chunks = ();
  while (my $line = <$info>) {
    chomp($line);
    SWITCH: {
      if ($line =~ /^\s*about /) {
        @chunks = split /\s+/, $line;
        $about = rm_quotes(join(' ', @chunks[2 .. $#chunks]));
        last SWITCH;
      }
      if ($line =~ /^\s*group /) {
        @chunks = split /\s+/, $line;
        my $group = rm_quotes($chunks[2]);
        if ($group =~ /\w+/) {
          push(@groups, $group);
          $groupsSeen{$group}++;
        }
        last SWITCH;
      }
      if ($line =~ /^\s*example /) {
        @chunks = split /\s+/, $line;
        my $example = rm_quotes(join(' ', @chunks[2 .. $#chunks]));
        if ($example =~ /\w+/) {
          push(@examples, $example);
        }
        last SWITCH;
      }
      if ($line =~ /^\s*param /) {
        @chunks = split /\s+/, $line;
        my $param = rm_quotes(join(' ', @chunks[2 .. $#chunks]));
        if ($param =~ /\w+/) {
          push(@params, $param);
        }
        last SWITCH;
      }
    }
  }
  close $info;
  return ($name, $about, \@groups, \@examples, \@params);
}

sub colorize {
  my $colorstr = shift;
  my $text = shift;
  # don't colorize if not attached to a terminal
  if (! -t STDOUT) {
    return $text;
  }
  return color($colorstr) . $text . color('reset');
}

main @ARGV