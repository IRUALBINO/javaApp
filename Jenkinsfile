pipeline {
    agent any

    tools {
        maven 'Maven'
    }

    environment {
        DOCKER_IMAGE = "memorieso/java-app"
        DOCKER_CREDENTIALS = "dockerhub-creds"
        GIT_CREDENTIALS = "githubtoken"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/IRUALBINO/javaApp.git', credentialsId: "${GIT_CREDENTIALS}"
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Verify JAR') {
            steps {
                sh 'ls -lh target || echo "❌ JAR not found!"'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    env.IMAGE_TAG = "${env.BUILD_NUMBER}"
                    sh """
                       echo "✅ Building Docker image with tag: ${IMAGE_TAG}"
                       ls -lh target   # Debug: confirm JAR exists
                       docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} .
                       docker tag ${DOCKER_IMAGE}:${IMAGE_TAG} ${DOCKER_IMAGE}:latest
                    """
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh """
                            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                            docker push ${DOCKER_IMAGE}:${IMAGE_TAG}
                            docker push ${DOCKER_IMAGE}:latest
                        """
                    }
                }
            }
        }

        stage('Deploy to EC2 via Ansible') {
            steps {
                sh '''
                cd ~/ansible-deploy
                ansible-playbook -i hosts.ini deploy-docker.yml
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful!"
        }
        failure {
            echo "❌ Build or Deploy failed."
        }
    }
