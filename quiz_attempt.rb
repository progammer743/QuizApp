require_relative 'model'
# Quiz attempt class
class QuizAttempt
  @@attempts = []
  attr_reader :title, :submitted_answers, :submitted_by, :score

  def initialize(title, submitted_answers, submitted_by, score)
    @title = title
    @submitted_answers = submitted_answers
    @submitted_by = submitted_by
    @score = score
  end

  def self.attempts
    @@attempts
  end

  def self.load_attempts
    ModelClass.load_data
    ModelClass.attempts.each do |attempt|
      title = attempt['title']
      submitted_answers = attempt['submitted_answers']
      submitted_by = attempt['submitted_by']
      score = attempt['score']
      attempts << QuizAttempt.new(title, submitted_answers, submitted_by, score)
      puts submitted_answers.class
      print submitted_answers
      puts
    end
  end
end

QuizAttempt.load_attempts