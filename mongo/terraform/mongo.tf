terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
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

variable "nfs_server" {
    type = string
}

variable "mongo_port" {
    type = number
}

variable "registry_server" {
  type = string
}

variable "registry_username" {
  type = string
}

variable "registry_password" {
  type = string
}


provider "kubernetes" {
  host = var.host

  client_certificate     = base64decode(var.client_certificate)
  client_key             = base64decode(var.client_key)
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
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


resource "kubernetes_namespace" "mongo" {
  metadata {
        name = var.prj_name
  }
}


resource "kubernetes_persistent_volume" "mongo-pv" {
  metadata {
    name = var.prj_name
     labels = {
      app = var.prj_name
      tier = "infra"
    }
  }
  spec {
    capacity = {
      storage = "1Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
        nfs {
            path = "/mnt/nfs_share"
            server = var.nfs_server
        }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "mongo-pvc" {
  metadata {
    name = var.prj_name
    namespace = var.prj_name
     labels = {
      app = var.prj_name
      tier = "infra"
    }
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "1Gi"
      } 
    }
    volume_name = "${kubernetes_persistent_volume.mongo-pv.metadata.0.name}"
  }
}


resource "kubernetes_service" "mongo-svc" {
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
      port        = var.mongo_port
      target_port = var.mongo_port
    }

    type = "ClusterIP"
  }
}



resource "kubernetes_secret" "mongo-secret" {
  metadata {
    namespace = var.prj_name
    name = var.prj_name
    labels = {
      app = var.prj_name
    }
  }

  data = {
    "username" = "superadminuser"
    "password" = "superadminpassword"
  }

  type = "Opaque"
}

resource "kubernetes_deployment" "mongo-deployment" {
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
          image = format("%s/mongo:latest", var.registry_server)
          name  = var.prj_name
          readiness_probe {
            exec {
              command = [
                "mongo",
                "--disableImplicitSessions",
                "--eval",
                "db.adminCommand('ping')"
              ]
            }
            initial_delay_seconds  = 30
            period_seconds         = 10
            timeout_seconds        = 5
            success_threshold = 1
            failure_threshold      = 6 
          }
          liveness_probe {
            exec {
              command = [
                "mongo",
                "--disableImplicitSessions",
                "--eval",
                "db.adminCommand('ping')"
              ]
            }
            initial_delay_seconds  = 30
            period_seconds         = 10
            timeout_seconds        = 5
            success_threshold = 1
            failure_threshold      = 6 
          }
          env {
            name = "MONGO_INITDB_ROOT_USERNAME"
            value_from {
              secret_key_ref {
                name = var.prj_name
                key = "username"
              }
            }
          }
          env {
            name = "MONGO_INITDB_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = var.prj_name
                key = "password"
              }
            }
          }
          volume_mount {
            name = "database-volume"
            mount_path = "/data/db"
          }
        }
        volume {
          name = "database-volume"
          persistent_volume_claim {
            claim_name = var.prj_name
          }
        }
      }
    }
  } 
}

resource "kubernetes_network_policy" "mongo-netpol" {
  metadata {
    name      = var.prj_name
    namespace = var.prj_name
  }

  spec {
    pod_selector {}
    ingress {
      ports {
        port = "27017"
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
            mongo = "true"
          }
        }
      }
    }

    policy_types = ["Ingress", "Egress"]
  }
}