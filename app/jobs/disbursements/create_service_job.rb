module Disbursements
  class CreateServiceJob < ApplicationJob
    queue_as :default
    def perform(*args)
      Disbursements::CreateService.perform
    end
  end
end