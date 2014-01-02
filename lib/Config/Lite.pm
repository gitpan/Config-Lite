package Config::Lite;

use strict;
use warnings;
use Fcntl qw/:flock/;

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(load_config);
our @EXPORT = qw();
our $VERSION = '0.01';

sub load_config
{
	my $config_filename = shift;
	open my $fh,"<", $config_filename or return "no config file found";
	flock $fh, LOCK_SH;
	my $config_content = '';
	while(<$fh>)
	{
		next unless $_ =~ /=/;
		next if $_ =~ /^#/;
		$config_content .= $_;
	}
	flock $fh, LOCK_UN;
	close $fh;
	my @config_hash = $config_content =~ /(.+?)=(.+?)$/smg;
	grep {s/^\s+//; s/\s+$//;} @config_hash;
	return @config_hash;
}



1;
__END__

=head1 NAME

Config::Lite - Load config from file to hash.

=head1 SYNOPSIS

Once you make a config file like this:

  # /etc/myconfig.conf
  test1=123
  test2=abc
  right=left
  pop = bad  [
  so =gogogo
  lover = yejiao       
  #sharped=somevalue

You can code like this:

  use Config::Lite qw(load_config);
  my %config = load_config("/etc/myconfig.conf");

You got this:

  # %config = (
  #   "test1" => 123,
  #   "test2" => "abc",
  #   "right" => "left",
  #   "pop" => "bad  [",
  #   "so" => "gogogo",
  #   "lover" => "yejiao",
  # );

=head1 DESCRIPTION

Simple config load module.
Code is clean and no dependence, so the module is easy to use and install.  
I<flock> inside.


=head1 EXPORT

None by default.



=head1 SEE ALSO

L<Config::Auto>, L<Config::General>

=head1 AUTHOR

Chen Gang, E<lt>yikuyiku.com@gmail.comE<gt>

L<http://blog.yikuyiku.com/>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by Chen Gang

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut
