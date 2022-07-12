build {
  name = var.builder_instance_name
  source "source.amazon-ebs.vm" {
    winrm_username = "Administrator"
  }


  provisioner "ansible" {
    user          = "Administrator"
    use_proxy     = false
    playbook_file = "../ansible/stig_playbook.yml"
    extra_arguments = [
      "-e",
      "ansible_connection=winrm ansible_ssh_port=5986 ansible_winrm_server_cert_validation=ignore ansible_shell_type=powershell ansible_shell_executable=None"
    ]
  }
}
