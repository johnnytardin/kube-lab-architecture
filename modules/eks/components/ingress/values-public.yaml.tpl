image:
  pullPolicy: IfNotPresent

deployment:
  replicas: null
  revisionHistoryLimit: 1
  terminationGracePeriodSeconds: 300
  dnsConfig:
    options:
      - name: ndots
        value: "1"
  lifecycle:
    preStop:
      exec:
        command: ["/bin/sh", "-c", "sleep 30"]

commonLabels:
  app: traefik-public-ingress
  application_app: traefik-public-ingress

resources:
  requests:
    cpu: "200m"
    memory: "256Mi"
  limits:
    cpu: "1000m"
    memory: "1024Mi"

autoscaling:
  enabled: true
  minReplicas: 1
  maxReplicas: 20
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 75
  - resource:
      name: memory
      target:
        averageUtilization: 75
        type: Utilization
    type: Resource
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
      - type: Pods
        value: 1
        periodSeconds: 300

#affinity:
#  podAntiAffinity:
#    requiredDuringSchedulingIgnoredDuringExecution:
#      - labelSelector:
#          matchLabels:
#            app.kubernetes.io/name: '{{ template "traefik.name" . }}'
#            app.kubernetes.io/instance: '{{ .Release.Name }}-{{ .Release.Namespace }}'
#        topologyKey: kubernetes.io/hostname

service:
  enabled: true
  single: true
  type: LoadBalancer
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "ssl"
    service.beta.kubernetes.io/aws-load-balancer-connection-draining-enabled: "true"
    service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout: "3600"
    service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "false"
    service.beta.kubernetes.io/aws-load-balancer-healthcheck-healthy-threshold: "2"
    service.beta.kubernetes.io/aws-load-balancer-healthcheck-interval: "10"
    service.beta.kubernetes.io/aws-load-balancer-healthcheck-timeout: "10"
    service.beta.kubernetes.io/aws-load-balancer-healthcheck-unhealthy-threshold: "2"
    service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
    # service.beta.kubernetes.io/aws-load-balancer-ssl-cert: "${ssl_cert_arn}"
    # service.beta.kubernetes.io/aws-load-balancer-ssl-negotiation-policy: "ELBSecurityPolicy-TLS13-1-2-2021-06"
    # service.beta.kubernetes.io/aws-load-balancer-ssl-ports: "443"
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb"

ingressClass:
  enabled: true
  isDefaultClass: false
  name: public

providers:
  kubernetesIngress:
    enabled: true
    allowExternalNameServices: false
    allowEmptyServices: false
    ingressClass: public
    namespaces: []
    publishedService:
      enabled: true

ports:
  traefik:
    port: 9000
    expose: false
    exposedPort: 9000
    protocol: TCP
  web:
    expose: true
  websecure:
    expose: false
    tls:
      enabled: true

nodeSelector:
  kubernetes.io/os: linux
  workload: management

logs:
  general:
    # -- logging levels are DEBUG, PANIC, FATAL, ERROR, WARN, and INFO.
    level: ERROR
  access:
    enabled: true
    format: json
    filters: {}
      # statuscodes: "200,300-302"
      # retryattempts: true
      # minduration: 10ms
    fields:
      general:
        defaultmode: keep
        names: {}
          ## Examples:
          # ClientUsername: drop
      headers:
        defaultmode: drop
        names: {}
          ## Examples:
          # User-Agent: redact
          # Authorization: drop
          # Content-Type: keep

metrics:
  prometheus:
    entryPoint: metrics
    addEntryPointsLabels: true
    addRoutersLabels: false
    addServicesLabels: true

extraObjects: []

globalArguments: []
