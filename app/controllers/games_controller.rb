require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    @letters = params[:letters]
    if !included?(params[:attempt].upcase, @letters)
      @message = "Sorry but #{params[:attempt]} can't be built out of #{@letters}"
    else
      if english_word?(params[:attempt])
        @message = "Congraturations! #{params[:attempt]} is a valid English word!"
      else
        @message = "Sorry but #{params[:attempt]} does not seem to be a valid Englsih word..."
      end
    end
  end

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
