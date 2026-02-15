# Security Module

## Overview

This module defines all security groups and traffic rules for the resources.

## 1. Shared internal Security Group

The module creates a shared security group:

`${var.name}-sg-internal`

Purpose:
- Acts as a common communication layer for cluster instances
- Used for internal traffic (Consul, SSH between services)
- Allows outbound traffic to anywhere (0.0.0.0/0)

Outbound rule:
- All protocols
- Destination 0.0.0.0/0

## 2. Consul inbound

Inbound rules are attached to the internal security group.

These rules allow internal cluster communication using security group references.

Allowed ports:
- 8300 TCP - Consul RPC
- 8301 TCP - Gossip (LAN)
- 8301 UDP - Gossip (LAN)
- 8600 TCP - Consul DNS
- 8600 UDP - Consul DNS

Source: `${var.name}-sg-internal`

It ensures only cluster members can communicate with Consul.

## 3. Jenkins UI

It exposes Jenkins UI publicly.

Security rule:

- Port 8080 TCP
- Source - 0.0.0.0/0
- Target - `${var.name}-sg-jenkins`

## 4. SSH Rules

It allows Jenkins to SSH into internal instances. Preferred access method - AWS SSM.

SSH configuration:

- Port 22 TCP
- Source - `${var.name}-sg-jenkins`
- Target - `${var.name}-sg-internal`

## 5. Role Security Groups

The module creates separate security groups per role:

- `${var.name}-sg-lb`
- `${var.name}-sg-app`
- `${var.name}-sg-db`
- `${var.name}-sg-consul`
- `${var.name}-sg-jenkins`

Each group is created inside the provided VPC.

## 6. LB public ingress

Inbound rules for the Load Balancer:

- Port 80 (HTTP) from 0.0.0.0/0
- Port 443 (HTTPS) from 0.0.0.0/0

Only Load Balancer is publicly exposed.

## 7. App ingress from LB

Traffic allowed from Load Balancer to Application instances.

- Port - `var.app_port`
- Source - `${var.name}-sg-lb`
- Target - `${var.name}-sg-app`

Application instances are not publicly accessible.

## 8. DB ingress from App

Traffic allowed from PostreSQL to Application instances

- Port - 5432
- Source - `${var.name}-sg-app`
- Target - `${var.name}-sg-db`

No public access to the database.

## 9. Consul UI (Commented)

There is a commented configuration for:

- Port 8501 (Consul UI/API)
- Controlled via:
  `enable_consul_ui`
  `consul_ui_cidr_allowlist`

This rule is currently disabled.

## Summary

- Public exposure limited to Load Balancer (80/443)
- Application and Database are private
- Consul internal traffic restricted via SG references
- Jenkins UI currently public
- SSH allowed only from Jenkins SG
- Outbound traffic allowed for all internal instances

