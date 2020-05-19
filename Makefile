all: update-oh-my-zsh update-scm-breeze

update-oh-my-zsh:
	curl -s -L -o /tmp/oh-my-zsh.tar.gz https://github.com/robbyrussell/oh-my-zsh/archive/master.tar.gz
	curl -s -L -o /tmp/zsh-autosuggestions.tar.gz https://github.com/zsh-users/zsh-autosuggestions/archive/master.tar.gz
	curl -s -L -o /tmp/zsh-syntax-highlighting.tar.gz https://github.com/zsh-users/zsh-syntax-highlighting/archive/master.tar.gz
	curl -s -L -o /tmp/powerlevel10k.tar.gz https://github.com/romkatv/powerlevel10k/archive/master.tar.gz
	chezmoi import --strip-components 1 --destination ${HOME}/.oh-my-zsh /tmp/oh-my-zsh.tar.gz
	chezmoi import --strip-components 1 --destination ${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions /tmp/zsh-autosuggestions.tar.gz
	chezmoi import --strip-components 1 --destination ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting /tmp/zsh-syntax-highlighting.tar.gz
	chezmoi import --strip-components 1 --destination ${HOME}/.oh-my-zsh/custom/themes/powerlevel10k /tmp/powerlevel10k.tar.gz

update-scm-breeze:
	curl -s -L -o /tmp/scm_breeze.tar.gz https://github.com/scmbreeze/scm_breeze/archive/master.tar.gz
	chezmoi import --strip-components 1 --destination ${HOME}/.scm_breeze /tmp/scm_breeze.tar.gz
