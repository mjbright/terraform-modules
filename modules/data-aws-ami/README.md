
The data-aws-ami module allows to look up the latest ami for the current region for a particular family.

The module only interrogates the data.aws_ami data source for the specified family.

The selected ami is returned as an output from the module.

Refer to [examples/data-aws-ami](tree/master/examples/data-aws-ami) for example usage
and [examples/data-aws-ami/TEST_module](tree/master/examples/data-aws-ami/TEST_module) for a simple test config

Currently supports:
- x86_64 architecture

Currently supported families are:
- ubuntu_1804
- ubuntu_2004
- rhel8p5
- centos6
- centos7
- centos8
- centos9
- debian8
- debian9
- debian10
- debian11
- amazon2


