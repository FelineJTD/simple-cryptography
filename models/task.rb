# models/task.rb
class Task
    attr_accessor :id, :title, :description

    def initialize(id, title, description)
      @id = id
      @title = title
      @description = description
    end

    # Additional methods for database interactions, validations, etc.
    def self.hello_world
      "Hello world"
    end
  end
