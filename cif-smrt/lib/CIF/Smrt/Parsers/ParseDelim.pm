package CIF::Smrt::Parsers::ParseDelim;

use strict;
use warnings;

use Moose;
use CIF::Smrt::Parser;
extends 'CIF::Smrt::Parser';
use namespace::autoclean;

use constant NAME => 'delimiter';
sub name { return NAME; }

has 'delimiter' => (
  is => 'ro',
  isa => 'Str',
  required => 1
);

has 'feed_limit' => (
  is => 'ro',
);

has 'values' => (
  is => 'ro',
  isa => 'Str',
  required => 1
);

has 'skipfirst' => (
  is => 'ro',
  isa => 'Num',
  default => 0
);

sub parse {
    my $self = shift;
    my $fh = shift;
    my $broker = shift;

    my $split = $self->delimiter;

    my @cols = split(/\s*,\s*/, $self->values);
    
    my $start = 0;
    my $end = undef;
    if(my $l = $self->feed_limit){
        if(ref($l) eq 'ARRAY'){
            ($start,$end) = @{$l};
        } else {
            ($start,$end) = (0,$l-1);
        }
    }
    $start += 1 if($self->skipfirst);

    # Find our way to the first line we need to read.
    for (my $lineno = 0; $lineno <= $end; $lineno++) {
      last if ($fh->eof());
      my $line = $fh->getline();
      next if $lineno < $start;

      next if($line =~ /^(#|$|<)/);
      my @m = split($split,$line);
      my $h = {};
      foreach (0 ... $#cols){
        $h->{$cols[$_]} = $m[$_];
      }
      $broker->emit($h);
    }

    return(undef);
}

__PACKAGE__->meta->make_immutable;

1;
