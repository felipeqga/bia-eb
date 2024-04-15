versao=$(git rev-parse HEAD | cut -c 1-7)
aws ecr get-login-password --region us-east-1 --profile bia | docker login --username AWS --password-stdin [SEU_REPOSITORIO]
