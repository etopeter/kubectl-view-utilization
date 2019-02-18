#!/bin/env bash

switch_context() {
    kubectl config use-context $1
    run kubectl config current-context
    echo "context= ${output}"
    [ $status -eq 0 ]
    [[ "${lines[0]}" == "${1}" ]]
}

setup() {
  export TMP="$BATS_TEST_DIRNAME/tmp"
}

teardown() {
  [ -d "$TMP" ] && rm -f "$TMP"/*
}

function awk() {
    /usr/bin/$VIEW_UTILIZATION_AWK "$@"
}

function use_awk() {
    VIEW_UTILIZATION_AWK="${1}"
}
