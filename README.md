# test_kitchen_mssql_helpers
Cookbook which performs a very basic installation of MSSQL Server 2014 Express using the [BoxStarter Cookbook](https://github.com/mwrock/boxstarter-cookbook) and [MsSqlServer2014Express](https://chocolatey.org/packages/MsSqlServer2014Express) Chocolatey package.  
This cookbook is useful as an example of how to install and configure MSSQL in a test-kitchen compatible manner and is also used by the [test_kitchen_mssql_template](https://github.com/Sam-Martin/test_kitchen_mssql_template).

# Dependencies
## BoxStarter
Matt Wrock's [Boxstarter.org](http://boxstarter.org) is used by this cookbook to automatically create a scheduled task to install the [MsSqlServer2014Express](https://chocolatey.org/packages/MsSqlServer2014Express) Chocolatey package.  
Without BoxStarter (i.e. installing the package in the context of a WinRM session) the MSSQL package [would](http://www.hurryupandwait.io/blog/safely-running-windows-automation-operations-that-typically-fail-over-winrm-or-powershell-remoting
) [not](https://learn.chef.io/manage-a-web-app/windows/configure-sql-server/) [install](http://stackoverflow.com/questions/26523301/powershell-remoting-executing-sql-server-installation-msi-fails).
## Chocolatey
[Chocolatey.org](https://chocolatey.org/) is a package management system for Windows which this cookbook uses to install MSSQL 2014.

# Author

Author:: Sam Martin (<samjackmartin@gmail.com>)