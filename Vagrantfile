# Vagrantfile for a simple EPIC Gateway demo environment.
#
# 2 virtual machines:
#  * "gateway" is a single-node k8s cluster running the epic gateway host
#  * "gwclient" is a single-node k8s cluster running the gateway-api client

BRIDGE = "#{ENV['USER']}-epic0"
PLAYBOOK = 'playbook/site.yml'
GROUPS = {
  epic: ['gateway'],
  client: ['gwclient']
}
GATEWAY_IP = '192.168.254.21'
CLIENT_IP = '192.168.254.121'
PURELB_IP = '192.168.254.210-192.168.254.211'
VARS = {
  gateway_ip: GATEWAY_IP,
  ws_ip: GATEWAY_IP,
  ws_hostname: 'gwdev-ctl',
  sample_gw_config: 'gateway_v1a2_gatewayclass-gwdev.yaml'
}
NETDEV_CFG = {
  dev: BRIDGE,
  type: :bridge,
  mode: :bridge,
  trust_guest_rx_filters: true
}

Vagrant.configure("2") do |config|

  config.vm.box = 'generic/ubuntu2004'

  config.vm.define :gateway do |vm|
    vm.trigger.before :up do |t|
      t.info = 'Creating network bridge'
      t.run = {inline: 'scripts/brmgr.sh up'}
    end
    vm.trigger.after :destroy do |t|
      t.info = 'Removing sample GatewayClass'
      t.run = {inline: 'rm -f playbook/gateway_v1a2_gatewayclass-gwdev.yaml'}
    end
    vm.trigger.after :destroy do |t|
      t.info = 'Destroying network bridge'
      t.run = {inline: 'scripts/brmgr.sh destroy'}
    end

    vm.vm.hostname = 'epic-gateway.localdomain'
    vm.vm.network :public_network, **NETDEV_CFG.merge(ip: GATEWAY_IP)

    vm.vm.provider :libvirt do |lv|
      lv.cpus = 4
      lv.memory = 6148
    end

    vm.vm.provision 'ansible' do |ansible|
      ansible.playbook = PLAYBOOK
      ansible.groups = GROUPS
      ansible.extra_vars = VARS.merge({
        k8s_cluster_vip: GATEWAY_IP,
        purelb_pool: PURELB_IP,
      })
    end
  end

  config.vm.define :gwclient do |vm|
    vm.vm.hostname = 'epic-client.localdomain'
    vm.vm.network :public_network, **NETDEV_CFG.merge(ip: CLIENT_IP)

    vm.vm.provider :libvirt do |lv|
      lv.cpus = 2
      lv.memory = 4096
    end

    vm.vm.provision 'ansible' do |ansible|
      ansible.playbook = PLAYBOOK
      ansible.groups = GROUPS
      ansible.extra_vars = VARS.merge({
        k8s_cluster_vip: CLIENT_IP,
        k8s_nodeaddr: "#{CLIENT_IP},fd00:254::121",
      })
    end
  end

end
