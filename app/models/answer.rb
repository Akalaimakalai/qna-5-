class Answer < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  after_create_commit :broadcast_answer
  after_create_commit :send_notification

  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true

  default_scope { order(correct: :desc).order(created_at: :asc) }

  def set_correct
    transaction do
      question.answers.update_all(correct: false)
      update!(correct: true)
      user.medals.push(question.medal) if question.medal
    end
  end

  private

  def broadcast_answer
    ActionCable.server.broadcast("question-#{question_id}", data: answer_data)
  end

  def answer_data
    { 
      answer: self,
      files: all_files,
      links: all_links,
      score: sum_votes
    }
  end

  def all_files
    files_arr = []

    files.each do |file|
      files_arr << { name: file.filename.to_s, url: file.service_url, id: file.id }
    end

    files_arr
  end

  def all_links
    links_arr = []

    links.each do |link|
      links_arr << { name: link.name, url: link.url, id: link.id }
    end

    links_arr
  end

  def send_notification
    NotificationMailer.new_answer_for(question).deliver_later
  end
end
