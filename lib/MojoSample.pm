package MojoSample;
use Mojo::Base 'Mojolicious';
use MojoSample::Schema;
use DBIx::Encoding;

# This method will run once at server start
sub startup {
  my $self = shift;

  $self->secrets(['4649onegaishimasu']);

  # Load configuration from hash returned by "my_app.conf"
  my $config = $self->plugin('Config');

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer') if $config->{perldoc};

  my $schema = MojoSample::Schema->connect(
    'dbi:mysql:mojolicious_sample', 'root', 'kani',
    {
      RaiseError => 1,
      AutoCommit => 1,
      RootClass => 'DBIx::Encoding',
      encoding  => 'utf8'
    },
  );
  $self->helper(db => sub { return $schema; });

  # Router
  my $r = $self->routes;

  # Normal route to controller
  my $filter = $r->under->to('Base#before_filter');
  $filter->get('/')->to('Top#index');
  $filter->get('/users/login')->to('Users#login');
  $filter->post('/users/login')->to('Users#login');
  $filter->get('/users/register')->to('Users#register');
  $filter->post('/users/register')->to('Users#register');

  # ログインが必要になるページ
  my $login_required = $filter->under->to('Users#logined_check');
  $login_required->get('memos')->to('Memos#index');
  $login_required->get('/users/logout')->to('Users#logout');

}

1;
