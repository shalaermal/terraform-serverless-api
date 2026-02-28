resource "aws_dynamodb_table" "tasks" {
  name         = "tasks-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-basic-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

#Attach logging policy
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#Lambda Function
resource "aws_lambda_function" "basic_lambda" {
  function_name = "basic-terraform-lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.9"

  filename         = "lambda/function.zip"
  source_code_hash = filebase64sha256("lambda/function.zip")
}

resource "aws_iam_role_policy" "lambda_dynamodb_policy" {
  name = "lambda-dynamodb-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "dynamodb:PutItem"
      ]
      Resource = aws_dynamodb_table.tasks.arn
    }]
  })
}

#HTTP API
resource "aws_apigatewayv2_api" "http_api" {
  name          = "terraform-serverless-api"
  protocol_type = "HTTP"
}

#Integration with Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"

  integration_uri        = aws_lambda_function.basic_lambda.invoke_arn
  payload_format_version = "2.0"
}

#route
resource "aws_apigatewayv2_route" "post_task" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /task"

  target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}
#Stage auto deploy
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

#Lambda permission API Gateway
resource "aws_lambda_permission" "api_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.basic_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

#Output URL
output "api_url" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}

