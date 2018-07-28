module ManageIQ
  module Providers
    class Telefonica::InfraManager::Refresher < ManageIQ::Providers::BaseManager::Refresher
      def parse_legacy_inventory(ems)
        ManageIQ::Providers::Telefonica::InfraManager::RefreshParser.ems_inv_to_hashes(ems, refresher_options)
      end

      # TODO(lsmola) NetworkManager, remove this once we have a full representation of the NetworkManager.
      # NetworkManager should refresh base on it;s own conditions
      def save_inventory(ems, target, hashes)
        super
        EmsRefresh.queue_refresh(ems.network_manager)
      end

      def post_process_refresh_classes
        [::Vm]
      end
    end
  end
end
