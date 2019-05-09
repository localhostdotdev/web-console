require "ipaddr"

module WebConsole
  class Permissions
    ALWAYS_PERMITTED_NETWORKS = ['127.0.0.0/8', '::1']

    def initialize(networks = nil)
      @networks = normalize_networks(networks).map do |network|
        coerce_network_to_ipaddr(network)
      end

      @networks.uniq!
    end

    def include?(network)
      @networks.any? { |permission| permission.include?(network.to_s) }
    rescue IPAddr::InvalidAddressError
      false
    end

    def to_s
      @networks.map { |network| human_readable_ipaddr(network) }.join(", ")
    end

    private

    def normalize_networks(networks)
      Array(networks).concat(ALWAYS_PERMITTED_NETWORKS)
    end

    def coerce_network_to_ipaddr(network)
      if network.is_a?(IPAddr)
        network
      else
        IPAddr.new(network)
      end
    end

    def human_readable_ipaddr(ipaddr)
      ipaddr.to_range.to_s.split("..").uniq.join("/")
    end
  end
end
