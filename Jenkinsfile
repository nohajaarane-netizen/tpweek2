
pipeline {
    // Jenkins exécute le pipeline sur un agent disponible
    agent any

    // Arrêter les étapes suivantes si les tests deviennent UNSTABLE
    options {
        skipStagesAfterUnstable()
    }

    // Variable utilisée dans plusieurs étapes
    environment {
        APP_NAME = 'tpweek2'
    }

    stages {

        // ÉTAPE 1 : Récupérer le code depuis GitHub
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        // ÉTAPE 2 : Vérifier les fichiers du projet
        stage('Build') {
            steps {
                // Afficher le nom de l'application
                echo "Build de ${APP_NAME}"

                // Afficher les fichiers dans le dossier Jenkins
                sh 'ls -la'
            }
        }

        // ÉTAPE 3 : Exécuter les tests automatiques
        stage('Test') {
            steps {
                // Lancer notre script Bash de tests
                sh 'bash scripts/test.sh'
            }

            post {
                always {
                    // Publier le rapport JUnit,
                    // même si les tests échouent nn nnnkkkkk
                    junit 'reports/results.xml'
                }
            }
        }

        // ÉTAPE 4 : Créer une archive du projet
        stage('Package') {
            steps {
                // Compresser les fichiers principaux
                // dans une archive .tar.gz
                sh 'tar -czf $APP_NAME-$BUILD_NUMBER.tar.gz server.js package.json README.md'

                // Conserver l'archive dans Jenkins
                archiveArtifacts artifacts: "${APP_NAME}-${BUILD_NUMBER}.tar.gz", fingerprint: true
            }
        }

        // ÉTAPE 5 : Construire l'image Docker
        stage('Build Docker') {
            steps {
                script {
                    // Récupérer les 12 premiers caractères
                    // du SHA du commit Git
                    env.IMAGE_TAG = sh(
                        script: 'git rev-parse --short=12 HEAD',
                        returnStdout: true
                    ).trim()
                }

                // Construire l'image Docker
                // Exemple : tpweek2:96d22a4fc70a
                sh 'docker build -t tpweek2:$IMAGE_TAG .'
            }
        }

        // ÉTAPE 6 : Publier l'image sur Docker Hub
        stage('Publish Docker Hub') {
            steps {

                // Récupérer les identifiants stockés
                // de manière sécurisée dans Jenkins
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-login',
                        usernameVariable: 'DH_USER',
                        passwordVariable: 'DH_TOKEN'
                    )
                ]) {
                    sh '''
                        # Donner à l'image le nom Docker Hub
                        docker tag tpweek2:$IMAGE_TAG $DH_USER/tpweek2:$IMAGE_TAG

                        # Se connecter avec le jeton secret
                        echo "$DH_TOKEN" | docker login -u "$DH_USER" --password-stdin

                        # Envoyer l'image vers Docker Hub
                        docker push $DH_USER/tpweek2:$IMAGE_TAG

                        # Se déconnecter de Docker Hub
                        docker logout
                    '''
                }
            }
        }
    }
}
