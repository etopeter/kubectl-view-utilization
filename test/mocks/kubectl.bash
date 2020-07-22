#!/bin/bash
kubectl() {
    local clusters=(
        cluster-small
        cluster-medium
        cluster-big
        cluster-bug1
        cluster-issue-52
        cluster-issue-56
    )

    if [ "${1}" == "config" ] && [ "${2}" == "use-context" ] && [[ "${clusters[*]}" =~ $3 ]]; then
        KUBECTL_CONTEXT="${3}"
        echo "setting context to ${3}"
    fi

    if [ "${1}" == "config" ] && [ "${2}" == "current-context" ]; then
        echo "${KUBECTL_CONTEXT}"
    fi

    # kubectl config get-contexts unknown -o name
    if [ "${1}" == "config" ] && [ "${2}" == "get-contexts" ] && [ "${3}" == "unknown" ] && [ "${4}" == "-o" ] && [ "${5}" == "name" ]; then
        echo "Context error"
    fi

    # kubectl config get-contexts cluster-small -o name
    if [ "${1}" == "config" ] && [ "${2}" == "get-contexts" ] && [ "${3}" == "cluster-small" ] && [ "${4}" == "-o" ] && [ "${5}" == "name" ]; then
        echo "cluster-small"
    fi

    # kubectl config get-contexts cluster-medium -o name
    if [ "${1}" == "config" ] && [ "${2}" == "get-contexts" ] && [ "${3}" == "cluster-medium" ] && [ "${4}" == "-o" ] && [ "${5}" == "name" ]; then
        echo "cluster-medium"
    fi

    # kubectl config get-contexts cluster-big -o name
    if [ "${1}" == "config" ] && [ "${2}" == "get-contexts" ] && [ "${3}" == "cluster-big" ] && [ "${4}" == "-o" ] && [ "${5}" == "name" ]; then
        echo "cluster-big"
    fi


    if [[ "${1}" == *"--context="* ]] && [ -n "${1#*=}" ]; then
        KUBECTL_CONTEXT="${1#*=}"
        shift 1
    fi


    # get all nodes requests
    if [ "${1}" == "get" ] && [ "${2}" == "nodes" ] && [ "${3}" == "--field-selector=spec.unschedulable=false" ] && [ "${4}" == "-o=jsonpath={range .items[*]}{.metadata.name}{'\t'}{.status.allocatable.cpu}{'\t'}{.status.allocatable.memory}{'\n'}{end}" ]; then
        kubectl_get_all_nodes_requests
    fi

    # get master nodes requests
    if [ "${1}" == "get" ] && [ "${2}" == "nodes" ] && [ "${3}" == "-l" ] && [ "${4}" == "node-role.kubernetes.io/master=true" ] && [ "${5}" == "--field-selector=spec.unschedulable=false" ] && [ "${6}" == "-o=jsonpath={range .items[*]}{.metadata.name}{'\t'}{.status.allocatable.cpu}{'\t'}{.status.allocatable.memory}{'\n'}{end}" ]; then
        kubectl_get_master_nodes_requests
    fi

    # get worker nodes form cluster issue-56
    if [ "${1}" == "get" ] && [ "${2}" == "nodes" ] && [ "${3}" == "-l" ] && [ "${4}" == "role=kube-worker" ] && [ "${5}" == "--field-selector=spec.unschedulable=false" ] && [ "${6}" == "-o=jsonpath={range .items[*]}{.metadata.name}{'\t'}{.status.allocatable.cpu}{'\t'}{.status.allocatable.memory}{'\n'}{end}" ]; then
        kubectl_get_all_nodes_requests "role=kube-worker"
    fi


    # get all pod requests and with namespaces
    if [ "${1}" == "get" ] && [ "${2}" == "pod" ] && [ "${3}" == "--all-namespaces" ] && [ "${4}" == "--field-selector=status.phase=Running" ] && [ "${5}" == "-o=go-template" ] && [[ "${6}" == *"get_pod_data"* ]]; then
        kubectl_get_all_pods_requests_with_namespaces
    fi

    # get all pod requests in kube-system namespace
    if [ "${1}" == "get" ] && [ "${2}" == "pod" ] && [ "${3}" == "--namespace=kube-system" ] && [ "${4}" == "--field-selector=status.phase=Running" ] && [ "${5}" == "-o=go-template" ] && [[ "${6}" == *"get_pod_data"* ]]; then
        kubectl_get_all_pods_requests_with_namespaces | grep "kube-system" 
    fi

}


kubectl_get_all_nodes_requests() {
    local label=$1

    if [ "${KUBECTL_CONTEXT}" == "cluster-bug1" ]; then 
        echo "ip-10-1-1-10.us-west-2.compute.internal	2	1351126Ki"
        echo "ip-10-1-1-11.us-west-2.compute.internal	4	2702252Ki"
    fi

    if [ "${KUBECTL_CONTEXT}" == "cluster-issue-52" ]; then
        echo "ip-10-1-1-10.us-west-2.compute.internal	1	2250Mi"
        echo "ip-10-1-1-11.us-west-2.compute.internal	1	1574Mi"
    fi

    if [ "${KUBECTL_CONTEXT}" == "cluster-issue-56" ] && [ "${label}" == "" ]; then
        echo "ip-10-45-17-163.eu-central-1.compute.internal	28	60768081688"
        echo "ip-10-45-18-16.eu-central-1.compute.internal	28	60768081688"
        echo "ip-10-45-18-56.eu-central-1.compute.internal	36	71828568Ki"
        echo "ip-10-45-21-153.eu-central-1.compute.internal	28	60768081688"
        echo "ip-10-45-22-223.eu-central-1.compute.internal	28	60768081688"
        echo "ip-10-45-23-121.eu-central-1.compute.internal	36	71828568Ki"
        echo "ip-10-45-24-151.eu-central-1.compute.internal	28	60768073701"
        echo "ip-10-45-24-23.eu-central-1.compute.internal	36	71828568Ki"
        echo "ip-10-45-24-8.eu-central-1.compute.internal	28	60768073701"
    fi

    if [ "${KUBECTL_CONTEXT}" == "cluster-issue-56" ] && [ "${label}" == "role=kube-worker" ]; then
        echo "ip-10-45-17-163.eu-central-1.compute.internal	28	60768081688"
        echo "ip-10-45-18-16.eu-central-1.compute.internal	28	60768081688"
        echo "ip-10-45-21-153.eu-central-1.compute.internal	28	60768081688"
        echo "ip-10-45-22-223.eu-central-1.compute.internal	28	60768081688"
        echo "ip-10-45-24-151.eu-central-1.compute.internal	28	60768073701"
        echo "ip-10-45-24-8.eu-central-1.compute.internal	28	60768073701"
    fi


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
        echo "infra	ip-10-1-1-10.us-west-2.compute.internal	0	1G	0	0Ki"
        echo "infra	ip-10-1-1-11.us-west-2.compute.internal	0	1500M	0	0Ki"
        echo "infra	ip-10-1-1-11.us-west-2.compute.internal	0	937500k	0	0Ki"
    fi

    if [ "${KUBECTL_CONTEXT}" == "cluster-issue-52" ]; then
        echo "kube-system	ip-10-1-1-10.us-west-2.compute.internal	100m	100Mi	100m	150Mi"
        echo "default	ip-10-1-1-11.us-west-2.compute.internal	200m	200Mi	250m	250Mi"
    fi

    if [ "${KUBECTL_CONTEXT}" == "cluster-small" ]; then 
        echo "default	ip-10-1-1-10.us-west-2.compute.internal	10m	0Ki	100m	50Ki"
        echo "default	ip-10-1-1-11.us-west-2.compute.internal	0	0Ki	100m	50Ki"
        echo "default	ip-10-1-1-10.us-west-2.compute.internal	50m	300Mi	100m	500Mi"
        echo "kube-system	ip-10-1-1-11.us-west-2.compute.internal	5m	32Mi	20m	64Mi"
        echo "kube-system	ip-10-1-1-11.us-west-2.compute.internal	5m	32Mi	20m	64Mi"
    fi

    if [ "${KUBECTL_CONTEXT}" == "cluster-medium" ]; then 
        echo "kube-system	ip-10-1-1-10.us-west-2.compute.internal	10m	0Ki	0	0Ki"
        echo "kube-system	ip-10-1-1-11.us-west-2.compute.internal	10m	0Ki	0	0Ki"
        echo "kube-system	ip-10-1-1-10.us-west-2.compute.internal	10m	0Ki	0	0Ki"
        echo "kube-system	ip-10-1-1-12.us-west-2.compute.internal	0	0Ki	0	0Ki"
        echo "kube-system	ip-10-1-1-14.us-west-2.compute.internal	0	0Ki	0	0Ki"
        echo "kube-system	ip-10-1-1-16.us-west-2.compute.internal	10m	0Ki	0	0Ki"
        echo "default	ip-10-1-1-10.us-west-2.compute.internal	50m	300Mi	0	0Ki"
        echo "default	ip-10-1-1-11.us-west-2.compute.internal	100m	70Mi	0	0Ki"
        echo "default	ip-10-1-1-11.us-west-2.compute.internal	100m	0Ki	0	0Ki"
        echo "default	ip-10-1-1-14.us-west-2.compute.internal	5m	32Mi	0	0Ki"
        echo "default	ip-10-1-1-15.us-west-2.compute.internal	2	1G	0	0Ki"
        echo "qa	ip-10-1-1-16.us-west-2.compute.internal	2	1G	0	0Ki"
        echo "qa	ip-10-1-1-11.us-west-2.compute.internal	2	1G	0	0Ki"
        echo "qa	ip-10-1-1-11.us-west-2.compute.internal	2	1G	0	0Ki"
        echo "qa	ip-10-1-1-14.us-west-2.compute.internal	3	2G	0	0Ki"
        echo "qa	ip-10-1-1-15.us-west-2.compute.internal	3	2G	0	0Ki"
        echo "qa	ip-10-1-1-15.us-west-2.compute.internal	3	2G	0	0Ki"
        echo "qa	ip-10-1-1-16.us-west-2.compute.internal	3	2G	0	0Ki"
        echo "default	ip-10-1-1-14.us-west-2.compute.internal	5m	32Mi	0	0Ki"
        echo "kube-system	ip-10-1-1-15.us-west-2.compute.internal	500m	256Mi	0	0Ki"
        echo "kube-system	ip-16-1-1-11.us-west-2.compute.internal	500m	256Mi	0	0Ki"
    fi

    if [ "${KUBECTL_CONTEXT}" == "cluster-big" ]; then 
        echo "default	ip-10-1-1-10.us-west-2.compute.internal	10m	0Ki	0	0Ki"
        echo "default	ip-10-1-1-11.us-west-2.compute.internal	10m	0Ki	0	0Ki"
        echo "default	ip-10-1-1-10.us-west-2.compute.internal	0	0Ki	0	0Ki"
        echo "kube-system	ip-10-1-1-12.us-west-2.compute.internal	10m	0Ki	0	0Ki"
        echo "kube-system	ip-10-1-1-12.us-west-2.compute.internal	50m	300Mi	0	0Ki"
        echo "kube-system	ip-10-1-1-14.us-west-2.compute.internal	100m	70Mi	0	0Ki"
        echo "kube-system	ip-10-1-1-15.us-west-2.compute.internal	100m	0Ki	0	0Ki"
        echo "kube-system	ip-10-1-1-15.us-west-2.compute.internal	5m	32Mi	0	0Ki"
        echo "qa	ip-10-1-1-15.us-west-2.compute.internal	2	1G	0	0Ki"
        echo "kube-system	ip-10-1-1-16.us-west-2.compute.internal	5m	32Mi	0	0Ki"
        echo "monitoring	ip-10-1-1-16.us-west-2.compute.internal	500m	256Mi	0	0Ki"
        echo "monitoring	ip-10-1-1-10.us-west-2.compute.internal	500m	256Mi	0	0Ki"
        echo "default	ip-10-1-12.us-west-2.compute.internal	0	0Ki	0	0Ki"
        echo "qa	ip-10-1-1-14.us-west-2.compute.internal	2	1G	0	0Ki"
        echo "qa	ip-10-1-1-15.us-west-2.compute.internal	2	1G	0	0Ki"
        echo "dev	ip-10-1-1-16.us-west-2.compute.internal	2	3G	0	0Ki"
        echo "dev	ip-10-1-1-17.us-west-2.compute.internal	2	3G	0	0Ki"
        echo "qa	ip-10-1-1-18.us-west-2.compute.internal	2	4G	0	0Ki"
        echo "qa	ip-10-1-1-19.us-west-2.compute.internal	2	4G	0	0Ki"
        echo "qa	ip-10-1-1-20.us-west-2.compute.internal	3	5G	0	0Ki"
        echo "qa	ip-10-1-1-21.us-west-2.compute.internal	3	5G	0	0Ki"
        echo "qa	ip-10-1-1-22.us-west-2.compute.internal	3	7G	0	0Ki"
        echo "qa	ip-10-1-1-23.us-west-2.compute.internal	3	7G	0	0Ki"
        echo "stg	ip-10-1-1-24.us-west-2.compute.internal	2	8G	0	0Ki"
        echo "stg	ip-10-1-1-25.us-west-2.compute.internal	2	8G	0	0Ki"
        echo "stg	ip-10-1-1-26.us-west-2.compute.internal	2	8G	0	0Ki"
        echo "stg	ip-10-1-1-27.us-west-2.compute.internal	2	8G	0	0Ki"
        echo "stg	ip-10-1-1-28.us-west-2.compute.internal	2	8G	0	0Ki"
        echo "stg	ip-10-1-1-29.us-west-2.compute.internal	2	8G	0	0Ki"
        echo "qa	ip-10-1-1-30.us-west-2.compute.internal	4	5G	0	0Ki"
        echo "qa	ip-10-1-1-31.us-west-2.compute.internal	4	5G	0	0Ki"
        echo "dev	ip-10-1-1-32.us-west-2.compute.internal	4	5G	0	0Ki"
        echo "dev	ip-10-1-1-33.us-west-2.compute.internal	4	5G	0	0Ki"
        echo "dev	ip-10-1-1-34.us-west-2.compute.internal	4	5G	0	0Ki"
        echo "dev	ip-10-1-1-35.us-west-2.compute.internal	4	5G	0	0Ki"
        echo "qa	ip-10-1-1-36.us-west-2.compute.internal	6	4G	0	0Ki"
        echo "qa	ip-10-1-1-37.us-west-2.compute.internal	6	4G	0	0Ki"
        echo "dev	ip-10-1-1-38.us-west-2.compute.internal	6	4G	0	0Ki"
        echo "stg	ip-10-1-1-40.us-west-2.compute.internal	6	4G	0	0Ki"
        echo "stg	ip-10-1-1-42.us-west-2.compute.internal	6	4G	0	0Ki"
        echo "stg	ip-10-1-1-41.us-west-2.compute.internal	6	4G	0	0Ki"
    fi
}
