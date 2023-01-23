class ApplicationService
  class << self
    def perform(*args)
      new(*args).perform
    end
  end
end