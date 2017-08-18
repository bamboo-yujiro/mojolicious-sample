package MojoSample::Schema::Result::MemoTag;
use base qw/DBIx::Class::Core/;
use MojoSample::Schema::ResultSet::MemoTag;

# Associated table in database
__PACKAGE__->table('memo_tags');

# Column definition
__PACKAGE__->add_columns(

     id => {
         data_type => 'integer',
         is_auto_increment => 1,
     },

     memo_id => {
         data_type => 'integer',
     },

     tag_id => {
         data_type => 'integer',
     },


 );

# Tell DBIC that 'id' is the primary key
__PACKAGE__->set_primary_key('id');

__PACKAGE__->resultset_class('MojoSample::Schema::ResultSet::MemoTag');

__PACKAGE__->belongs_to(
    tag =>
    'MojoSample::Schema::Result::Tag',
    'tag_id'
);

__PACKAGE__->belongs_to(
    memo =>
    'MojoSample::Schema::Result::Memo',
    'memo_id'
);


1;
