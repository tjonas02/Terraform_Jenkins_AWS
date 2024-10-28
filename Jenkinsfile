pipeline {
    agent any

    stages {
        stage('Git_Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/tjonas02/Terraform_Jenkins_AWS'
            }
        }
        stage ("terraform init") {
            steps {
                sh 'terraform init'
            }
        }
        stage ("terraform fmt") {
            steps {
                sh 'terraform fmt'
            }
        }
        stage ("terraform validate") {
            steps {
                sh 'terraform validate'
            }
        }
        stage ("terrafrom plan") {
            steps {
                sh 'terraform plan '
            }
        }
        stage ("terraform apply") {
            steps {
                sh 'terraform apply --auto-approve'
            }
        }
        stage ("terrafrom destroy") {
            steps {
                sh 'terraform destroy '
            }
        }
    }
}
