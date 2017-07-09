package MojoSample::Model::Row::Memo;
use strict;
use warnings;
use utf8;
use MojoSample::Model;

sub table_name {'memos'}

sub user {
  my $self = shift;
  $self->{skinny}->search('users',{id => $self->user_id});
}

sub all {
  my $class = shift;
  MojoSample::Model->search(
    table_name,
  );
}

1;
