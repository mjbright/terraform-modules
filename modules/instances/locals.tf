
locals {
  num_instances_per_group = var.num_instances / var.num_groups 

  hostnames = [ for index, node in aws_instance.instances.* :
   ( var.num_groups == 1 ?
      ( var.num_instances == 1 ?
        # ONE GROUP: simple
        # HOST:
        "${var.host}" :
        # HOST-{INDEX-IN-GROUP}:
        "${var.host}-${index}"

        # MULTIPLE GROUPS: ...
      ) : ( var.num_instances == 1 ?
        # HOST{GROUP-INDEX}:
        "${var.host}${index}" : 
        # HOST{GROUP-INDEX}-{INDEX-IN-GROUP}:
        "${var.host}${ floor( index / local.num_instances_per_group ) }-${ index % local.num_instances_per_group }"
      )
  ) ]
}

