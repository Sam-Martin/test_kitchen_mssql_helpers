include_recipe 'boxstarter::default'

boxstarter "boxstarter install SQL Server" do
  password node['test_kitchen_mssql_helpers']['chef_client_user_password']
  disable_reboots false
  code <<-EOH
  	
	[Environment]::SetEnvironmentVariable("chocolateyInstallArguments",'/SECURITYMODE=SQL /SAPWD="#{node['test_kitchen_mssql_helpers']['sa_password']}"',"Machine")
  	cinst mssqlserver2014express
  	
  	Install-WindowsFeature Net-Framework-Core
  	cinst mssqlservermanagementstudio2014express
  EOH
end