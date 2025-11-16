pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "memorieso/java-app"        // Docker Hub repo
        DOCKER_CREDENTIALS = "dockerhub-creds"     // Jenkins credentials ID
        GIT_CREDENTIALS = "githubtoken"            // GitHub credentials ID
        IMAGE_TAG = ""                              // Initialize globally
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/IRUALBINO/javaApp.git', credentialsId: "${GIT_CREDENTIALS}"
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn -B clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    env.IMAGE_TAG = "${env.BUILD_NUMBER}"  // Set globally
                    sh """
                       docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} .
                    """
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh """
                            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                            docker push ${DOCKER_IMAGE}:${IMAGE_TAG}
                            docker tag ${DOCKER_IMAGE}:${IMAGE_TAG} ${DOCKER_IMAGE}:latest
                            docker push ${DOCKER_IMAGE}:latest
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Build SUCCESS: Pushed Docker image ${DOCKER_IMAGE}:${IMAGE_TAG}"
        }
        failure {
            echo "❌ Build FAILED. Check logs."
        }
    }
}
