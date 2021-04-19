if [[ $# -eq 0 ]]; then
    echo 'usage:\n    . ./import_csv_to_ch.sh path_to_big_csv_file "sql_string_for_import_to_ch" port_of_clickhouse_server'
    echo '\nexample:\n  . ./import_csv_to_ch.sh a.csv "SELECT trip_id,pickup_datetime from trips_lite_n10m" 9528'
    echo '\nnote:\n     the bin (or link to) "clickhouse-client" is assumed on your shell path'
else
    file=$1
    query=$2
    port=$3

    echo "file: ${file}"
    echo "query: ${query}"
    echo "port: ${port}"

    ncpus=$(grep -c ^processor /proc/cpuinfo)

    #echo "to run: cat ${file} | parallel --dry-run -j ${ncpus} --pipe --block 100M clickhouse-client --query='\""${query}"\"'"
    SECONDS=0;
    eval "cat ${file} | parallel -j ${ncpus} --pipe --block 100M clickhouse-client --port \"${port}\" --query='\""${query}"\"'"

    # rm x*
    echo "importing done in $SECONDS seconds."
fi
