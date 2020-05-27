properties([
    parameters ([
        string(name: 'BUILD_NODE', defaultValue: 'omar-build', description: 'The build node to run on'),
        booleanParam(name: 'CLEAN_WORKSPACE', defaultValue: true, description: 'Clean the workspace at the end of the run')
    ]),
    pipelineTriggers([
            [$class: "GitHubPushTrigger"]
    ]),
    [$class: 'GithubProjectProperty', displayName: '', projectUrlStr: 'https://github.com/ossimlabs/omar-nifi'],
    buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '3', daysToKeepStr: '', numToKeepStr: '20')),
    disableConcurrentBuilds()
])
podTemplate(
  containers: [
    containerTemplate(
      name: 'docker',
      image: 'docker:19.03.8',
      ttyEnabled: true,
      command: 'cat',
      privileged: true
    ),
    containerTemplate(
      image: "${DOCKER_REGISTRY_DOWNLOAD_URL}/omar-builder:latest",
      name: 'builder',
      command: 'cat',
      ttyEnabled: true
    )
  ],
  volumes: [
    hostPathVolume(
      hostPath: '/var/run/docker.sock',
      mountPath: '/var/run/docker.sock'
    ),
  ]
)
node(POD_LABEL){

    stage("Checkout branch $BRANCH_NAME")
    {
        checkout(scm)
    }

    stage("Load Variables")
    {
        withCredentials([string(credentialsId: 'o2-artifact-project', variable: 'o2ArtifactProject')]) {
            step ([$class: "CopyArtifact",
                projectName: o2ArtifactProject,
                filter: "common-variables.groovy",
                flatten: true])
        }

        load "common-variables.groovy"
    }

    stage ("Publish Docker App")
    {
        container('builder'){
            withCredentials([[$class: 'UsernamePasswordMultiBinding',
                            credentialsId: 'dockerCredentials',
                            usernameVariable: 'DOCKER_REGISTRY_USERNAME',
                            passwordVariable: 'DOCKER_REGISTRY_PASSWORD']])
            {
                // Run all tasks on the app. This includes pushing to OpenShift and S3.
                sh """
                gradle pushDockerImage \
                    -PossimMavenProxy=${MAVEN_DOWNLOAD_URL}
                """
            }
        }
    }
    stage('Docker build') {
      container('docker') {
        withDockerRegistry(credentialsId: 'dockerCredentials', url: "https://${DOCKER_REGISTRY_DOWNLOAD_URL}") {  //TODO
          sh """
            docker build -t "${DOCKER_REGISTRY_PUBLIC_UPLOAD_URL}"/omar-mensa-app:${BRANCH_NAME} ./docker
          """
        }
      }
      stage('Docker push'){
        container('docker') {
          withDockerRegistry(credentialsId: 'dockerCredentials', url: "https://${DOCKER_REGISTRY_PUBLIC_UPLOAD_URL}") {
          sh """
              docker push "${DOCKER_REGISTRY_PUBLIC_UPLOAD_URL}"/omar-mensa-app:${BRANCH_NAME}
          """
          }
        }
      }
    }
    stage("Clean Workspace")
    {
        if ("${CLEAN_WORKSPACE}" == "true")
            step([$class: 'WsCleanup'])
    }
}
