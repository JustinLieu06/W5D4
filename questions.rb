require 'sqlite3'
require 'singleton'

class QuestionsDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end

end

class Questions
  attr_accessor :id, :title, :body, :user_id
  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end

  def self.find_by_id(id)
    question = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.id = ?
    SQL

    Questions.new(question.first)
  end

  def self.find_by_author_id(user_id)
    question = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.user_id = ?
    SQL

    question.map { |q| Questions.new(q) }
  end

  def author
    user = QuestionsDBConnection.instance.execute(<<-SQL, self.user_id)
      SELECT
        *
      FROM
        users
      WHERE
        users.id = ?
    SQL

    Users.new(user.first)
  end

  def replies
    Replies.find_by_question_id(self.id)
  end

  def followers
    Question_Follows.followers_for_question_id(self.id)
  end

end

class Users
  attr_accessor :id, :fname, :lname
  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def self.find_by_id(id)
    user = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        users.id = ?
    SQL

    Users.new(user.first)
  end

  def self.find_by_name(fname, lname)
    user = QuestionsDBConnection.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        users.fname = ? AND users.lname = ?
    SQL

    Users.new(user.first)
  end

  def authored_questions
    Questions.find_by_author_id(self.id)
  end

  def authored_replies
    Replies.find_by_author_id(self.id)
  end

  def followed_questions
    Question_Follows.followed_questions_for_user_id(self.id)
  end
end

class Question_Follows
  attr_accessor :id, :user_id, :question_id
  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def self.find_by_id(id)
    question_foll = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        question_follows.id = ?
    SQL

    Question_Follows.new(question_foll.first)
  end

  def self.followers_for_question_id(question_id)
    users = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        users
      JOIN
        questions ON users.id = questions.user_id
      WHERE
        questions.id = ?
    SQL

    users.map { |user| Users.new(user) }
  end

  def self.followed_questions_for_user_id(user_id)
    questions = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      JOIN
        users ON users.id = questions.user_id
      WHERE
        questions.user_id = ?
    SQL

    questions.map { |quest| Questions.new(quest) }

  end

end

class Replies
  attr_accessor :id, :body, :question_id, :reply_id, :user_id
   def initialize(options)
    @id = options['id']
    @body = options['body']
    @question_id = options['question_id']
    @reply_id = options['reply_id']
    @user_id = options['user_id']
  end

  def self.find_by_id(id)
    rep = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.id = ?
    SQL

    Replies.new(rep.first)
  end

  def self.find_by_author_id(user_id)
    reps = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.user_id = ?
    SQL

    reps.map { |rep| Replies.new(rep) }
  end

  def self.find_by_question_id(question_id)
    reps = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.question_id = ?
    SQL

    reps.map { |rep| Replies.new(rep) }
  end

  def author
    user = QuestionsDBConnection.instance.execute(<<-SQL, self.user_id)
      SELECT
        *
      FROM
        users
      WHERE
        users.id = ?
    SQL

    Users.new(user.first)
  end

  def question
    question = QuestionsDBConnection.instance.execute(<<-SQL, self.question_id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.id = ?
    SQL

    Questions.new(question.first)
  end

  def parent_reply
    parent = QuestionsDBConnection.instance.execute(<<-SQL, self.reply_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.id = ?
    SQL

    Replies.new(parent.first)
  end

  def child_replies
    children = QuestionsDBConnection.instance.execute(<<-SQL, self.id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.reply_id = ?
    SQL

    children.map { |child| Replies.new(child) }
  end
end

class Question_Likes
  attr_accessor :id, :user_id, :question_id
  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def self.find_by_id(id)
    question_li = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        question_likes.id = ?
    SQL

    Question_Likes.new(question_li.first)
  end

end