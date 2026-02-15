pipeline {
    agent any 
    parameters {
        choice(name: 'env', choices: ['dev', 'stage', 'prod'], description: 'Environment deployed by Terraform'), 

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
                withCredentials([
                    aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-access-key-veronika', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')
                ]){
                    script{
                        def terraformApply = ''
                        if (params.terraform_apply == true) {
                            terraformApply = '-auto-approve'    
                        } 
                        sh "echo terraformApply: ${terraformApply}"
                        sh '''
                            terraform -var-file ${params.env} ${terraformApply} apply
                        '''
                    }
                }
            }
        }
    }
}