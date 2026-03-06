locals  {
    common_tags ={
        project = var.project
        environment = var.environment
        terraform = "true"
    }

    ec2_vpc_tags = merge (
                          local.common_tags,
                          { Name = "${var.project}-${var.environment}" },
                           var.vpc_tags
    )
        
    ig_final_tags = merge (
                           local.common_tags,
                          { Name = "${var.project}-${var.environment}" }, 
                          var.ig_tags
                           )

    az_names = slice(data.aws_availability_zones.available.names,0,2)                 

}