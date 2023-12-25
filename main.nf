docker {
    enabled = true
}

process {
    executor = 'local'
    cpus = 2
    memory = '4 GB'
    time = '4h' // Adjust time as per the process requirements
}

params {
    // Add other parameters here
    genomeIndex = '/path/to/genome/index' // Genome index path for STAR
    annotationFile = '/path/to/annotation.gtf' // Annotation file path for featureCounts
}

// Add any custom profiles or docker image specifications if required
profiles {
    standard {
        process.container = 'your_docker_image' // Specify your Docker image
    }
}
