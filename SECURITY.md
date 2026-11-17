# SECURITY

## Security baseline

This project is currently a prototype and pilot-aligned application. The goal is to establish a secure baseline without overbuilding production controls before the system is mature.

## Core principles

- No secret material should be stored in the repository.
- AWS access should favor IAM roles and instance profiles over static credentials.
- Ingress should be limited to the minimum required network access.
- Lambda and model access should be scoped to the minimum set of actions required.
- Operational logs should be reviewed for sensitive content or error leakage.

## Current controls to maintain

- `.env.example` is a template only; real values must stay out of source control.
- Use EC2 instance profile or IAM role credentials for runtime service access.
- Validate CloudWatch logs for exceptions and permission failures.
- Restrict public access if the app is not meant to be open to the internet.
- Review any uploaded document or user-submitted content for safe handling and retention expectations.

## Recommended hardening before pilot scale-up

- Move from local configuration to a dedicated AWS deployment configuration.
- Add least-privilege IAM policies for EC2 and Lambda execution roles.
- Review security groups and load balancer rules.
- Add centralized logging and alerting for access and failures.
- Add dependency scanning and vulnerability review for Python packages.

## Security validation commands

```bash
python -m pip install -r requirements-dev.txt
bandit -r . -ll
pip-audit
```

These checks are intended as a baseline for ongoing review. They do not replace formal security review when the project expands beyond prototype status.
