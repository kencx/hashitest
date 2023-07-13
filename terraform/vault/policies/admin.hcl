## System Backend

# Read system health check
path "sys/health" {
  capabilities = ["read", "sudo"]
}

path "sys/audit" {
  capabilities = ["read", "create", "sudo"]
}

# Manage leases
path "sys/leases/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List secrets engine
path "sys/mounts" {
  capabilities = ["read", "list"]
}

# Manage secrets engine
path "sys/mounts/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

## ACL Policies

# Create, manage ACL policies
path "sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List existing policies
path "sys/policies/acl" {
  capabilities = ["list"]
}

# Deny changing own policy
path "sys/policies/acl/admin" {
  capabilities = ["read"]
}

## Auth Methods

# Manage auth methods
path "auth/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Create, update, delete auth methods
path "sys/auth/*" {
  capabilities = ["create", "update", "delete", "sudo"]
}

# List auth methods
path "sys/auth" {
  capabilities = ["read"]
}

## Identity Entity

path "identity/entity/*" {
  capabilities = ["create", "update", "delete", "read"]
}

path "identity/entity/name" {
  capabilities = ["list"]
}

path "identity/entity/id" {
  capabilities = ["list"]
}

path "identity/entity-alias/*" {
  capabilities = ["create", "update", "delete", "read"]
}

path "identity/entity-alias/id" {
  capabilities = ["list"]
}

## KV Secrets Engine

# manage kv secrets engine
path "kvv2/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

## PKI

path "pki/config/urls" {
  capabilities = ["read"]
}

# List roles
path "pki_int/roles" {
  capabilities = ["list"]
}

# Create, update roles
path "pki_int/roles/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Issue certs
path "pki_int/issue/*" {
  capabilities = ["create", "update"]
}

# List certs
path "pki_int/certs" {
  capabilities = ["list"]
}

# Read certs
path "pki_int/cert/*" {
  capabilities = ["read"]
}

# Revoke certs
path "pki_int/revoke" {
  capabilities = ["create", "update", "read"]
}

# Tidy certs
path "pki_int/tidy" {
  capabilities = ["create", "update", "read"]
}

path "pki_int/tidy-status" {
  capabilities = ["read"]
}
