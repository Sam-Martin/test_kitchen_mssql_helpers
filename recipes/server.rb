include_recipe 'boxstarter::default'
include_recipe 'firewall::default'

boxstarter 'boxstarter install SQL Server' do
  password node['test_kitchen_mssql_helpers']['chef_client_user_password']
  disable_reboots false
  code <<-EOH
$SQLArgs = '/SECURITYMODE=SQL ' +
  '/SAPWD="#{node['test_kitchen_mssql_helpers']['sa_password']}" ' +
  '/TCPENABLED=1'
[Environment]::SetEnvironmentVariable(
  "chocolateyInstallArguments",
  $SQLArgs,
  "Machine")
cinst mssqlserver2014express

  EOH
end

powershell_script 'Set IpAll TCP 1433 listener in MSSQL' do
  code <<-EOH
[reflection.assembly]::LoadWithPartialName(
  "Microsoft.SqlServer.Smo")
[reflection.assembly]::LoadWithPartialName(
  "Microsoft.SqlServer.SqlWmiManagement")
$mc = new-object Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer
$tcp = $mc.GetSmoObject(
  "ManagedComputer[@Name='$env:computername']/ " +
  "ServerInstance[@Name='SQLEXPRESS']/ServerProtocol[@Name='Tcp']")

if($tcp.IPAddresses['IPAll'].IPAddressProperties['TcpPort'].value -ne '1433'){
  $tcp.IPAddresses | %{$_.IPAddressProperties['TcpPort'].value=''}
  $tcp.IPAddresses | %{$_.IPAddressProperties['TcpDynamicPorts'].value=''}
  $tcp.IPAddresses['IPAll'].IPAddressProperties['TcpPort'].value='1443'
  $tcp.IsEnabled = $true
  $tcp.alter()
  Restart-Service 'MSSQL$SQLEXPRESS' -Force
}

try{
  New-Object System.Net.Sockets.TCPClient -ArgumentList localhost, 1433
}catch{
  $tcp.IPAddresses['IPAll'].IPAddressProperties['TcpPort'].value=''
  $tcp.IsEnabled = $true
  $tcp.alter()
  Restart-Service 'MSSQL$SQLEXPRESS' -Force

  $tcp.IPAddresses['IPAll'].IPAddressProperties['TcpPort'].value='1433'
  $tcp.IsEnabled = $true
  $tcp.alter()
  Restart-Service 'MSSQL$SQLEXPRESS' -Force
}
  EOH
end

firewall_rule 'mssql' do
  port 1433
  protocol :tcp
  position 1
  command :allow
end
