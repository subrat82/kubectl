## Docker image with Kubectl
`[kubectl](https://kubernetes.io/docs/user-guide/kubectl-overview/)` is a command line interface for running commands against Kubernetes clusters. 

This image is for CI/CD in [Kubernetes](https://kubernetes.io/).

## Usage
This image should be used insight of a pod to execute kubectl commands.

Note: Entrypoint is set to sh

### Usage in Jenkins pipeline

For example multibranch pipeline to access a local Kubernetes cluster, build and deploy your nodejs docker image:

``` [groovy]
def image = "registryserver:5000/appname:${env.BRANCH_NAME}-${env.BUILD_ID}"

podTemplate(cloud: 'k8sClusterLabel' ,label: 'docker',
  containers: [
    containerTemplate(name: 'docker', image: 'docker:git', ttyEnabled: true, command: 'cat'),
    containerTemplate(name: 'nodejs', image: 'node:6-onbuild', ttyEnabled: true, command: 'cat'),
    containerTemplate(name: 'kubectl', image: 'amaceog/kubectl', ttyEnabled: true, command: 'cat')
  ],
  volumes: [
    hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock'),
  ]) {
  node('docker') {
    gitlabCommitStatus(name: 'jenkins') {
      stage('Build Docker image') {
        git credentialsId: 'app-credential-Id-to-clone', url: 'ssh://git@url.for.app.git'
        container('nodejs') {
          sh '''
            npm install
          '''
        }

        container('docker') { 
          sh "docker build --no-cache -t ${image} ."
        }
      }
      stage('Push Image to Registry'){
        withCredentials([usernamePassword(credentialsId: 'registry-push-credential', passwordVariable: 'DOCKER_PASSWD', usernameVariable: 'DOCKER_USER')]) {
          container('docker') {
            sh '''
            echo ${DOCKER_PASSWD} |docker login -u ${DOCKER_USER} --password-stdin registryserver:5000
              '''
            sh "docker push ${image} && docker rmi ${image}"    
          }
        }
      }
      switch (env.BRANCH_NAME) {
        case "master":
          container('kubectl') {
            sh "kubectl --namespace=production set image deployment/app-deployment ${image}"
          }
        default:
          container('kubectl') {
            sh "kubectl --namespace=qa set image deployment/app-deployment ${image}"
          }
      }
    }
  }
}
```
