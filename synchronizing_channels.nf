#!/usr/bin/env nextflow

params.input = "${baseDir}/data/sync_files/*"

input_files = Channel
                .fromPath(params.input)
                .map { file -> tuple(file.baseName, file) }


input_files.into { input_files_left; input_files_right }

process leftProc {

    input:
    set datasetID, file(datasetFile) from input_files_left

    output:
    set datasetID, file("${datasetID}_left.txt") into left_proc_out

    """
    head -1 ${datasetFile} > ${datasetID}_left.txt
    """
}

process rightProc {

    input:
    set datasetID, file(datasetFile) from input_files_right

    output:
    set datasetID, file("${datasetID}_right.txt") into right_proc_out

    """
    tail -1 ${datasetFile} > ${datasetID}_right.txt
    """
}

comb_ch = left_proc_out 
            .phase(right_proc_out)
            .map { left, right -> tuple(left[0], left[1], right[1]) }

process mergeAndPrint {

    input:
    set pair_id, file(left_file), file(right_file) from comb_ch

    output:
    stdout result

    """
    echo "${pair_id} ${left_file} ${right_file}"
    cat ${left_file} ${right_file}
    """
}

result.subscribe { println it }


