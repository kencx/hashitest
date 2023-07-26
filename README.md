# hashitest

## Prerequisites

- Vagrant >= v2.3.6
- [Vagrant libvirt plugin](https://github.com/vagrant-libvirt/vagrant-libvirt)
  v0.12.2 (optional)
- Terraform >= v1.5.3
- Ansible >= v2.15.1 (optional - can use `ansible_local` provisioner instead)

## Usage

The Vagrantfile uses the libvirt provider by default.

```
$ vagrant up
```

Start Vault with TLS:

```
$ VAULT_TLS=1 vagrant up
```

## Tests

- [x] Vault Integration in Nomad
- [x] Nomad, Consul integration and Consul Connect
- [x] Vault database secrets engine
- [ ] Nomad TLS configuration (`tls` block)
- [ ] Vault Agent and consul-template
- [ ] Vault Agent's new process supervisor mode
- [ ] Consul signal termination and cluster leaving
- [ ] Vault as Consul Connect CA provider
- [ ] Consul client auto-encrypt
