#!perl

use strict;
use Test::More;

use Data::Dumper;
use DateTime;
use Calendar::Model;

my $cal = Calendar::Model->new(selected_date=>DateTime->new(day=>3, month=>1, year=>2013));

is_deeply($cal->columns, [
          'Sunday',
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday'
        ]);

is($cal->first_entry_day->dmy,'30-12-2012');

is($cal->month, 1);

is($cal->year, 2013);

is($cal->previous_month, 12);

is($cal->previous_year, 2012);

is($cal->next_month, 2);

is($cal->next_year, 2013);

my $weeks = $cal->weeks;

my $day2 = $weeks->[0][2];

is ($day2->dow_name, 'Tuesday', '2nd day is tuesday');

is ($day2->day_of_week => 3, 'day of week');

is ($day2->dd => '01');

is ($day2->yyyy => '2013');

is ($cal->month_name, 'January', 'month name');

is ($cal->month_name('next'), 'February', 'next month name');

is ($cal->month_name('previous'), 'December', 'prev month name');

done_testing();

