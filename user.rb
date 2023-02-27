require_relative 'inputs'
require_relative 'model'
require 'json'
# User Class Defination
class User
  attr_accessor :name, :password, :role

  def initialize(name:, password:, role:)
    @name = name
    @password = password
    @role = role
  end

  def self.from_json(json)
    users_data = JSON.parse(json)
    users_data.map do |user_data|
      User.new(name: user_data['name'], password: user_data['password'], role: user_data['role'])
    end
  end

  def to_json(*_args)
    JSON.pretty_generate({ name: name, password: password, role: role })
  end

  def self.login(users)
    user_data = Inputs.take_user_input
    users.each do |user|
      if user.name == user_data[0] && user.password == user_data[1] && user.role == user_data[2]
        puts 'Login Successful'
        sleep(2)
        return user_data
      end
    end
    Inputs.user_not_found
    false
  end

  def self.sign_up(users)
    user_data = Inputs.take_user_input
    users.each do |user|
      if user.name == user_data[0]
        puts 'User with same Name already present'
        sleep(4)
        return false
      end
    end
    users << User.new(name: user_data[0], password: user_data[1], role: user_data[2])
    UserModel.new(users: users).save_to_file('users.json')
    true
  end
end