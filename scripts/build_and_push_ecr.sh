# ECR build commands

# aws ecr get-login-password --profile $PROFILE --region eu-west-2 | docker login --username AWS --password-stdin <acc>.dkr.ecr.eu-west-2.amazonaws.com

# docker build -t web-server-repo .

# docker tag web-server-repo:latest <acc>.dkr.ecr.eu-west-2.amazonaws.com/web-server-repo:<version>

# docker push <acc>.dkr.ecr.eu-west-2.amazonaws.com/web-server-repo:<tag>