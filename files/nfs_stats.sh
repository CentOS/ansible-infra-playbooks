#!/usr/bin/env bash
set -e

HOSTNAME=$(hostname)

function generate_avg_rtt_read() {
  for i in $(nfsiostat | grep -A 1 "read:" | grep -v "read:\|--" | awk '{ print $6 }'); do
    nfs_read_array+=($i)
  done
}

function generate_avg_rtt_write() {
  for i in $(nfsiostat | grep -A 1 "write:" | grep -v "write:\|--" | awk '{ print $6 }'); do
    nfs_write_array+=($i)
  done
}

function generate_nfs_info() {
  nfsiostat | grep nfs02 | sed 's/://g' | \
  {
  while read i; do
    x=$(awk '{ print $1; }' <<< $i)
    y=$(awk '{ print $4; }' <<< $i)
    nfs_exports_array+=($x)
    nfs_mounts_array+=($y)
  done

  if [ ${#nfs_read_array[@]} -eq 0 ]; then
    exit 0
  fi

  # ${#array[@]} is the number of elements in the array
  for ((i = 0; i < ${#nfs_read_array[@]}; ++i)); do
    # bash arrays are 0-indexed
    position=$(( $i + 1 ))
    echo "nfs_avg_rtt_read{instance=\"$HOSTNAME\",export=\"${nfs_exports_array[$i]}\",mount=\"${nfs_mounts_array[$i]}\"} ${nfs_read_array[$i]}"
    echo "nfs_avg_rtt_write{instance=\"$HOSTNAME\",export=\"${nfs_exports_array[$i]}\",mount=\"${nfs_mounts_array[$i]}\"} ${nfs_write_array[$i]}"
  done
  }
}

generate_avg_rtt_read
generate_avg_rtt_write
generate_nfs_info

exit 0
