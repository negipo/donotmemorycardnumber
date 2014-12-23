class Memory::Action < Memory::Base
  private

  def self.config_path
    Rails.root.join('config', 'actions.yml')
  end
end
