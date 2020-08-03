BOX='generic/ubuntu2004'
EGWINT = ENV.fetch('EGWINT', 'enp113s0f0')


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
          gitlab_user: 'oz_adam',
          gitlab_secret: 'Qi4oXVKA1gzGdenTCd7G',
          postgresql_egw_user: 'egw',
          postgresql_egw_password: '18companyOTHERbornSOON',
          ansible_python_interpreter: '/usr/bin/python3',
          postgresql_pref_int: 'eth1'
        }
      }
      ansible.verbose = true
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
