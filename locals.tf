locals {
  vpc_cidr               = terraform.workspace == "prod" ? "10.0.0.0/16" : "10.1.0.0/16"
  private_subnet_cidr    = terraform.workspace == "prod" ? ["10.0.0.0/24", "10.0.1.0/24"] : ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnet_cidr     = terraform.workspace == "prod" ? ["10.0.2.0/24", "10.0.3.0/24"] : ["10.1.3.0/24", "10.1.4.0/24"]
  availability_zones     = ["ap-south-1a", "ap-south-1b"]
  bucket_name            = "${terraform.workspace}-test-s3"
  ecs_cluster_name       = "${terraform.workspace}-ecs-cluster"
  project_name           = "test_project"
  codebuild_compute_type = "BUILD_GENERAL1_SMALL"
  codebuild_env_type     = "LINUX_CONTAINER"
  code_build_image       = "aws/codebuild/standard:7.0"
  aliases = []
  ecs_service_name = "test_project-service"
  database_name = "test_projectAuroraDb"
  price_class = "PriceClass_200" 
  /* ["PriceClass_100" "PriceClass_200" "PriceClass_All"] in short availability of cloudfront distribution */
  origin_protocol_policy = "match-viewer"
  /* ["http-only" "match-viewer" "https-only"] */
  caching_policy_for_cf = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  codebuild_env ={
    AWS_DEFAULT_REGION="ap-south-1"
    AWS_ACCOUNT_ID="375266390002"
    IMAGE_REPO_NAME="prod-test_project"
    IMAGE_TAG="latest"
    DockerFilePath="Dockerfile"
    CONTAINER_NAME="prod-ECS-Container"
    REPOSITORY_URI="375266390002.dkr.ecr.ap-south-1.amazonaws.com/prod-test_project"
    }  
}
