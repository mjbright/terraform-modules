
data "aws_route53_zone" "zone" {
    name         = "${var.domain}."
    private_zone = false
}

resource "aws_route53_record" "my_name" {
   count   = var.num_instances

   zone_id = var.zone_id == "" ?  data.aws_route53_zone.zone.zone_id : var.zone_id

   name    = var.num_instances == 1 ?  "${var.host}.${var.domain}" : "${var.host}${count.index}.${var.domain}"

   type    = "A"
   ttl     = "300"
   records = ["${element(aws_instance.example.*.public_ip, count.index)}"]
}

