require_relative 'inputs'
require_relative 'user'
require_relative 'model'
require_relative 'question'
$user_info = []
def main
  users = UserModel.load_users
  quizzes = QuizModel.load_quizzes
  attempts = AttemptModel.load_attempts
  loop do
    break_flag = user_choice(users)
    if break_flag == true
      return
    elsif $user_info[2] == 'teacher'
      quiz_choice(quizzes)
    elsif $user_info[2] == 'student'
      student_attempt_choice(attempts)
    end
  end
end

def user_choice(users)
  loop do
    choice = Inputs.user_entry
    case choice
    when '1'
      User.sign_up(users)
    when '2'
      login_successful?(users) ? break : nil
    when '3'
      return true
    end
  end
end

def login_successful?(users)
  res = User.login(users)
  if res.instance_of?(Array)
    $user_info = res
    return true
  end
  false
end

def quiz_choice(quizzes)
  loop do
    choice = Inputs.quiz_entry
    case choice
    when '1'
      Quiz.create_quiz(quizzes, $user_info[0])
    when '2'
      Quiz.edit_quiz(quizzes, $user_info[0])
      sleep(5)
    when '3'
      Quiz.lock_unlock_quiz(quizzes, $user_info[0] )
    when '4'
      teacher_attempt_choice
    when '5'
      break
    end
  end
end

def student_attempt_choice(attempts)
  loop do
    choice = Inputs.student_attempt_entry
    case choice
    when '1'
      Attempt.make_attempt(attempts, $user_info[0])
    when '2'
      Attempt.show_attempts_student($user_info[0])
    else
      break
    end
  end
end

def teacher_attempt_choice
  loop do
    choice = Inputs.teacher_attempt_entry
    case choice
    when '1'
      # view all attempts
      Attempt.show_attempts_teacher($user_info[0])
      sleep(5)
    when '2'
      break
    end
  end
end
main