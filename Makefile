all: generate_ssh_keys
	vagrant up	

generate_ssh_keys:
	mkdir -p .ssh && test -f .ssh/id_rsa ||  ssh-keygen -f ./.ssh/id_rsa

ensure_deps:
	vagrant plugin install vagrant-vbguest
	vagrant plugin install vagrant-reload
