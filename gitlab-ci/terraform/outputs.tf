output "gitlab_external_ip" {
  value = "${module.gitlab.db_ext_ip}"
}
