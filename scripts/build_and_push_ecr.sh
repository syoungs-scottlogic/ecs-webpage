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

AWS_ACCOUNT=$(get_sso_Profile "$PROFILE")
AWS_REGION=$(get_aws_region "$PROFILE")

function build_image {
    cd "$ROOT_DIR/web-server" 
    # Check if docker is running. If not, exit script. If so, build image.
    docker ps > /dev/null 2>&1 || highlight "red" "Docker is not running. Please start Docker before running" exit 1
    docker build -t "$AWS_ACCOUNT".dkr.ecr."$AWS_REGION".amazonaws.com/$IMAGE_NAME:$IMAGE_TAG .

    push_to_aws
}

function confirm_push {
    echo
    echo "Pushing the following:"
    echo -n "Image: "
    highlight "green" "$IMAGE_NAME:$IMAGE_TAG"
    echo -n "ECR Registry "
    highlight "purple" "$AWS_ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME"
    echo
    yes_no_prompt
}

    # Log in before confirming if you want to push
function push_to_aws {
    if aws ecr get-login-password --profile "$PROFILE" --region "$AWS_REGION" | docker login --username AWS --password-stdin "$AWS_ACCOUNT".dkr.ecr."$AWS_REGION".amazonaws.com ; then
        confirm_push
        docker push "$AWS_ACCOUNT".dkr.ecr."$AWS_REGION".amazonaws.com/"$IMAGE_NAME":"$IMAGE_TAG"
    else
        highlight "red" "ECR login failed."
        exit 1
    fi
}

build_image
