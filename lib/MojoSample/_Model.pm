package MojoSample::Model;
use Mojo::Base 'Mojolicious';
use strict;
use warnings;

use DBIx::Skinny connect_info => +{
    dsn => 'dbi:mysql:mojolicious_sample',
    username => 'root',
    password => 'kani',
};

use MojoSample::Model::Row::Memo;
has 'memo' => sub { MojoSample::Model::Row::Memo->new };


1;
