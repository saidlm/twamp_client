#!/bin/bash
#
# METIS perfSONAR twping wrapper for TWAMP measurements
#
# Release 1.9.0
#
# Bartlomiej Kos, bartlomiej.kos@t-mobile.pl / NWI-ITI / GTS Poland
# Martin Saidl, martin.saidl@t-mobile.cz / NWI-ITI / GTS Czech Republic
# Andreas Laudwein, andreas.laudwein@telekom.de / NWI-ITI
#

###
### PRE-RUN
###

### DEBUG
# set -x

### ENVIRONMENTALS

PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

### VARIABLES

_test_source1=""

###
### FUNCTIONS
###

get_return_value1() { return_value1=${?}; }

run_test1() { result1=$(timeout -k5s 40s twping -M -Z -D ${_test_dscp1} ${_test_target1} 2>&1); get_return_value1; }

process_result1()
{
output_oneliner1="{\"measurement_name\":\"twamp_twping1\""

case ${return_value1} in
0)
 # from_host1="${result1/*FROM_HOST[[:space:]]/}"
 # from_host1="${from_host1%%[[:space:]]*}"
 output_oneliner1="${output_oneliner1},\"from_host\":\"${_test_source1}\""

 from_addr1="${result1/*FROM_ADDR[[:space:]]/}"
 from_addr1="${from_addr1%%[[:space:]]*}"
 output_oneliner1="${output_oneliner1},\"from_addr\":\"${from_addr1}\""

 to_host1="${result1/*TO_HOST[[:space:]]/}"
 to_host1="${to_host1%%[[:space:]]*}"
 output_oneliner1="${output_oneliner1},\"to_host\":\"${to_host1}\""

 to_addr1="${result1/*TO_ADDR[[:space:]]/}"
 to_addr1="${to_addr1%%[[:space:]]*}"
 output_oneliner1="${output_oneliner1},\"to_addr\":\"${to_addr1}\""

 dscp1="${result1/*DSCP[[:space:]]/}"
 dscp1="${dscp1%%[[:space:]]*}"
 dscp1=$((16#${dscp1/0x/}))
 output_oneliner1="${output_oneliner1},\"dscp_dec\":${dscp1}"

 duplicates_fwd1="${result1/*DUPS_FWD[[:space:]]/}"
 duplicates_fwd1="${duplicates_fwd1%%[[:space:]]*}"
 output_oneliner1="${output_oneliner1},\"duplicates_fwd_pkt\":${duplicates_fwd1}"

 duplicates_bck1="${result1/*DUPS_BCK[[:space:]]/}"
 duplicates_bck1="${duplicates_bck1%%[[:space:]]*}"
 output_oneliner1="${output_oneliner1},\"duplicates_bck_pkt\":${duplicates_bck1}"

 sent1="${result1/*SENT[[:space:]]/}"
 sent1="${sent1%%[[:space:]]*}"
 output_oneliner1="${output_oneliner1},\"sent_pkt\":${sent1}"

 lost1="${result1/*LOST[[:space:]]/}"
 lost1="${lost1%%[[:space:]]*}"
 output_oneliner1="${output_oneliner1},\"lost_pkt\":${lost1}"

 if [[ ${result1} =~ MAXERR ]]; then
  error_rtt1="${result1/*MAXERR[[:space:]]/}"
  error_rtt1="${error_rtt1%%[[:space:]]*}"
  output_oneliner1="${output_oneliner1},\"measurement_error_rtt_seconds\":${error_rtt1}"
 else
  output_oneliner1="${output_oneliner1},\"measurement_error_rtt_seconds\":null"
 fi
 if [[ ${result1} =~ MAXERR_FWD ]]; then
  error_fwd1="${result1/*MAXERR_FWD[[:space:]]/}"
  error_fwd1="${error_fwd1%%[[:space:]]*}"
  output_oneliner1="${output_oneliner1},\"measurement_error_fwd_seconds\":${error_fwd1}"
 else
  output_oneliner1="${output_oneliner1},\"measurement_error_fwd_seconds\":null"
 fi
 if [[ ${result1} =~ MAXERR_BCK ]]; then
  error_bck1="${result1/*MAXERR_BCK[[:space:]]/}"
  error_bck1="${error_bck1%%[[:space:]]*}"
  output_oneliner1="${output_oneliner1},\"measurement_error_bck_seconds\":${error_bck1}"
 else
  output_oneliner1="${output_oneliner1},\"measurement_error_bck_seconds\":null"
 fi
 if [[ ${result1} =~ MIN[[:space:]] ]]; then
  min_rtt1="${result1/*MIN[[:space:]]/}"
  min_rtt1="${min_rtt1%%[[:space:]]*}"
  output_oneliner1="${output_oneliner1},\"min_rtt_seconds\":${min_rtt1}"
 else
  output_oneliner1="${output_oneliner1},\"min_rtt_seconds\":null"
 fi
 if [[ ${result1} =~ MIN_FWD ]]; then
  min_latency_fwd1="${result1/*MIN_FWD[[:space:]]/}"
  min_latency_fwd1="${min_latency_fwd1%%[[:space:]]*}"
  output_oneliner1="${output_oneliner1},\"min_latency_fwd_seconds\":${min_latency_fwd1}"
 else
  output_oneliner1="${output_oneliner1},\"min_latency_fwd_seconds\":null"
 fi
 if [[ ${result1} =~ MIN_BCK ]]; then
  min_latency_bck1="${result1/*MIN_BCK[[:space:]]/}"
  min_latency_bck1="${min_latency_bck1%%[[:space:]]*}"
  output_oneliner1="${output_oneliner1},\"min_latency_bck_seconds\":${min_latency_bck1}"
 else
  output_oneliner1="${output_oneliner1},\"min_latency_bck_seconds\":null"
 fi
 if [[ ${result1} =~ MAX[[:space:]] ]]; then
  max_rtt1="${result1/*MAX[[:space:]]/}"
  max_rtt1="${max_rtt1%%[[:space:]]*}"
  output_oneliner1="${output_oneliner1},\"max_rtt_seconds\":${max_rtt1}"
 else
  output_oneliner1="${output_oneliner1},\"max_rtt_seconds\":null"
 fi
 if [[ ${result1} =~ MAX_FWD ]]; then
  max_latency_fwd1="${result1/*MAX_FWD[[:space:]]/}"
  max_latency_fwd1="${max_latency_fwd1%%[[:space:]]*}"
  output_oneliner1="${output_oneliner1},\"max_latency_fwd_seconds\":${max_latency_fwd1}"
 else
  output_oneliner1="${output_oneliner1},\"max_latency_fwd_seconds\":null"
 fi
 if [[ ${result1} =~ MAX_BCK ]]; then
  max_latency_bck1="${result1/*MAX_BCK[[:space:]]/}"
  max_latency_bck1="${max_latency_bck1%%[[:space:]]*}"
  output_oneliner1="${output_oneliner1},\"max_latency_bck_seconds\":${max_latency_bck1}"
 else
  output_oneliner1="${output_oneliner1},\"max_latency_bck_seconds\":null"
 fi
 if [[ ${result1} =~ MEDIAN ]]; then
  median_rtt1="${result1/*MEDIAN[[:space:]]/}"
  median_rtt1="${median_rtt1%%[[:space:]]*}"
  output_oneliner1="${output_oneliner1},\"median_rtt_seconds\":${median_rtt1}"
 else
  output_oneliner1="${output_oneliner1},\"median_rtt_seconds\":null"
 fi
 if [[ ${result1} =~ MEDIAN_FWD ]]; then
  median_latency_fwd1="${result1/*MEDIAN_FWD[[:space:]]/}"
  median_latency_fwd1="${median_latency_fwd1%%[[:space:]]*}"
  output_oneliner1="${output_oneliner1},\"median_latency_fwd_seconds\":${median_latency_fwd1}"
 else
  output_oneliner1="${output_oneliner1},\"median_latency_fwd_seconds\":null"
 fi
 if [[ ${result1} =~ MEDIAN_BCK ]]; then
  median_latency_bck1="${result1/*MEDIAN_BCK[[:space:]]/}"
  median_latency_bck1="${median_latency_bck1%%[[:space:]]*}"
  output_oneliner1="${output_oneliner1},\"median_latency_bck_seconds\":${median_latency_bck1}"
 else
  output_oneliner1="${output_oneliner1},\"median_latency_bck_seconds\":null"
 fi
 if [[ ${result1} =~ PDV ]]; then
  jitter_rt1="${result1/*PDV[[:space:]]/}"
  jitter_rt1="${jitter_rt1%%[[:space:]]*}"
  output_oneliner1="${output_oneliner1},\"jitter_rt_seconds\":${jitter_rt1}"
 else
  output_oneliner1="${output_oneliner1},\"jitter_rt_seconds\":null"
 fi
 if [[ ${result1} =~ PDV_FWD ]]; then
  jitter_fwd1="${result1/*PDV_FWD[[:space:]]/}"
  jitter_fwd1="${jitter_fwd1%%[[:space:]]*}"
  output_oneliner1="${output_oneliner1},\"jitter_fwd_seconds\":${jitter_fwd1}"
 else
  output_oneliner1="${output_oneliner1},\"jitter_fwd_seconds\":null"
 fi
 if [[ ${result1} =~ PDV_BCK ]]; then
  jitter_bck1="${result1/*PDV_BCK[[:space:]]/}"
  jitter_bck1="${jitter_bck1%%[[:space:]]*}"
  output_oneliner1="${output_oneliner1},\"jitter_bck_seconds\":${jitter_bck1}"
 else
  output_oneliner1="${output_oneliner1},\"jitter_bck_seconds\":null"
 fi
 if [[ ${result1} =~ MINTTL_FWD ]]; then
  minttl_fwd1="${result1/*MINTTL_FWD[[:space:]]/}"
  minttl_fwd1="${minttl_fwd1%%[[:space:]]*}"
  minttl_fwd1=$((255 - ${minttl_fwd1}))
  output_oneliner1="${output_oneliner1},\"min_hops_fwd\":${minttl_fwd1}"
 else
  output_oneliner1="${output_oneliner1},\"min_hops_fwd\":null"
 fi
 if [[ ${result1} =~ MINTTL_BCK ]]; then
  minttl_bck1="${result1/*MINTTL_BCK[[:space:]]/}"
  minttl_bck1="${minttl_bck1%%[[:space:]]*}"
  minttl_bck1=$((255 - ${minttl_bck1}))
  output_oneliner1="${output_oneliner1},\"min_hops_bck\":${minttl_bck1}"
 else
  output_oneliner1="${output_oneliner1},\"min_hops_bck\":null"
 fi
 if [[ ${result1} =~ MAXTTL_FWD ]]; then
  maxttl_fwd1="${result1/*MAXTTL_FWD[[:space:]]/}"
  maxttl_fwd1="${maxttl_fwd1%%[[:space:]]*}"
  maxttl_fwd1=$((255 - ${maxttl_fwd1}))
  output_oneliner1="${output_oneliner1},\"max_hops_fwd\":${maxttl_fwd1}"
 else
  output_oneliner1="${output_oneliner1},\"max_hops_fwd\":null"
 fi
 if [[ ${result1} =~ MAXTTL_BCK ]]; then
  maxttl_bck1="${result1/*MAXTTL_BCK[[:space:]]/}"
  maxttl_bck1="${maxttl_bck1%%[[:space:]]*}"
  maxttl_bck1=$((255 - ${maxttl_bck1}))
  output_oneliner1="${output_oneliner1},\"max_hops_bck\":${maxttl_bck1}"
 else
  output_oneliner1="${output_oneliner1},\"max_hops_bck\":null"
 fi

 output_oneliner1="${output_oneliner1},\"reachable_bool\":1"
 output_oneliner1="${output_oneliner1}}"
 ;;
*)
 output_oneliner1="${output_oneliner1},\"from_host\":\"${_test_source1}\",\"to_host\":\"${_test_target1}\""
 output_oneliner1="${output_oneliner1},\"reachable_bool\":0"
 output_oneliner1="${output_oneliner1}}"
 ;;
esac
}

send_result1()
{
curl --connect-timeout 15 -m 10 -s -k -X POST -H "Content-Type: application/json" -H "Authorization: Basic ${_result_delivery_auth_string1}" -d "${output_oneliner1}" ${_result_delivery_url1}
}

set_test_source_name1()
{
if [ "${_test_source1}" = "" ]; then _test_source1="$(hostname -f)"; fi
}

###
### LOOPS
###

while getopts "t:q:d:a:s:" _options1; do
 case ${_options1} in
 t)
  _test_target1="${OPTARG}"
  ;;
 q)
  if ! [[ ${OPTARG} =~ ^[0-9]+$ ]]; then echo "Error: Integer value expected."; exit 1; fi
  _test_dscp1="${OPTARG}"
  ;;
 d)
  _result_delivery_url1="${OPTARG}"
  ;;
 a)
  _result_delivery_auth_string1="${OPTARG}"
  ;;
 s)
  _test_source1="${OPTARG}"
  ;;
  *)
  exit 1
  ;;
 esac
done

set_test_source_name1

run_test1
process_result1
send_result1

###
### POST-RUN
###

exit ${return_value1}

# EOF
