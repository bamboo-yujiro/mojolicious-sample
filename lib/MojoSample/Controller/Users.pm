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

sub create {
  my $c = shift;
  if ($c->req->method eq 'POST'){
    my $username = $c->param('username');
    my $password = $c->param('password');
    my $user = $c->db->resultset('User')->search({username => $username})->first();
    eval {#例外
      my $new_user = $c->db->resultset('User')->create({username => $username, password => $password})->insert;
      $c->session->{login_user_id} = $new_user->id;
      $c->redirect_to('/memos/');
    };
    if ($@) {
      #$use Data::Dumper;
      #print Dumper $@;
      #exit;
      my $error_messages = $@->messages('users');
      $c->stash({message => "保存できませんでした。", error => 1, records => $@->_records, error_messages => $error_messages});
      $c->render();
      return;
    }
  }
  $c->stash({error => 0, records => '', error_messages => []});
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
