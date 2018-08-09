require 'manageiq/network_discovery/port'

module ManageIQ::Providers::Telefonica
  class Discovery
    IRONIC_PORT = 6385

    def self.probe(ost)
      # Telefonica InfraManager (TripleO/Director) discovery
      if ManageIQ::NetworkDiscovery::Port.open?(ost, IRONIC_PORT)
        res = ""
        Socket.tcp(ost.ipaddr, 6385) do |s|
          s.print("GET / HTTP/1.0\r\n\r\n")
          s.close_write
          res = s.read
        end
        # ost.hypervisor << :telefonica_infra if res =~ /Telefonica Ironic API/
      end
    end
  end
end
