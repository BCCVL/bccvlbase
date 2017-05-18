node ('docker') {

    def imagename
    def img

    // fetch source
    stage('Checkout') {
        checkout scm
    }

    // build image
    stage('Build') {

        withCredentials([string(credentialsId: 'pypi_index_url_prod', variable: 'PYPI_INDEX_URL')]) {
            docker.withRegistry('https://hub.bccvl.org.au', 'hub.bccvl.org.au') {
                imagename = "hub.bccvl.org.au/bccvl/bccvlbase:${dateTag()}"
                img = docker.build(imagename, "--pull --no-cache --build-arg PIP_INDEX_URL=${PYPI_INDEX_URL} . ")
            }
        }

    }

    // publish image to registry
    stage('Publish') {
        docker.withRegistry('https://hub.bccvl.org.au', 'hub.bccvl.org.au') {
            img.push()
        }

        slackSend color: 'good', message: "New Image ${imagename}\n${env.JOB_URL}"
    }
}
