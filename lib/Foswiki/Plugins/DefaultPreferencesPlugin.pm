# See bottom of file for default license and copyright information
package Foswiki::Plugins::DefaultPreferencesPlugin;

use strict;
use warnings;

use Foswiki::Func;
use Foswiki::Plugins;
use List::Util 'max';
use JSON;

our $VERSION = '2.0';
our $RELEASE = '2.0';
our $SHORTDESCRIPTION = 'Custom preferences backend for Q.wiki';
our $NO_PREFS_IN_TOPIC = 1;

our $sitePrefs;

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

sub finishPlugin {
  if($sitePrefs) {
    $sitePrefs->finish();
    undef $sitePrefs;
  }
}

sub nopValue {
  my $value = shift;
  $value =~ s/%/%<nop>/g;
  $value =~ s/\$/\$<nop>/g;
  return $value;
}

sub tagDEFAULTPREFS {
  my($session, $params, $topic, $web, $topicObject) = @_;
  my $levels = $session->{prefs}{main}{levels};

  my $preferenceDescriptors = {};

  my $isSitePrefTopic = $topicObject->web.'.'.$topicObject->topic eq $Foswiki::cfg{LocalSitePreferences};

  # We track and parse the preferences in the stack
  my $foundSitePreferences = 0;
  my $lastBackend;
  for(my $i = 0; $i < @$levels - 2; $i++){
    my $backend = @{$levels}[$i];
    # We want to start tracking with the SitePreferences
    if($backend->{topicObject}->topic eq 'SitePreferences'){
      $foundSitePreferences = 1;
    }
    unless($foundSitePreferences){
      next;
    }
    $lastBackend = $backend;
    foreach(keys %{$backend->{values}}){
      unless($preferenceDescriptors->{$_}){
        $preferenceDescriptors->{$_} = {
          name => $_,
          inheritPath => [],
          value => nopValue(Foswiki::Func::getPreferencesValue($_))
        };
      }
      my $isDefaultPref = exists $backend->{inheritedDefaultPrefs}{$_};
      if ($isDefaultPref) {
        push(@{$preferenceDescriptors->{$_}->{inheritPath}}, {
          source => $backend->{inheritedDefaultPrefs}{$_}->{module},
          value => nopValue($backend->{inheritedDefaultPrefs}{$_}->{value}),
          isDefaultPref => JSON::true
        });
      }
      unless ($isDefaultPref && !$backend->{inheritedDefaultPrefs}{$_}->{isOverridden}) {
        push(@{$preferenceDescriptors->{$_}->{inheritPath}}, {
          source => $backend->{topicObject}->web."/".$backend->{topicObject}->topic,
          value => nopValue($backend->{values}{$_}),
          isDefaultPref => JSON::false
        });
      }
    }
  }

  my @prefsArray = ();
  map { push(@prefsArray, $preferenceDescriptors->{$_}) } keys %$preferenceDescriptors;
  my $jsonPrefs = to_json({
      isSitePrefTopic => $isSitePrefTopic ? JSON::true : JSON::false,
      preferences => \@prefsArray
    });

  Foswiki::Func::addToZone( 'script', 'DEFAULT_PREFERENCES',
    "<script type='text/javascript' src='%PUBURL%/%SYSTEMWEB%/DefaultPreferencesPlugin/js/defaultPreferencesPlugin.js'></script>","jsi18nCore"
  );
  Foswiki::Func::addToZone( 'script', "DEFAULT_PREFERENCES_PREFS",
    "<script type='text/json'>$jsonPrefs</script>"
  );

  return "<default-preferences preferences-selector='DEFAULT_PREFERENCES_PREFS'></default-preferences>"
}

sub getSitePreferencesValue {
  my ($name, $session) = @_;
  $session ||= $Foswiki::Plugins::SESSION;

  unless($sitePrefs) {
      $sitePrefs = Foswiki::Prefs->new($session);
      $sitePrefs->loadSitePreferences();
  }

  return $sitePrefs->getPreference($name);
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
