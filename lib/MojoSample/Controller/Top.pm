package MojoSample::Controller::Top;
use Mojo::Base 'Mojolicious::Controller';
use MojoSample::Schema;

# This action will render a template
sub index {
  my $c = shift;
  $c->render();
}

1;
