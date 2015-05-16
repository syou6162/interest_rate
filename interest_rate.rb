#!/usr/bin/env ruby
# coding: utf-8
require 'open-uri'
require 'json'

def convert_date(str)
  year_tmp, month, day = str.split(".")
  if /([S|H])(\d?\d)/ =~ year_tmp then
    if $1 == "S"
      "#{$2.to_i + 1925}-#{month}-#{day}"
    elsif $1 == "H"
      "#{$2.to_i + 1988}-#{month}-#{day}"
    end
  end
end

def parse_line(line)
  date_tmp, *nums = line.split(",")
  date = convert_date date_tmp
  [date, *nums]
end

header = ["基準日", "1年", "2年", "3年" ,"4年", "5年", "6年", "7年", "8年", "9年", "10年", "15年", "20年", "25年", "30年", "40年"]

# content = open("http://www.mof.go.jp/jgbs/reference/interest_rate/data/jgbcm_all.csv").read
content = open("http://www.mof.go.jp/jgbs/reference/interest_rate/jgbcm.csv").read

content.split("\r\n").each{|line|
  if /^[S|H].*/ !~ line then
    next
  end
  items = parse_line line
  date = items[0]
  header.each_with_index{|item, idx|
    next if item == "基準日"
    rate = items[idx]
    next if rate == "-"
    result = {"id" => "#{date}_#{item}", "date" => date, "rate" => rate.to_f, "year" => item}
    puts result.to_json
  }
}
