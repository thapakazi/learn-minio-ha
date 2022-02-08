# -*- mode: ruby -*-
# vi: set ft=ruby :

NODE_CONFIG = YAML.load_file('hosts.yaml')
IMAGE = NODE_CONFIG["image"]
IP_RANGE = NODE_CONFIG["ip_range"]
MINIO_VERSION = NODE_CONFIG["version"]
NODES_COUNT = NODE_CONFIG["nodes"]["count"]
HOST_MAP = (1..NODES_COUNT).collect{|x| "#{IP_RANGE}#{x} minio-#{x}" }.join("\n")
MINIO_ENV_VARS= {
  "MINIO_OPTS"=> (1..NODES_COUNT).collect{|x| "http://minio-#{x}:9000/data" }.join(" "),
  "MINIO_ACCESS_KEY"=> "AKaHEgQ4II0S7BjT6DjAUDA4BX",
  "MINIO_SECRET_KEY"=> "SKFzHq5iDoQgF7gyPYRFhzNMYSvY6ZFMpH"
}

Vagrant.configure("2") do |config|
  config.vagrant.plugins = ["vagrant-reload", "vagrant-vbguest"]

  config.vbguest.auto_update = false
  config.vm.provision "shell", privileged: true, path: "./scripts/setup_alpine.sh"
  config.vm.provision :reload
  config.vm.provision "file", source: "./.ssh/id_rsa", destination: "/tmp/id_rsa"
  config.vm.provision "file", source: "./.ssh/id_rsa.pub", destination: "/tmp/id_rsa.pub"
  config.vm.provision "shell", privileged: true, path: "./scripts/setup_ssh.sh"
  config.vm.provision "shell", privileged: true, path: "./scripts/setup_user.sh"
  config.vm.provision "shell", privileged: true, path: "./scripts/setup_minio.sh"
  
  FN_IP = ""
  (1..NODES_COUNT).each do |i|
    config.vm.define "minio#{i}" do |minonode|
      ID = i + 1
      IP = "#{IP_RANGE}#{ID}"
      minonode.vm.box = IMAGE
      minonode.vm.hostname = "minio#{i}"
      minonode.vm.network :private_network, ip: IP
      minonode.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", NODE_CONFIG["nodes"]["resources"]["memory"]]
        vb.customize ["modifyvm", :id, "--cpus", NODE_CONFIG["nodes"]["resources"]["cpu"]]
        # (1..DISK_COUNT).each do |d|
        #   vb.customize ["modifyvm", :id, "--disk", NODE_CONFIG["nodes"]["resources"]["disk"]]
        # end
      end

      # minonode.vm.provision "file", source: "./scripts/manifests/.", destination: "/tmp/manifests/"
      minonode.vm.provision "shell",
                            privileged: true,
                            inline: "echo \"#{HOST_MAP}\" >> /etc/hosts"
      minonode.vm.provision "shell",
                            privileged: true,
                            inline: "mkdir -p /etc/default; echo \"#{MINIO_ENV_VARS.map {|k,v| "#{k}=#{v}"}.join("\n")}\" > /etc/default/minio"
    end
  end
end


# #
# # export MINIO_OPTS='http://minio-1:9000/data/1 http://minio-1:9000/data/2 http://minio-1:9000/data/3 http://minio-1:9000/data/4 http://minio-2:9000/data http://minio-3:9000/data http://minio-4:9000/data'; minio server $MINIO_OPTS


# export MINIO_OPTS='http://minio-1:9000/data/1 http://minio-1:9000/data/2 http://minio-1:9000/data/3 http://minio-1:9000/data/4 http://minio-2:9000/data/1 http://minio-2:9000/data/2 http://minio-2:9000/data/3 http://minio-2:9000/data/4 http://minio-3:9000/data/1 http://minio-3:9000/data/2 http://minio-3:9000/data/3 http://minio-3:9000/data/4 http://minio-4:9000/data/1 http://minio-4:9000/data/2 http://minio-4:9000/data/3 http://minio-4:9000/data/4'; minio server $MINIO_OPTS --console-address :9001
