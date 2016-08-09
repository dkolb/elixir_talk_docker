#!/usr/bin/perl

print "Starting Exlir app...\n";

$SIG{TERM} = sub {
  exec "/app/hello_world/bin/eventer_alerts stop";
  die "Exiting. \n";
};

system "/app/hello_world/bin/hello_world foreground";
