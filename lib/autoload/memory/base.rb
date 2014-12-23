class Memory::Base
  attr_reader :name, :number

  def initialize(name: name, number: number)
    @name = name
    @number = number
  end

  def self.all
    @actions ||= YAML.load_file(config_path).map.with_index do |name, idx|
      self.new(
        name: name,
        number: idx
      )
    end
  end

  def self.at(numbers)
    self.all[numbers]
  end
end
