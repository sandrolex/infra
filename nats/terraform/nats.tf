terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

variable "registry_server" {
  type = string
}

variable "host" {
  type = string
}

variable "client_certificate" {
  type = string
}

variable "client_key" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}

variable "prj_name" {
  type = string
}

variable "nats_port1" {
    type = number
}

variable "nats_port2" {
    type = number
}

provider "kubernetes" {
  host = var.host

  client_certificate     = base64decode(var.client_certificate)
  client_key             = base64decode(var.client_key)
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
}


resource "kubernetes_namespace" "nats" {
  metadata {
        name = var.prj_name
  }
}

resource "kubernetes_secret" "regcred" {
  metadata {
    name = "regcred"
    namespace = var.prj_name
  }

  data = {
    ".dockerconfigjson" = "${file("${path.module}/conf/registry/config.json")}"
  }

  type = "kubernetes.io/dockerconfigjson"
}


resource "kubernetes_service" "nats-svc" {
  metadata {
    namespace = var.prj_name
    name = var.prj_name
    labels = {
      app = var.prj_name
      tier = "infra"
    }
  }
  spec {
    selector = {
      app = var.prj_name
    }
    session_affinity = "ClientIP"
    port {
      name =    "nats-port1"
      port        = var.nats_port1
      target_port = var.nats_port1
    }
    port {
      name =    "nats-port2"
      port        = var.nats_port2
      target_port = var.nats_port2
    }

    type = "ClusterIP"
  }
}


resource "kubernetes_deployment" "nats-deployment" {
  metadata {
    namespace = var.prj_name
    name = var.prj_name
    labels = {
      app = var.prj_name
      tier = "infra"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.prj_name
      }
    }
    template {
      metadata {
        labels = {
          app = var.prj_name
        }
      }
      spec {
        image_pull_secrets {
          name = "regcred"
        }
        container {
          image = format("%s/nats:alpine3.10", var.registry_server)
          name  = var.prj_name
        }  
      }
    }
  } 
}


resource "kubernetes_network_policy" "nats-netpol" {
  metadata {
    name      = var.prj_name
    namespace = var.prj_name
  }

  spec {
    pod_selector {}
    
    ingress {
      ports {
        port = var.nats_port1
        protocol = "TCP"
      }
      ports {
        port     = var.nats_port2
        protocol = "TCP"
      }
      from {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "viper"
          } 
        }
        pod_selector {
          match_labels = {
            nats = "true"
          }
        }
      }
    }

    policy_types = ["Ingress", "Egress"]
  }
}