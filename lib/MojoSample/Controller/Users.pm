package MojoSample::Controller::Users;
use Mojo::Base 'Mojolicious::Controller';
use MojoSample::Schema;

sub logined {
  my $c = shift;
  if ($c->session('login_user_id')) {
    my $user = $c->db->resultset('User')->search({id => $c->session('login_user_id')})->first();
    $c->stash('current_user', $user);
    return 1;
  }
  $c->redirect_to('/users/login');
  return undef;
}

sub register {
  my $c = shift;
  if ($c->req->method eq 'POST'){
    my $username = $c->param('username');
    my $password = $c->param('password');
    my $user = $c->db->resultset('User')->search({username => $username})->first();
    if($user){
      my $username = $user->username;
      $c->flash(message => "${username}というユーザーは既に存在します。別の名前を選択してください。");
      $c->redirect_to('/users/register');
    }else{
      my $new_user = $c->db->resultset('User')->create({username => $username, password => $password})->insert;
      $c->session->{login_user_id} = $new_user->id;
      $c->redirect_to('/mypage/');
    }
  }
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
      $c->redirect_to('/mypage/');
    }else{
      $c->flash(message => "ユーザー名かパスワードが間違っています。");
    }
  }
  $c->render();
  return undef;
}

sub logout {
  my $c = shift;
  delete $c->session->{login_user_id};
  $c->redirect_to('/');
}

1;
