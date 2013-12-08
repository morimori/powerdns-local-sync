class AXFR
  def self.parse(dns_server, domain_name, ip_map, vhosts)
    zt = Dnsruby::ZoneTransfer.new.tap do |zt|
      zt.transfer_type = Dnsruby::Types.AXFR
      zt.server = dns_server
    end
    zone = zt.transfer domain_name
    records = zone.map do |record|
      case record.type.to_s
      when 'SOA', 'NS', 'CNAME'
        {:name => record.name.to_s, :type => record.type, :content => record.rdata_to_string, :ttl => record.ttl}
      when 'MX'
        {:name => record.name.to_s, :type => record.type, :content => record.exchange.to_s, :ttl => record.ttl, :priority => record.preference}
      when 'A'
        vhost = vhosts.assoc record.name
        if vhost
          {:name => record.name.to_s, :type => record.type, :content => vhost[1], :ttl => record.ttl}
        elsif ip_map.key? record.address.to_s
          {:name => record.name.to_s, :type => record.type, :content => ip_map[record.address.to_s], :ttl => record.ttl}
        else
          {:name => record.name.to_s, :type => record.type, :content => record.address.to_s, :ttl => record.ttl}
        end
      else
        raise "Unknown record type #{record.inspect}"
      end
    end
  end
end
