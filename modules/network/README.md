# Network module

## Purpose
Creates base networking resources for the project:
- VPC
- Public subnets across multiple AZs
- Internet Gateway
- Route tables for public subnets

This module is environment-independent and does not create any compute resources.

## Resources
- aws_vpc
- aws_subnet (public)
- aws_internet_gateway
- aws_route_table
- aws_route_table_association

## Inputs
- name - project/environment name prefix
- vpc_cidr - CIDR block for the VPC
- azs - list of availability zones
- public_subnet_cidrs - CIDR blocks for public subnets

## Outputs
- vpc_id
- public_subnet_ids

## Notes
- NAT Gateway is intentionally not created to keep costs low.
- All subnets created by this module are public.
