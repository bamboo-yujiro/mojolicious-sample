package MojoSample;
use Mojo::Base 'Mojolicious';
use MojoSample::Schema;
use DBIx::Encoding;
use MojoSample::Helpers;
use FormValidator::Simple;

our $schema;

# This method will run once at server start
sub startup {
  my $self = shift;

  $self->secrets(['4649onegaishimasu']);

  # Load configuration from hash returned by "my_app.conf"
  my $config = $self->plugin('Config');

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer') if $config->{perldoc};

  $schema = MojoSample::Schema->connect(
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
  $filter->get('/users/new')->to('Users#new_');
  $filter->post('/users/create')->to('Users#create');

  # ログインが必要になるページ
  my $login_required = $filter->under->to('Users#logined_check');
  $login_required->get('/memos')->to('Memos#index');
  $login_required->get('/memos/new')->to('Memos#new_'); # new は使えなかった
  $login_required->get('/memos/:id/show')->to('Memos#show');
  $login_required->post('/memos/create')->to('Memos#create');
  $login_required->post('/memos/:id/destroy')->to('Memos#destroy');
  $login_required->get('/memos/:id/edit')->to('Memos#edit');
  $login_required->post('/memos/:id/update')->to('Memos#update');
  $login_required->get('/users/logout')->to('Users#logout');


  $self->plugin('MojoSample::Helpers');

  # Validation
  FormValidator::Simple->set_message_decode_from('utf-8');
  FormValidator::Simple->set_messages({
    users => {
      username => {
        NOT_BLANK => 'ユーザー名は必須です。',
        LENGTH => 'ユーザー名は4文字以上16文字以内で入力してください。',
        DBIC_UNIQUE => '指定されたユーザー名は既に使用されています。'
      },
      password => {
        NOT_BLANK => 'パスワードは必須です。',
        LENGTH => 'パスワードは8文字以上16文字以内で入力してください。'
      }
    },
    memos => {
      title => {
        NOT_BLANK => 'タイトルは必須です。',
      },
      content => {
        NOT_BLANK => '内容は必須です。',
      }
    },
  });

  MojoSample::Schema::Result::User->validation(
    module => 'FormValidator::Simple',
    profile => [
      username => [
        'NOT_BLANK',
        ['LENGTH', 4, 16],
        ['DBIC_UNIQUE', $schema->resultset('User'), 'username']
      ],
      password => ['NOT_BLANK', ['LENGTH', 8, 16]],
    ],
    filter => 0,
    auto => 1,
  );

  MojoSample::Schema::Result::Memo->validation(
    module => 'FormValidator::Simple',
    profile => [
      title => ['NOT_BLANK'],
      content => ['NOT_BLANK'],
    ],
    filter => 0,
    auto => 1,
  );

}

1;
