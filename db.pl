#!/usr/bin/env/perl

use strict;
use warnings;
use DBI;

# Connect to the database.
my $dbh = DBI->connect("DBI:mysql:database=mojolicious_sample;host=localhost",
                       "root", "kani",
                       {'RaiseError' => 1});

