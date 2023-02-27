require 'json'
# require_relative 'quiz'
require_relative 'user'
require_relative 'question'
require_relative 'attempt'

# Model Class
class UserModel
  attr_accessor :users

  def initialize(users:)
    @users = users
  end

  def self.from_json
    json = File.read('users.json')
    users = User.from_json(json)
    UserModel.new(users: users)
  end

  def self.load_users
    user_model = UserModel.from_json
    user_model.users
  end

  def to_json(*_args)
    JSON.generate(users)
  end

  def save_to_file(filename)
    File.write(filename, to_json)
  end
end

# Quiz Model Class
class QuizModel
  attr_accessor :quizzes

  def initialize(quizzes:)
    @quizzes = quizzes
  end

  def self.from_json
    json = File.read('data1.json')
    quizzes = Quiz.from_json(json)
    QuizModel.new(quizzes: quizzes)
  end

  def self.load_quizzes
    quiz_model = QuizModel.from_json
    quiz_model.quizzes
  end

  def to_json(*_args)
    JSON.generate(quizzes)
  end

  def save_to_file(filename)
    File.write(filename, to_json)
  end
end

# Quiz Model Class
class AttemptModel
  attr_accessor :attempts

  def initialize(attempts:)
    @attempts = attempts
  end

  def self.from_json
    json = File.read('attempts.json')
    attempts = Attempt.from_json(json)
    AttemptModel.new(attempts: attempts)
  end

  def self.load_attempts
    attempt_model = AttemptModel.from_json
    attempt_model.attempts
  end

  def to_json(*_args)
    JSON.generate(attempts)
  end

  def save_to_file(filename)
    File.write(filename, to_json)
  end
end