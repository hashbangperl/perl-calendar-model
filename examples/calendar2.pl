#!perl

use strict;

use Template;
use DateTime;
use Calendar::Model;

my $cal = Calendar::Model->new(selected_date=>DateTime->new(day=>5, month=>12, year=>2012));

my $events = {
    '2012-12-16' => 'Mousehole Lights',
    '2012-12-19' => 'Anniversary of Penlee Lifeboat Disaster',
};

my $template = Template->new({ INCLUDE_PATH => 'templates', POST_CHOMP=> 1,});
# process sidebar template
$template->process('sidebar_calendar.tt', {cal => $cal, events => $events })
|| die $template->error();
