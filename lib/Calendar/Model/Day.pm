package Calendar::Model::Day;
use strict;

=head1 NAME

Calendar::Model::Day - Simple class modelling Calendar day

=cut

use Data::Dumper;

use Moose;

=head1 SYNOPSIS

=head1 METHODS

=head2 new

Class constructor method, returns a Calendar::Model::Day object based on the arguments :

=over 4

=item dmy - required a date in DD-MM-YYYY format

=item day_of_week - required day of week (1 to 7)

=back


=head1 ATTRIBUTES

=over 4

=item dmy - date in DD-MM-YYYY format

=item day_of_week - day of week (1 (Monday) to 7)

=item dow_name - day of week name (Monday, etc)

=item dd - day of month

=item mm - Month number ( 0-12 )

=item yyyy - Year (4 digits)

=back

=cut

has 'dmy' => (
    is  => 'ro',
    isa => 'Str',
    required => 1,
);


has 'dd' => (
    is  => 'ro',
    isa => 'Int',
    init_arg => undef,
);

has 'mm' => (
    is  => 'ro',
    isa => 'Int',
    init_arg => undef,
);

has 'yyyy' => (
    is  => 'ro',
    isa => 'Int',
    init_arg => undef,
);


has 'day_of_week' => (
    is  => 'ro',
    isa => 'Int',
    required => 1,
);

has 'dow_name' => (
    is  => 'ro',
    isa => 'Str',
    required => 1,
);

has 'is_selected_month' => (
    is => 'ro',
    isa => 'Bool',
);

=head2 BUILD

Std Moose initialisation hook called by constructor method

=cut

sub BUILD {
    my $self = shift;
    my $args = shift;

    # split dmy into dd mm yyyy,
    @{$self}{qw/dd mm yyyy/} = split(/\-/,$self->dmy);

    # check if provided selected month and set flag appropriately

    # do working day check

    # work out ordinal value/format

}

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Aaron Trevena.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.

=cut

1;
