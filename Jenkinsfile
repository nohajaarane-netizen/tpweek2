
pipeline {
    agent any

    options {
        skipStagesAfterUnstable()
    }

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

        stage('Build Docker') {
            steps {
                script {
                    env.IMAGE_TAG = sh(
                        script: 'git rev-parse --short=12 HEAD',
                        returnStdout: true
                    ).trim()
                }

                sh 'docker build -t tpweek2:$IMAGE_TAG .'
            }
        }

        stage('Publish Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-login',
                        usernameVariable: 'DH_USER',
                        passwordVariable: 'DH_TOKEN'
                    )
                ]) {
                    sh '''
                        docker tag tpweek2:$IMAGE_TAG $DH_USER/tpweek2:$IMAGE_TAG
                        echo "$DH_TOKEN" | docker login -u "$DH_USER" --password-stdin
                        docker push $DH_USER/tpweek2:$IMAGE_TAG
                        docker logout
                    '''
                }
            }
        }
    }
}
