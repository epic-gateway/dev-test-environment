BOX='generic/ubuntu2004'
EGWINT = ENV.fetch('EGWINT', 'enp113s0f0')
EXTRA_DOCKER_CONFIG = ENV['EXTRA_DOCKER_CONFIG'] && "#{ENV['EXTRA_DOCKER_CONFIG']}," || ""
VAULT_PASSWORD_FILE = '.ansible-vault-password'
SHELL_PROVISION_SCRIPT = <<-SHELL
  apt-get purge -qq unattended-upgrades
  apt-get install -qq ifmetric
  # Make the Vagrant-created interface cost more so the public_network interface is the default (now, and after reboot)
  ifmetric eth0 200
  sed s/RouteMetric=100/RouteMetric=200/ /run/systemd/network/10-netplan-eth0.network > /etc/systemd/network/10-netplan-eth0.network
  # make logging in a little quieter
  echo -n > /etc/motd
  # add me to some useful groups
  usermod -G systemd-journal,root -a vagrant
SHELL

Vagrant.configure('2') do |config|
  config.vm.box = BOX

  config.vm.provider :libvirt do |lv|
    lv.cpus = 3
    lv.memory = 8192
  end

  config.vm.synced_folder './', '/vagrant', type: 'nfs'

  config.vm.define 'egw' do |egw|
    egw.vm.hostname = 'egw'
    egw.vm.network :public_network,
                   dev: EGWINT,
                   mode: 'passthrough',
                   mac: '20:ca:b0:70:00:02',
                   trust_guest_rx_filters: true
    egw.vm.provision :shell, inline: SHELL_PROVISION_SCRIPT
    egw.vm.provision 'ansible' do |ansible|
      ansible.playbook = 'master.yml'
      ansible.compatibility_mode = '2.0'
      ansible.extra_vars = {
        ansible_user: 'vagrant',
        extra_docker_config: EXTRA_DOCKER_CONFIG,
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
