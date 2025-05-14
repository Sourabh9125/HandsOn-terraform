resource "aws_key_pair" "ansible_key" {
    key_name = "terra-ansible-key"
    public_key = file("terra-ansible_ec2.pub")

    tags = {
        Name = "terra-ansible-key"
    }
  
}

resource "aws_default_vpc" "default_vpc" {

  
}

resource "aws_security_group" "my_sg" {
    name = "terra-ansible-sg"
    vpc_id = aws_default_vpc.default_vpc.id

    ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTP access"
    }
    
    ingress{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "SSH access"
    }

    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "All outbound access"

    }

    tags = {
      Name = "terra-ansible-sg"
    }

  
}

resource "aws_instance" "my_instance" {
    for_each = tomap({
        TWS-MASTER = "ami-084568db4383264d4"
        TWS-WORKER = "ami-0e449927258d45bc4"
        TWS-WORKER2 = "ami-0c15e602d3d6c6c4a"
    })

    depends_on = [ aws_security_group.my_sg, aws_key_pair.ansible_key  ]

    key_name = aws_key_pair.ansible_key.key_name
    security_groups = [aws_security_group.my_sg.name]
    instance_type = "t2.micro"
    ami = each.value
    root_block_device {
  
        volume_size = 10
        volume_type = "gp3"
    }

    tags = {
        Name = each.key
    }
  
}