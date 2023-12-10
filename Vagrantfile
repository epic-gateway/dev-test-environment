# Vagrantfile for a simple EPIC Gateway demo environment.
#
# 2 virtual machines:
#  * "gateway" is a single-node k8s cluster running the epic gateway host
#  * "gwclient" is a single-node k8s cluster running the gateway-api client

PLAYBOOK = 'playbook/site.yml'
GROUPS = {
  epic: ['gateway'],
  client: ['gwclient']
}
VARS = {
  service_prefix_subnet: '192.168.77.0/24',
  service_prefix_pool: '192.168.77.2-192.168.77.77',
  purelb_subnet: '192.168.254.160/27',
  purelb_pool: '192.168.254.160-192.168.254.190',
  ws_hostname: 'gwdev-ctl',
  k8s_nic: 'eth0',
  true_ingress_interface: 'eth0',
}

Vagrant.configure("2") do |config|

  config.vm.box = 'generic/ubuntu2004'

  config.vm.define :gateway do |vm|
    vm.vm.hostname = 'epic-gateway.localdomain'

    vm.vm.provider :libvirt do |lv|
      lv.cpus = 4
      lv.memory = 6148
    end

    vm.vm.provision 'ansible' do |ansible|
      ansible.playbook = PLAYBOOK
      ansible.groups = GROUPS
      ansible.extra_vars = VARS
    end

    vm.trigger.after :destroy do |t|
      t.run = {inline: 'rm -f playbook/gateway_v1a2_gatewayclass-gwdev.yaml playbook/ws_ip'}
    end

    config.vm.synced_folder ".", "/vagrant", disabled: true
  end

  config.vm.define :gwclient do |vm|
    vm.vm.hostname = 'epic-client.localdomain'

    vm.vm.provider :libvirt do |lv|
      lv.cpus = 2
      lv.memory = 4096
    end

    vm.vm.provision 'ansible' do |ansible|
      ansible.playbook = PLAYBOOK
      ansible.groups = GROUPS
      ansible.extra_vars = VARS
    end

    config.vm.synced_folder ".", "/vagrant", disabled: true
  end

end
