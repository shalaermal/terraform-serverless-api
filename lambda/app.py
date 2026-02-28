import json
import boto3
import uuid
from datetime import datetime

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("tasks-table")


def lambda_handler(event, context):
    method = event.get("requestContext", {}).get("http", {}).get("method")

    if method == "GET":
        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Serverless API is running"
            })
        }

    if method == "POST":
        task_id = str(uuid.uuid4())

        item = {
            "id": task_id,
            "created_at": datetime.utcnow().isoformat()
        }

        table.put_item(Item=item)

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Task created",
                "id": task_id
            })
        }

    return {
        "statusCode": 400,
        "body": "Unsupported method"
    }
