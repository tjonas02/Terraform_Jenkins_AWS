terraform {
  backend "s3" {
    bucket = "mys3-bucket-for-tf-state"
    key = "main"
    region = "us-east-1"
    dynamodb_table = "mydynamo-db-table-tf"
  }
}