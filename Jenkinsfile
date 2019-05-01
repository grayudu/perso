pipeline {
 agent any
 stages{
      stage('checkout') {
          steps {
            deleteDir()  
            git credentialsId: 'github', url: 'https://github.com/grayudu/perso.git'
          }
      }
      stage('Set Terraform path') {
          steps {
              script {
                  def tfHome ="/usr/local/bin/"
                  env.PATH = "${tfHome}:${env.PATH}"
              }
              sh 'terraform -version'
          }
      }
      stage('Provisioninfrastructure') {
          steps{
            dir('terraform/app1'){
                //sh 'unlink variables.tf'
                sh 'ln -s $environment variables.tf'
                sh 'terraform init'
                sh 'terraform plan'
            }  
          }
      }
      stage('Approval') {
          steps {
              script {
                  def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ])
              }
          }
      }
      stage('Apply') {
          steps {
              dir('terraform/app1'){
                  sh 'terraform apply -auto-approve'
              }
          }
      }
      stage('smoketest') {
          steps {
              dir('terraform/app1'){
                  sh "terraform output -json | jq -r .this_elb_dns_name.value > /tmp/endpoint"
                  sh 'chmod +x smoketest.sh'
                  sh "./smoketest.sh"
              }
          }
      }
      stage('destroy') {
          steps {
              dir('terraform/app1') {
                  sh 'terraform destroy -auto-approve'
              }
          }
      }
   }
}