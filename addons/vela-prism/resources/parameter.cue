parameter: {
    "replicacount": *1 | int
    "repository": *"oamdev/vela-prism"|string
    "tag": *"latest"|string
    "pullPolicy": *"IfNotPresent"|string
    "cpu": *"100m"|string
    "memory": *"200Mi"|string
    "enabled": *true | bool
}
