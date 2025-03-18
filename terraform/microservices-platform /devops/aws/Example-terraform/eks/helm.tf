resource "helm_release" "traefik" {
    name      = "traefik-ingress"
    repository = data.helm_repository.traefik.metadata[0].name
    chart     = "traefik/traefik"
    namespace = "kube-system"

    set {
        name  = "ports.web.nodePort"
        value = 32080
    }

    set {
        name  = "ports.traefik.expose"
        value = true
    }

    set {
        name  = "ports.traefik.nodePort"
        value = 32081
    }

    set {
        name  = "ports.websecure.expose"
        value = false
    }

    set {
        name = "additionalArguments"
        value = "{${join(",",["--providers.kubernetesingress=true","--ping=true", "--api.insecure=true"])}}"
    }

    set {
        name = "service.type"
        value = "NodePort"
    }
    depends_on = [module.eks]

}

resource "helm_release" "metrics_server" {
  name  = "metrics-server"
  chart = "metrics-server"
  namespace = "kube-system"
  repository = data.helm_repository.stable.metadata[0].name

  set {
    name  = "args"
    value = "{${join(",",["--kubelet-insecure-tls","--kubelet-preferred-address-types=InternalIP"])}}"
  }
  depends_on = [module.eks]
}

resource "helm_release" "kube2iam" {
  name  = "kube2iam"
  chart = "kube2iam"
  namespace = "kube-system"
  repository = data.helm_repository.stable.metadata[0].name

  set {
      name = "rbac.create"
      value = true
  }

  set {
    name  = "extraArgs.base-role-arn"
    value = module.eks.worker_iam_role
  }

  set {
    name  = "host.interface"
    value = "eni+"
  }

  set {
    name  = "host.ip"
    value = "$(HOST_IP)"
  }

  set {
    name  = "host.iptables"
    value = true 
  }
   depends_on = [module.eks]
}

resource "helm_release" "cluster_as" {
  name  = "cluster-autoscaler"
  chart = "cluster-autoscaler"
  namespace = "kube-system"
  repository = data.helm_repository.stable.metadata[0].name

  set {
      name = "autoscalingGroups[0].name"
      value = module.eks.asg_name
  }

  set {
      name = "autoscalingGroups[0].maxSize"
      value = var.eks.max_size
  }

  set {
      name = "autoscalingGroups[0].minSize"
      value = var.eks.min_size
  }

  set { 
      name = "podAnnotations.iam\\.amazonaws\\.com/role"
      value = aws_iam_role.cluster_as.arn
  }

  set { 
      name = "image.tag"
      value = "v1.15.5"
  }

  set { 
      name = "rbac.create"
      value =  true
  }

  set {
      name = "awsRegion"
      value = var.region
  }
   depends_on = [module.eks]
}