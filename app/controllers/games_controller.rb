require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    alphabets = ('A'..'Z').to_a
    10.times { @letters << alphabets.sample }
  end

  def score
    @word = params[:word]
    @grid_letters = params[:post_letters].chars
    if using_valid_letters?(@word, @grid_letters)
      if search_english_word(@word)
        @answer = "Congratulations! #{@word} is a valid English word!"
      else
        @answer = "Sorry but #{@word} does not seem to be a valid English word..."
      end
    else
      @answer = "Sorry but #{@word} cannot be built out of #{@grid_letters.join(", ")}"
    end
  end

  private

  def search_english_word(word)
    api_url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_hash = JSON.parse(URI.open(api_url).read)
    word_hash["found"]
  end

  def using_valid_letters?(word, grid_letters)
     word.chars.all? do |letter|
        word.count(letter) <= grid_letters.count(letter)
      end
  end
end
