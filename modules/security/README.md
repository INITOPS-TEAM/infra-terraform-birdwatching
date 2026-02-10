# Security module

## Purpose
Defines network security boundaries between project components:
- Load balancer
- Application instances
- Database
- Consul server

Security groups are configured to follow a principle of least privilege.

## Resources
- aws_security_group
- aws_vpc_security_group_ingress_rule
- aws_vpc_security_group_egress_rule

## Inputs
- name - project/environment name prefix
- vpc_id -VPC ID
- app_port - application port
- enable_ssh - enables SSH access to instances (intended for temporary lab/provisioning use)
- ssh_cidr_allowlist - CIDR allowlist for ssh access (currently may be 0.0.0.0/0 for lab convenience; planned to be restricted to a Jenkins host IP)
- enable_consul_ui - whether to expose Consul UI (8500)
- consul_ui_cidr_allowlist - CIDR allowlist for Consul UI


## Outputs
- sg_lb_id
- sg_app_id
- sg_db_id
- sg_consul_id

## Security model
- LB: public HTTP/HTTPS
- App: accepts traffic only from LB
- DB: accepts traffic only from App
- Consul: internal access only, UI via allowlist

## Notes
- SSH access is temporarily allowed for all instances to support Ansible-based provisioning.
- This will be restricted to a single Jenkins host IP once provisioning is finalized.
- AWS SSM is planned as the primary access method.
