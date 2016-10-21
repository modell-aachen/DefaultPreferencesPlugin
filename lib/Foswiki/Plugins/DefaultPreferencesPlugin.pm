# See bottom of file for default license and copyright information
package Foswiki::Plugins::DefaultPreferencesPlugin;

use strict;
use warnings;

use Foswiki::Func;
use Foswiki::Plugins;

our $VERSION = '2.0';
our $RELEASE = '2.0';
our $SHORTDESCRIPTION = 'Custom preferences backend for Q.wiki';
our $NO_PREFS_IN_TOPIC = 1;

sub initPlugin {
  my ($topic, $web, $user, $installWeb) = @_;
  if ($Foswiki::Plugins::VERSION < 2.0) {
    Foswiki::Func::writeWarning('Version mismatch between ',
    __PACKAGE__, ' and Plugins.pm');
    return 0;
  }

  $Foswiki::Plugins::SESSION->{prefs}->setSessionPreferences(
    VIEW_TEMPLATE => 'PrefsDefaultView'
  ) if $topic eq $Foswiki::cfg{WebPrefsTopicName} || "$web.$topic" eq $Foswiki::cfg{LocalSitePreferences};

  Foswiki::Func::registerTagHandler('DEFAULTPREFS', \&tagDEFAULTPREFS);

  return 1;
}

sub tagDEFAULTPREFS {
  my($session, $params, $topic, $web, $topicObject) = @_;

  my $levels = $session->{prefs}{main}{levels};
  my @rams = grep {$_->isa('Foswiki::Prefs::EnhancedTopicRAM')} @$levels;

  my $prefs;
  if ($topic eq $Foswiki::cfg{WebPrefsTopicName}) {
    my @webPrefs = grep {$_->{topicObject}->topic eq $Foswiki::cfg{WebPrefsTopicName}} @rams;
    $prefs = pop(@webPrefs);
  } elsif ("$web.$topic" eq $Foswiki::cfg{LocalSitePreferences}) {
    my @sitePrefs = grep {$_->{topicObject}->web.'.'.$_->{topicObject}->topic eq $Foswiki::cfg{LocalSitePreferences}} @rams;
    $prefs = pop(@sitePrefs);
  }

  return $prefs->stringify if defined $prefs;
  return '';
}

sub maintenanceHandler {
  Foswiki::Plugins::MaintenancePlugin::registerCheck("prefs_backend", {
    name => "EnhancedTopicRAM",
    description => "Check whether \$Foswiki::cfg{Store}{PrefsBackend} is set to EnhancedTopicRAM",
    check => sub {
      my $retval = {result => 0};
      my $enabled = $Foswiki::cfg{Plugins}{DefaultPreferencesPlugin}{Enabled} || 0;
      if ($enabled) {
        unless ($Foswiki::cfg{Store}{PrefsBackend} eq 'Foswiki::Prefs::EnhancedTopicRAM') {
          $retval->{result} = 1;
          $retval->{priority} = $Foswiki::Plugins::MaintenancePlugin::CRITICAL;
          $retval->{solution} = "Set =\$Foswiki::cfg{Store}{PrefsBackend}= to =Foswiki::Prefs::EnhancedTopicRAM=";
        }
      }

      return $retval;
    }
  });
}

1;

__END__
Q.Wiki DefaultPreferencesPlugin - Modell Aachen GmbH

Author: Modell Aachen GmbH

Copyright (C) 2016 Modell Aachen GmbH

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.
