class ManageIQ::Providers::Telefonica::Inventory::Persister::CloudManager < ManageIQ::Providers::Telefonica::Inventory::Persister
  include ManageIQ::Providers::Telefonica::Inventory::Persister::Definitions::CloudCollections

  def initialize_inventory_collections
    initialize_cloud_inventory_collections
  end
end
