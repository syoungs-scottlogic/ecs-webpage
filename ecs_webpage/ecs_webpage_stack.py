from aws_cdk import (
    # Duration,
    aws_ecr as ecr,
    Stack,
    RemovalPolicy
    # aws_sqs as sqs,
)
from constructs import Construct

class EcsWebpageStack(Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)
        
        cluster_name = self.node.try_get_context("ecr-repo-name")

        ecr.Repository(self,
                    "web-server-repository",
                    repository_name=cluster_name,
                    image_tag_mutability=ecr.TagMutability.IMMUTABLE,
                    empty_on_delete=True,
                    removal_policy=RemovalPolicy.DESTROY
                    )
    
    # creat iam role
    
