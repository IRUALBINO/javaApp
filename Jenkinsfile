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
               docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} .
               docker tag ${DOCKER_IMAGE}:${IMAGE_TAG} ${DOCKER_IMAGE}:latest
            """
        }
    }
}
