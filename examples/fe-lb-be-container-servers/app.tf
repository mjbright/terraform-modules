
module be-servers {
    #source          = "./modules/be-container-servers"
    source          = "git::https://github.com/mjbright/terraform-modules.git//modules/be-container-servers?ref=42d7fab1db7f0bddc21ba632a338bfdd48798044"

    network_name    = "apps"
    image_names     = [ "mjbright/k8s-demo:alpine1", "mjbright/k8s-demo:alpine2", "mjbright/k8s-demo:alpine3" ] 
    container_count = 3
    base_ext_port   = 6000

    container_name_prefix = "app-server"
}

module fe-lb {
    #source          = "./modules/fe-container-lb"
    source          = "git::https://github.com/mjbright/terraform-modules.git//modules/fe-container-lb?ref=42d7fab1db7f0bddc21ba632a338bfdd48798044"

    # We need module.be-servers to complete as it creates the apps_network
    depends_on = [ module.be-servers ]

    network_name    = "apps"
    container_name  = "app-lb"
    be_servers      =  module.be-servers.c_ips

    ext_port = 8000

    # Where generated haproxy.cfg should be placed:
    haproxy_cfg_abs_dir = "${ abspath( path.root ) }"
}

