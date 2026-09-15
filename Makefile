# 除外リスト
EXCLUSIONS := .DS_Store .git .gitmodules .gitignore
# 対象リスト
CANDIDATES := $(wildcard .??*) bin
# 対象リストから除外リストを除外したリスト
DOTFILES := $(filter-out $(EXCLUSIONS), $(CANDIDATES))
# サブディレクトリ配下にあり、個別に $HOME へ配置するドットファイル (リポジトリからの相対パス)
NESTED_DOTFILES := git/.gitconfig git/.gitignore_global tmux/.tmux.conf zsh/.zprofile zsh/.zshenv zsh/.zshrc
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
	@$(foreach val, $(NESTED_DOTFILES), ln -sfnv $(DOTPATH)/$(val) $(HOME)/$(notdir $(val));)

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
	@-$(foreach val, $(NESTED_DOTFILES), rm -vrf $(HOME)/$(notdir $(val));)
	-rm -rf $(DOTPATH)

help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
