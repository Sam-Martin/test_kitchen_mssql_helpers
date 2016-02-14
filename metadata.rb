name 'test_kitchen_mssql_helpers'
maintainer 'Sam Martin'
maintainer_email 'samjackmartin@gmail.com'
license 'Apache v2.0'
description 'Facilitates the setup of a multi-node test setup using ' \
      'MS SQL Server 2014 in Test Kitchen'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.1'
supports 'windows'

depends 'boxstarter'
depends 'firewall'
