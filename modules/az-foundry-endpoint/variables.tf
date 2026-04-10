variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "prefix" {
  type = string
}

variable "organization_name" {
  type = string
}

variable "models" {
  type = map(object({
    name               = string
    format             = string
    version            = string
    model_provider_data = optional(map(string))
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}
