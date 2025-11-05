# Helm Chart: [Charmm Helm Chart]

## Overview

This Helm chart provides a flexible and reusable way to deploy services to Kubernetes. It is designed to be highly configurable and to reduce repetition in your service definitions.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- Istio (optional, for advanced networking features)
- Cert-manager (optional, for automated certificate management)

## Installation

To install the Helm chart, use the following command:

```bash
helm install [RELEASE_NAME] charmm-helm-chart/charmm-helm-chart
```

## Configuration

This chart is configured using the `values.yaml` file. The following sections describe the available configuration options.

### Complete `values.yaml` example

```yaml
# Default service properties
serviceProperties:
  name: "default-service"
  namespace: "default-namespace"
  enabled: true

deployment:
  name: campaign
  enabled: false
  namespace: charmm
  replicaCount: 1
  restartPolicy: Always
  args: [ ]
  image:
    # repository -- The image repository to pull from
    repository: your-repo.acr.io
    tag: latest
    pullPolicy: Always
  ports: { }

service:
  name: campaign
  enabled: false
  type: ClusterIP
  namespace: charmm
  ports: { }

resources:
  enabled: false
  limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 100m
    memory: 128Mi

autoscaling:
  enabled: false
  minReplicas: 1
  maxReplicas: 10

configMap:
  enabled: false
  name: campaign
  namespace: charmm
  data: { }

secrets:
  enabled: false
  namespace: default
  name: charmm
  data: { }

certificate:
  enabled: false
  name: ''
  namespace: ''
  secretName: ''
  issuerRef: ''
  commonName: ''
  dnsNames: { }

gateway:
  enabled: false
  name: ''
  namespace: ''
  specSelector: ''
  servers: { }

virtualService:
  enabled: false
  name: campaign
  gateways:
    - api-gateway
  httpRoutes:
    - name: campaign
      corsPolicy:
        allowHeaders:
          - authorization
          - content-type
        allowMethods:
          - GET
          - PUT
          - POST
          - PATCH
          - DELETE
      match:
        - uri:
            prefix: /v1/campaigns
      route:
        - destination:
            host: campaign.default.svc.cluster.local
            port:
              number: 8080
  tcpRoutes:
    - match:
        - port: 444
      route:
        - destination:
            host: campaign.default.svc.cluster.local
            port:
              number: 444
  namespace: charmm
  # host -- The host for the virtual service
  host: api.charmm.net

destinationRule:
  enabled: false
  name: ''
  namespace: ''
  host: ''
  trafficPolicy:
    loadBalancer:
      simple: ''
  subsets:
    - name: ''
      labels:
        version: v3
      trafficPolicy:
        loadBalancer:
          simple: ''

cronJob:
  enabled: false
  name: ''
  namespace: default
  schedule: "59 23 28-31 * *"
  containers: { }
  metadata: { }

persistentVolume:
  enabled: false
  name: ''
  namespace: ''
  labelType: ''
  storage:
    className: 'default'
    capacity: '10Gi'
  accessModes:
    - ReadWriteOnce
  hostPath: '/mnt/data'

persistentVolumeClaim:
  name: ''
  namespace: ''
  enabled: false
  accessModes:
    - ReadWriteOnce
  storage: 16Gi

argocd:
  name: ' '
  enabled: false
  namespace: ' '
  projectName: ''
  sources: [ ]
  sync:
    automated:
      prune: 'true'
      selfHeal: 'true'
    options:
      - RespectIgnoreDifferences=true
      - PruneLast=true
      - Validate=false
      - ServerSideApply=true
      - ApplyOutOfSyncOnly=true
      - CreateNamespace=true
    retry:
      limit: '2'
      backoffDuration: '5s'
      backOffMaxDuration: '3m0s'
      backOffFactor: '2'
  destination:
    name: ''
    namespace: ''
    server: 'https://kubernetes.default.svc'
  repository:
    url: ''
    path: ''
    targetRevision: ''
    chart: ''
    valueFiles: { }
  values: { }

hpa:
  enabled: false
  name: ''
  namespace: ''
  minReplicas: 1
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 80
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: 80
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
        - type: Percent
          value: 100
          periodSeconds: 15
    scaleUp:
      stabilizationWindowSeconds: 0
      policies:
        - type: Percent
          value: 100
          periodSeconds: 15
        - type: Pods
          value: 4
          periodSeconds: 15
      selectPolicy: Max
```
