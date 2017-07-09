package MojoSample::Schema::Result::Memo;
use base qw/DBIx::Class::Core/;

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


__PACKAGE__->belongs_to(
    user =>
    'MojoSample::Schema::Result::User',
    'user_id'
);


1;
