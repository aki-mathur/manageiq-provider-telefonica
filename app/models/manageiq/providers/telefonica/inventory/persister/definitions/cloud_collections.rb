module ManageIQ::Providers::Telefonica::Inventory::Persister::Definitions::CloudCollections
  extend ActiveSupport::Concern

  include ManageIQ::Providers::Telefonica::Inventory::Persister::Definitions::Utils

  # used also in ovirt, so automatic model_classes are not possible in many cases
  def initialize_cloud_inventory_collections
    add_vms

    add_miq_templates

    add_availability_zones

    add_cloud_tenants

    add_flavors

    add_key_pairs

    unless targeted?
      add_cloud_resource_quotas

      add_cloud_services

      add_host_aggregates
    end

    add_orchestration_stacks_with_ems_param

    %i(hardwares
       operating_systems
       disks
       networks
       orchestration_stacks_resources
       orchestration_stacks_outputs
       orchestration_stacks_parameters).each do |name|

      add_collection(cloud, name)
    end

    add_orchestration_templates

    # Custom processing of Ancestry
    add_collection(cloud, :vm_and_miq_template_ancestry)

    add_orchestration_stack_ancestry
  end

  # ------ IC provider specific definitions -------------------------

  # model_class defined due to ovirt dependency
  def add_vms
    add_collection_with_ems_param(cloud, :vms) do |builder|
      builder.add_properties(:model_class => ManageIQ::Providers::Telefonica::CloudManager::Vm)
    end
  end

  def add_miq_templates
    add_collection(cloud, :miq_templates) do |builder|
      builder.add_properties(:model_class => ::MiqTemplate)

      builder.add_default_values(:ems_id => manager.id)

      # Extra added to automatic attributes
      builder.add_inventory_attributes(%i(cloud_tenant cloud_tenants))
    end
  end

  # model_class defined due to ovirt dependency
  def add_availability_zones
    add_collection_with_ems_param(cloud, :availability_zones) do |builder|
      builder.add_properties(:model_class => ManageIQ::Providers::Telefonica::CloudManager::AvailabilityZone)
    end
  end

  # model_class defined due to ovirt dependency
  def add_cloud_tenants
    add_collection_with_ems_param(cloud, :cloud_tenants) do |builder|
      builder.add_properties(:model_class => ManageIQ::Providers::Telefonica::CloudManager::CloudTenant)
    end
  end

  # model_class defined due to ovirt dependency
  def add_flavors
    add_collection_with_ems_param(cloud, :flavors) do |builder|
      builder.add_properties(:model_class => ManageIQ::Providers::Telefonica::CloudManager::Flavor)
    end
  end

  # model_class defined due to ovirt dependency
  def add_cloud_resource_quotas
    add_collection_with_ems_param(cloud, :cloud_resource_quotas) do |builder|
      builder.add_properties(:model_class => ManageIQ::Providers::Telefonica::CloudManager::CloudResourceQuota)
    end
  end

  def add_cloud_services
    add_collection_with_ems_param(cloud, :cloud_services)
  end

  # model_class defined due to ovirt dependency
  def add_host_aggregates
    add_collection_with_ems_param(cloud, :host_aggregates) do |builder|
      builder.add_properties(:model_class => ManageIQ::Providers::Telefonica::CloudManager::HostAggregate)
    end
  end

  def add_orchestration_stacks(extra_properties = {})
    add_collection(cloud, :orchestration_stacks, extra_properties) do |builder|
      builder.add_properties(:model_class => ManageIQ::Providers::CloudManager::OrchestrationStack)

      yield builder if block_given?
    end
  end

  def add_orchestration_templates
    add_collection(cloud, :orchestration_templates) do |builder|
      builder.add_properties(:model_class => ::OrchestrationTemplate)
    end
  end

  def add_key_pairs(extra_properties = {})
    add_collection(cloud, :key_pairs, extra_properties) do |builder|
      builder.add_properties(
        :model_class => ManageIQ::Providers::Telefonica::CloudManager::AuthKeyPair,
      )

      builder.add_default_values(:resource => manager) unless targeted?
    end
  end

  def add_orchestration_stack_ancestry
    add_collection(cloud, :orchestration_stack_ancestry) do |builder|
      builder.remove_dependency_attributes(:orchestration_stacks_resources) unless targeted?
    end
  end

  protected

  # Shortcut for better code readability
  def add_orchestration_stacks_with_ems_param
    add_orchestration_stacks do |builder|
      builder.add_default_values(:ems_id => manager.id)
    end
  end
end
