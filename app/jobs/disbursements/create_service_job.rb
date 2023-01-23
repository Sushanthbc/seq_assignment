module Disbursements
  class CreateServiceJob < ApplicationJob
    def perform(*args)
      Disbursements::CreateService.perform
    end
  end
end