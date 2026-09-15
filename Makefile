# 除外リスト
EXCLUSIONS := .DS_Store .git .gitmodules .gitignore
# 対象リスト
CANDIDATES := $(wildcard .??*) bin
# 対象リストから除外リストを除外したリスト
DOTFILES := $(filter-out $(EXCLUSIONS), $(CANDIDATES))
# サブディレクトリ配下にあり、個別に $HOME へ配置するドットファイル
# 形式: "リポジトリ内の相対パス:$HOME からの相対パス" ($HOME 配下の別ディレクトリに置く場合も対応)
NESTED_DOTFILES := git/.gitconfig:.gitconfig git/.gitignore_global:.gitignore_global tmux/.tmux.conf:.tmux.conf zsh/.zprofile:.zprofile zsh/.zshenv:.zshenv zsh/.zshrc:.zshrc claude/CLAUDE.md:.claude/CLAUDE.md
# ドットファイルディレクトリ
DOTPATH := $(PWD)
# ホームディレクトリ := $(変数名:置換する文字列=置換後)
HOME_DIR := $(DOTPATH:/.dotfiles=)

######################################################################
# 関数
######################################################################
.DEFAULT_GOAL := help

all:

deploy: ## Create symlink to home directory
	@echo '==> Start to deploy dotfiles to home directory.'
	@echo ''
	@$(foreach val, $(DOTFILES), ln -sfnv $(DOTPATH)/$(val) $(HOME)/$(val);)
	@$(foreach pair, $(NESTED_DOTFILES), \
		mkdir -p $(dir $(HOME)/$(word 2, $(subst :, ,$(pair)))); \
		ln -sfnv $(DOTPATH)/$(word 1, $(subst :, ,$(pair))) $(HOME)/$(word 2, $(subst :, ,$(pair)));)

list: ## Show dot files in this repo
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)

init: ## Setup environment settings
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/etc/init/init.sh

install: update deploy init ## Run make update, deploy, init
	@exec $$SHELL

update: ## Fetch changes for this repo
	git pull origin master
	git submodule init
	git submodule update
	git submodule foreach git pull origin master

clean: ## Remove the dot files and this repo
	@echo 'Remove dot files in your home directory.'
	@-$(foreach val, $(DOTFILES), rm -vrf $(HOME)/$(val);)
	@-$(foreach pair, $(NESTED_DOTFILES), rm -vf $(HOME)/$(word 2, $(subst :, ,$(pair)));)
	-rm -rf $(DOTPATH)

help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
