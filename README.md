# terraform
### Databricks Terraform example for creating External Storage Location for Databricks AWS Workspace

This repo contains terraform templates and scripts creating External Storage Location for Databricks AWS Workspace.

### Steps to execute the templates

1. Install Terraform. For Mac, this is described in https://learn.hashicorp.com/tutorials/terraform/install-cli.
2. Clone this repo to your machine.
3. Make sure you've configured your AWS CLI credentials with the AWS Account you want to deploy to.
4. Create a file called *secrets.tfvars* in directory you will be calling *configure.sh* or the other scripts from. You can put *secrets.tfvars* in any directory of your choice, just make sure you are in that directory when calling *configure.sh* or other scripts. This file should have the following variables:
> databricks_account_id       = "\<databricks account id>"<br>
> databricks_workspace_host = "\<databricks workspace host url>"<br>
> databricks_workspace_token = "\<databricks workspace PAT token>"<br>

Be careful with token as secrets in Terraform are stored in plain text. This is why *secrets.tfvars* file is in .gitignore

5. Once you have created *secrets.tfvars* file, run *configure.sh* script and pass to it *-w <your workspace name>* parameter. So for example, if you want to store state in a Terraform Workspace called **demo**, you would run *./configure.sh -w demo* on command line.
6. The script will apply the template in *workspace* subdirectory.

### Variables
The file *variables.tf* in workspace subdirectory contains variables you can specify for the template.
The following variables should be provided:
* bucket_full_path - The full path to S3 bucket, the bucket must already exist, e.g. s3://my_bucket/my_path
* role_name - The name of the IAM role and storage credential to create
* external_location_name - The name of external storage credential to create pointing to bucket path in bucket_full_path

### Usage
./configure.sh [**-w** \<workspace name\>] <br>
| Argument              | Description    |
| ---                   | ---            |
|**-w** \<workspace name\> |- optional, deployment artefacts will have specified \<workspace name\> prefix and the Workspace will be named \<workspace name\>. If not specified <workspace name> will default to **terratest-\<random string\>**<br> |

You can either run configure.sh script above or use templates as examples in your own terraform templates.
