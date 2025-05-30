module "network" {
  source         = "./modules/network"
  project_name   = var.project_name
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
}

module "security_groups" {
  source       = "./modules/security-groups"
  project_name = var.project_name
  vpc_id       = module.network.vpc_id
}

module "efs" {
  source          = "./modules/efs"
  project_name    = var.project_name
  subnet_ids      = module.network.public_subnet_ids
  efs_mount_sg_id = module.security_groups.efs_mount_sg_id
}

module "ecs_cluster" {
  source       = "./modules/ecs-cluster"
  project_name = var.project_name
}

module "ecs_task_service" {
  source                      = "./modules/ecs-task-service"
  project_name                = var.project_name
  vpc_id                      = module.network.vpc_id
  public_subnet_ids           = module.network.public_subnet_ids
  cluster_name                = module.ecs_cluster.cluster_name
  ecs_task_execution_role_arn = module.ecs_cluster.ecs_task_execution_role_arn
  grafana_image               = var.grafana_image
  renderer_image              = var.renderer_image
  redis_image                 = var.redis_image
  task_cpu                    = var.task_cpu
  task_memory                 = var.task_memory
  desired_count               = var.desired_count
  ecs_tasks_sg_id             = module.security_groups.ecs_tasks_sg_id
  efs_id                      = module.efs.efs_id
  efs_access_point_id         = aws_efs_access_point.grafana_efs_ap.id
}

resource "aws_efs_access_point" "grafana_efs_ap" {
  file_system_id = module.efs.efs_id

  posix_user {
    uid = 1000
    gid = 1000
  }

  root_directory {
    path = "/grafana-data"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = "0755"
    }
  }
}
