from aws_cdk import (
    Stack,
    aws_ec2 as ec2,
    aws_ecs as ecs
)
from constructs import Construct

class EcStack(Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)
        
        ecs_vpc = ec2.Vpc(
            self,
            "WebServerVPC",
            vpc_name="ECS_VPC",
            ip_addresses=ec2.IpAddresses.cidr("10.0.0.0/8"),
            max_azs=1            
            )
        
        cluster = ecs.Cluster(
            self,
            cluster_name="web-server-cluster",
            vpc=ecs_vpc
            )
        # add task role
        task_definition = ecs.Ec2TaskDefinition(
            self,
            "task-def",
            task_role=task_role,
        )
        #add container https://docs.aws.amazon.com/cdk/api/v2/python/aws_cdk.aws_ecs/Ec2TaskDefinition.html