
%{ for node_ip in node_ips ~}
    %{ for file in files ~}
        scp -i ${var.key_file} ${file} ubuntu@${node_ip}:/tmp/
    %{ endfor ~}
%{ endfor ~}


