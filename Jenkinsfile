pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = "localhost:5000"
        IMAGE_NAME = 'testjenkins'
        COMMIT_HASH = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
        IMAGE_TAG = "${env.BUILD_NUMBER}-${COMMIT_HASH}"
        IMAGE_FULL_NAME = "${IMAGE_NAME}:${IMAGE_TAG}"
    }

    stages {
        stage('Approval') {
            steps {
                script {
                    def approver = input(
                        message: 'Do you want to proceed?',
                        ok: 'Yes',
                        submitter: 'admin'
                    )

                    echo "Approved by: ${approver}"
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_REGISTRY}/${IMAGE_FULL_NAME}")
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry("http://${DOCKER_REGISTRY}") {
                        docker.image("${DOCKER_REGISTRY}/${IMAGE_FULL_NAME}").push()
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
			environment {
                TESTJENKINS_MATER_PASS = credentials('TESTJENKINS_MATER_PASS') // ID de la credencial del secreto
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'TESTJENKINS_MATER_PASS', passwordVariable: 'MASTER_PASS', usernameVariable: 'MASTER_USER')]) {
                    // Ejecuta el script .sh con la credencial en el entorno
                    sh '''
                        #!/bin/bash
                        chmod +x ./scripts/deploy-01-deploy.sh
                        ./scripts/deploy-01-deploy.sh
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Deploy completed successfully!'
        }
        failure {
            echo 'Deploy failed!'
        }
    }
}
