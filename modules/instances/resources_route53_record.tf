
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

