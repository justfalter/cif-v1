package Cikl::DataTypes::PortList;
use strict;
use warnings;
use namespace::autoclean;
use Mouse::Util::TypeConstraints;

subtype "Cikl::DataTypes::PortList", 
  as 'Str',
  where {
    my $portlist = shift;
    foreach my $part (split(',', $portlist)) {
      if ($part =~ /^(\d+)(?:-(\d+))?$/) {
        my $start = $1;

        # No end? Just use the start as the end.
        my $end = $2 || $start; 

        # The start should come before the end...
        if (($start > $end) ||
            ($start < 0 || $start > 65535) ||
            ($end < 0 || $end > 65535)) { 
          return 0;
        }
      } else {
        return 0;
      }
    }
    return 1;
  };


1;

