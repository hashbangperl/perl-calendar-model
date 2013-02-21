#!perl

use strict;

use Template;

use Data::Dumper;
use DateTime;
use Calendar::Model;

my $cal = Calendar::Model->new(selected_date=>DateTime->new(day=>5, month=>12, year=>2012));

my $events = {
    '2012-12-16' => 'Mousehole Lights',
    '2012-12-19' => 'Anniversary of Penlee Lifeboat Disaster',
};

my $holidays = {
    '2012-12-25' => 'Christmas Day',
    '2012-12-26' => 'Boxing Day',
};

# create Template object
my $template = Template->new({ INCLUDE_PATH => 'templates', POST_CHOMP=> 1,});
# process input template, substituting variables
$template->process('calendar.tt', {cal => $cal, events => $events, holidays => $holidays })
|| die $template->error();
