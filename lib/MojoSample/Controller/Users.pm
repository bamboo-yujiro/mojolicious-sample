package MojoSample::Controller::Users;
use Mojo::Base 'Mojolicious::Controller';
use MojoSample::Schema;

sub logined_check {
  my $c = shift;
  if ($c->session('login_user_id')) {
    return 1;
  }
  $c->redirect_to('/users/login');
}

sub register {
  my $c = shift;
  if ($c->req->method eq 'POST'){
    my $username = $c->param('username');
    my $password = $c->param('password');
    my $user = $c->db->resultset('User')->search({username => $username})->first();
    if($user){
      my $username = $user->username;
      $c->stash(message => "${username}というユーザーは既に存在します。別の名前を選択してください。");
      $c->render('/users/register');
    }else{
      eval {#例外
        my $new_user = $c->db->resultset('User')->create({username => $username, password => $password})->insert;
        $c->session->{login_user_id} = $new_user->id;
        $c->redirect_to('/memos/');
      };
      if ($@) {
        my $error_messages = $@->messages('users');
        $c->stash(message => "保存できませんでした。");
        $c->render('error_messages' => $error_messages);
        return;
      }
    }
  }
  $c->stash('error_messages' => []);
  $c->render();
}

sub login {
  my $c = shift;
  if ($c->req->method eq 'POST'){
    my $username = $c->param('username');
    my $password = $c->param('password');
    my $user = $c->db->resultset('User')->search({username => $username, password => $password})->first();
    if($user){
      $c->session->{login_user_id} = $user->id;
      $c->redirect_to('/memos/');
    }else{
      $c->stash(message => "ユーザー名かパスワードが間違っています。");
      $c->render();
      return;
    }
  }
  $c->render();
  return;
}

sub logout {
  my $c = shift;
  delete $c->session->{login_user_id};
  $c->redirect_to('/');
}

1;
