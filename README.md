# hashitest

## Prerequisites

- Vagrant >= v2.3.6
- [Vagrant libvirt plugin](https://github.com/vagrant-libvirt/vagrant-libvirt)
  (0.12.2) (optional)
- Terraform >= v1.5.3
- Ansible >= 2.15.1 (optional - can use `ansible_local` provisioner instead)

## Usage

The Vagrantfile uses the libvirt provider by default.

```
$ vagrant up
```

## Tests

- [ ] Vault Integration in Nomad
- [ ] Nomad TLS configuration (`tls` block)
- [ ] Vault Agent and consul-template
- [ ] Nomad, Consul integration and Consul Connect
- [ ] Vault Agent's new process supervisor mode
