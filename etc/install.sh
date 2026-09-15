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
# gitコマンドが存在すれば、gitを使う
if is_exists "git"; then
    # git clone [リポジトリ] [ディレクトリ(クローン先)]
    # git clone --recursiveは下記のコマンドと同義
    # git submodule init
    # git submodule update
    git clone -c core.symlinks=true --recursive "$DOTFILES_GITHUB" "$DOTPATH"
# curl または wget が存在すれば、それを使う
elif is_exists "curl" || is_exists "wget"; then
    local tarball="https://github.com/cygnu/dotfiles/archive/master.tar.gz"
    if is_exists "curl"; then
        curl -L "$tarball"
    elif is_exists "wget"; then
        wget -0 - "$tarball"
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
# /Users/[ユーザー名] 配下にシンボリックリンク(参照)を作成
######################################################################
# 移動
command cd ~/.dotfiles
# コマンド実行時の終了ステータスが正常(0)でなければエラー
if [ $? -ne 0 ]; then
    log_fail "not found: $DOTPATH"
    exit 1
fi
# ドットファイルを列挙して、シンボリックリンクを作成
for f in .??*
do
    # 一致したら、シンボリックリンクを作成せずに次の処理に移る
    # 不要なドットファイルを対象から除外する
    [ "$f" = ".git" ] && continue
    [ "$f" = ".gitignore" ] && continue
    [ "$f" = ".DS_Store" ] && continue

    # ln [オプション] リンク元 リンク先
    # e.g. ~/.dotfiles/.vimrcの参照を~/.vimrcに作成
    # 更新する際は、~/.dorfilesを更新すれば、~/.vimrcにも反映される
    # 基本的にはリンク元のファイルを更新・取得してメンテナンスする
    ln -snfv "$DOTPATH/$f" "$HOME/$f"
#       │││└─ 処理内容を表示
#       ││└─ 強制的にシンボリックリンクを作成
#       │└─ リンクの作成場所として指定したディレクトリがシンボリックリンクだった場合、参照先にリンクを作るのではなく、シンボリックリンクそのものを置き換える（-fと組み合わせて使用）
#       └─ シンボリックリンクを作成
done
