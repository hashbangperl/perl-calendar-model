package Calendar::Model;
use strict;

=head1 NAME

Calendar::Model - Simple class modelling Month/Week Calendars

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use Calendar::Model;

    my $cal = Calendar::Model->new();

    my $columns = $cal->columns;

    my $rows = $cal->rows;

    my $dates = $cal->as_list;

    my $start_date = $cal->start_date;

    my $selected_date = $cal->selected_date

    my $month = $cal->month;

    my $year  = $cal->year;

    my $next_month = $cal->next_month;

    my $prev_month = $cal->previous_month;

=cut

use DateTime;
use DateTime::Duration;
use Calendar::List;

use Calendar::Model::Day;

use Data::Dumper;

use Moose;
with 'MooseX::Role::Pluggable';

=head1 ATTRIBUTES

=over 4

=back

=cut

has 'columns' => (
    is  => 'ro',
    isa => 'ArrayRef',
    init_arg => undef,
    default => sub { [qw/Sunday Monday Tuesday Wednesday Thursday Friday Saturday/] },
);

has 'rows'  => (
    is  => 'ro',
    isa => 'ArrayRef',
    init_arg => undef,
);

has 'month' => (
    is  => 'ro',
    isa => 'Str',
    init_arg => undef,
);

has 'next_month' => (
    is  => 'ro',
    isa => 'Str',
    init_arg => undef,
);

has 'previous_month' => (
    is  => 'ro',
    isa => 'Str',
    init_arg => undef,
);

has 'year' => (
    is  => 'ro',
    isa => 'Str',
);

has 'next_year' => (
    is  => 'ro',
    isa => 'Str',
    init_arg => undef,
);

has 'previous_year' => (
    is  => 'ro',
    isa => 'Str',
    init_arg => undef,
);

# has 'start_date' => (
#     is  => 'ro',
#     isa => 'DateTime'
# );

has 'selected_date' => (
    is  => 'ro',
    isa => 'DateTime',
);

has 'first_entry_day' => (
    is  => 'ro',
    isa => 'DateTime',
    init_arg => undef,
);

=head1 METHODS

=head2 new

Class constructor method, returns a Calendar::Model object based on the arguments :

=over 4

=item selected_date - optional, defaults to current local/system date, otherwise provide a DateTime object

=item window - optional, defaults to current month + next/previous days to complete calendar rows,
 otherwise provide number of days before selected date to show at start.

=back

=head2 BUILD

Std Moose initialisation hook called by constructor method

=cut

sub BUILD {
    my $self = shift;
    my $args = shift;

    # get selected date, month, year
    my $selected_date = $self->selected_date;
    my $dd;
    if ($self->month && $self->year) {
        $selected_date ||= DateTime->new(year => $self->year, month => $self->month, day => 1);
        $dd = 1 unless ($selected_date->month == $self->month and $selected_date->year == $self->year );
    } else {
        $selected_date ||= DateTime->now();
        $self->{month} = $selected_date->month;
        $self->{year} = $selected_date->year;
        $dd = $selected_date->day;
    }
    $self->{selected_date} = $selected_date unless ($self->selected_date);

    # get first entry
    my $first_month_day = $selected_date->clone;
    unless ($dd == 1) {
        $first_month_day = DateTime->new(year => $self->year, month => $self->month, day => 1);
    }
    my $first_entry_day = $first_month_day->clone;
    unless ($first_month_day->wday == 7) {
        $first_entry_day->subtract(days => $first_month_day->wday);
    }
    $self->{first_entry_day} = $first_entry_day;

    # get next/prev month and year
    $self->{previous_month} = ($self->month == 1) ? 12 : $self->month - 1;
    $self->{next_month} = ($self->month == 12) ? 1 : $self->month + 1;
    $self->{previous_year} = ($self->{previous_month} == 12) ? $self->year - 1 : $self->year;
    $self->{next_year} = ($self->{next_month} == 1)? $self->year + 1 : $self->year;

    my $day_plugins = [];
    foreach my $plugin ( @{ $self->plugin_list } ) {
        $plugin->init() if ( $plugin->can( 'init' ));
    }

    return;
}

sub weeks {
    my $self = shift;

    unless ($self->rows) {
        # build rows of days
        my $day_plugins = [];
        foreach my $plugin ( @{ $self->plugin_list } ) {
            push  if ( $plugin->can( 'init' ));
        }

        foreach (1..5) {
            my $dow = 1;
            push (
                @{$self->{rows}},
                map { Calendar::Model::Day->new({ dmy => $_, day_of_week => $dow++ }) }
                calendar_list('DD-MM-YYYY',{start => $self->{first_entry_day}->dmy, "options" => 7})
            );
        }
    }
    # natatime is iterator accessor for ArrayRef accessor in moose - built in, would be nice to wrap it
    return $self->rows;
}


###

no Moose;
__PACKAGE__->meta->make_immutable;

=head1 AUTHOR

Aaron Trevena, C<< <teejay at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-calendar-model at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Calendar-Model>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Calendar::Model


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Calendar-Model>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Calendar-Model>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Calendar-Model>

=item * Search CPAN

L<http://search.cpan.org/dist/Calendar-Model/>

=back

=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 Aaron Trevena.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.

=cut

1;
