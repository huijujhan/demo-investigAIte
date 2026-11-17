import json
import os
from typing import Iterable, Optional

import boto3

AWS_REGION = os.getenv("AWS_REGION", "us-east-2")
ARCOS_LAMBDA_NAME = os.getenv("ARCOS_LAMBDA_NAME", "arcos-nl-sql-handler")
DEA6_LAMBDA_NAME = os.getenv("DEA6_LAMBDA_NAME", "dea6-bedrock-kb-handler")
INTENT_MODEL_ID = os.getenv("INTENT_MODEL_ID", "us.anthropic.claude-sonnet-4-6")
EXPLAIN_MODEL_ID = os.getenv("EXPLAIN_MODEL_ID", INTENT_MODEL_ID)
REPORT_MODEL_ID = os.getenv("REPORT_MODEL_ID", INTENT_MODEL_ID)


def build_history_payload(messages: Iterable[dict], n: int = 6) -> list:
    """Return the last n messages trimmed so the first message is always a user turn."""
    history = [
        {"role": message["role"], "content": message["content"]}
        for message in list(messages)[-n:]
        if message.get("role") in ("user", "assistant")
    ]
    while history and history[0]["role"] != "user":
        history.pop(0)
    return history


def invoke_lambda(function_name: str, payload: dict, region_name: Optional[str] = None) -> dict:
    """Invoke an AWS Lambda and return a JSON payload."""
    client = boto3.client("lambda", region_name=region_name or AWS_REGION)
    response = client.invoke(
        FunctionName=function_name,
        InvocationType="RequestResponse",
        Payload=json.dumps(payload).encode(),
    )
    body = response["Payload"].read()
    if not body:
        return {}
    return json.loads(body)
