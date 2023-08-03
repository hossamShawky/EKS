variable "vpc_id" {
  type = string
}
variable "public_cidrs" {
  type = list(string)
}
variable "availability_zones" {
  type = list(string)
}
variable "destination" {
  type    = string
  default = "0.0.0.0/0"
}
variable "igw_id" {
  type = string
}