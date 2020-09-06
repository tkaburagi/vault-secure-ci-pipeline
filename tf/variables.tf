variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "ap-northeast-1"
}
variable "ami" {
    default = "ami-06d9ad3f86032262d"
}
variable "hello_tf_instance_count" {
    default = 3
}
variable "hello_tf_instance_type" {
    default = "t2.micro"
}
