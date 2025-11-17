pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "memorieso/java-app"
        DOCKER_CREDENTIALS = "dockerhub-creds"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/IRUALBINO/javaApp.git'
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    // Build Docker Image
                    sh """
                        docker build -t ${DOCKER_IMAGE}:latest .
                    """

                    // Login & Push to DockerHub
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS, usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh """
                            echo "$PASS" | docker login -u "$USER" --password-stdin
                            docker push ${DOCKER_IMAGE}:latest
                        """
                    }
                }
            }
        }

        stage('Deploy to EC2 via Ansible') {
            steps {
                sh """
                    export ANSIBLE_HOST_KEY_CHECKING=False
                    ansible-playbook -i /var/lib/jenkins/ansible-deploy/hosts.ini \
                                     /var/lib/jenkins/ansible-deploy/deploy-docker.yml
                """
            }
        }
    }

    post {
        success {
            echo "🎉 Deployment Successful!"
        }
        failure {
            echo "❌ Deployment Failed!"
        }
    }
}
