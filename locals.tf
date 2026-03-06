locals  {
    common_tags ={
        project = var.project
        environment = var.environment
        terraform = "true"
    }

    ec2_vpc_tags = merge (
        local.common_tags,
        {name = "${var.project}-${var.environmet} "
             },
    var.vpc_tags
    )
        
}