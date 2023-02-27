# Attempt class
require_relative 'question'
class Attempt
  attr_accessor :quiz_title, :attempted_by, :score, :attempt_time

  def initialize(quiz_title, attempted_by, score, attempt_time)
    @quiz_title = quiz_title
    @attempted_by = attempted_by
    @score = score
    @attempt_time = attempt_time
  end

  def self.from_json(json)
    attempts_data = JSON.parse(json)
    attempts_data.map do |attempt|
      Attempt.new(attempt['quiz_title'], attempt['attempted_by'], attempt['score'], attempt['attempt_time'])
    end
  end

  def to_json(*_args)
    JSON.pretty_generate({ 'quiz_title' => @quiz_title, 'attempted_by' => attempted_by, 'score' => score, 'attempt_time' => attempt_time })
  end

  def self.make_attempt(attempts, name)
    quiz_number = Inputs.show_attemptable_quizzes
    quiz_number.nil? ? return : nil

    data = Inputs.attempt_quiz(quiz_number.to_i, name)
    attempts << Attempt.new(data[0], name, data[2], data[3])
    AttemptModel.new(attempts: attempts).save_to_file('attempts.json')
  end

  def self.show_attempts_student(name)
    attempts = AttemptModel.load_attempts.select {|attempt| attempt.attempted_by == name }
    if attempts.empty?
      puts 'No attempts.....!'
      sleep(5)
    else
      puts "Quiz_title \tScore \tAttempt Time"
      puts '------------------------------------------------------'
      attempts.each do |attempt|
        print "#{attempt.quiz_title} :\t"
        print "#{attempt.score} :\t"
        puts "#{attempt.attempt_time} "
      end
      sleep(10)
    end
  end

  def self.show_attempts_teacher(name)
    quizzes = QuizModel.load_quizzes.select { |quiz| quiz.created_by == name }
    attempts = AttemptModel.load_attempts.select do |attempt|
      quizzes.any? { |quiz| quiz.title == attempt.quiz_title }
    end
    if attempts.empty?
      puts 'No attempts.....!'
    #   sleep(3)
    else
      puts "Quiz_title \tAttempted_by \tScore \tAttempt Time"
      puts '------------------------------------------------------'
      attempts.each do |attempt|
        print "#{attempt.quiz_title} :\t"
        print "#{attempt.attempted_by} :\t  "
        print "#{attempt.score} :\t"
        puts "#{attempt.attempt_time} "
      end
    end
  end
end