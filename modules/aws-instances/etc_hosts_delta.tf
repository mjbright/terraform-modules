
# NOTE: Resources in this file are created only if
# - number of groups is non-zero

# File to save individual /etc/hosts delta for each group:

resource "local_file" "group_etc_hosts" {
  count           = var.num_groups

  content         = format( "%s\n", local.group_etc_hosts_lines[ count.index ] )
  filename        = "var/etc_hosts_${var.host}${ 1+count.index }"
  file_permission = 0600
}

# File to save merged /etc/hosts delta for all groups:

resource "local_file" "global_etc_hosts" {
  count           = ( var.num_groups > 0 ? 1 : 0 )

  content         = format( "%s\n", local.global_etc_hosts_lines )
  filename        = "var/etc_hosts_${var.host}"
  file_permission = 0600
}

