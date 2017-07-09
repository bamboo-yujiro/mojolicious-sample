package MojoSample::Controller::Base;
use Mojo::Base 'Mojolicious::Controller';
use MojoSample::Schema;

sub before_filter {
  my $c = shift;
  if ($c->session('login_user_id')) {
    my $user = $c->db->resultset('User')->search({id => $c->session('login_user_id')})->first();
    $c->stash('current_user', $user);
    return 1;
  }else{
    $c->stash('current_user', undef);
  }
  return 1;
}

1;
