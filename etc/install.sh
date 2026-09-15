#!/bin/bash

######################################################################
# 変数を環境変数として追加
######################################################################
DOTPATH=~/.dotfiles; export DOTPATH
DOTFILES_GITHUB="https://github.com/nagahamm/dotfiles.git"; export DOTFILES_GITHUB

######################################################################
# 関数
######################################################################
# コマンドの存在確認
is_exists() {
    which "$1" >/dev/null 2>&1
    return $?
}
# エラーログ出力
log_fail() {
    logging ERROR "$1" 1>&2
}

######################################################################
# dotfilesをホームディレクトリに複製
######################################################################
# 既にcloneされていれば、再度cloneしない(make updateで最新化する)
if [ -d "$DOTPATH" ]; then
    :
# gitコマンドが存在すれば、gitを使う
elif is_exists "git"; then
    # git clone [リポジトリ] [ディレクトリ(クローン先)]
    # git clone --recursiveは下記のコマンドと同義
    # git submodule init
    # git submodule update
    git clone -c core.symlinks=true --recursive "$DOTFILES_GITHUB" "$DOTPATH"
# curl または wget が存在すれば、それを使う
elif is_exists "curl" || is_exists "wget"; then
    tarball="https://github.com/nagahamm/dotfiles/archive/master.tar.gz"
    if is_exists "curl"; then
        curl -L "$tarball"
    elif is_exists "wget"; then
        wget -O - "$tarball"
    fi | tar zxv
    # 解凍したら、DOTPATHに置く
    # mv [オプション] 移動元 移動先
    command mv -f dotfiles-master "$DOTPATH"
#              └─ 移動先に同名ファイルがあっても確認せずに上書き
else
    log_fail "Requires curl or wget"
    exit 1
fi

######################################################################
# セットアップ (シンボリックリンク作成・環境設定・ツール導入)
######################################################################
# 移動
command cd "$DOTPATH"
# コマンド実行時の終了ステータスが正常(0)でなければエラー
if [ $? -ne 0 ]; then
    log_fail "not found: $DOTPATH"
    exit 1
fi
# Makefile の deploy/init/tools に委譲する(ここで独自にシンボリックリンクを
# 組み立てると、Makefile側と二重管理になり片方だけ更新されてずれるため)
make install
