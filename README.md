# dotfiles

macOS(Apple Silicon)の開発環境を構築するためのdotfiles。シェル・git・tmux・
Neovim・Homebrewパッケージの設定に加え、個人ツール(smart-renamer等)の
セットアップまで一括で行う。

## インストール

新しいMacで、このリポジトリをまだcloneしていない場合:

```Shell
bash -c "$(curl -L raw.githubusercontent.com/nagahamm/dotfiles/master/etc/install.sh)"
```

`~/.dotfiles` にcloneした上で `make install` を実行する。既に `~/.dotfiles`
が存在する場合はcloneをスキップし、最新化してから続行する(再実行しても
安全)。

既にこのリポジトリをcloneしてある場合は、直接:

```Shell
make install
```

## Makefileの主なターゲット

| ターゲット | 内容 |
| --- | --- |
| `make install` | `update` → `deploy` → `init` → `tools` を一括実行 |
| `make deploy` | ドットファイルを `$HOME` にシンボリックリンク |
| `make init` | git identity(`~/.gitconfig.local`)の対話入力、iTerm2カラープリセットのインポート |
| `make tools` | smart-renamer等、個人ツールリポジトリのセットアップ(対話確認あり) |
| `make update` | このリポジトリを最新化 |
| `make clean` | シンボリックリンクとこのリポジトリを削除 |
| `make list` | 配置対象のドットファイル一覧を表示 |
| `make help` | ターゲット一覧を表示 |

Homebrewパッケージ(`mac/brew/.Brewfile`)は `bash mac/brew/install_brew.sh`
で別途インストールする。

`eza --icons`(`ls`等のエイリアス)のアイコンを正しく表示するには、iTerm2の
プロファイルフォントを `FiraCode Nerd Font` に変更する(iTerm2 > Preferences
> Profiles > Text > Font)。

## ディレクトリ構成

| パス | 内容 |
| --- | --- |
| `git/` | `.gitconfig`(個人情報は含まず `~/.gitconfig.local` をinclude。`core.excludesfile` で `.gitignore_global` を読み込む設定込み)・`.gitignore_global` |
| `zsh/` | `.zshrc`・`.zprofile`・`.zshenv` |
| `tmux/` | `.tmux.conf` |
| `claude/` | Claude Codeのグローバル `CLAUDE.md`・`settings.json`(それぞれ `~/.claude/CLAUDE.md`・`~/.claude/settings.json` にリンク) |
| `.config/` | Neovim(`nvim/`)・starship(`starship.toml`) |
| `mac/brew/` | Homebrewの `.Brewfile` とインストールスクリプト |
| `mac/iterm2/` | iTerm2のカラープリセット(`make init` で自動インポート) |
| `etc/` | インストール(`install.sh`)・初期設定(`init/init.sh`)・個人ツール導入(`tools.sh`)のスクリプト |
| `windows/` | Windows Terminalの設定(Windows環境向け、macOSのセットアップ対象外) |
| `.github/workflows/` | Brewfileの整合性を定期チェックするCI |
