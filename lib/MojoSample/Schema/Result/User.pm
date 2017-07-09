package MojoSample::Schema::Result::User;
use base qw/DBIx::Class::Core/;
use base qw( DBIx::Class );
use FormValidator::Simple;

__PACKAGE__->load_components(qw/Validation/);

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

FormValidator::Simple->set_message_decode_from('utf-8');
FormValidator::Simple->set_messages({
  users => {
    username => {
      NOT_BLANK => 'ユーザー名は必須です。',
      LENGTH => 'ユーザー名は4文字以上16文字以内で入力してください。',
    },
    password => {
      NOT_BLANK => 'パスワードは必須です。',
      LENGTH => 'パスワードは8文字以上16文字以内で入力してください。'
    }
  },
});

__PACKAGE__->validation(
  module => 'FormValidator::Simple',
  profile => [
    username => ['NOT_BLANK', ['LENGTH', 4, 255]],
    password => ['NOT_BLANK', ['LENGTH', 8, 16]],
  ],
  filter => 0,
  auto => 1,
);

1;
