pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = "192.168.49.2:5000"
        IMAGE_NAME = 'testjenkins'
        IMAGE_TAG = "latest"
    }

    stages {
        stage('Build') {
            steps {
                script {
                    // Clonar el repositorio y construir el proyecto
                    sh 'mvn clean package -DskipTests'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry("http://${DOCKER_REGISTRY}") {
                        docker.image("${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}").push()
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Aplicar el archivo de despliegue de Kubernetes
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
