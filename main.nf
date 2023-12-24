#!/usr/bin/env nextflow

params.data = 'data/*.txt' // Example data path

process printFile {
    input:
    file txt from params.data

    script:
    """
    cat $txt
    """
}
