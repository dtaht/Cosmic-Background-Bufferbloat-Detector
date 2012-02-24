# awk program to scan rawstats files and report errors/statistics
#


BEGIN {
    n = 0
    packets = 0
}
{
    packets++
    i = n
    for (j = 0; j < n; j++) {
        if ($3 == peer_ident[j])
            i = j
    }
    if (i == n) {
        peer_ident[i] = $3
        n++
    }
    peer_count[i]++
    peer_recv_delay[i] += $6 - $5
    peer_proc_delay[i] += $7 - $6
    peer_send_delay[i] += $8 - $7
} END {
          #"12345678901234567890123456789012345678901234567890"
    print "Delays (ms)"
    printf "       ident       cnt    recv      send    process\n"
    printf "==========================================================================\n"
    for (i = 0; i < n; i++) {
        peer_recv_delay[i] /= peer_count[i]
        peer_proc_delay[i] /= peer_count[i]
        peer_send_delay[i] /= peer_count[i]
        printf "%-15s  %5d  %2.6f  %2.6f  %2.6f\n", peer_ident[i], peer_count[i], peer_recv_delay[i] * 1e3, peer_send_delay[i] * 1e3, peer_proc_delay[i] * 1e3
    }
}


