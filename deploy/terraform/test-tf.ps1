az login

az account show

$env = "bnk"
$appName = "iac-tf-azcli"
$rg = "$env-$appName-rg"
$params = ".\params.$env.json"
$deployName = "test-bicep-" + (get-date -format "MMdd-HHmm")

terraform init  -backend-config="key=iaz-tf-azcli.tfstate"
terraform init  -backend-config="key=iaz-tf2-azcli.tfstate"

terraform plan -var-file params.local.tfvars # -backend-config="key=iaz-tf-azcli.tfstate"

terraform apply -var-file params.local.tfvars # -backend-config="key=iaz-tf-azcli.tfstate"

terraform destroy -var-file params.local.tfvars # -backend-config="key=iaz-tf-azcli.tfstate"