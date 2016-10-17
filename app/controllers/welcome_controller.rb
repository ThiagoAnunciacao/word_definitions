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
    @definitions = Definitions.where(word: params[:word]).order(:position)
    @translations = Translations.where(word: params[:word])

    @definitions = @definitions.group_by{ |x| x.word_type }

    Unsplash.configure do |config|
      config.application_id     = "edf81e7f33d5d59d0e7bc708adb3747fc4683b3576d3e340f97b15269cdabfb2"
      config.application_secret = "b2e053d3487201142584cd55aeaa49454cb2560b69c20ea14b2ba105972572ca"
      config.application_redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
    end

    @search_results = Unsplash::Photo.search(params[:word])

    respond_to do |format|
      format.js{ render 'modal' }
    end
  end
end
