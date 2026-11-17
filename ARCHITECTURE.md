# ARCHITECTURE

## Overview

This repository is a working prototype for an investigative research assistant. The current implementation is intentionally lightweight: a Streamlit front end coordinates user questions, delegates intent routing to Amazon Bedrock, calls AWS Lambda functions for data retrieval, and assembles findings into an investigative report.

This document captures the current-state architecture for the repo as it exists today and the near-term target-state architecture for a pilot deployment. It is structured as an internal engineering handoff and is intended for a junior engineer taking ownership of the effort.

## Current state (POC)

The current application is designed to run as a single EC2-hosted Streamlit service in AWS commercial us-east-2. The EC2 instance hosts the front end and connects to AWS APIs using the instance identity and role-based permissions available in the environment.

The Streamlit UI accepts investigator questions and routes them through the following flow:

1. User submits a natural-language question in the Streamlit interface.
2. The app calls Bedrock to classify the request and determine the most relevant data source.
3. The app invokes one of the configured AWS Lambda functions over the AWS SDK.
4. The selected Lambda function returns structured results, including answer text, SQL, and/or findings.
5. The app optionally asks Bedrock to translate SQL into plain-English query logic and to synthesize a final markdown report.
6. The report is assembled from saved findings and is downloadable as a Word document.

### Current repository responsibilities

- `app.py`: primary Streamlit application and investigative workflow
- `app_utils.py`: shared helpers for AWS config and Lambda invocation logic
- `requirements.txt`: runtime dependencies
- `requirements-dev.txt`: test and security tooling
- `docs/`: architecture, operations, deployment, and supporting diagrams

## Future-state / pilot architecture

The near-term target is a more resilient pilot deployment:

- EC2 hosts the Streamlit service in a VPC-based network boundary.
- Application Load Balancer (ALB) or Network Load Balancer (NLB) terminates TLS and forwards traffic to the EC2 host.
- Private subnets host the application tier and AWS-managed service connectivity.
- Public subnets are reserved for ingress only when needed per security model.
- Lambda functions are retained for targeted retrieval and orchestration.
- Bedrock remains the model layer for intent classification, explanation, and report synthesis.
- CloudWatch provides operational telemetry, logs, and alerts.
- IAM roles replace static credentials where possible.

## AWS service view

The relevant AWS components in the current repo flow are:

- Amazon EC2: application host for the Streamlit service
- AWS Lambda: data retrieval and domain-specific processing handler
- Amazon Bedrock: intent routing, explanation generation, and report synthesis
- Amazon CloudWatch: logs and operational observability
- AWS IAM: permissions and least-privilege access model
- Amazon S3: optional artifact storage or document staging (if used in a later pilot)
- VPC / private subnets: network isolation for the app and backend access

## Data flow

Data flows through the application in the following sequence:

1. User traffic enters the environment via the public or restricted access layer.
2. The request reaches the Streamlit service on the EC2 host.
3. The service calls Bedrock over HTTPS on port 443 to classify the request and generate explanations or report content.
4. The service calls AWS Lambda over the AWS API endpoint on port 443 using the execution role attached to the EC2 instance.
5. The Lambda function returns structured data to the application.
6. The application serializes result sets and assembles a narrative report for the analyst.

### Transport and protocol summary

- Ingress to EC2 or ALB: HTTPS (TCP 443), optionally HTTP to ALB with TLS termination
- Internal app streaming: local HTTP on EC2 port 8501 for the Streamlit server
- AWS service calls: HTTPS (TCP 443) via boto3 and AWS SDKs
- Lambda invocation: AWS API over HTTPS
- Bedrock model calls: AWS API over HTTPS
- Logs and metrics: CloudWatch APIs over HTTPS

## Network model

This is expected to be deployed in a standard VPC layout in us-east-2:

- Public subnet: optional ingress, NAT, or management access
- Private subnet: EC2 application host and internal services
- Security groups: restrict inbound access to required ports only
- Internet-facing ALB or restricted public load balancer: allowable only under a least-access design
- Private VPN / private networking: preferred option for production governance and reduced exposure

In the current prototype, the immediate goal is to keep the application understandable and secure without overengineering the network. The future pilot should explicitly choose between:

- private-only access via VPN or private network path, or
- restricted public access through a controlled load balancer with guardrails.

## Security posture and operational assumptions

This repo is a prototype and should be treated as a POC until formal security review is completed. Current controls should include:

- no hardcoded AWS credentials in committed source files
- use of IAM roles and EC2 instance profiles wherever possible
- no secrets in `.env` committed to the repo; `.env.example` is a template only
- least-privilege AWS policy design for EC2 and Lambda roles
- CloudWatch logging for failures, model calls, and access events
- regular dependency and security scanning

## Current-state diagram

![Current-state AWS architecture](./investigaite-architecture.svg)

## Near-term pilot target

The target architecture should evolve toward a more controlled deployment model:

- EC2 behind ALB/NLB with private networking preferred
- dedicated IAM roles for app and Lambda execution
- restricted ingress rules and explicit security groups
- CloudWatch dashboards and alert thresholds for service health
- structured deployment pipeline and configuration management

This gives the team a clear path from prototype to pilot without prematurely locking in an overbuilt production control plane.

## Ownership and next steps

The repository is now structured so a junior engineer can understand the system and continue from a documented baseline. The immediate next steps are:

1. Validate the live AWS resources against the documented architecture.
2. Convert manual infrastructure into Terraform.
3. Add environment-specific deployment configuration for EC2 and service discovery.
4. Expand test coverage and CI validation.
5. Harden IAM and network restrictions before expansion beyond the pilot.
