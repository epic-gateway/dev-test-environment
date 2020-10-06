BOX='generic/ubuntu2004'
EGWINT = ENV.fetch('EGWINT', 'enp113s0f0')
VAULT_PASSWORD_FILE = '.ansible-vault-password'
SHELL_PROVISION_SCRIPT = <<-SHELL
  # add the vagrant user to the docker group (and some others) before we run ansible so that it can run docker commands in the ansible playbook
  grep --quiet docker /etc/group || groupadd --system docker && usermod -a -G docker,systemd-journal,root vagrant

  cat <<ENV > /etc/environment
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
KUBECONFIG="/etc/kubernetes/admin.conf"
ENV

  # remove the vagrant default route so ansible figures out the correct default interface
  ip route | grep --quiet "^default via 192.168.121.1" && ip route delete default via 192.168.121.1 || true
SHELL

Vagrant.configure('2') do |config|
  config.vm.box = BOX

  config.vm.provider :libvirt do |lv|
    lv.cpus = 2
    lv.memory = 4096
  end

  config.vm.define 'egw' do |egw|
    egw.vm.hostname = 'egw'
    egw.vm.network :public_network,
                   dev: EGWINT,
                   mode: 'passthrough',
                   mac: '20:ca:b0:70:00:02',
                   trust_guest_rx_filters: true
    egw.vm.provision 'shell',
                     inline: 'ip route | grep --quiet "^default via .* dev eth0" && ip route delete 0.0.0.0/0 dev eth0 || true'
    egw.vm.provision 'shell',
                     inline: 'echo "PATH=\"/tmp/.acnodal/bin:${PATH}\"" > /etc/environment'
    egw.vm.provision 'ansible' do |ansible|
      ansible.playbook = 'master.yml'
      ansible.compatibility_mode = '2.0'
      ansible.host_vars = {
        egw: {
          bridge_name: 'multus0',
          isGateway: true,
          subnet: '192.168.128.0/24',
          rangeStart: '192.168.128.200',
          rangeEnd: '192.168.128.216',
          gateway: '192.168.128.1',
          pod_cidr: '10.128.0.0/16',
          ansible_python_interpreter: '/usr/bin/python3',
          postgresql_pref_int: 'eth1',
          pfc_src_path: '../packet-forwarding-component',
          pfc_remote_path: '/tmp/.acnodal/bin',
          pfc_interface: 'eth1',
          pfc_gue_port_min: 5000,
          pfc_gue_port_max: 6000,
          pfc_instance_name: 'egw'
        }
      }
      ansible.verbose = true
      ansible.vault_password_file = VAULT_PASSWORD_FILE
    end
    egw.trigger.after :destroy do |trigger|
      trigger.run = {inline: 'rm -f egw-admin.conf master.retry'}
    end

  end


  config.trigger.before [:up, :resume, :reload] do |trigger|
    trigger.info = "Setting EGWINT #{EGWINT} down"
    trigger.run = { inline: "sudo ip link set dev #{EGWINT} down" }
  end



  config.trigger.after [:destroy, :halt, :suspend] do |trigger|
    trigger.info = "setting EGWINT #{EGWINT} down"
    trigger.run = { inline: "sudo ip link set dev #{EGWINT} down" }
  end

end
