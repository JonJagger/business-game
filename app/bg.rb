# frozen_string_literal: true
require_relative 'bg_scores'
require_relative 'level_passwords'
require_relative 'events'
require 'sinatra/base'
require 'sinatra/contrib'
require 'sprockets'

module ApplicationHelper
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

class BG < Sinatra::Base
  register Sinatra::Contrib
  helpers ApplicationHelper

  set :port, ENV['PORT']
  set :environment, Sprockets::Environment.new
  set :erb, :escape_html => true
  environment.append_path('assets/stylesheets')
  environment.append_path('assets/javascripts')
  environment.css_compressor = :scss

  def initialize(app = nil)
    super(app)
  end

  get '/assets/*' do
    env['PATH_INFO'].sub!('/assets', '')
    settings.environment.call(env)
  end

  # - - - - - - - - - - - - - - -
  # Decisions

  get '/decisions_login' do
    @error = ""
    erb :"decisions/login"
  end

  get '/decisions_form' do
    if valid_level_password?
      @level_password = level_password
      @org_name = org_name
      @level = level
      erb :"decisions/form"
    else
      @error = "invalid password"
      erb :"decisions/login"
    end
  end

  post '/decisions_form' do
    a = decisions('a', 'wa')
    b = decisions('b', 'wb')
    c = decisions('c', 'wc')
    d = decisions('d', 'wd')
    sections = [params['a'], params['b'], params['c'], params['d']]
    scores = bg_scores(level, sentence?, rhymes?, a,b,c,d)
    save_decisions(org_name, level, sections, scores)
    erb :"decisions/login"
  end

  # - - - - - - - - - - - - - - -
  # Scores

  get '/scores_login' do
    @error = ""
    erb :"scores/login"
  end

  get '/scores' do
    if valid_level_password?
      @level_password = level_password
      @org_name = org_name
      @org_total = current_total(org_name)
      @other_org_name = other_org_name
      @other_org_total = current_total(other_org_name)
      @events = read_events(org_name)
      erb :"scores/view"
    else
      @error = "invalid password"
      erb :"scores/login"
    end
  end

  # - - - - - - - - - - - - - - -
  # Consulting

  get '/consulting' do
    @error = ""
    erb :"consulting/pay"
  end

  post '/consulting' do
    if valid_level_password?
      error = pay(org_name, level)
      if error != ""
        @error = error
        erb :"consulting/pay"
      else
        redirect "/scores?level_password=#{level_password}"
      end
    else
      @error = "invalid password"
      erb :"consulting/pay"
    end
  end

  private

  def decisions(s, is_word)
    s = params[s]
    params[is_word] === 'true' ? word(s) : blah(s)
  end

  def valid_level_password?
    LEVEL_PASSWORDS.has_key?(level_password)
  end

  def level_password
    params['level_password']
  end

  def level
    LEVEL_PASSWORDS[level_password][:level]
  end

  def org_name
    LEVEL_PASSWORDS[level_password][:org_name]
  end

  def sentence?
    params['sentence'] === 'true'
  end

  def rhymes?
    params['rhymes'] === 'true'
  end

  def word(s)
    [ s, true ]
  end

  def blah(s)
    [ s, false ]
  end

  def other_org_name
    if org_name === "BlueSquare"
       "GreenCircle"
    else
       "BlueSquare"
    end
  end

end
