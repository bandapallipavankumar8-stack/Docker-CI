pipeline {
    agent any

    // Configuration variables for your CI pipeline
    environment {
        // Your exact AWS S3 Bucket Name
        S3_BUCKET    = 'code-version'
        
        // The name of the zip archive file to create
        PACKAGE_NAME = 'bookstore-package.zip'
        
        // The ID of the credentials you saved in Jenkins
        AWS_CREDS_ID = 'aws-credentials-id'
    }

    stages {
        stage('CI: Checkout Code') {
            steps {
                echo 'Pulling the latest code from your GitHub repository...'
                // Downloads files from your Git repo
                checkout scm
            }
        }

        stage('CI: Package Application') {
            steps {
                echo 'Compressing files into a deployment package...'
                // Packages your exact files directly from the root directory
                sh "zip -r ${PACKAGE_NAME} Dockerfile index.html"
            }
        }

        stage('CI: Upload to AWS S3') {
            steps {
                // Securely pulls your secret AWS keys from Jenkins storage
                withCredentials([usernamePassword(credentialsId: "${AWS_CREDS_ID}", 
                                                 usernameVariable: 'AWS_ACCESS_KEY_ID', 
                                                 passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    
                    echo "Uploading ${PACKAGE_NAME} to S3 bucket: ${S3_BUCKET}..."
                    // Transmits the package directly to your S3 bucket
                    sh "aws s3 cp ${PACKAGE_NAME} s3://${S3_BUCKET}/"
                }
            }
        }

        stage('CI: Trigger CD Pipeline') {
            steps {
                echo 'CI completed successfully! Triggering the CD deployment job automatically...'
                
                // This triggers your separate CD job (Docker-CD-VM) automatically
                build job: 'Docker-CD-VM', wait: false
            }
        }
    }

    post {
        always {
            echo 'Cleaning up the build environment...'
            // Deletes the local zip file from the Jenkins server to save space
            sh "rm -f ${PACKAGE_NAME}"
        }
        success {
            echo 'CI Pipeline Success! Your package is now live in S3 and CD is triggered.'
        }
        failure {
            echo 'CI Pipeline Failed. CD was not triggered. Please check the logs above to troubleshoot errors.'
        }
    }
}
