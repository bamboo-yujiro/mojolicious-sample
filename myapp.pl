#!/usr/bin/env perl
use strict;
use warnings;
use Mojolicious::Lite;
use DBI;

# Documentation browser under "/perldoc"
plugin 'PODRenderer';

# Connect to the database.
my $dbh = DBI->connect("DBI:mysql:database=mojolicious_sample;host=localhost",
                       "root", "kani",
                       {'RaiseError' => 1});

get '/' => sub {
  my $c = shift;
  my $memos = $dbh->prepare('select * from memos');
  $memos->execute;
  $c->stash('memos' => $memos);
  $c->render(template => 'index');
};

get '/test' => sub {
  my $c = shift;
  $c->render(template => 'test');
};

#app->start;
app->start("psgi");
