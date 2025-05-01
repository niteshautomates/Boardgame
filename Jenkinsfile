pipeline {
    agent any
    tools {
        maven 'maven'
        jdk 'jdk17'
    }
    environment {
        SONAR_SCANNER_HOME = tool 'SonarQube'
    }
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'develop', url: 'https://github.com/niteshautomates/Boardgame.git'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                script {
                    withSonarQubeEnv('SonarQube') {
                        sh '''
                        ${SONAR_SCANNER_HOME}/bin/sonar-scanner -Dsonar.projectKey=Boardgame -Dsonar.sources=. 
                        '''
                    }
                }
            }
        }
        stage("Quality Gate") {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token'
                }
            }
        }
        stage('Trivy File Scan') {
            steps {
                sh 'trivy fs --format table -o trivy_results.txt .'
            }
        }
        stage("Docker Build & Push") {
            steps {
                script {
                    // This step should not normally be used in your script. Consult the inline help for details.
                    withDockerRegistry(credentialsId: 'docker-token', toolName: 'docker') {
                        sh "docker build -t boardgame ."
                        sh "docker tag boardgame nitesh2611/boardgame:latest "
                        sh "docker push nitesh2611/boardgame:latest "
                    }
                }
            }
        }
        stage("Trivy Image Scan") {
            steps {
                sh "trivy image -f table -o img_scan_report.txt nitesh2611/boardgame:latest"
            }
        }
        stage('Deploy to container') {
            steps {
                sh 'docker run -d --name hotstar -p 8282:8080 nitesh2611/boardgame:latest'
            }
        }
    }
}

