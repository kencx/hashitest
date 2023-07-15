# -*- mode: ruby -*-
# vi: set ft=ruby :
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'

Vagrant.configure("2") do |config|
  config.vm.box = "debian/bullseye64"
  config.vm.hostname = "hashitest"

  config.nfs.verify_installed = false
  config.vm.synced_folder '.', '/vagrant', disabled: true

  config.vm.network "forwarded_port", guest: 4646, host:4646
  config.vm.network "forwarded_port", guest: 8200, host:8200
  config.vm.network "private_network", ip: "10.0.0.2"

  vault_tls = ["true", "1"].include?((ENV['VAULT_TLS'] || false).to_s.downcase)
  vault_root_token = ENV["VAULT_ROOT_TOKEN"] || "root"

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/main.yml"
    ansible.galaxy_role_file = "ansible/requirements.yml"
    ansible.config_file = "ansible/ansible.cfg"
    ansible.extra_vars = {
      vault_tls: vault_tls,
      vault_root_token: vault_root_token,
    }
  end
end
