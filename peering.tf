resource "aws_vpc_peering_connection" "dev_def" {
  #peer_owner_id = var.peer_owner_id
  count = var.is_peerring_required ? 1 : 0

  #Acceptor(Target)
  peer_vpc_id   = data.aws_vpc.default.id

  #Requestor
  vpc_id        = aws_vpc.roboshop.id
  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
  tags = merge (
                local.common_tags,
            { Name = "${var.project}-${var.environment}-default" }
  )

}