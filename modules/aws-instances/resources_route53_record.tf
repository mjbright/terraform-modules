
# NOTE: Resources in this file are created only if
# - number of instances is non-zero

# Create DNS entries in AWS Route53 service
# - for all nodes (in the specified domain)

data "aws_route53_zone" "zone" {
   count   = ( var.domain == "" ? 0 :  var.num_instances )

    name         = "${var.domain}."
    private_zone = false
}

resource "aws_route53_record" "instance_name" {
   count   = ( var.domain == "" ? 0 :  var.num_instances )

   zone_id = var.zone_id == "" ?  data.aws_route53_zone.zone[count.index].zone_id : var.zone_id

   name    = "${local.hostnames[count.index]}.${var.domain}"

   type    = "A"
   ttl     = "300"
   records = ["${element(aws_instance.instances.*.public_ip, count.index)}"]
}

