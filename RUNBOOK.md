# RUNBOOK

## Purpose

This runbook is intended as a lightweight operational guide for a junior engineer taking over the InvestigAIte prototype. The system is currently a POC, so the emphasis is on safe startup, troubleshooting, and understanding the current AWS components rather than formal SRE-scale operations.

## System summary

The application is a Streamlit app running on an EC2 instance in AWS us-east-2. It uses AWS Lambda for request routing and data retrieval, and Amazon Bedrock for model orchestration. The app relies on AWS SDK credentials available to the EC2 host via IAM role or environment configuration.

## Service ownership and responsibilities

- Application owner: project maintainer / product lead
- Engineering owner: current developer or next assigned engineer
- AWS operations: validate the underlying resources manually created in the account
- Security review: confirm IAM least privilege, network controls, and secret handling before broader rollout

## Expected runtime topology

- Application host: EC2 instance
- Front end: Streamlit on port 8501 inside the EC2 environment
- Front-end access: private network or restricted public access model
- Backend: AWS Lambda functions for retrieval workflows
- Model layer: Amazon Bedrock
- Observability: CloudWatch logs and metrics

## Quick startup

1. Log in to the EC2 instance using the approved access mechanism.
2. Change to the application directory.
3. Activate the Python environment.
4. Export or provide the required AWS environment variables.
5. Start the application:

```bash
streamlit run app.py --server.address 0.0.0.0 --server.port 8501
```

6. Confirm the service is listening on the expected port and that the app loads without credential or model-access errors.

## Common operational checks

### Health checks

- Confirm the EC2 instance is running.
- Confirm the Streamlit process is active.
- Confirm the target AWS Lambda functions are accessible.
- Confirm Bedrock model access works.
- Confirm CloudWatch logs show normal startup and runtime behavior.

### Useful validation steps

```bash
ps -ef | grep streamlit
journalctl -u streamlit -n 100
aws lambda list-functions --region us-east-2
aws sts get-caller-identity
```

## Common failure modes

### Missing AWS credentials

Symptoms:

- Lambda invocation fails
- Bedrock calls fail
- boto3 raises credential or authorization errors

Action:

- Validate the EC2 role or instance profile attached to the host.
- Confirm the environment is not relying on static credentials unless intentionally required for a local troubleshooting session.
- Confirm the IAM policy includes the required Lambda and Bedrock permissions.

### Invalid model or environment configuration

Symptoms:

- Bedrock model IDs are invalid or not available in the region
- The app logs Bedrock invocation failures

Action:

- Review the `.env` values or EC2 environment variables.
- Ensure the configured model IDs are valid for us-east-2.
- Confirm the IAM role is allowed to call Bedrock.

### Lambda invocation errors

Symptoms:

- `handle_query()` returns an error message
- AWS Lambda timeouts or permission errors are seen in CloudWatch

Action:

- Check Lambda execution role permissions.
- Validate the target function name and AWS region.
- Review CloudWatch logs for the specific Lambda function.

### UI startup failures

Symptoms:

- app fails to start on the EC2 host
- Streamlit cannot bind to the configured port

Action:

- Validate the port is not in use.
- Confirm the service runs under a permitted user context.
- Check for library installation issues or missing dependencies.

## Logging and observability

The current app is not a full production telemetry stack, but the system should still emit enough signals to be operable:

- EC2 system logs
- Streamlit server logs
- Lambda logs in CloudWatch
- Bedrock invocation failures in CloudWatch and application logs
- Security logs and IAM activity in CloudWatch and AWS CloudTrail

## Security reminders

- Do not store AWS secrets in the repo.
- Use IAM roles attached to EC2 for runtime access.
- Keep `.env` local only and never commit it.
- Restrict inbound access to the minimal required ports.
- Use private networking or a tightly controlled ingress path when operating outside a restricted internal environment.

## Escalation guidance

Escalate to the engineering owner or platform owner when:

- the app cannot start after dependency changes
- AWS role or permission errors persist after configuration review
- Bedrock model access fails unexpectedly
- Lambda integration is broken for more than a short troubleshooting window
- a security or access-control issue is discovered

## Handoff note

This repo should not be treated as a fully hardened production service. It is a prototype and pilot-aligned system that needs documented validation before broader operational use.
