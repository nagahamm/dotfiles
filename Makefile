# $HOME へ配置するドットファイル
# 形式: "リポジトリ内の相対パス:$HOME からの相対パス" ($HOME 配下の別ディレクトリに置く場合も対応)
NESTED_DOTFILES := git/.gitconfig:.gitconfig git/.gitignore_global:.gitignore_global tmux/.tmux.conf:.tmux.conf zsh/.zprofile:.zprofile zsh/.zshenv:.zshenv zsh/.zshrc:.zshrc claude/CLAUDE.md:.claude/CLAUDE.md .config/nvim:.config/nvim .config/starship.toml:.config/starship.toml
# ドットファイルディレクトリ
DOTPATH := $(PWD)

######################################################################
# 関数
######################################################################
.DEFAULT_GOAL := help

# NESTED_DOTFILES の "リポジトリ内パス:配置先" を分解する
nested_src = $(word 1, $(subst :, ,$(1)))
nested_dest = $(word 2, $(subst :, ,$(1)))

all:

deploy: ## Create symlink to home directory
	@echo '==> Start to deploy dotfiles to home directory.'
	@echo ''
	@$(foreach pair, $(NESTED_DOTFILES), \
		mkdir -p $(dir $(HOME)/$(call nested_dest,$(pair))); \
		ln -sfnv $(DOTPATH)/$(call nested_src,$(pair)) $(HOME)/$(call nested_dest,$(pair));)

list: ## Show dot files in this repo
	@$(foreach pair, $(NESTED_DOTFILES), /bin/ls -dF $(call nested_src,$(pair));)

init: ## Setup environment settings
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/etc/init/init.sh

tools: ## Setup personal tool repositories (smart-renamer, etc.)
	@bash $(DOTPATH)/etc/tools.sh

install: update deploy init tools ## Run make update, deploy, init, tools
	@exec $$SHELL

update: ## Fetch changes for this repo
	git pull origin master
	git submodule init
	git submodule update
	git submodule foreach git pull origin master

clean: ## Remove the dot files and this repo
	@echo 'Remove dot files in your home directory.'
	@-$(foreach pair, $(NESTED_DOTFILES), rm -vf $(HOME)/$(call nested_dest,$(pair));)
	-rm -rf $(DOTPATH)

help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
