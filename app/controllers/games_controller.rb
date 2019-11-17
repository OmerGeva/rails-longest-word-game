require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @start_time = Time.now
    @grid = 10.times.map do
      ('A'..'Z').to_a.sample
    end
  end

  def score
    @time = Time.now - params[:start_time].to_time
    @word = params["word"]
    @word_attr = json_data(@word)
    @attempt_hash = {}

    @word_exists = @word_attr["found"]
    @score = (@word.length * 2) / @time
    @in_grid = ifinclude?(@word.upcase.split(''), params[:grid].split)

    if @word_exists && @in_grid
      @attempt_hash = { time: @time, score: @score, message: "Well Done!" }
    elsif @in_grid
      @attempt_hash = { time: @time, score: 0, message: "not an english word" }
    else
      @attempt_hash = { time: @time, score: 0, message: "not in the grid" }
    end
  end

  private

  def json_data(attempt)
    url =  "https://wagon-dictionary.herokuapp.com/#{attempt.downcase}"
    data = open(url).read
    JSON.parse(data)
  end

  def ifinclude?(attempt_array, grid)
    letters_exist = []
    attempt_array.each do |letter|
      if grid.count(letter) >= attempt_array.count(letter)
        letters_exist << true
      else
        letters_exist << false
      end
    end

    !letters_exist.include?(false)
  end
end
