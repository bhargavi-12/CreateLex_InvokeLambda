data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "index.js"
  output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "hotel_fullfilment_lambda" {
  filename         = "lambda_function.zip"
  function_name    = "BookMyHotel"
  role             = aws_iam_role.iam_for_lambda_tf.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs14.x"
  depends_on = [
    aws_iam_role_policy_attachment.policy-attach
  ]
}

resource "aws_iam_policy" "lambda_iam_policy" {
  name        = "iam_Role_policy"
  description = "IAM role policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
          "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "policy-attach" {
  role       = aws_iam_role.iam_for_lambda_tf.name
  policy_arn = aws_iam_policy.lambda_iam_policy.arn
}

resource "aws_iam_role" "iam_for_lambda_tf" {
  name = "iam_For_lambda"
  permissions_boundary = "arn:aws:iam::235***828061:policy/eo_role_boundary"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    },
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lex.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_permission" "lex_sample_intent_lambda" {
  statement_id  = "AllowExecutionFromAmazonLex"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hotel_fullfilment_lambda.arn
  principal     = "lex.amazonaws.com"
  depends_on = [
    aws_lambda_function.hotel_fullfilment_lambda
  ]
}



