class ManageIQ::Providers::Telefonica::Inventory::Persister < ManagerRefresh::Inventory::Persister
  require_nested :CloudManager
  require_nested :NetworkManager
  require_nested :CinderManager
  require_nested :TargetCollection

  # TODO(lsmola) figure out a way to pass collector info, probably via target, then remove the below
  attr_reader :collector
  # @param manager [ManageIQ::Providers::BaseManager] A manager object
  # @param target [Object] A refresh Target object
  # @param collector [ManagerRefresh::Inventory::Collector] A Collector object
  def initialize(manager, target = nil, collector = nil)
    @manager   = manager
    @target    = target
    @collector = collector

    @collections = {}

    initialize_inventory_collections
  end

  protected

  def strategy
    nil
  end

  def parent
    manager.presence
  end

  def shared_options
    {
      :parent   => parent,
      :strategy => strategy,
      :targeted => targeted?
    }
  end
end
