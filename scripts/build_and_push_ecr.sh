#! /usr/bin/bash

# Get script directory.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT_DIR="$SCRIPT_DIR/.."

source $SCRIPT_DIR/utils.sh

function help {
    echo
    echo "Build the nginx docker image and push to the ECR repository in the respective account."
    echo "Syntax: $0 [p | h | t | n]"
    echo "Options:"
    echo "  -h  Display this help."
    echo "  -p  The AWS profile to use."
    echo "  -t  The docker tag to use."
    echo "  -n  The docker image name to use. Default: web-server-repo"
    echo

    exit 0
}

while getopts "hp:t:n:" opts; do
    case "$opts" in
        h)
        help
        ;;
        p)
        PROFILE="$OPTARG"
        echo -n "Using profile: "
        highlight "cyan" "$PROFILE"
        ;;
        t)
        IMAGE_TAG="$OPTARG"
        echo -n "Using image tag: "
        highlight "cyan" "$IMAGE_TAG"
        ;;
        n)
        IMAGE_NAME="$OPTARG"
        echo -n "Using docker image name : "
        highlight "cyan" "$IMAGE_NAME"
        ;;
        *)
        echo "Invalid option flag found. See $0 -h for usage."
        exit 0
        ;;
    esac
done

if [[ -z $PROFILE ]]; then
    read -p "Enter a profile to use: " PROFILE
    echo -n "Using profile: "
    highlight "cyan" "$PROFILE"
fi

if [[ -z $IMAGE_NAME ]]; then
    IMAGE_NAME="web-server-repo"
    echo -n "Using docker image name : "
    highlight "cyan" "$IMAGE_NAME"
fi

if [[ -z $IMAGE_TAG ]]; then
    read -p "Enter a tag to use. Eg 1.1: " IMAGE_TAG
    echo -n "Using image tag: "
    highlight "cyan" "$IMAGE_TAG"
fi


function build_image {
    cd "$ROOT_DIR/web-server" 
    docker build -t web-server-repo .
    # docker build -t <acc>.dkr.ecr.eu-west-2.amazonaws.com/$IMAGE_NAME:$IMAGE_TAG .
}

function push_to_aws {
    aws ecr get-login-password --profile $PROFILE --region eu-west-2 | docker login --username AWS --password-stdin <acc>.dkr.ecr.eu-west-2.amazonaws.com

    #docker push <acc>.dkr.ecr.eu-west-2.amazonaws.com/web-server-repo:<tag>
}

function verify_aws_sso {
    # verify aws sts and get account.
    #aws sts get-caller-identity
}

echo "$ROOT_DIR"

# ECR build commands

# aws ecr get-login-password --profile $PROFILE --region eu-west-2 | docker login --username AWS --password-stdin <acc>.dkr.ecr.eu-west-2.amazonaws.com

# docker build -t web-server-repo .

# docker tag web-server-repo:latest <acc>.dkr.ecr.eu-west-2.amazonaws.com/web-server-repo:<version>

# docker push <acc>.dkr.ecr.eu-west-2.amazonaws.com/web-server-repo:<tag>

# add check showing full image name with are you sure you want to push? y/n

# Get region with aws configure get region --profile