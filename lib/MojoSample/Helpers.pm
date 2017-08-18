package MojoSample::Helpers;
use base 'Mojolicious::Plugin';

sub register {
  my ($self, $app) = @_;
  $app->helper(my_pager =>
    sub {
      my ($self, $pager) = @_;
      my $pager_content = '';
      my $link;
      my $class;
      for (my $count = $pager->first_page(); $count <= $pager->last_page; $count++){
        if($count == $pager->current_page){
          $link = "${count}";
          $class = 'current';
        }else{
          $link = "<a href=\"?page=${count}\" class=\"${class}\">${count}</a>";
          $class = '';
        }
        $pager_content .= "<span>${link}</span>";
      }
      return $pager_content;
    }
  );
}

1;
