class mikonwordpress
{	
	$paketit = [ "php7.0","gedit","tree","ssh","curl","php-gd", "php-ssh2","php7.0-phpdbg","rsync","php7.0-mysql", ]
	package {$paketit: 
		ensure=> "installed",
		allowcdrom => "true" 
		}
	package { "apache2":
		ensure=> "installed",
                allowcdrom => "true"
		}
	package { "libapache2-mod-php7.0":
		ensure => "installed",
		require => Package[ "apache2"],
		allowcdrom => "true"}
	file	{ "/etc/puppet/manifests/site.pp":
		content => template ("mikonwordpress/site.pp"),
		}
	exec	{puppetmodule-apache2:
		command => "sudo puppet module install puppetlabs-apache",
		path => "/bin:/usr/bin:/sbin:/usr/sbin:",
		creates => "/etc/puppet/modules/apache", 
		}
	exec	{
		puppetmodule-mysql: 
                command => "sudo puppet module install puppetlabs-mysql",
		path => "/bin:/usr/bin:/sbin:/usr/sbin:",
		creates => "/etc/puppet/modules/mysql", 
		}
	exec	{
		wordpressgetpack:
                command => "sudo wget -P /etc/puppet/modules/mikonwordpress/manifests http://wordpress.org/latest.tar.gz",
                path => "/bin:/usr/bin:/sbin:/usr/sbin:",
                creates => "/etc/puppet/modules/mikonwordpress/manifests/latest.tar.gz",
		}
	exec	{
		wordpressunpack:
                command => "sudo tar xzvf /etc/puppet/modules/mikonwordpress/manifests/latest.tar.gz -C /etc/puppet/modules/mikonwordpress/manifests ",
                path => "/bin:/usr/bin:/sbin:/usr/sbin:",
		creates => "/etc/puppet/modules/mikonwordpress/manifests/wordpress",
		}
	exec	{wordpressmove:
                command => "sudo rsync -avP /etc/puppet/modules/mikonwordpress/manifests/wordpress/ /var/www/html/",
                path => "/bin:/usr/bin:/sbin:/usr/sbin:",
		creates => "/var/www/html/wp-config.php",
		require => "File[/etc/puppet/modules/mikonwordpress/manifests/wordpress/wp-config.php]",
		}
	file {"/var/www/html/wp-content/uploads":
		ensure => 'directory',
		}
	file { "/etc/puppet/modules/mikonwordpress/manifests/wordpress/wp-config.php":
                content => template ("mikonwordpress/wp-config.php"),
		require => Exec[wordpressunpack]
		}
	file { "/etc/apache2/mods-available/php7.0.conf":
		content => template ('mikonwordpress/php7.0.conf'),
		require => "Package[libapache2-mod-php7.0]"
		}
	file { "/var/www/html/index.html":
		ensure => "absent",
		}
	file {"/etc/puppet/modules/mysql/manifests/client/install.pp":
		content => template ("mikonwordpress/mysqlclientinstall.pp"),
		}
	file {"/etc/puppet/modules/mysql/manifests/server/install.pp":
		content => template ("mikonwordpress/mysqlserverinstall.pp"),
		}
}
