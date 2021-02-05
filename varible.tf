variable "org_name" {
  description = "The name of the org for which we are setting the PKI"
  type        = string
  default     = "NewOrg"
}

variable "ca_type" {
  description = "The type of ca for the PKI"
  type        = string
  default     = "internal"
}

variable "key_bits" {
  description = "The size of the encryption algorithm"
  type        = number
  default     = 256
}

variable "base_domain" {
  description = "The base domain for peers"
  type        = list(string)
  default     = ["service.consul"]
}
//
//variable "roles" {
//  description = "The list of fabric roles"
//  type        = list(string)
//  default     = ["peer", "admin"]
//}
