module TelefonicaHandle
  class MeteringDelegate < DelegateClass(Fog::Metering::OpenStack)
    include TelefonicaHandle::HandledList
    include Vmdb::Logging

    SERVICE_NAME = "Metering"

    attr_reader :name

    def initialize(dobj, os_handle, name)
      super(dobj)
      @os_handle = os_handle
      @name      = name
    end
  end
end
