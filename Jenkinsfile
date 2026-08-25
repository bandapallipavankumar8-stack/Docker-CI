pipeline {
    agent any

    environment {
        // Your AWS S3 Bucket Name
        S3_BUCKET    = 'code-version'
        PACKAGE_NAME = 'bookstore-package.zip'
        AWS_CREDS_ID = 'aws-credentials-id' // Matches your Jenkins AWS credentials ID
    }

    stages {
        stage('CI: Checkout Code') {
            steps {
                echo 'Pulling application code from GitHub...'
                checkout scm
            }
        }

        stage('CI: Package Application') {
            steps {
                echo 'Compressing core files into a deployment package...'
                sh "zip -r ${PACKAGE_NAME} Dockerfile index.html"
            }
        }

        stage('CI: Upload to AWS S3') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${AWS_CREDS_ID}", 
                                                 usernameVariable: 'AWS_ACCESS_KEY_ID', 
                                                 passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    
                    echo "Uploading package to S3 bucket: ${S3_BUCKET}..."
                    sh "aws s3 cp ${PACKAGE_NAME} s3://${S3_BUCKET}/"
                }
            }
        }

        // ============================================================
        // AUTOMATICALLY TRIGGER CD JOB RIGHT AFTER S3 UPLOAD
        // ============================================================
        stage('CI: Trigger CD Pipeline') {
            steps {
                echo 'CI complete! Triggering the CD deployment job automatically...'
                // This jump-starts your separate CD job (Docker-CD-VM)
                build job: 'Docker-CD-VM', wait: false
            }
        }
    }

    post {
        always {
            echo 'Cleaning up local workspace...'
            sh "rm -f ${PACKAGE_NAME}"
        }
        success {
            echo 'CI Pipeline Success! Package is live in S3 and CD is triggered.'
        }
        failure {
            echo 'CI Pipeline Failed. Please check logs.'
        }
    }
}
