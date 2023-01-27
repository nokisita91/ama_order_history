require "open3"
require "optparse"
require_relative "./term_names"
require_relative "./order_history_excel_writer"
require_relative "./order_history_reporter"

class AmaOrderHistoryController < ApplicationController
  
  protect_from_forgery
  protect_from_forgery except: :collect_post #クッキー仕込むときに外す
  
  def index
  end

  def collect
    
  end

  def collect_post
    
    term = params[:term]
    account = params[:account_mail]
    password = params[:account_password]
    script = "./app/controllers/order_history_reporter.rb"
    @file = "ohr-#{term}.txt"
    #script = "long_time_test.rb"
    #file = "ohr-dummy.output"
    #cmd = "ruby #{script} -t #{term} -a #{account} > #{file}"
    cmd = "ruby #{script} -t #{term} -a #{account} -p #{password} -f #{@file}"
    @stdout, stderr, status = Open3.capture3(cmd) #外部rb実行、cmdが正常終了したかを判定する　{"RAILS_ENV" => Rails.env} 
    p @stdout, stderr, status    
    if /exit 0/ =~ status.to_s
      cookies[:exported] = { value: "yes", expires: 1.hour.from_now }
      send_data(@stdout, filename: @file, disposition: 'attachment')
    else
      render :nocollected
    end
    
  end

  def collect_DL
  end

  def collected
  end

  def delete
  end

  def excel_trans_failed
  end

  def excel_trans_succeeded
  end

  def excel_trans
  end

  def list
  end

  def nocollected
    #term = params[:nocollect_term]
    #account = params[:nocollect_account]
  end

  def nodeleted
    if cookies.exists?(:exported)
      cookies.delete(:exported)
    end
  end

  def report
  end

  def test
    render layout: false
    cookies[:login] = { value: "test", expires: 1.hour.from_now }
  end


end
