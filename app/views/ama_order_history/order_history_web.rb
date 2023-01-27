# frozen_string_literal: true

require "webrick"
require "erb"
require "open3"
require_relative "./term_names"
require_relative "./order_history_excel_writer"

class OrderHistoryWebApp
  def initialize
    @config = {
    DocumentRoot: "./",
    BindAddress: "127.0.0.1",
    Port: 8099
    }
    @server = WEBrick::HTTPServer.new(@config)
    WEBrick::HTTPServlet::FileHandler.add_handler("erb", WEBrick::HTTPServlet::ERBHandler)
    @server.config[:MimeTypes]["erb"] = "text/html"
    trap("INT") { @server.shutdown }
    add_procs
  end

  def add_procs
    add_collect_proc
    add_list_proc
    add_report_proc
    add_delete_proc
    add_excel_trans_proc
  end

  def run
    @server.start
  end

  def add_collect_proc #{[a,b],[c,d]...}each do|a,b|
    @server.mount_proc("/collect") do |req, res|
      p req.query
      term = req.query["term"]
      account = req.query["account"]
      script = "./order_history_reporter.rb"
      file = "ohr-#{term}.output"
      #script = "long_time_test.rb"
      #file = "ohr-dummy.output"
      cmd = "ruby #{script} -t #{term} -a #{account} > #{file}"
      stdout, stderr, status = Open3.capture3(cmd) #cmdが正常終了したかを判定する
      p stdout, stderr, status
      erb =
        if /exit 0/ =~ status.to_s
          "collected.erb"
        else
          "nocollected.erb"
        end
      template = ERB.new(File.read(erb))
      res.body << template.result(binding) #erb内容上書き
    end
  end
  def add_list_proc
    @server.mount_proc("list") do |req, res|
      template = ERB.new(File.read("list.erb"))
      res.body << template.result(binding)
    end
  end

  def add_report_proc
    @server.mount_proc("/report") do |req, res|
      p req.query
      term = req.query["term"]
      file = req.query["file"]
      p file
      account = req.query["account"]
      template = ERB.new(File.read("report.erb"))
      res.body << template.result(binding)
    end
  end

  def add_delete_proc
    @server.mount_proc("/delete") do |req, res|
      p req.query
      term = req.query["term"]
      file = req.query["file"]
      begin
        File.delete(file)
        p "#{file} was deleted."
        erb = "delete.erb"
      rescue => e
        errormsg = e
        erb = "nodeleted.erb"
      end
      template = ERB.new(File.read(erb))
      res.body << template.result(binding)
    end
  end

  def add_excel_trans_proc
    @server.mount_proc("/excel_trans") do |req, res|
      p req.query
      term = req.query["term"]
      file = req.query["file"]
      exfile = req.query["exfile"]
      begin
        app = OrderHistoryExcelWriter.new(file, exfile)
        app.write_order_history
        erb = "excel_trans_succeeded.erb"
      rescue => e
        errormsg = e
        erb = "excel_trans_failed.erb"
      end
      template = ERB.new(File.read(erb))
      res.body << template.result(binding)
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  app = OrderHistoryWebApp.new
  app.run
end