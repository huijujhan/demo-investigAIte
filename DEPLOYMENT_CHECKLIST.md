# DEPLOYMENT CHECKLIST

## Purpose

This checklist is intended to support a clean handoff from the current prototype developer to a new engineer or team. It focuses on the minimum required steps to validate the application in AWS and prepare the deployment for a pilot environment.

## Pre-deployment review

- [ ] Confirm the target AWS region is us-east-2.
- [ ] Verify the VPC layout matches the intended production or pilot design.
- [ ] Confirm the EC2 instance is the application host.
- [ ] Confirm the application runs on a supported Python version.
- [ ] Confirm the IAM role attached to the EC2 instance has least-privilege access.
- [ ] Confirm Bedrock model access works in the target region.
- [ ] Confirm the Lambda function names and region values are correct.
- [ ] Confirm the repo is not containing any secrets or `.env` files.
- [ ] Confirm the app is using secure configuration and not static credentials unless explicitly required for local troubleshooting.

## Infrastructure validation

- [ ] Validate the EC2 instance has the correct AMI, security group, and network placement.
- [ ] Confirm the VPC has the necessary public and private subnets.
- [ ] Confirm the load balancer or ingress model is consistent with the deployment pattern.
- [ ] Confirm security group rules permit only required inbound traffic.
- [ ] Confirm outbound access to AWS APIs is allowed on HTTPS (TCP 443).
- [ ] Confirm CloudWatch logging is enabled.

## Application validation

- [ ] Create a Python virtual environment.
- [ ] Install runtime dependencies.
- [ ] Install development dependencies for validation.
- [ ] Create a local `.env` file from `.env.example` for troubleshooting.
- [ ] Validate that the app starts without error.
- [ ] Verify the app loads in the browser or via the host endpoint.
- [ ] Validate a question triggers the appropriate Bedrock intent routing.
- [ ] Validate Lambda invocation works and returns the expected output.
- [ ] Validate the export/report-generation flow works.

## Security checks

- [ ] Confirm no secrets are committed to source control.
- [ ] Confirm IAM policy scope is least-privilege and purpose-bound.
- [ ] Confirm `.env` is excluded by version control.
- [ ] Confirm only required ports are open.
- [ ] Confirm public exposure is either disabled or tightly restricted.
- [ ] Confirm logs do not capture sensitive secrets in plaintext.

## Handoff checklist

- [ ] README includes purpose, setup, and architecture context.
- [ ] Architecture document captures both current-state and pilot-state design.
- [ ] Runbook describes startup, troubleshooting, and escalation points.
- [ ] Deployment checklist is stored in the repo and shared with the next owner.
- [ ] Requirements and dev tooling are documented for the next engineer.
- [ ] AWS resource names and environment variables are captured for the target deployment.
- [ ] The project is documented as a prototype / pilot with an upgrade path.

## Exit criteria

The application is ready for a controlled pilot when:

- the EC2 host is running cleanly,
- the AWS integrations are validated,
- the environment is configured through IAM-based access instead of static secrets where possible,
- the architecture and operations docs are complete,
- and a junior engineer can start the app and diagnose basic failures without support from the original author.
