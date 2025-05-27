# terraform_aws_sample

Sample pipeline
```
pipeline {
    agent any
    
    environment {
        GIT_REPO =  'https://github.com/jessetop/terraform_aws_sample/'
        GIT_FOLDER = 'terraform_aws_sample'
        PROJECT_FOLDER = 'space-invaders-website'
    }

    stages {
        stage('Clone repo') {
            steps {
                // clean up workspace before clone
                cleanWs()
                git (
                    url: "https://github.com/jessetop/terraform_aws_sample",
                    branch: "main",
                    changelog: true,
                    poll: true
                )
            }
        }
            
        stage('Terraform verify') {
            steps {
                sh 'pwd'
                sh 'terraform -v'
            }
        }
        stage('Terraform init') {
            steps {
                // this line uses the groovy syntax env.PROJECT_FOLDER
                dir("${env.PROJECT_FOLDER}") {
                    sh 'terraform init'
                }
                
               // this line uses the env var PROJECT_FOLDER via the shell
               //sh 'terraform -chdir=${PROJECT_FOLDER} init'
            }
        }
        stage('Terraform apply') {
            steps {
                dir("${env.PROJECT_FOLDER}") {
                    sh 'terraform apply --auto-approve'
                }
            }
        }
        stage('Terraform destroy') {
            steps {
                dir("${env.PROJECT_FOLDER}") {
                    sh 'terraform destroy --auto-approve'
                }
            }
        }
    }
    post {
        failure {
             echo "Failed to deploy"
            sh 'terraform destroy --auto-approve'
        }
    }
}
```
