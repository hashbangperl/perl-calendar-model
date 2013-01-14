#!perl

use strict;
use Test::More;

use Data::Dumper;
use DateTime;
use Calendar::Model;

my $cal = Calendar::Model->new(selected_date=>DateTime->new(day=>3, month=>1, year=>2013));

warn Dumper($cal->columns);

is($cal->first_entry_day->dmy,'30-12-2012');

is($cal->month, 1);

is($cal->year, 2013);

is($cal->previous_month, 12);

is($cal->previous_year, 2012);

is($cal->next_month, 2);

is($cal->next_year, 2013);

warn Dumper $cal->weeks;

done_testing();

