%{ for index, node in node_names ~}
Host u${node}
    Hostname      ${node_ips[index]}
    User          ubuntu
    IdentityFile  ${key_file}

Host ${node}
    Hostname      ${node_ips[index]}
    User          ${user}
    IdentityFile  ${key_file}

%{ endfor ~}
