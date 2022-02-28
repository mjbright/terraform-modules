#!/bin/bash

# NOTE: With lightsail, initial script is inserted forcing /bin/sh not /bin/bash !!
#       So beware of bash-isms in this script

# user_data can be accessed thus, from within the instance:
#     curl -sL http://169.254.169.254/latest/user-data
# user_data can be deleted thus, from outside the instance:
#     aws ec2 modify-instance-attribute --instance-id <your-instance-id> --user-data ":"

#### echo "<html ><head><title>Server is UP</title></head>  <body><h1>Welcome - Server is UP</h1></body> </html>" > index.html
#### nohup busybox httpd -f -p "${var.webserver_port}" &

exec > /tmp/user_data.op 2>&1

BASH_EXEC() {
    # Detect if not running bash:
    echo "$0: SHELL='$SHELL'"
    # [ -z "$SHELL" ] && { exit 37; }

    #ps $$ | grep bash || SHELL=/bin/sh
    #[ "${SHELL%bash}" = "$SHELL" ] && {
    ps $$ | grep bash || {
        # Not running bash - copy the following lines to /tmp/bash_user_data.sh and execute it:
        sed -e '1,/^# START_BASH/d' $0 > /tmp/bash_user_data.sh
    
        bash -x /tmp/bash_user_data.sh
        exit $?
    }
}

set -x

BASH_EXEC

# DON'T CHANGE or remove the following line: --------------------------------
# START_BASH
#!/bin/bash

echo "$0: SHELL='$SHELL'"

