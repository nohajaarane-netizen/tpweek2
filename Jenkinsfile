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
                echo "Build de ${env.APP_NAME}, numero ${env.BUILD_NUMBER}"
                sh 'ls -la'
            }
        }
        stage('Test') {
            steps {
                sh '''
                    mkdir -p reports
                    tests=0
                    fail=0
                    cases=""
                    check() {
                        tests=$((tests+1))
                        if sh -c "$2" > /dev/null 2>&1; then
                            cases="$cases<testcase classname='tpweek2' name='$1'/>"
                        else
                            fail=$((fail+1))
                            echo "ECHEC : $1"
                            cases="$cases<testcase classname='tpweek2' name='$1'><failure message='echec'/></testcase>"
                        fi
                    }
                    check "server.js existe" "test -f server.js"
                    check "le serveur ecoute sur 3000" "grep -q 'listen(3000' server.js"
                    check "package.json contient express" "grep -q express package.json"
                    echo "<testsuite name='tpweek2' tests='$tests' failures='$fail'>$cases</testsuite>" > reports/results.xml
                    echo "$tests tests, $fail echec(s)"
                    test "$fail" -eq 0
                '''
            }
            post {
                always {
                    junit 'reports/results.xml'
                }
            }
        }
        stage('Package') {
            steps {
                sh 'tar -czf $APP_NAME-$BUILD_NUMBER.tar.gz server.js package.json README.md' // creer archive
                archiveArtifacts artifacts: "${env.APP_NAME}-${env.BUILD_NUMBER}.tar.gz", fingerprint: true // Conserver l'archive dans Jenkins
            }
                
                
        stage('Credentials') {
            steps {
                withCredentials([string(credentialsId: 'github-token', variable: 'GH_TOKEN')]) {
                    sh 'curl -s -o /dev/null -w "GitHub API : %{http_code}\n" -H "Authorization: Bearer $GH_TOKEN" https://api.github.com/user'
                }
            }
        }    
        }
    }
}