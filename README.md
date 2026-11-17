# InvestigAIte

InvestigAIte is a Streamlit-based investigative research assistant built to support investigators who spend significant time gathering, cleaning, and analyzing information before scheduled investigations or other enforcement work.

The problem is substantial: investigators often spend many manual hours researching data across multiple systems, downloading reports, submitting standard data requests, reconciling information from different sources, and compiling findings into a usable case picture. This work is time-consuming and repetitive, and it takes investigators away from higher-value enforcement and strategic investigative tasks.

InvestigAIte is intended to reduce that manual effort by helping investigators quickly access relevant data and summaries through a conversational interface. The app routes questions to the most relevant source:

- transactional data for patterns, trends, and activity analysis
- investigative reports for prior case history, findings, and related context
- manuals and reference materials for regulatory and procedural guidance

At a high level, the front end gathers a question, classifies the intent using Amazon Bedrock, invokes AWS Lambda handlers for the selected data source, and composes a readable investigative summary for the user.

## What this project does

This project is built for investigative analysis workflows. It is meant to help answer questions such as:

- Which regions or entities show unusual transactional patterns?
- What historical investigative records exist for a specific subject, organization, or location?
- How do transaction trends, past case findings, and procedural guidance connect into a broader investigative narrative?

The UI is intentionally lightweight: a Streamlit app provides the chat workflow, while the analytics and retrieval logic are handled by AWS services and LLM-based routing.

## Current architecture

The repository currently contains the core app in `app.py` and the pinned Python dependencies in `requirements.txt`.

### Front end
- `app.py` contains the Streamlit application
- It sets up the page layout, custom styling, and session state
- It handles question intake, intent routing, and report generation

### AI + data flow
- A user question is classified with a Bedrock model
- The app calls AWS Lambda functions based on the selected source
- transactional queries return activity and trend insights
- report retrieval pulls case-related findings and narrative information
- manual/reference lookups surface procedural and policy context
- The app can summarize SQL logic and generate a final investigative report

### AWS configuration
The app expects AWS credentials and access to Bedrock and Lambda in the configured AWS region. The default setup in `app.py` uses:

- `AWS_REGION` default: `us-east-1`
- `TRANSACTIONAL_LAMBDA_NAME` default: `transactional-nl-sql-handler`
- `REPORTS_LAMBDA_NAME` default: `reports-bedrock-kb-handler`
- `MANUALS_LAMBDA_NAME` default: `manuals-bedrock-kb-handler`

The app also reads model IDs from environment variables, with defaults pointing at Bedrock Anthropic Claude models.

## Local setup

### 1. Clone the repository

```bash
git clone <repo-url>
cd demo-investigAIte
```

### 2. Create a virtual environment

```bash
python3 -m venv .venv
source .venv/bin/activate
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

### 4. Configure environment variables

Create a `.env` file in the project root with the values required by the app, for example:

```env
AWS_REGION=us-east-1
TRANSACTIONAL_LAMBDA_NAME=transactional-nl-sql-handler
REPORTS_LAMBDA_NAME=reports-bedrock-kb-handler
MANUALS_LAMBDA_NAME=manuals-bedrock-kb-handler
INTENT_MODEL_ID=us.anthropic.claude-sonnet-4-6
EXPLAIN_MODEL_ID=us.anthropic.claude-sonnet-4-6
REPORT_MODEL_ID=us.anthropic.claude-sonnet-4-6
AWS_ACCESS_KEY_ID=your_key_here
AWS_SECRET_ACCESS_KEY=your_secret_here
AWS_SESSION_TOKEN=optional_if_using_temporary_credentials
```

If you are using a standard AWS profile, you may also rely on your local AWS CLI configuration instead of hardcoding keys.

### 5. Run the app

```bash
streamlit run app.py
```

Then open the local URL shown by Streamlit in your browser.

## Development conventions

This project is still in active development, so contributors should keep the following points in mind:

- Prefer environment variables for AWS and model configuration rather than hardcoding values into the app
- Keep analytics and Lambda invocation logic centralized and easy to follow
- Treat prompts and routing logic as an important part of the product, since they shape how the model selects the most relevant data source
- Keep the app beginner-friendly: if you add new flows, document the expected inputs and outputs clearly

## Contributing

When contributing:

1. Review the app entry points in `app.py` before making changes
2. Keep new logic modular and readable
3. Update environment variables and local setup notes when adding dependencies or external services
4. Validate the app locally with `streamlit run app.py` before opening a pull request

## Notes

This project depends on AWS access to Lambda and Bedrock, so anyone contributing locally will need the appropriate AWS permissions and a working AWS profile or credentials setup. If the Lambda functions or model IDs differ in your environment, update the `.env` file to match your deployment.

---

This README is intended to help a new contributor understand not just what the app is, but how the current system is wired together and how to get it running locally.
