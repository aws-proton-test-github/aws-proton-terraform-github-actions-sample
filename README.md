## Terraform OpenSource GitHub Actions automation template for AWS Proton TEST

Welcome! This repository should help you test how Proton works with Terraform Open Source to provision your infrastructure. In this repository you will find three things:

1. A CloudFormation template (GitHubConfiguration.yaml) that will help you get the underlying roles and permissions set up
2. A GitHub Actions task to run Terraform Open Source based on commits to this repo
3. An AWS Proton sample template that uses Terraform files to work

To configure this sample, follow this instructions:


1. Fork this repository into your GitHub account
1. Ensure you have a CodeStar Connection set up for the account into which you
   forked the repo in the previous step. For information on how to set that up see [this documentation](https://docs.aws.amazon.com/dtconsole/latest/userguide/connections-create.html).
3. In the GitHubConfiguration.yaml file, update the input parameters to your username and repository that you forked in (2).
3. Run GitHubConfiguration.yaml through CloudFormation (https://aws.amazon.com/cloudformation/). This will create a role that GitHub Actions will use to provision resources into your account, as well as an S3 bucket to store Terraform Open Source state files. Make sure you use all lowercase names in the stack name, as we will use it to create an S3 bucket to save your state files
```
aws cloudformation create-stack --stack-name aws-proton-terraform-role-stack
--template-body file:///$PWD/GitHubConfiguration.yaml --capabilities
CAPABILITY_NAMED_IAM
```
4. Open the file env_config.json and update the role ARN with the `Role` output from the stack created in (3), the environment name with the name of the environment you are going to create and the region with your preferred deployment region. This will tell Terraform the role and region to use for deployments. You can use different roles for each environment by adding them to this file
5. Open the file .github/workflows/terraform.yml and update `bucket` used for the `terraform init` with the `BucketName` output from (3). This will tell Terraform where to store the state file
6. Take the sample template and create a Proton environment template by following the instructions [here](https://docs.aws.amazon.com/proton/latest/adminguide/template-create.html). Replace `your-s3-bucket` with the name of the bucket in which you would like to store your Proton templates.
```
tar -zcvf sample-vpc-environment-template.tar.gz sample-templates/sample-vpc-environment-template/
aws s3 cp sample-vpc-environment-template.tar.gz s3://your-s3-bucket/sample-vpc-environment-template.tar.gz --region us-west-2
rm sample-vpc-environment-template.tar.gz

aws proton create-environment-template --name "sample-vpc-environment-template"
aws proton create-environment-template-version \
        --template-name sample-vpc-environment-template \
        --description "Sample template for setting up a Pull Request environment" \
        --source s3="{bucket=your-s3-bucket, key=sample-vpc-environment-template.tar.gz}"
aws proton update-environment-template-version \
        --template-name "sample-vpc-environment-template" \
        --major-version "1" \
        --minor-version "0" \
        --status "PUBLISHED"
```
7. Register your repository with Proton by following the instructions [here](https://docs.aws.amazon.com/proton/latest/adminguide/ag-create-repo.html) For
8. Deploy your environment in Proton by following the instructions [here](https://docs.aws.amazon.com/proton/latest/adminguide/ag-create-env.html#ag-create-env-pull-request). Change `githubuser` to be name of the github account with the forked repository.
```
 aws proton create-environment \
        --name "pr-environment" \
        --template-name "sample-vpc-environment-template" \
        --template-major-version "1" \
        --provisioning-repository="branch=main,name=githubuser/aws-proton-terraform-github-actions-sample,provider=GITHUB"
        --spec file:///$PWD/example_schema.txt
```
9. Sortly after you trigger the deployment, come back to your repository to see the Pull Request. Once you merge it, you can go back to Proton and see the updated status of your newly created environment

Fell free to reach out with questions or open a ticket with suggestions in our public roadmap at https://github.com/aws/aws-proton-public-roadmap

Thank you!


## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.

