variable "vpc_id" {
  type = string
}
variable "private_cidrs" {
  type = list(string)
}
variable "availability_zones" {
  type = list(string)
}