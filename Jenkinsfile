node {
    stage('Checkout') {
        // Get some code from a GitHub repository
        sh 'rm -rf *'
        git 'https://github.com/aviruprc/gcp-vm-provision.git'
        sh 'ls -ltr'
    }
    stage('Build Terraform') {
        echo "This is where we take input for Terraform and generate .tf.json file"
        def params = input message: 'Please enter the following details for VM Creation',
        parameters: [
            string(defaultValue: 'us-west1', description: '', name: 'Region'), 
            string(defaultValue: 'us-west1-c', description: '', name: 'Zone'), 
            string(defaultValue: 'v2agent-9423a', description: '', name: 'Project_ID'),
            string(defaultValue: 'n2-standard-2', description: 'Make sure it belongs to N2 family', name: 'CPU_Type'),
            string(defaultValue: 'debian-cloud/debian-9', description: 'Please specify in the format project/image-name', name: 'Image_Name'),
            string(defaultValue: '1', description: 'The value cannot be null', name: 'Number_Of_VM')
        ]
        dir("example"){
            def tffile = readJSON file: "createvm.tf.json"
            tffile.module[0].gcpvm[0].zone = params.Zone
            tffile.module[0].gcpvm[0].region = params.Region
            tffile.module[0].gcpvm[0].projectid = params.Project_ID
            tffile.module[0].gcpvm[0].machinetype = params.CPU_Type
            tffile.module[0].gcpvm[0].image = params.Image_Name
            tffile.module[0].gcpvm[0].vmnos = params.Number_Of_VM
            writeJSON file: 'createvm.tf.json', json: tffile
        }
    }
    stage('Run Terraform') {
        echo "In this stage we run Terraform and create Ansible Inventory"
        def addresses
        dir("example"){
            sh 'terraform init'
            sh 'terraform plan'
            sh 'terraform apply -auto-approve'
            def tfstate = readJSON file: "terraform.tfstate"
            addresses = tfstate.resources[0].instances.attributes.network_interface.access_config.nat_ip
        }
        sh 'rm -rf inventory.txt'
        sh 'touch inventory.txt'
        for (address in addresses)
        {
            env.ip = address[0][0]
            sh 'echo ${ip} >> inventory.txt'
        }
        echo "********************************IPs***********************************"
        sh 'cat inventory.txt'
        echo "**********************************************************************"
    }
    stage('Ansible') {
        echo "In this stage we run Ansible with the generated inventory file"
        sh 'ls -ltr'
        sh 'ansible all -m ping -i inventory.txt -u aviruproychowdhury'
    }
    stage('Cleanup') {
        echo "In this stage we delete the resources created during execution"
        dir("example"){
            sh 'terraform destroy -auto-approve'
        }
    }
}
