class NginxVhosts
  def self.parse(domain_name, vhosts_path, local_ip_pattern)
    vhosts = `cd '#{vhosts_path}'; grep '#{local_ip_pattern}' * | grep proxy_pass`.each_line.map do |vhost|
      tokens = vhost.split(/\s+/)
      tokens[0] =~ /^(?:.+?_)?(.+\.kray\.jp).+:$/
      hostname = $1
      tokens[2] =~ /(\d+\.\d+\.\d+\.\d+);/
      ip = $1
      if hostname && ip
        [hostname, ip]
      else
        nil
      end
    end
    vhosts.compact!
    vhosts.sort!
    vhosts.uniq!
    vhosts
  end
end
