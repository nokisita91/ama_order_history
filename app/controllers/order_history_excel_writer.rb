# frozen_string_literal: true

require "rubyXL"
require "rubyXL/convenience_methods/cell"
require "rubyXL/convenience_methods/workbook"

require_relative "./order_history_reader.rb"

class OrderHistoryExcelWriter
  def initialize(order_filename, excel_filename)
    @order_filename = order_filename
    @excel_filename = excel_filename
    @book = RubyXL::Workbook.new #新しいブック
    @sheet = @book[0] #一番最初のシート
  end

  def write_header
    @sheet.add_cell(0, 0, "ID")
    @sheet.add_cell(0, 1, "注文番号")
    @sheet.add_cell(0, 2, "注文日")
    @sheet.add_cell(0, 3, "合計")
    @sheet.add_cell(0, 4, "お届け先")
    @sheet.add_cell(0, 5, "明細")
  end

  def add_cell_with_date_format(row, column ,order_date) #注文日追加用メソッド
    cell = @sheet.add_cell(row, column, 0)
    od = Date.strptime(order_date, "%Y年 %m月 %d日")
    cell.change_contents(od)
    cell.set_number_format("yyyy年mm月dd日")
  end

  def add_cell_with_price_format(row, column ,price) #金額追加用メソッド
    cell = @sheet.add_cell(row, column, 0)
    p = price.split(/\D+/).join.to_i #price(金額)を数字以外で区切って結合して整数にする
    cell.change_contents(p)
    cell.set_number_format("#,##0円")
  end

  def write_records
    row = 1
    OrderHistoryReader.new(@order_filename) do |reader|
      reader.each do |rec|
        @sheet.add_cell(row, 0, rec["ID"])
        @sheet.add_cell(row, 1, rec["注文番号"])
        add_cell_with_date_format(row, 2, rec["注文日"])
        add_cell_with_price_format(row, 3, rec["合計"])
        @sheet.add_cell(row, 4, rec["お届け先"])
        @sheet.add_cell(row, 5, rec["明細"])
        row += 1
      end
    end
  end

  def write_order_history
    write_header
    write_records
    @book.write(@excel_filename)
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "OHF : #{ARGV[0]}"
  puts "OHE : #{ARGV[1]}"
  app = OrderHistoryExcelWriter.new(ARGV[0], ARGV[1])
  app.write_order_history
end