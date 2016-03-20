# test_kitchen_mssql_helpers [![Build Status](https://travis-ci.org/Sam-Martin/test_kitchen_mssql_helpers.svg?branch=master)](https://travis-ci.org/Sam-Martin/test_kitchen_mssql_helpers)
Cookbook which performs a very basic installation of MSSQL Server 2014 Express using the [BoxStarter Cookbook](https://github.com/mwrock/boxstarter-cookbook) and [MsSqlServer2014Express](https://chocolatey.org/packages/MsSqlServer2014Express) Chocolatey package.  
This cookbook is useful as an example of how to install and configure MSSQL in a test-kitchen compatible manner and is also used by the [test_kitchen_mssql_template](https://github.com/Sam-Martin/test_kitchen_mssql_template).

# Attributes
* `['test_kitchen_mssql_helpers']['chef_client_user_password']` (Must contain the password of the user executing chef-client)  
* `['test_kitchen_mssql_helpers']['sa_password']` (Declares the SA password for MSSQL)

# Usage
Copy the files from this repository into your cookbook's repo (merging files as necessary), then use the platform named 'windows-2012r2' in .kitchen.yml as your test bed. Replace the existing tests in default with the tests you wish to run and add a run_list that specifies your cookbook or other kitchen provisioners as you desire!

## Connectivity
You will presumably need to populate the MSSQL server's IP in your cookbook/script somewhere. You can do this in Chef like so
```
search_query = 'run_list:*test_kitchen_mssql_helpers??server*'
sql_server_ip = search('node', search_query)[0]['ipaddress']
```

Or in any other scripting scenario by parsing the JSON file you can find in `%temp%\kitchen\nodes\default-windows-mssqlserver.json`.

MSSQL is configured to listen to all IPs (i.e. NAT and Private) on TCP 1433.

## Authentication
The default username and password are `sa` and `Vagrant!`, you can change the default password using the attributes in the [test_kitchen_mssql_helpers cookbook](https://github.com/Sam-Martin/test_kitchen_mssql_template)

# Dependencies
## BoxStarter
Matt Wrock's [Boxstarter.org](http://boxstarter.org) is used by this cookbook to automatically create a scheduled task to install the [MsSqlServer2014Express](https://chocolatey.org/packages/MsSqlServer2014Express) Chocolatey package.  
Without BoxStarter (i.e. installing the package in the context of a WinRM session) the MSSQL package [would](http://www.hurryupandwait.io/blog/safely-running-windows-automation-operations-that-typically-fail-over-winrm-or-powershell-remoting
) [not](https://learn.chef.io/manage-a-web-app/windows/configure-sql-server/) [install](http://stackoverflow.com/questions/26523301/powershell-remoting-executing-sql-server-installation-msi-fails).
## Chocolatey
[Chocolatey.org](https://chocolatey.org/) is a package management system for Windows which this cookbook uses to install MSSQL 2014.

# Author

Author:: Sam Martin (<samjackmartin@gmail.com>)