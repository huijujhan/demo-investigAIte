# InvestigAIte

InvestigAIte is a prototype investigative research assistant designed to reduce repetitive manual research and case-prep work for investigators. The current app is intentionally focused on a lightweight user experience: an analyst asks a question in natural language, the system routes the request to the most relevant data source, and the result is summarized in a report-friendly format.

This project is currently a working POC for a broader pilot effort. The goal is to reduce time spent collecting and reconciling information across multiple systems so investigators can focus on higher-value analytical and enforcement work.

## Project purpose

The system is meant to help investigators answer questions spanning three core categories:

- transactional data for patterns, trends, and activity analysis
- investigative reports for prior case history, findings, and related context
- manuals and reference materials for regulatory and procedural guidance

At a high level, the application workflow is:

1. a user asks a question in the Streamlit UI
2. an Amazon Bedrock model classifies the request and selects the best source
3. AWS Lambda functions retrieve the relevant information
4. the app composes a summary and can build a report from saved findings

## Default stack and runtime

The repository is currently structured for a Python-based EC2 deployment rather than workstation-only execution.

- recommended Python version: 3.13.x
- target deployment model: EC2 in AWS us-east-2
- current repo state: prototype / POC with an upgrade path to pilot-ready architecture

## Current architecture

The repo currently contains:

- `app.py`: Streamlit application and investigative workflow
- `app_utils.py`: reusable AWS helper functions for Lambda invocation and context building
- `requirements.txt`: runtime dependencies
- `requirements-dev.txt`: developer and test tooling
- `ARCHITECTURE.md`: architecture overview and current-vs-future view
- `RUNBOOK.md`: operational guidance for the next engineer
- `DEPLOYMENT_CHECKLIST.md`: pre-deployment and handoff checklist
- `SECURITY.md`: baseline security controls and review guidance

See [ARCHITECTURE.md](ARCHITECTURE.md) for the detailed AWS architecture and diagram. The diagram is available in [docs/investigaite-architecture.svg](docs/investigaite-architecture.svg).

## AWS deployment model

The current repo assumes the app is deployed to an EC2 instance in AWS commercial us-east-2 with a standard VPC layout. The intended traffic flow is:

- user enters the app through a restricted ingress path, private network, or controlled public access model
- the Streamlit service runs on the EC2 host
- the app calls Amazon Bedrock for routing and synthesis
- the app calls AWS Lambda functions for targeted retrieval workflows
- CloudWatch is used for logs and operational monitoring

This is a prototype architecture and is intentionally written as a handoff-ready baseline for a future pilot-scale deployment.

## Infrastructure as code

The repository now includes a starting Terraform baseline in [terraform/README.md](terraform/README.md) for the current EC2 + VPC + IAM + logging pattern. This is intended to support validation of the manually created AWS resources and transition the setup into an infrastructure-as-code workflow.

The Terraform baseline is designed to reflect the current architecture assumptions without hardcoding a final production design. Before production use, validate the live AWS inventory and reconcile those resource names and network ranges with the real environment.

## Local setup

### 1. Clone the repository

```bash
git clone <repo-url>
cd demo-investigAIte
```

### 2. Create a virtual environment

```bash
python3.13 -m venv .venv
source .venv/bin/activate
```

### 3. Install dependencies

```bash
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
python -m pip install -r requirements-dev.txt
```

### 4. Configure environment values

Copy the example env file and adjust for the target environment:

```bash
cp .env.example .env
```

The app expects values such as:

```env
AWS_REGION=us-east-2
ARCOS_LAMBDA_NAME=arcos-nl-sql-handler
DEA6_LAMBDA_NAME=dea6-bedrock-kb-handler
INTENT_MODEL_ID=us.anthropic.claude-sonnet-4-6
EXPLAIN_MODEL_ID=us.anthropic.claude-sonnet-4-6
REPORT_MODEL_ID=us.anthropic.claude-sonnet-4-6
```

Prefer IAM roles and instance profiles for EC2-based deployment. Use static AWS credentials only for local troubleshooting and never commit them to the repo.

### 5. Run the app

For a local development environment:

```bash
streamlit run app.py
```

For EC2 deployment, the intended execution pattern is:

```bash
streamlit run app.py --server.address 0.0.0.0 --server.port 8501
```

## Developer workflow and quality gates

This repository is being structured for a clean handoff and for future pilot development. The project should maintain:

- unit tests for core logic and helper behavior
- a baseline security review for dependencies and code
- clear architecture and operational documentation
- environment-driven configuration rather than hardcoded secrets

## Testing

Unit tests are the starting point for coverage. The project includes a lightweight test suite for helper logic and AWS integration wrappers.

```bash
python -m pytest
```

## Security

Security baseline guidance is captured in [SECURITY.md](SECURITY.md). The expected posture is:

- IAM role and instance profile usage preferred over static access keys
- no secrets checked into version control
- least-privilege AWS permissions
- network restrictions based on pilot or internal deployment needs

## Documentation set

- [ARCHITECTURE.md](ARCHITECTURE.md) — system overview, data flow, current-state vs. pilot-state architecture
- [DATA_SOURCES.md](DATA_SOURCES.md) — expected source types, schemas, and safe data-handling guidance
- [RUNBOOK.md](RUNBOOK.md) — key operations and troubleshooting guidance
- [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) — deployment validation and handoff checklist
- [SECURITY.md](SECURITY.md) — baseline security controls and review checklist

## Contributing

When contributing to this repo:

1. keep the app config externalized through environment variables
2. prefer IAM-based access over static credentials
3. validate tests before proposing a merge
4. update the architecture and runbook when the system changes
5. keep the repo in a prototype-ready state for the next engineer

## Notes

This project is intentionally structured as a functional prototype with a path toward a pilot deployment. The repository should continue to evolve in a way that makes the architecture, security posture, and operational flow understandable to a junior engineer without requiring deep tribal knowledge.
