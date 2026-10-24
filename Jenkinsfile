pipeline {
    agent any

    environment {
        APP_NAME = 'tpweek2'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo "Build de ${APP_NAME}"
                sh 'ls -la'
            }
        }

        stage('Test') {
            steps {
                sh 'bash scripts/test.sh'
            }
            post {
                always {
                    junit 'reports/results.xml'
                }
            }
        }

        stage('Package') {
            steps {
                sh 'tar -czf $APP_NAME-$BUILD_NUMBER.tar.gz server.js package.json README.md'

                archiveArtifacts artifacts: "${APP_NAME}-${BUILD_NUMBER}.tar.gz", fingerprint: true
            }
        }
    }
}