/*
This file is managed by AWS Proton. Any changes made directly to this file will be overwritten the next time AWS Proton performs an update.

To manage this resource, see AWS Proton Resource: arn:aws:proton:us-east-1:175441209007:service/test-service/pipeline

If the resource is no longer accessible within AWS Proton, it may have been deleted and may require manual cleanup.
*/

output "PipelineEndpoint" {
  value = "https://${local.region}.console.aws.amazon.com/codesuite/codepipeline/pipelines/${aws_codepipeline.pipeline.id}/view?region=${local.region}"
}