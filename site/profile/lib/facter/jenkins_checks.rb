require 'facter'

Facter.add(:jenkins_installed) do
	confine :kernel => 'Linux' 
	confine do
	if !Facter.value(:modules).nil?
			Facter.value(:modules).include?('Jenkins_master')
		else
		  false
		end
	end
	setcode do
		if (Facter::Util::Resolution.exec("[ \"$(grep -c 'hudson' '/var/lib/jenkins/config.xml' -s -R -n)\" -gt 0 ] 2>> /dev/null && echo true || echo false")) == 'true'
			true
		else
			false
		end
	end
end

Facter.add(:jenkins_start) do
	confine :kernel => 'Linux' 
	confine :jenkins_installed => true
	setcode do
		if (Facter::Util::Resolution.exec("[ \"$(grep -c 'hudson.security.FullControlOnceLoggedInAuthorizationStrategy' '/var/lib/jenkins/config.xml' -s -R -n)\" -gt 0 ] 2>> /dev/null && echo true || echo false")) == 'true'
			true
		else
			false
		end
	end
end

Facter.add(:jenkins_bootstrap) do
	confine :kernel => 'Linux' 
	confine :jenkins_installed => true
	setcode do
		if (Facter::Util::Resolution.exec("[ \"$(grep -c 'hudson.security.AuthorizationStrategy$Unsecured' '/var/lib/jenkins/config.xml' -s -R -n)\" -gt 0 ] 2>> /dev/null && echo true || echo false")) == 'true'
			true
		else
			false
		end
	end
end

Facter.add(:jenkins_matrix) do
	confine :kernel => 'Linux'
	confine :jenkins_installed => true
	setcode do
		if (Facter::Util::Resolution.exec("[ \"$(grep -c 'hudson.security.GlobalMatrixAuthorizationStrategy' '/var/lib/jenkins/config.xml' -s -R -n)\" -gt 0 ] 2>> /dev/null && echo true || echo false")) == 'true'
			true
		else
			false
		end
	end
end

Facter.add(:jenkins_ldap) do
	confine :kernel => 'Linux'
	confine :jenkins_installed => true
	setcode do
		if (Facter::Util::Resolution.exec("[ \"$(grep -c 'hudson.security.LDAPSecurityRealm' '/var/lib/jenkins/config.xml' -s -R -n)\" -gt 0 ] 2>> /dev/null && echo true || echo false")) == 'true'
			true
		else
			false
		end
	end
end

Facter.add(:jenkins_secure) do
	confine :kernel => 'Linux'
	confine :jenkins_installed => true
	setcode do
		if (Facter::Util::Resolution.exec("[ \"$(grep -c 'hudson.security.LDAPSecurityRealm' '/var/lib/jenkins/config.xml' -s -R -n)\" -gt 0 ] 2>> /dev/null && echo true || echo false")) == 'true' && (Facter::Util::Resolution.exec("[ \"$(grep -c 'hudson.security.GlobalMatrixAuthorizationStrategy' '/var/lib/jenkins/config.xml' -s -R -n)\" -gt 0 ] && echo true || echo false")) == 'true'
		  true
		else
		  false
		end
	end
end
