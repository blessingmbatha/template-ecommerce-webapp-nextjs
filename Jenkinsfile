pipeline {
       agent any
           tools{
                 jdk 'jdk17'
                 nodejs 'node16'
           }
           environment{
                 SCANNER_HOME=tool 'sonar-scanner'
           }
           stages {
                stage('Cleanup Workspace'){
                    steps {
                        cleanWs()
                    }
                }
                stage('Git Checkout'){
                    steps {
                        git branch: 'main', changelog: false, poll: false, url: 'https://github.com/blessingmbatha/template-ecommerce-webapp-nextjs.git'
                    }
                }
                stage('SonarQube Analysis'){
                    steps {
                        withSonarQubeEnv('sonar-server'){
                                 sh '''$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Ecommerce-Project \
                                      -Dsonar.projectKey=Ecommerce-Project '''
                        }  
                    }
                }
                stage("quality gate"){
                    steps {
                        script {
                             waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token' 
                        }
                    } 
                }
                stage('Install Dependencies') {
                    steps {
                        sh "npm install"
                    }
                }
                stage('TRIVY FS SCAN') {
                    steps {
                        sh "trivy fs . > trivyfs.txt"
                    }
                }
           }
}
