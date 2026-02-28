Terraform Serverless API (AWS)

A fully serverless REST API built and deployed on AWS using Terraform (Infrastructure as Code).

This project provisions a production-style cloud architecture using:

AWS Lambda (Python 3.9)

Amazon API Gateway (HTTP API v2)

Amazon DynamoDB

IAM roles with least-privilege access

Fully managed via Terraform

Architecture Overview

Client (Browser / HTTP Request)
→ API Gateway (HTTP API)
→ AWS Lambda (Python)
→ DynamoDB (tasks-table)

This architecture is fully serverless:

No EC2

No servers

No manual provisioning

Fully managed infrastructure

🛠 Tech Stack

Terraform

AWS Lambda (Python 3.9)

Amazon API Gateway (HTTP API)

Amazon DynamoDB

AWS IAM

REST API

Infrastructure Provisioning

All AWS resources were created using Terraform.

Commands Used
terraform init
terraform plan
terraform apply
Terraform Apply (Successful Provisioning)

Infrastructure provisioned successfully using Terraform.

API Gateway

HTTP API deployed in eu-central-1 (Frankfurt region).

API Overview

Configured Routes

GET / → Health check endpoint

POST /task → Create new task

Lambda Integration

API Gateway integrated with Lambda using AWS_PROXY integration.

AWS Lambda

Lambda function deployed and configured via Terraform.

Runtime: Python 3.9

Handler: app.lambda_handler

Integrated with API Gateway

IAM permissions configured

Lambda Overview

Successful Lambda Execution

Lambda tested from AWS Console and returned a successful response.

DynamoDB

DynamoDB table: tasks-table

Configuration:

Billing mode: PAY_PER_REQUEST

Partition key: id (String)

Fully managed via Terraform

Stored Items After API Calls

Tasks were successfully created and stored via the API.

Public API Access

The API is publicly accessible via HTTPS endpoint.

Health Check Endpoint (Browser Access)
GET https://<api-id>.execute-api.eu-central-1.amazonaws.com/

Response:

{
  "message": "Serverless API is running"
}

Example API Usage
Create Task
POST /task

Response:

{
  "message": "Task created",
  "id": "generated-uuid"
}

Flow:

API Gateway receives request

Lambda is invoked

Data is stored in DynamoDB

JSON response is returned

IAM & Security

IAM role configured with:

AWSLambdaBasicExecutionRole (CloudWatch logging)

Custom DynamoDB policy allowing:

dynamodb:PutItem

Principle of least privilege applied.

Infrastructure Cleanup

All resources destroyed using:

terraform destroy
Terraform Destroy (Clean Teardown)

Ensures:

No remaining AWS resources

No ongoing cloud costs

Clean infrastructure lifecycle

What This Project Demonstrates

Infrastructure as Code (Terraform)

Serverless architecture design

API Gateway + Lambda integration

DynamoDB data persistence

IAM permission management

Cloud deployment lifecycle (apply → destroy)

Public HTTPS endpoint exposure

Clean resource teardown

How To Deploy

Configure AWS credentials

Run:

terraform init
terraform apply

Use returned api_url

To remove infrastructure:
terraform destroy


Project Status
✔ Infrastructure provisioned successfully
✔ API fully operational
✔ Data persistence working
✔ Infrastructure destroyed cleanly