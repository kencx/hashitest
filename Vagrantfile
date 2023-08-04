# -*- mode: ruby -*-
# vi: set ft=ruby :
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'

Vagrant.configure("2") do |config|
  config.vm.box = "debian/bullseye64"
  config.vm.hostname = "hashitest"

  config.vm.provider "libvirt" do |libvirt|
    libvirt.cpus = 2
    libvirt.memory = 1024
  end

  config.nfs.verify_installed = false
  config.vm.synced_folder '.', '/vagrant', disabled: true

  config.vm.network "private_network", ip: "10.0.0.2"
  ansible_tags = ["untagged"]

  # common
  common_reset_nomad = true

  vault_install = true
  consul_install = true
  nomad_install = true

  if vault_install
    config.vm.network "forwarded_port", guest: 8200, host:8200

    vault_tls = ["true", "1"].include?((ENV['VAULT_TLS'] || false).to_s.downcase)
    vault_root_token = ENV["VAULT_ROOT_TOKEN"] || "root"
    vault_terraform_reset = true

    if !consul_install
      vault_consul_register = false
    end

    ansible_tags.concat(["vault"])
  end

  if consul_install
    config.vm.network "forwarded_port", guest: 8500, host:8500

    consul_tls = ["true", "1"].include?((ENV['CONSUL_TLS'] || false).to_s.downcase)
    if consul_tls
      config.vm.network "forwarded_port", guest: 8501, host:8501
    end

    ansible_tags.concat(["consul"])
  end

  if nomad_install
    config.vm.network "forwarded_port", guest: 4646, host:4646
    config.vm.network "forwarded_port", guest: 5432, host:5432
    nomad_vault_integration = true

    if !vault_install
      nomad_vault_integration = false
    end

    ansible_tags.concat(["nomad"])
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/main.yml"
    ansible.galaxy_role_file = "ansible/requirements.yml"
    ansible.config_file = "ansible/ansible.cfg"

    ansible.extra_vars = {
      # common
      common_reset_nomad: common_reset_nomad,

      # vault
      vault_tls: vault_tls,
      vault_root_token: vault_root_token,
      vault_terraform_reset: vault_terraform_reset,

      # consul
      consul_tls: consul_tls,

      # nomad
      setup_vault_integration: nomad_vault_integration,
    }

    ansible.tags = ansible_tags
  end
end
