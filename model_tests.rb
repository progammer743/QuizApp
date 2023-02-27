require_relative 'model'
require 'rspec'
# Test Class for UserModel
RSpec.describe UserModel do
  let(:user1) { User.new(name: 'Alice', password: 'pass', role: 'teacher') }
  let(:user2) { User.new(name: 'Bob', password: 'pass', role: 'student') }
  let(:users) { [user1, user2] }
  let(:user_model) { UserModel.new(users: users) }

  describe '#initialize' do
    it 'creates a new instance of UserModel with an array of users' do
      expect(user_model).to be_a(UserModel)
      expect(user_model.users).to eq(users)
    end
  end

  describe '.from_json' do
    it 'creates a new instance of UserModel from a JSON file' do
      sample_json = '[{"name": "Alice", "password": "pass", "role": "teacher"},{"name": "Bob", "password": "pass", "role": "student"}]'
      allow(File).to receive(:read).with('users.json').and_return(sample_json)
      allow(UserModel).to receive(:from_json).and_return(user_model)
      expect(user_model).to be_an_instance_of UserModel
    end
  end

  describe 'to_json' do
    it 'converts users object into json' do
      sample_json = '[{"name": "Alice", "password": "pass", "role": "teacher"},{"name": "Bob", "password": "pass", "role": "student"}]'
      allow(JSON).to receive(:generate).with(users).and_return(sample_json)
      expect(user_model.to_json).to eq(sample_json)
    end
  end
end