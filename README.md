## 詳細

[Mojolicious でアプリケーションをつくってみた ①【環境構築編】](http://bamboo-yujiro.hatenablog.com/entry/2017/08/20/003154)

[Mojolicious でアプリケーションをつくってみた ②](http://bamboo-yujiro.hatenablog.com/entry/2017/08/20/003214)


## 準備

perl env のインストール

`$ git clone git://github.com/tokuhirom/plenv.git ~/.plenv`


path 通す。自分は .zshrc に以下を入れました。

```
# For Perl Environment
export PERL_ROOT="${HOME}/.plenv"
if [ -d "${PERL_ROOT}" ]; then
  export PATH="$HOME/.plenv/bin:$PATH"
  eval "$(plenv init -)"
fi

```

再読込

`$ source ~/.zshrc`


perl-build のインストール

`$ git clone git://github.com/tokuhirom/Perl-Build.git ~/.plenv/plugins/perl-build/`


plenv で perl の 5.24.0 をインストール

`$ plenv install 5.24.0`


~/.plenv/shims 以下にコマンド群を入れる

`$ plenv rehash`

5.24.0 をglobal に適用する

`$ plenv global 5.24.0`

確認

`$ plenv versions`

cpanm のインストール

`$ plenv install-cpanm`

carton のインストール

`$ cpanm Carton`

ソースコード取得

`$ git clone https://github.com/bamboo-yujiro/mojolicious-sample.git  /path/to/project/`

アプリケーションの場所まで移動

`$ cd /path/to/project/`


cpanfileからライブラリをインストールスル前に必要なパッケージをいれておく

`$ sudo apt-get install mysql-client mysql-server`

`$ sudo apt-get install libmysqlclient15-dev`


cpanfile をもとにライブラリをインストールする

`$ carton install`


database 設定が直書きされているので変えてください。20行目あたりです。

`$ vi lib/MojoSample.pm`


起動シェル雛形コピー

`$ cp start.sh.sample start.sh`


host を変えてください。

`$ vi start.sh`


起動します。

`$ sh start.sh`


ちなみに vim で開発する場合、以下がよいかもしれません。
[https://github.com/yko/mojo.vim](https://github.com/yko/mojo.vim)

