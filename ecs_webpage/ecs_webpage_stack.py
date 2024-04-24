from aws_cdk import (
    # Duration,
    aws_ecr as ecr,
    Stack,
    # aws_sqs as sqs,
)
from constructs import Construct

class EcsWebpageStack(Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

    ecr.Repository(self,
                   repository_name="web-server-repo",
                   image_tag_mutability=ecr.TagMutability.IMMUTABLE,
                   auto_delete_images=True,
                   removal_policy=RemovalPolicy.Destroy,
                   empty_on_delete=True
                   )
