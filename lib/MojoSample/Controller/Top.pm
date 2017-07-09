package MojoSample::Controller::Top;
use Mojo::Base 'Mojolicious::Controller';
use MojoSample::Schema;

# This action will render a template
sub index {
  my $c = shift;
  my $memos = $c->db->resultset('Memo');
  $c->render('memos' => $memos);
}

1;
