pipeline {
       agent any
           tools{
                 jdk 'jdk17'
                 nodejs 'node18'
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
                stage("Sonar quality gate"){
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
                stage('Dependency Check'){
                    steps {
                        dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'OWASP DC'
                        dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
                    }
                }
                stage('TRIVY FS SCAN') {
                    steps {
                        sh "trivy fs . > trivyfs.txt"
                    }
                }
                stage("Docker Build & Push Image"){
                    steps{
                        script{
                              withDockerRegistry(credentialsId: 'docker', toolName: 'docker'){   
                                  sh "docker build -t ecommerce:latest ."
                                  sh "docker tag ecommerce nkosenhlembatha/ecommerce:latest"
                                  sh "docker push nkosenhlembatha/ecommerce:latest"
                              }
                        }
                    }
                }
                stage("Scan Docker Image"){
                    steps{
                        sh "trivy image nkosenhlembatha/ecommerce:latest > trivyimage.txt" 
                    }
                }
                stage('Deploy to container'){
                    steps{
                        sh "docker run -d --name ecommerce4 -p 8081:80 nkosenhlembatha/ecommerce:latest"
                    }
                }
           }
}
