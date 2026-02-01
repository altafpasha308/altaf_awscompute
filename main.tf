data "terraform_remote_state" "network_details" {
backend = "s3"
config = {
    bucket = "altaf-s3-frmterra-test-bucket1"
    key    = "networkingstatefile"
    region = "ap-southeast-2"
}
}
data "aws_ami" "example" {
  most_recent      = true
  owners           = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images-testing/hvm-ssd-gp3/ubuntu-questing-daily-amd64-server-20250608"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

}
resource "aws_instance" "example" {
  ami           = data.aws_ami.example.id
  instance_type = "t3.micro"
  subnet_id     = data.terraform_remote_state.network_details.outputs.subnetid
  key_name = data.terraform_remote_state.network_details.outputs.awskeyname
  security_groups = [data.terraform_remote_state.network_details.outputs.securitygroup]
  tags = {
    Name = "tf-example"
  }
}
