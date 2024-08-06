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
                script {
					
					def masterPass = env.TESTJENKINS_MATER_PASS_PSW
                    
                    // Actualizar el archivo de despliegue con el nuevo tag
                    sh """
                    sed -i 's|image: testjenkins:.*|image: ${DOCKER_REGISTRY}/${IMAGE_FULL_NAME}|' deployment.yaml
                    """

                    sh 'cat deployment.yaml'
                    
                    // Aplicar el despliegue a Minikube
                    sh "kubectl set env deployment/testjenkins JASYPT_ENCRYPTOR_PASSWORD=${masterPass}"

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
