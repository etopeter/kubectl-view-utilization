function awk() {
    /usr/bin/$VIEW_UTILIZATION_AWK "$@"
}

function use_awk() {
    VIEW_UTILIZATION_AWK="${1}"
}
