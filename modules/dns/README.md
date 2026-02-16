# DNS Module

Route 53 DNS management for the root domain.

## Purpose

- Looks up an existing public hosted zone
- Manages an A record for the root domain
- Points the record to a provided IPv4 address (LB Elastic IP)

## Inputs

- `domain_name` - Public Route 53 hosted zone name
- `ipv4_address` - IPv4 address for the root domain
- `ttl` - TTL for the A record (default 300)

## Notes

- The domain is delegated to Route 53.
- Existing records were imported into Terraform state before apply.
