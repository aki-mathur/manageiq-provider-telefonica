class ManageIQ::Providers::Telefonica::CloudManager::Flavor < ::Flavor
  include ManageIQ::Providers::Telefonica::HelperMethods

  def self.raw_create_flavor(ext_management_system, create_options)
    ext_management_system.with_provider_connection({:service => 'Compute'}) do |service|
      service.flavors.create(create_options)
    end
  rescue => err
    _log.error "flavor=[#{name}], error=[#{err}]"
    raise MiqException::MiqTelefonicaApiRequestError, parse_error_message_from_fog_response(err), err.backtrace
  end

  def self.validate_create_flavor(ext_management_system, _options = {})
    if ext_management_system
      {:available => true, :message => nil}
    else
      {:available => false,
       :message   => _("The Flavor is not connected to an active %{table}") %
         {:table => ui_lookup(:table => "ext_management_system")}}
    end
  end

  def raw_delete_flavor
    ext_management_system.with_provider_connection({:service => 'Compute'}) do |service|
      service.delete_flavor(ems_ref)
    end
  rescue => err
    _log.error "flavor=[#{name}], error: #{err}"
    raise MiqException::MiqTelefonicaApiRequestError, parse_error_message_from_fog_response(err), err.backtrace
  end

  def validate_delete_flavor
    {:available => true, :message => nil}
  end

  def description
    ram = ActionController::Base.helpers.number_to_human_size(memory)
    disk_size = ActionController::Base.helpers.number_to_human_size(root_disk_size)
    _("#{cpus} CPUs, #{ram} RAM, #{disk_size} Root Disk")
  end

  def self.display_name(number = 1)
    n_('Flavor (OpenStack)', 'Flavors (OpenStack)', number)
  end
end
