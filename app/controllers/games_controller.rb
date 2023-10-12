class GamesController < ApplicationController
  require 'json'
  require 'open-uri'

  def new
    @start = Time.now()
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    @letters = params[:letters]
    @time = params[:time]
    @score = 0
    if !included?(params[:attempt].upcase, @letters)
      @message = "Sorry but '#{params[:attempt]}' can't be built out of #{@letters}"
    else
      if english_word?(params[:attempt])
        @message = "Congraturations! '#{params[:attempt]}' is a valid English word!"
        @score = (params[:attempt].size * 10) / (@time.to_f * 1000)
      else
        @message = "Sorry but '#{params[:attempt]}' does not seem to be a valid Englsih word..."
      end
    end
  end

  # def score
  #   @time = params[:time]
  #   @score = 0
  #   if self.included
  #     if self.found
  #       @result = "Congratulations! '#{params[:word].upcase}' is a valid English word!"
  #       @score = (@word.size * 10) / (@time.to_f * 1000)
  #     else
  #       @result = "Sorry, but '#{params[:word].upcase}' does not appear to be a valid English word!"
  #     end
  #   else
  #     @result = "Sorry but '#{params[:word].upcase}' can't be built out of #{params[:letters].split.join(', ')}"
  #   end
  # end

  def home
  end

  private

  def included?(word, letters)
    word.chars.all? do |letter|
      word.chars.count(letter) <= letters.count(letter)
    end
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json['found']
  end
end
