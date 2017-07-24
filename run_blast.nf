#!/usr/bin/env nextflow

params.query = "$baseDir/data/sample.fa"
params.db = "$baseDir/path/to/blast.db"

db = file(params.db)
query = file(params.query)

// Executed when query input is received - on start
process blastSearch {
    input:
    file query

    output:
    file top_hits

    """
    blastp -db ${db} -query $query -outfmt 6 > blast_results
    cat blast_results | head -n 10 | cut -f2 > top_hits
    """
}

// Executed when top_hits channel from blastSearch comes in
process extractTopHits {
    input:
    file top_hits

    output:
    file sequences

    """
    blastdbcmd -db ${db} -entry_batch $top_hits > sequences
    """
}
