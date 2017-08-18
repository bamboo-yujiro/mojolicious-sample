package MojoSample::Schema::ResultSet::Memo;
use base 'DBIx::Class::ResultSet';

sub list {
  my ($self, $user_id) = @_;
  my $memos = $self->search({user_id => $user_id}, {rows => 12, order_by => 'id asc'});
  return $memos;
}

sub created {
  my $self = shift;
  return $self->created_at;
}

1;

