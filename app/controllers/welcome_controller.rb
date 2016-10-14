class WelcomeController < ApplicationController
  def index
    @book_words = BookWords.joins('INNER JOIN `words` ON `words`.`id` = `book_words`.`word_id`')
                           .select('`words`.`id`, `words`.`word`')
                           .group('`words`.`word`')
                           .order('`words`.`word`')

    if params[:page].present?
      @book_words = @book_words.where(page: params[:page])
    end

    if params[:word].present?
      @book_words = @book_words.where(['`words`.`word` LIKE(?)', "%#{params[:word]}%".downcase])
    elsif params[:char].present?
      @book_words = @book_words.where(['`words`.`first_char` = ?', params[:char].downcase])
    end
  end

  def show
    @definitions = Definitions.where(word: params[:word]).order(:word_type, :position)
    @translations = Translations.where(word: params[:word])

    respond_to do |format|
      format.js{ render 'modal' }
    end
  end
end
