node {
    // fetch source
    stage 'Checkout'

    checkout scm

    // build image
    stage 'Build'

    def imagename = newImageTag('bccvl/bccvlbase')
    def img = docker.build(imagename)

    // publish image to registry
    stage 'Publish'

    img.push()

    slackSend color: 'good', message: "New Image ${imagename}\n${env.JOB_URL}"
}

