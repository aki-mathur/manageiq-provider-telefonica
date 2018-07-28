module ManageIQ
  module Providers
    module Telefonica
      class Engine < ::Rails::Engine
        isolate_namespace ManageIQ::Providers::Telefonica
      end
    end
  end
end
