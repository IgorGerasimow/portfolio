include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/compute/lambda/aws-health-events?ref=v0.1.101-lambda-aha"
}

# payload is encrypted using KMS alias/vault-kms-prod

inputs = {
    encrypted_password = "AQICAHhB3ALNLeZo91htOFIfIg6ls4VzgNq0Sx75zFNU9X2FlgFwhPkZV0Y/YH5Y5iBKQ47FAAAAsTCBrgYJKoZIhvcNAQcGoIGgMIGdAgEAMIGXBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDAZS3cYxfHMTkPfAWAIBEIBquyXOpZQuFKIFlJLkc7SzzBVkufD+PrcDGvkoua3Y3+jiX7nMx9AHp3F+H6N3jRfOYdDWNvqSeqHy/y1N6aL/zHCvQmiRA3ZUTtWSqcc1A2lP9uLExYJcLhr4spdEPkO6Mpsgg6i6BKJLIA=="
}
