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
            steps {
                script {
                    // Actualizar el archivo de despliegue con el nuevo tag
                    sh """
                    sed -i 's|image: testjenkins:.*|image: ${DOCKER_REGISTRY}/${IMAGE_FULL_NAME}|' deployment.yaml
                    """

                    sh 'cat deployment.yaml'
                    
                    // Aplicar el despliegue a Minikube
                    sh 'kubectl apply -f deployment.yaml'
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
