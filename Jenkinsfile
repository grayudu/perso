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
                sh 'sed -i 's/_key_/$environment/g' remote-backend.tf'
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
                  sh '''
                     while true;do i=`cat /tmp/endpoint`;status=`curl -s -o /dev/null -w  "%{http_code}" http://$i`;if [ $status -eq 200 ]; then echo "Smoke Successfull";break;else echo "......";fi;done
                     '''
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
