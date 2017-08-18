package MojoSample::Schema::Result::Tag;
use base qw/DBIx::Class::Core/;
use MojoSample::Schema::ResultSet::Tag;

# Associated table in database
__PACKAGE__->table('tags');

# Column definition
__PACKAGE__->add_columns(

     id => {
         data_type => 'integer',
         is_auto_increment => 1,
     },

     name => {
         data_type => 'varchar',
     },

 );

# Tell DBIC that 'id' is the primary key
__PACKAGE__->set_primary_key('id');

__PACKAGE__->resultset_class('MojoSample::Schema::ResultSet::Tag');


1;
