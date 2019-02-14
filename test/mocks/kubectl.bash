#!/bin/bash

kubectl() {
    local clusters=(cluster-small cluster-medium cluster-big cluster-bug1)
    if [ "${1}" == "config" ] && [ "${2}" == "use-context" ] && [[ "${clusters[*]}" =~ $3 ]]; then
        KUBECTL_CONTEXT="${3}"
        echo "setting context to ${3}"
    fi

    if [ "${1}" == "config" ] && [ "${2}" == "current-context" ]; then
        echo "${KUBECTL_CONTEXT}"
    fi

    # get all nodes requests
    if [ "${1}" == "get" ] && [ "${2}" == "nodes" ] && [ "${3}" == "-o=jsonpath={range .items[*]}{.metadata.name}{'\t'}{.status.allocatable.cpu}{'\t'}{.status.allocatable.memory}{'\n'}{end}" ]; then
        kubectl_get_all_nodes_requests
    fi

    # get master nodes requests
    if [ "${1}" == "get" ] && [ "${2}" == "nodes" ] && [ "${3}" == "-l" ] && [ "${4}" == "node-role.kubernetes.io/master=true" ] && [ "${5}" == "-o=jsonpath={range .items[*]}{.metadata.name}{'\t'}{.status.allocatable.cpu}{'\t'}{.status.allocatable.memory}{'\n'}{end}" ]; then
        kubectl_get_master_nodes_requests
    fi

    # get all pod requests and with namespaces
    if [ "${1}" == "get" ] && [ "${2}" == "pod" ] && [ "${3}" == "--all-namespaces" ] && [ "${4}" == "--field-selector=status.phase=Running" ] && [ "${5}" == "-o=go-template" ] && [[ "${6}" == *"get_pod_data"* ]]; then
        kubectl_get_all_pods_requests_with_namespaces
    fi

}


kubectl_get_all_nodes_requests() {

    if [ "${KUBECTL_CONTEXT}" == "cluster-small" ]; then 
        echo "ip-10-1-1-10.us-west-2.compute.internal	449m	1351126Ki"
        echo "ip-10-1-1-11.us-west-2.compute.internal	449m	1351126Ki"
    fi


    if [ "${KUBECTL_CONTEXT}" == "cluster-medium" ]; then 
        echo "ip-10-1-1-10.us-west-2.compute.internal	940m	2702252Ki"
        echo "ip-10-1-1-11.us-west-2.compute.internal	940m	2702252Ki"
        echo "ip-10-1-1-12.us-west-2.compute.internal	4	15850212Ki"
        echo "ip-10-1-1-14.us-west-2.compute.internal	8	31700424Ki"
        echo "ip-10-1-1-15.us-west-2.compute.internal	8	31700424Ki"
        echo "ip-10-1-1-16.us-west-2.compute.internal	8	31700424Ki"
    fi

    if [ "${KUBECTL_CONTEXT}" == "cluster-big" ]; then 
        echo "ip-10-1-1-11.us-west-2.compute.internal	940m	2702252Ki"
        echo "ip-10-1-1-12.us-west-2.compute.internal	940m	2702252Ki"
        echo "ip-10-1-1-14.us-west-2.compute.internal	4	15850212Ki"
        echo "ip-10-1-1-15.us-west-2.compute.internal	4	15850212Ki"
        echo "ip-10-1-1-16.us-west-2.compute.internal	8	31700424Ki"
        echo "ip-10-1-1-17.us-west-2.compute.internal	8	31700424Ki"
        echo "ip-10-1-1-18.us-west-2.compute.internal	16	63400848Ki"
        echo "ip-10-1-1-19.us-west-2.compute.internal	16	63400848Ki"
        echo "ip-10-1-1-20.us-west-2.compute.internal	16	63400848Ki"
        echo "ip-10-1-1-21.us-west-2.compute.internal	16	63400848Ki"
        echo "ip-10-1-1-22.us-west-2.compute.internal	16	63400848Ki"
        echo "ip-10-1-1-23.us-west-2.compute.internal	16	63400848Ki"
        echo "ip-10-1-1-24.us-west-2.compute.internal	16	63400848Ki"
        echo "ip-10-1-1-25.us-west-2.compute.internal	16	63400848Ki"
        echo "ip-10-1-1-26.us-west-2.compute.internal	16	63400848Ki"
        echo "ip-10-1-1-27.us-west-2.compute.internal	16	63400848Ki"
        echo "ip-10-1-1-28.us-west-2.compute.internal	16	63400848Ki"
        echo "ip-10-1-1-29.us-west-2.compute.internal	16	63400848Ki"
        echo "ip-10-1-1-30.us-west-2.compute.internal	16	63400848Ki"
        echo "ip-10-1-1-31.us-west-2.compute.internal	16	63400848Ki"
        echo "ip-10-1-1-32.us-west-2.compute.internal	16	63400848Ki"
        echo "ip-10-1-1-33.us-west-2.compute.internal	16	63400848Ki"
        echo "ip-10-1-1-34.us-west-2.compute.internal	16	63400848Ki"
        echo "ip-10-1-1-35.us-west-2.compute.internal	16	63400848Ki"
        echo "ip-10-1-1-36.us-west-2.compute.internal	16	63400848Ki"
        echo "ip-10-1-1-37.us-west-2.compute.internal	16	63400848Ki"
        echo "ip-10-1-1-38.us-west-2.compute.internal	32	63400848Ki"
        echo "ip-10-1-1-39.us-west-2.compute.internal	32	63400848Ki"
        echo "ip-10-1-1-40.us-west-2.compute.internal	32	63400848Ki"
        echo "ip-10-1-1-41.us-west-2.compute.internal	32	63400848Ki"
        echo "ip-10-1-1-42.us-west-2.compute.internal	32	63400848Ki"
        echo "ip-10-1-1-43.us-west-2.compute.internal	32	63400848Ki"
    fi
}

kubectl_get_master_nodes_requests() {

    if [ "${KUBECTL_CONTEXT}" == "cluster-small" ]; then 
        echo "ip-10-1-1-10.us-west-2.compute.internal	449m	1351126Ki"
    fi


    if [ "${KUBECTL_CONTEXT}" == "cluster-medium" ]; then 
        echo "ip-10-1-1-10.us-west-2.compute.internal	940m	2702252Ki"
        echo "ip-10-1-1-11.us-west-2.compute.internal	940m	2702252Ki"
        echo "ip-10-1-1-12.us-west-2.compute.internal	4	15850212Ki"
    fi

    if [ "${KUBECTL_CONTEXT}" == "cluster-big" ]; then 
        echo "ip-10-1-1-14.us-west-2.compute.internal	4	15850212Ki"
        echo "ip-10-1-1-15.us-west-2.compute.internal	4	15850212Ki"
        echo "ip-10-1-1-16.us-west-2.compute.internal	8	31700424Ki"
    fi
}


kubectl_get_all_pods_requests_with_namespaces() {

    if [ "${KUBECTL_CONTEXT}" == "cluster-bug1" ]; then 
        echo "infra	ip-10-1-1-10.us-west-2.compute.internal		1G"
        echo "infra	ip-10-1-1-11.us-west-2.compute.internal		1500M"
        echo "infra	ip-10-1-1-12.us-west-2.compute.internal		937500K"
    fi


    if [ "${KUBECTL_CONTEXT}" == "cluster-small" ]; then 
        echo "default	ip-10-1-1-10.us-west-2.compute.internal	10m	"
        echo "default	ip-10-1-1-11.us-west-2.compute.internal		"
        echo "default	ip-10-1-1-10.us-west-2.compute.internal	50m	300Mi"
        echo "kube-system	ip-10-1-1-11.us-west-2.compute.internal	5m	32Mi"
        echo "kube-system	ip-10-1-1-11.us-west-2.compute.internal	5m	32Mi"
    fi

    if [ "${KUBECTL_CONTEXT}" == "cluster-medium" ]; then 
        echo "kube-system	ip-10-1-1-10.us-west-2.compute.internal	10m	"
        echo "kube-system	ip-10-1-1-11.us-west-2.compute.internal	10m	"
        echo "kube-system	ip-10-1-1-10.us-west-2.compute.internal	10m	"
        echo "kube-system	ip-10-1-1-12.us-west-2.compute.internal		"
        echo "kube-system	ip-10-1-1-14.us-west-2.compute.internal		"
        echo "kube-system	ip-10-1-1-16.us-west-2.compute.internal	10m	"
        echo "default	ip-10-1-1-10.us-west-2.compute.internal	50m	300Mi"
        echo "default	ip-10-1-1-11.us-west-2.compute.internal	100m	70Mi"
        echo "default	ip-10-1-1-11.us-west-2.compute.internal	100m	"
        echo "default	ip-10-1-1-14.us-west-2.compute.internal	5m	32Mi"
        echo "default	ip-10-1-1-15.us-west-2.compute.internal	2	1G"
        echo "qa	ip-10-1-1-16.us-west-2.compute.internal	2	1G"
        echo "qa	ip-10-1-1-11.us-west-2.compute.internal	2	1G"
        echo "qa	ip-10-1-1-11.us-west-2.compute.internal	2	1G"
        echo "qa	ip-10-1-1-14.us-west-2.compute.internal	3	2G"
        echo "qa	ip-10-1-1-15.us-west-2.compute.internal	3	2G"
        echo "qa	ip-10-1-1-15.us-west-2.compute.internal	3	2G"
        echo "qa	ip-10-1-1-16.us-west-2.compute.internal	3	2G"
        echo "default	ip-10-1-1-14.us-west-2.compute.internal	5m	32Mi"
        echo "kube-system	ip-10-1-1-15.us-west-2.compute.internal	500m	256Mi"
        echo "kube-system	ip-16-1-1-11.us-west-2.compute.internal	500m	256Mi"
    fi

    if [ "${KUBECTL_CONTEXT}" == "cluster-big" ]; then 
        echo "default	ip-10-1-1-10.us-west-2.compute.internal	10m	"
        echo "default	ip-10-1-1-11.us-west-2.compute.internal	10m	"
        echo "default	ip-10-1-1-10.us-west-2.compute.internal		"
        echo "kube-system	ip-10-1-1-12.us-west-2.compute.internal	10m	"
        echo "kube-system	ip-10-1-1-12.us-west-2.compute.internal	50m	300Mi"
        echo "kube-system	ip-10-1-1-14.us-west-2.compute.internal	100m	70Mi"
        echo "kube-system	ip-10-1-1-15.us-west-2.compute.internal	100m	"
        echo "kube-system	ip-10-1-1-15.us-west-2.compute.internal	5m	32Mi"
        echo "qa	ip-10-1-1-15.us-west-2.compute.internal	2	1G"
        echo "kube-system	ip-10-1-1-16.us-west-2.compute.internal	5m	32Mi"
        echo "monitoring	ip-10-1-1-16.us-west-2.compute.internal	500m	256Mi"
        echo "monitoring	ip-10-1-1-10.us-west-2.compute.internal	500m	256Mi"
        echo "default	ip-10-1-12.us-west-2.compute.internal		"
        echo "qa	ip-10-1-1-14.us-west-2.compute.internal	2	1G"
        echo "qa	ip-10-1-1-15.us-west-2.compute.internal	2	1G"
        echo "dev	ip-10-1-1-16.us-west-2.compute.internal	2	3G"
        echo "dev	ip-10-1-1-17.us-west-2.compute.internal	2	3G"
        echo "qa	ip-10-1-1-18.us-west-2.compute.internal	2	4G"
        echo "qa	ip-10-1-1-19.us-west-2.compute.internal	2	4G"
        echo "qa	ip-10-1-1-20.us-west-2.compute.internal	3	5G"
        echo "qa	ip-10-1-1-21.us-west-2.compute.internal	3	5G"
        echo "qa	ip-10-1-1-22.us-west-2.compute.internal	3	7G"
        echo "qa	ip-10-1-1-23.us-west-2.compute.internal	3	7G"
        echo "stg	ip-10-1-1-24.us-west-2.compute.internal	2	8G"
        echo "stg	ip-10-1-1-25.us-west-2.compute.internal	2	8G"
        echo "stg	ip-10-1-1-26.us-west-2.compute.internal	2	8G"
        echo "stg	ip-10-1-1-27.us-west-2.compute.internal	2	8G"
        echo "stg	ip-10-1-1-28.us-west-2.compute.internal	2	8G"
        echo "stg	ip-10-1-1-29.us-west-2.compute.internal	2	8G"
        echo "qa	ip-10-1-1-30.us-west-2.compute.internal	4	5G"
        echo "qa	ip-10-1-1-31.us-west-2.compute.internal	4	5G"
        echo "dev	ip-10-1-1-32.us-west-2.compute.internal	4	5G"
        echo "dev	ip-10-1-1-33.us-west-2.compute.internal	4	5G"
        echo "dev	ip-10-1-1-34.us-west-2.compute.internal	4	5G"
        echo "dev	ip-10-1-1-35.us-west-2.compute.internal	4	5G"
        echo "qa	ip-10-1-1-36.us-west-2.compute.internal	6	4G"
        echo "qa	ip-10-1-1-37.us-west-2.compute.internal	6	4G"
        echo "dev	ip-10-1-1-38.us-west-2.compute.internal	6	4G"
        echo "stg	ip-10-1-1-40.us-west-2.compute.internal	6	4G"
        echo "stg	ip-10-1-1-42.us-west-2.compute.internal	6	4G"
        echo "stg	ip-10-1-1-41.us-west-2.compute.internal	6	4G"
    fi
}
