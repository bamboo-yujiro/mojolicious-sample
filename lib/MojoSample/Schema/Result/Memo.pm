package MojoSample::Schema::Result::Memo;
use base qw/DBIx::Class::Core/;
use MojoSample::Schema::ResultSet::Memo;
use MojoSample::Schema::ResultSet::Tag;
use FormValidator::Simple;

__PACKAGE__->load_components(qw/Validation/);

# Associated table in database
__PACKAGE__->table('memos');

# Column definition
__PACKAGE__->add_columns(

     id => {
         data_type => 'integer',
         is_auto_increment => 1,
     },

     title => {
         data_type => 'varchar',
     },

     content => {
         data_type => 'text',
     },

     user_id => {
         data_type => 'integer',
     },

     created_at => {
         data_type => 'datetime',
     },

     updated_at => {
         data_type => 'datetime',
     },


 );

# Tell DBIC that 'id' is the primary key
__PACKAGE__->set_primary_key('id');

__PACKAGE__->resultset_class('MojoSample::Schema::ResultSet::Memo');

__PACKAGE__->belongs_to(
    user => 'MojoSample::Schema::Result::User',
    'user_id'
);

__PACKAGE__->has_many(
    memo_tags => 'MojoSample::Schema::Result::MemoTag',
    'memo_id'
);

__PACKAGE__->many_to_many(
    tags => 'memo_tags' => 'tag'
);

sub formated_created {
  my $self = shift;
  return substr($self->created_at, 0, 16);
}

sub append_tag {
  my ($self, $tag_str) = @_;
  @tag_array = split /,/, $tag_str;
  for my $tag_name(@tag_array){
    $tag = $MojoSample::schema->resultset('Tag')->search({name => $tag_name})->first();
    if($tag){
    }else{
      $tag = $MojoSample::schema->resultset('Tag')->create({name => $tag_name})->insert();
    }
    $self->create_related('memo_tags', {tag_id => $tag->id});
  }
}

sub tag_str {
  my $self = shift;
  my $tag_str = '';
  foreach $tag ($self->tags) {
    $tag_str .= $tag->name . ',';
  }
  chop($tag_str);
  return $tag_str;
}

1;
