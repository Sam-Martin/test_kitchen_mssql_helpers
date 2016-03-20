require 'serverspec'
require 'json'

describe 'sql server' do
  let(:sql_server) do
    JSON.parse(
      IO.read(File.join(ENV['TEMP'] || '/tmp', 
        'kitchen/nodes/default-windows-mssqlserver.json'))
    )
  end
  let(:default_node) do
    JSON.parse(
      IO.read(File.join(ENV['TEMP'] || '/tmp', 
        'kitchen/nodes/default-windows-2012r2.json'))
    )
  end
  let(:local_node_private_ip){
    IO::popen(["powershell.exe", 
      "(Get-NetIPConfiguration | " \
      "?{!$_.IPv4DefaultGateway}).IPv4Address.IPAddress"]) {|io| io.read}.chomp
  }
  let(:ip) { 
    # Use the first three octets of this node's private IP to find the IP of
    #   the MSSQL node which is on the correct subnet
    ip_array = sql_server['automatic']['ipaddress']
    return ip_array if ip_array.class === 'String'
    ip_array.find { |e| 
      /#{local_node_private_ip.gsub(/\d{1,3}$/,'')}\d{1,3}$/ =~ e
    } 
  }
  let(:connection) do
    require 'tiny_tds'
    ::TinyTds::Client.new(
      username: 'sa',
      password: 'Vagrant!',
      host: ip
    )
  end

  it 'has an non localhost ip' do
    expect(ip).not_to eq('127.0.0.1')
  end

  it 'has a valid ip' do
    expect(ip).to match(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/)
  end

  it 'connects successfully' do
    expect(connection.active?).to be true
  end
end