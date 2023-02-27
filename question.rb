#Quiz Class
class Quiz
    attr_accessor :title, :questions, :time_range, :lock, :created_by
  
    def initialize(title, questions, time_range, lock, created_by)
      @title = title
      @questions = questions
      @time_range = time_range
      @lock = lock
      @created_by = created_by
    end
  
    def to_json(*_args)
      JSON.pretty_generate({ 'title' => @title, 'questions' => @questions, 'time_range' => @time_range, 'lock' => @lock, 'created_by' => @created_by })
    end
  
    def self.from_json(json)
      data = JSON.parse(json)
      quizzes = []
      data.each do |quiz|
        title = quiz['title']
        qus = quiz['questions']
        questions = qus.map { |q| Question.from_json(q) }
        quizzes << Quiz.new(title, questions, quiz['time_range'], quiz['lock'], quiz['created_by'])
      end
      quizzes
    end
  
    def self.create_quiz(quizzes, teacher_name)
      title = Inputs.unique_title(quizzes)
      questions = Inputs.take_questions
      question_objs = []
      questions.each do |question|
        question_objs << Question.from_json(question)
      end
      # print questions[0]['statement']
      time_range = Inputs.take_time_range
      lock = Inputs.take_input_lock.downcase
      quizzes << Quiz.new(title, questions, time_range, lock, teacher_name)
      QuizModel.new(quizzes: quizzes).save_to_file('data1.json')
    end
  
    def self.attemptable_quiz_array
      quizzes = []
      QuizModel.load_quizzes.each do |quiz|
        start_time, end_time = quiz.time_range.split('..')
        start_time = Time.parse(start_time)
        end_time = Time.parse(end_time)
        range = start_time..end_time
        quiz.lock == 'n' && range.include?(Time.now) ? quizzes << quiz : nil
      end
      quizzes
    end
  
    def self.edit_quiz(quizzes)
      # Inputs.print_titles_quizzes(quizzes)
    end
  
    def self.lock_unlock_quiz(quizzes, teacher_name)
      qzzs = QuizModel.load_quizzes.select { |quiz| quiz.created_by == teacher_name }
      if qzzs.length == 0
        Inputs.custom_puts('No Quizzes found')
        sleep(3)
      else
        Inputs.change_lock(qzzs, quizzes)
      end
    end
  end
  
  # Question Class
  class Question
    attr_accessor :statement, :choices, :correct
  
    def initialize(statement, choices, correct)
      @statement = statement
      @choices = choices
      @correct = correct
    end
  
    def to_json(*args)
      { 'statement' => @statement, 'choices' => @choices, 'correct' => @correct }.to_json(*args)
    end
  
    def self.from_json(data)
      self.new(data['statement'], data['choices'], data['correct'])
    end
  end