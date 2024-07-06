nodeSelector:
  kubernetes.io/os: linux
  workload: management

jaeger:
  enabled: false

collector:
  config: |
    receivers:
      otlp:
        protocols:
          grpc:
          http:
      opencensus:
      jaeger:
        protocols:
          grpc:
          thrift_http:
          thrift_compact:
          thrift_binary:
    processors:
      batch:
      resource:
        attributes:
        - key: service.name
          from_attribute: alias
          action: upsert
        - key: component
          value: linkerd
          action: insert
      probabilistic_sampler:
        hash_seed: 22
        sampling_percentage: 20
    extensions:
      health_check:
    exporters:
      jaeger:
        endpoint: ${jaeger_endpoint}
        insecure: true
    service:
      extensions: [health_check]
      pipelines:
        traces:
          receivers: [otlp,opencensus,jaeger]
          processors: [batch,resource]
          exporters: [jaeger]
