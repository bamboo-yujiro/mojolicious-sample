package MojoSample::Controller::Memos;
use Mojo::Base 'Mojolicious::Controller';
use MojoSample::Schema;

sub index {
  my $c = shift;
  my $memos = $c->db->resultset('Memo')->list($c->session->{login_user_id})->page(($c->param('page') || 1));
  my $pager = $memos->pager();
  $c->render(memos => $memos, pager => $pager);
}

sub show {
  my $c = shift;
  my $memo = $c->db->resultset('Memo')->search({id => $c->param('id')})->first();
  $c->render(memo => $memo);
}

sub new_ {
  my $c = shift;
  my $memo = $c->db->resultset('Memo')->new({});
  $c->render('error_messages' => [], memo => $memo);
}

sub create {
  my $c = shift;
  my $memo = $c->db->resultset('Memo')->new({title => $c->param('title'), content => $c->param('content'), user_id => $c->session->{login_user_id}});
  $memo->append_tag($c->param('tag_str'));
  eval {
    $memo->insert;
  };
  if($@){
    my $error_messages = $@->messages('memos');
    $c->stash(error_messages => $error_messages, message => "保存できませんでした。", memo => $memo);
    $c->render('memos/new_');
    return;
  }
  $c->flash(message => 'メモを追加しました');
  $c->redirect_to('/memos/' . $memo->id . '/edit');
}

sub edit {
  my $c = shift;
  my $memo = $c->db->resultset('Memo')->search({id => $c->param('id')})->first();
  $c->render(memo => $memo, error_messages => []);
}

sub update {
  my $c = shift;
  my $old_tags = $c->db->resultset('MemoTag')->search({memo_id => $c->param('id')});
  my $memo = $c->db->resultset('Memo')->search({id => $c->param('id')})->first();
  $memo->title($c->param('title'));
  $memo->content($c->param('content'));
  eval {
    $memo->validate();
  };
  if($@){
    my $error_messages = $@->messages('memos');
    $c->stash({message => '保存できませんでした', error_messages => $error_messages, memo => $memo});
    $c->render('memos/edit');
    return;
  }
  # 古いタグの削除
  $old_tags->delete;
  $memo->append_tag($c->param('tag_str'));
  $memo->update;
  $c->flash(message => 'メモを編集しました');
  $c->redirect_to('/memos/' . $c->param('id') . '/edit');
}

sub destroy {
  my $c = shift;
  $c->db->resultset('Memo')->search({id => $c->param('id')})->first()->delete();
  $c->flash(message => 'メモを削除しました');
  $c->redirect_to($c->req->headers->header('referer'));
}

1;
