variable "vpc_id" {
  type = string
}
variable "private_cidrs" {
  type = list(string)
}
variable "availability_zones" {
  type = list(string)
}

variable "destination" {
  type=string
  default="0.0.0.0/0"
}
variable "public_subnet" {
  type=string
}