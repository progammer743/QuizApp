require_relative 'question'
require_relative 'model'
require 'time'
# Input Class
class Inputs
  def self.take_user_input
    data = []
    clear_screen
    name = take_input(custom_puts('Please Enter Your Name:: '))
    password = take_input(custom_puts('Please Enter Your Password:: '))
    role = take_input("\tPlease Enter Your Role [teacher/student]:: ", %w[teacher student])
    data << name << password << role
  end

  def self.take_input(title = nil, expected = nil)
    loop do
      title.nil? ? nil : print("#{title}\n")
      str = gets.chomp
      expected.nil? || expected.include?(str) ? (return str) : nil
      valid_request
    end
  end

  def self.take_input_lock
    take_input('Is Quiz Locked [y/n]', %w[y n Y N]).downcase
  end

  def self.user_entry
    loop do
      clear_screen
      custom_puts('To SignUp Enter:: 1')
      custom_puts('To Login Enter:: 2')
      custom_puts('To Exit:: 3')
      choice = take_input
      return choice if %w[1 2 3].include?(choice)

      valid_request
    end
  end

  def self.quiz_entry
    loop do
      clear_screen
      custom_puts('To Create a Quiz Enter:: 1')
      custom_puts('To Edit a Quiz:: 2')
      custom_puts('To Lock/UnLock a Quiz:: 3')
      custom_puts('To View Attempts:: 4')
      custom_puts('To Exit:: 5')
      choice = take_input
      return choice if %w[1 2 3 4 5].include?(choice)

      valid_request
    end
  end

  def self.print_titles_quizzes(quizzes)
    puts('-----------------')
    puts('quiz no:: Title')
    puts('-----------------')
    quizzes.each_with_index do |quiz, index|
      print("#{index + 1}:: ")
      puts(quiz.title)
    end
  end

  def self.unique_title(quizzes)
    loop do
      new_title = take_input(custom_puts('Please Enter title of the quiz'))
      unless quizzes.any? { |quiz| quiz.title == new_title }
        return new_title
      end
      custom_puts('Quiz with same name already present, please enter a different title')
      sleep(2)
      clear_screen
    end
  end

  def self.take_questions
    questions = []
    loop do
      clear_screen
      statement = take_input(custom_puts('Enter Question Statement'))
      choices = question_options
      correct = choices[%w[a b c d].index(take_input(custom_puts('Enter a correct key [a/b/c/d]'), %w[a b c d]))]
      questions << hash_question(statement, choices, correct)
      break unless take_input("To add more questions enter '1' to halt enter any key") == '1'
    end
    questions
  end

  def self.hash_question(statement, choices, correct)
    hash_questions = {}
    hash_questions['statement'] = statement
    hash_questions['choices'] = choices
    hash_questions['correct'] = correct
    hash_questions
  end

  def self.question_options
    options = %w[a b c d]
    values = []
    4.times do |i|
      print "(#{options[i]})  "
      x = gets.chomp
      values << x
    end
    values
  end

  def self.take_time_range
    loop do
      start_time = take_time_input('start')
      end_time = take_time_input('end')
      range = start_time..end_time
      end_time > start_time ? (return range) : custom_puts('End time is less than start time')
    end
  end

  def self.take_time_input(status)
    loop do
      begin
        time = Time.parse(take_input(custom_puts("Please enter #{status} time (e.g. 'YYYY-MM-DD H:M:S'): ")))
        return time
      rescue ArgumentError
        valid_request
      end
    end
  end

  def self.teacher_attempt_entry
    loop do
      clear_screen
      custom_puts('To View All Attempts:: 1')
      custom_puts('To Exit:: 2')
      choice = take_input
      %w[1 2].include?(choice) ? (return choice) : valid_request
    end
  end

  def self.student_attempt_entry
    loop do
      clear_screen
      custom_puts('To attempt a Quiz:: 1')
      custom_puts('To View Attempts:: 2')
      custom_puts('To Exit:: 3')
      choice = take_input
      %w[1 2 3].include?(choice) ? (return choice) : valid_request
    end
  end

  def self.show_attemptable_quizzes
    quizzes = Quiz.attemptable_quiz_array
    if quizzes.empty?
      custom_puts('No quiz available')
      sleep(4)
      return
    end
    clear_screen
    print_titles_quizzes(quizzes)
    take_input('Enter Quiz number which you want to Attempt', (1..quizzes.size).to_a.map(&:to_s))
  end

  def self.attempt_quiz(quiz_number, student_name)
    values = { a: 0, b: 1, c: 2, d: 3 }
    data = []
    original_answers = []
    answers = []
    quiz = Quiz.attemptable_quiz_array[quiz_number-1]
    total_questions = quiz.questions.length
    attempt_time = Time.now
    quiz.questions.each_with_index do |question, index|
      original_answers << question.correct
      clear_screen
      puts "Question #{index + 1} of #{total_questions}"
      puts '------------------------------'
      answers << question.choices[values[attempt_question(question)]]
    end
    score = calculate_score(answers, original_answers)
    data << quiz.title << student_name << score << attempt_time
  end

  def self.calculate_score(answers, original_answers)
    total_score = 0
    total_questions = answers.length.to_f
    answers.each_with_index do |answer, index|
      if answer == original_answers[index]
        total_score += 1
      end
    end
    total_score = (total_score / total_questions) * 100

  end

  def self.attempt_question(question)
    options = %w[a b c d]
    loop do
      puts question.statement
      4.times do |i|
        print "(#{options[i]}) #{question.choices[i]}"
        puts
      end
      puts 'Enter your answer [a/b/c/d]:: '
      choice = gets.chomp
      choice = choice.downcase
      return choice.to_sym if options.include?(choice)
    end
  end

  def self.print_quizzes_with_lock_status(quizzes)
    puts('-----------------')
    puts('quiz no:: Title :: Lock Status')
    puts('-----------------')
    quizzes.each_with_index do |quiz, index|
      print("#{index + 1}:: ")
      print("#{quiz.title}:: ")
      puts(quiz.lock)
    end
  end

  def self.change_lock(quizzes, qzzs)
    print_quizzes_with_lock_status(quizzes)
    quiz_number = take_input('Enter Quiz number which you want to Lock/UnLock', (1..quizzes.size).to_a.map(&:to_s))
    quiz = quizzes[quiz_number.to_i - 1]
    title = quiz.title
    index = 0
    qzzs.each_with_index do |qz, i|
      if qz.title == title
        index = i
      end
    end
    quiz = qzzs[index]
    quiz.lock == 'n' ? quiz.lock = 'y' : quiz.lock = 'n'
    QuizModel.new(quizzes: qzzs).save_to_file('data1.json')
    custom_puts("Quiz #{quiz.title} Lock Status is #{quiz.lock}")
    sleep(3)
  end

  def self.user_not_found
    custom_puts('User not found')
    sleep(2)
    clear_screen
  end

  def self.valid_request
    custom_puts("OOPS...!\n\tPlease Enter a valid Input")
    sleep(2)
    # clear_screen
  end

  def self.custom_puts(title)
    puts "\t#{title}"
  end

  def self.login_or_sign_up
    take_input("To sign up Enter '1'")
  end

  def self.clear_screen
    system('clear')
  end
end