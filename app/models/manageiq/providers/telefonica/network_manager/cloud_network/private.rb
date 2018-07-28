class ManageIQ::Providers::Telefonica::NetworkManager::CloudNetwork::Private < ManageIQ::Providers::Telefonica::NetworkManager::CloudNetwork
  def self.display_name(number = 1)
    n_('Cloud Network (OpenStack)', 'Cloud Networks (OpenStack)', number)
  end
end
