output "public_ip" {
    value = [
  for instance in aws_instance.my_instance :{ 
    name = instance.tags.Name
    public_ip = instance.public_ip
  }
    ]  
}

output "public_dns" {
    value= [
        for instance in aws_instance.my_instance : instance.public_dns
    ]
  
}