package Warnings::Deprecated::AlwaysFatal;
use strict;
use warnings;

our $VERSION = '0.001000';
$VERSION =~ tr/_//d;

my $real_import = \&warnings::import;
my $real_unimport = \&warnings::unimport;

my $import = sub {
  my $class = shift;
  $class->$real_import(@_);
  $class->$real_import(FATAL => 'deprecated');
};

my $unimport = sub {
  my $class = shift;
  $class->$real_unimport(@_);
  $class->$real_import(FATAL => 'deprecated');
};

my $injected;
sub import {
  return if $injected;

  *warnings::import = $import;
  *warnings::unimport = $unimport;

  my $old_sig = $SIG{__WARN__};

  $SIG{__WARN__} = sub {
    my ($warning) = @_;

    goto &$old_sig
      if $old_sig;
  };

  ++$injected;
}

1;
__END__

=head1 NAME

Warnings::Deprecated::AlwaysFatal - A new module

=head1 SYNOPSIS

  use Warnings::Deprecated::AlwaysFatal;

=head1 DESCRIPTION

A new module.

=head1 AUTHOR

haarg - Graham Knop (cpan:HAARG) <haarg@haarg.org>

=head1 CONTRIBUTORS

None so far.

=head1 COPYRIGHT

Copyright (c) 2024 the Warnings::Deprecated::AlwaysFatal L</AUTHOR> and L</CONTRIBUTORS>
as listed above.

=head1 LICENSE

This library is free software and may be distributed under the same terms
as perl itself. See L<https://dev.perl.org/licenses/>.

=cut
