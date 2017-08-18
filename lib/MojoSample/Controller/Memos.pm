package MojoSample::Controller::Memos;
use Mojo::Base 'Mojolicious::Controller';
use MojoSample::Schema;

sub index {
  my $c = shift;
  my $memos = $c->db->resultset('Memo')->list($c->session->{login_user_id})->page(($c->param('page') || 1));
  my $pager = $memos->pager();
  $c->render(memos => $memos, pager => $pager);
}

sub create {
  my $c = shift;
  if($c->req->method eq 'POST'){
    my $title = $c->param('title');
    my $content = $c->param('content');
    my $tag_str = $c->param('tag_str');
    eval {
      my $memo = $c->db->resultset('Memo')->new({title => $title, content => $content, user_id => $c->session->{login_user_id}})->insert;
      $memo->append_tag($tag_str);
      $c->redirect_to('/memos/');
    };
    if($@){
      my $error_messages = $@->messages('memos');
      $c->stash(message => "保存できませんでした。");
      $c->render('error_messages' => $error_messages);
      return;
    }
  }
  $c->stash('error_messages' => []);
  $c->render();
}

1;
