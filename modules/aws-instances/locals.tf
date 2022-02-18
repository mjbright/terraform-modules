
locals {

  # Create local.zip_files which has at least 4 entries:
  # - to get around non-dynamic nature of "file" provisioner
  zip_files = concat( var.zip_files, [ "", "", "", "" ])

  # Calculate the number of instances per group:
  # - but set to 1 if num_groups is 0 to prevent division-by-zero
  num_instances_per_group = ( var.num_groups == 0 ? 1 : var.num_instances / var.num_groups )

  # Build up list of hostnames to use for /etc/hosts and ssh_config file:
  # - adapt to number of groups, number of instances per group
  hostnames = [ for index in range(var.num_instances) :
   ( var.num_groups == 1 ?
      ( var.num_instances == 1 ?
        # ONE GROUP: simple
        # HOST:
        "${var.host}" :
        # HOST-{INDEX-IN-GROUP}:
        "${var.host}-${index + 1}"

        # MULTIPLE GROUPS: ...
      ) : (
        var.num_instances == 1 ?
          # HOST{GROUP-INDEX}:
          "${var.host}${index + 1}" : 
          # HOST{GROUP-INDEX}-{INDEX-IN-GROUP}:
          "${var.host}${ 1+floor( index / local.num_instances_per_group ) }-${ 1 + (index % local.num_instances_per_group) }"
      )
  ) ]

  private_ips = aws_instance.instances.*.private_ip

  group_etc_hosts_lines = [ for index in range(var.num_groups) :
    format("# Group ${var.host}${index+1}:\n%s",
      join("\n",
        [ for index2 in range(local.num_instances_per_group) :
          format("%-15s   %s   %s",
            local.private_ips[ (index * local.num_instances_per_group) + index2 ],
            local.hostnames[ (index * local.num_instances_per_group) + index2 ],
            format("%s.%s",
              local.hostnames[ (index * local.num_instances_per_group) + index2 ], var.domain) )
    ]))
  ]
  
  global_etc_hosts_lines = join("\n\n", local.group_etc_hosts_lines)
}

