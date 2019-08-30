#!/bin/bash

switch_context() {
    kubectl config use-context $1
    run kubectl config current-context
    echo "context= ${output}"
    [ $status -eq 0 ]
    [[ "${lines[0]}" == "${1}" ]]
}

function awk() {
    /usr/bin/$VIEW_UTILIZATION_AWK "$@"
}

function use_awk() {
    VIEW_UTILIZATION_AWK="${1}"
}
