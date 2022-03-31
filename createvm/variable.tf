variable "region" {
  description = "GCP region name"
  type        = string
  default     = "us-west1"
  validation {
    condition     = can(regex("^us-west", var.region))
    error_message = "The region should only be us-west."
  }
}

variable "projectid" {
  description = "GCP projectid"
  type        = string
  default     = "v2agent-9423a"
}

variable "zone" {
  description = "GCP VM Zone"
  type        = string
  default     = "us-west1-c"
  validation {
    condition     = contains(["us-west1-a", "us-west1-b", "us-west1-c"], var.zone)
    error_message = "The zone value must be us-west1-a, us-west1-b or us-west1-c only."
  }
}

variable "vmname" {
  description = "GCP VM Name"
  type        = string
  default     = "terraform-test"
}

variable "machinetype" {
  description = "GCP VM CPU Type"
  type        = string
  default     = "n2-standard-2"
  validation {
    condition     = can(regex("^n2", var.machinetype))
    error_message = "The machine type can only be n2."
  }
}

variable "image" {
  description = "GCP VM Image"
  type        = string
  default     = "debian-cloud/debian-9"
  validation {
    condition     = can(regex("^debian-cloud", var.image)) || can(regex("^centos-cloud", var.image))
    error_message = "The image could only be a part of debian-cloud or centos-cloud image project."
  }
}

variable "vmnos" {
  description = "Number of VMs to create with provided config"
  type        = string
  default     = "2"
  nullable = false 
}