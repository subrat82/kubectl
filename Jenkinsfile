def mylabel = "worker-${UUID.randomUUID().toString()}"

pipeline {
  agent {
    kubernetes {
      label mylabel
      defaultContainer 'ubuntu'
      yaml """
        apiversion: v1
        kind: Pod
        metadata:
          labels:
             component: ci
          spec:
            containers:
            - name: ubuntu
              imae: marketplace.gcr.io/google/ubuntu1804
              command:
              - cat
      
       """
         }
  }
  
  stages {
    stage(stage1){
      steps {
        sh 'echo "hello" '
      }
    }
  }
  
  
}
