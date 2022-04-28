resource "aws_iam_role" "iam_role" {
  name               = var.role_name
  assume_role_policy = var.assume_role_policy
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "iam_policy_attachement" {
  count      = length(var.policies)
  policy_arn = var.policies[count.index]
  role       = aws_iam_role.iam_role.id
}