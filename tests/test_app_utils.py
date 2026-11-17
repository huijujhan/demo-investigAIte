import io
from unittest.mock import MagicMock

from app_utils import build_history_payload, invoke_lambda


def test_build_history_payload_keeps_first_turn_user():
    messages = [
        {"role": "assistant", "content": "initial response"},
        {"role": "user", "content": "first question"},
        {"role": "assistant", "content": "follow up answer"},
        {"role": "user", "content": "second question"},
    ]

    history = build_history_payload(messages, n=6)

    assert history == [
        {"role": "user", "content": "first question"},
        {"role": "assistant", "content": "follow up answer"},
        {"role": "user", "content": "second question"},
    ]


def test_invoke_lambda_decodes_json_response(monkeypatch):
    mock_client = MagicMock()
    mock_client.invoke.return_value = {"Payload": io.BytesIO(b'{"status": "ok"}')}

    monkeypatch.setattr("boto3.client", lambda *args, **kwargs: mock_client)

    result = invoke_lambda("demo-function", {"question": "example"})

    assert result == {"status": "ok"}
    mock_client.invoke.assert_called_once()
