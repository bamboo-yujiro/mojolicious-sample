package MojoSample::Controller::Users;
use Mojo::Base 'Mojolicious::Controller';
use MojoSample::Schema;

sub logined_check {
  my $c = shift;
  if ($c->session->{login_user_id}) {
    return 1;
  }
  $c->redirect_to('/users/login');
  return undef;
}

sub new_{
  my $c = shift;
  my $user = $c->db->resultset('User')->new({});
  $c->render(user => $user, error_messages => []);
}

sub create {
  my $c = shift;
  my $user = $c->db->resultset('User')->new({username => $c->param('username'), password => $c->param('password')});
  eval {
    $user->insert;
  };
  if ($@) {
    my $error_messages = $@->messages('users');
    $c->stash({message => "保存できませんでした。", error_messages => $error_messages, user => $user});
    $c->render('users/new_');
    return;
  }
  $c->session->{login_user_id} = $user->id;
  $c->redirect_to('/memos/');
}

sub login {
  my $c = shift;
  if ($c->req->method eq 'POST'){
    my $user = $c->db->resultset('User')->search({username => $c->param('username'), password => $c->param('password')})->first();
    if($user){
      $c->session->{login_user_id} = $user->id;
      $c->redirect_to('/memos/');
    }else{
      $c->stash(message => "ユーザー名かパスワードが間違っています。");
      $c->render();
      return undef;
    }
  }
  $c->render();
}

sub logout {
  my $c = shift;
  delete $c->session->{login_user_id};
  $c->redirect_to('/');
}

1;
