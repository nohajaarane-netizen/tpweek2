pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                echo 'Build de tpweek2'
                sh 'ls -la'
            }
        }
        stage('Info') {
            steps {
                echo 'Cette etape vient de mon Jenkinsfile'
            }
        }
    }
}