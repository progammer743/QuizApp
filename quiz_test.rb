require 'rspec'
require 'time'
require_relative 'question'
require_relative 'inputs'

# Quiz TestCases
RSpec.describe Quiz do
  let(:statement) { 'What is color of sky' }
  let(:choices) { %w[blue red green yellow] }
  let(:correct) { 'blue' }
  let(:question) { Question.new(statement, choices, correct) }
  let(:title) { 'Test Quiz' }
  let(:time_range) { Time.now..Time.now + 3600 }
  let(:teacher_name) { 'John' }
  let(:quiz) { Quiz.new(title, question, time_range, 'n', teacher_name) }
  let(:quizzes) { [] }

  describe '#initialize Quiz Instance' do
    it 'creates a new instance of Quiz' do
      expect(quiz).to be_an_instance_of Quiz
    end
  end

  before do
    allow(Inputs).to receive(:unique_title).with(quizzes).and_return('Math Quiz')
    allow(Inputs).to receive(:take_questions).and_return([{ statement: statement, choices: choices, correct: correct }])
    allow(Inputs).to receive(:take_time_range).and_return(time_range)
    allow(Inputs).to receive(:take_input_lock).and_return('n')
    allow(Question).to receive(:from_json).with({ statement: statement, choices: choices, correct: correct }).and_return(question)
  end

  it 'adds a new quiz to the quizzes list and saves it to file' do
    expect(File).to receive(:write).with('data6.json')
    Quiz.create_quiz(quizzes, teacher_name)
    expect(quizzes.size).to eq(1)
  end
end