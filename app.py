#!/usr/bin/env python3
import os

import aws_cdk as cdk

from ecs_webpage.ecs_webpage_stack import EcsWebpageStack
from ecs_webpage.ecs_stack import EcStack


app = cdk.App()
# the stack for ECS cluster and VPC. 


# primary stack
EcsWebpageStack(app, "EcsWebpageStack")

EcStack(app, "EcsStack")

#EcStack.add_dependency(EcsWebpageStack)

app.synth()
