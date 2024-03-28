    bucket         = "kasraz-state"
    key            = "stage/services/docker-app/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "state-lock"
    encrypt        = true