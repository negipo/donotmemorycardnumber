class Memory::Object < Memory::Base
  private

  def self.config_path
    Rails.root.join('config', 'objects.yml')
  end
end
