pipeline {
    agent any
    environment {
        ECR_HOST        = "584896334638.dkr.ecr.ap-southeast-1.amazonaws.com"
        ECR_REPOSITORY  = "feature"
        ECR_TAG         = "amp-dutaplay"

        APP_ENV         = "Prod"
        APP_NAME        = "AMP-Dutaplay"

        DOCKER_TAG      = "$ECR_HOST/$ECR_REPOSITORY:$ECR_TAG"
    }

    stages {        
		stage("Get git information") {
            steps {
                script {
                    env.GIT_COMMIT_MSG = sh (script: 'git log -1 --pretty=%B ${GIT_COMMIT}', returnStdout: true).trim()
                    env.GIT_COMMITTER = sh (script: 'git show -s --pretty=%an', returnStdout: true).trim()
                }
            }
        }
        stage("Telegram message: building") {
            steps {
                script {
                    withCredentials([string(credentialsId: "telegramToken", variable: "TOKEN"),
                    string(credentialsId: "telegramChatID", variable: "CHAT_ID")]) {
                        sh """
                        curl -s -X POST https://api.telegram.org/bot${TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d parse_mode="HTML" -d text="[$APP_ENV] [<b>$APP_NAME</b>]%0abuilding app...%0a%0a%22$GIT_COMMIT_MSG%22%0a-$GIT_COMMITTER"
                        """
                    }
                }
            }
        }
        stage("Build & Publish") {
            steps {
                sh "sudo docker build -t $DOCKER_TAG ."
                sh "aws ecr get-login-password --region ap-southeast-1 | sudo docker login --username AWS --password-stdin $ECR_HOST"
                sh "sudo docker push $DOCKER_TAG"
                sh "sudo docker image rm $DOCKER_TAG"
                sh "sudo docker image prune -f"
                sh "sudo docker system prune -f"
            }
        }
		stage("Telegram message: deploying") {
            steps {
                script {
                    withCredentials([string(credentialsId: "telegramToken", variable: "TOKEN"),
                    string(credentialsId: "telegramChatID", variable: "CHAT_ID")]) {
                        sh """
                        curl -s -X POST https://api.telegram.org/bot${TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d parse_mode="HTML" -d text="[$APP_ENV] [<b>$APP_NAME</b>]%0adeploying app..."
                        """
                    }
                }
            }
        }
        stage("Deploy") {
            steps {
                sh "ssh -i /var/lib/jenkins/LAGaming.pem admin@172.31.19.193 'sudo sh /home/admin/feature/autodeploy-amp-dutaplay.sh'"
            }
        }
		stage("Telegram message: deployed") {
            steps {
                script {
                    withCredentials([string(credentialsId: "telegramToken", variable: "TOKEN"),
                    string(credentialsId: "telegramChatID", variable: "CHAT_ID")]) {
                        sh """
                        curl -s -X POST https://api.telegram.org/bot${TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d parse_mode="HTML" -d text="[$APP_ENV] [<b>$APP_NAME</b>]%0aDeployed..."
                        """
                    }
                }
            }
        }
	}
	post {
        failure {
            script {
                withCredentials([string(credentialsId: "telegramToken", variable: "TOKEN"),
                string(credentialsId: "telegramChatID", variable: "CHAT_ID")]) {
                    sh """
                    curl -s -X POST https://api.telegram.org/bot${TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d parse_mode="HTML" -d text="[$APP_ENV] [<b>$APP_NAME</b>]%0aFAILED!"
                    """
                }
            }
        }
    }
}
