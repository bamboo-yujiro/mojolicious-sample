package MojoSample::Schema::Result::User;
use base qw/DBIx::Class::Core/;

# Associated table in database
__PACKAGE__->table('users');

# Column definition
__PACKAGE__->add_columns(

    id => {
      data_type => 'integer',
      is_auto_increment => 1,
    },

    username => {
      data_type => 'varchar',
    },

    password => {
      data_type => 'text',
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


1;
