pipeline {
    agent any 
    parameters {
        choice(
        name: 'env', 
        choices: ['dev', 'stage', 'prod'], 
        description: 'Environment deployed by Terraform'
        )
        booleanParam(
         defaultValue: false,
         description: 'Use -auto-approve Terraform option',
         name: 'terraform_apply'
        )   
    }
    stages {
        stage('Prepare & Check') {
            steps {
                script {
                    echo "Checking if Terraform is ready..."
                    sh 'terraform --version'
                }
            }
        }
        stage('Run Terraform') {
            steps {
                script{
                    withCredentials([
                        aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-access-key-veronika', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')
                    ]){
                        def terraformApply = ''
                        if (params.terraform_apply == true) {
                            terraformApply = '-auto-approve'    
                        } 
                        sh "echo terraformApply: ${terraformApply}"
                        sh "terraform init -backend-config=backend-eun1-${params.env}.hcl"
                        sh "terraform apply -var-file envs/${params.env}.tfvars ${terraformApply}"
                    }
                }
            }
        }
    }
}