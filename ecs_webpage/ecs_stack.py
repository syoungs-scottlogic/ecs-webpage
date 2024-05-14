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
            ip_addresses=ec2.IpAddresses.cidr("10.0.0.0/16"),
            max_azs=1            
            )
        
        cluster = ecs.Cluster(
            self,
            "web-server-cluster",
            cluster_name="web-server-cluster",
            vpc=ecs_vpc
            )
        # add task role
        repo_name = self.node.try_get_context("ecr-repo-name")
        image_tag = self.node.try_get_context("nginx-image-tag")
        task_definition = ecs.Ec2TaskDefinition(
            self,
            "task-def",
        )
        
        port_mappings = [ecs.PortMapping(container_port = 443), ecs.PortMapping(container_port = 8080)]
        task_definition.add_container(
            "web-container",
            image=ecs.ContainerImage.from_registry(f"{repo_name}:{image_tag}"),
            memory_limit_mib=256,
            port_mappings=(port_mappings)
        )
        #add container https://docs.aws.amazon.com/cdk/api/v2/python/aws_cdk.aws_ecs/Ec2TaskDefinition.html