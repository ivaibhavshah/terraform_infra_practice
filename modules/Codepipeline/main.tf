


resource "aws_codecommit_repository" "my_repo" {
  repository_name = "test-project-repo"
}
resource "aws_codebuild_project" "my_codebuild" {
  name          = "${terraform.workspace}-codebuild-test-project"  
  description   = "test-project CodeBuild Project"
  service_role  = aws_iam_role.codebuild_role.arn
  # vpc_config {
  #   vpc_id = var.vpc_id
  #   subnets = var.public_subnets
  #   security_group_ids = [var.security_group]
  # }
  source {
    type = "CODEPIPELINE"
  }
  artifacts {
    type = "CODEPIPELINE"
  }
  logs_config {
    
    s3_logs {
     encryption_disabled = true
    }
  }
  environment {
    compute_type                = var.environment_compute_type
    image                       = var.environment_image
    type                        = var.environment_type
    # image_pull_credentials_type = "CODEBUILD"
    dynamic "environment_variable" {
      for_each = var.env_vars
      content {
        name = environment_variable.key
        value = environment_variable.value
        type  = "PLAINTEXT"
      }
       }
     }
    
    
  /* post_build {
    commands = [
      "aws lambda invoke --function-name ${aws_lambda_function.email_notification.function_name} /tmp/output.txt",
    ]
  } */
}


resource "aws_codepipeline" "my_pipeline" {
  name = "${terraform.workspace}-${var.project_name}-pipeline"
  role_arn = aws_iam_role.pipeline_role.arn
  # type = "V2"
  artifact_store {
    location = var.s3_id
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source_Action"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      configuration = {
        RepositoryName = aws_codecommit_repository.my_repo.repository_name
        BranchName     = terraform.workspace == "prod" ? "main" : "dev" 
      }
      output_artifacts = ["SourceArtifact"]
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build_Action"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["SourceArtifact"]
      configuration = {
        ProjectName = aws_codebuild_project.my_codebuild.name
      }
      output_artifacts = ["imagedefinitions"]
    }
    
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy_Action"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["imagedefinitions"]
      configuration = {
        ClusterName = "${var.ecs_cluster_name}"
        ServiceName = "${var.service_name}"
        FileName    = "imagedefinitions.json"
        # ApplicationName = aws_codedeploy_app.my_app.name
        # DeploymentGroupName = aws_codedeploy_deployment_group.my_deployment_group.deployment_group_name
        
      }
    }
    

  }
}

