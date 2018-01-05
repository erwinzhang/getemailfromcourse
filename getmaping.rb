require 'nokogiri'

dat_detail = File.read("users.xml").delete("\n")
xml = Nokogiri::XML(dat_detail)

def get_email_user_mapping xml
  map = {}
  begin
    xml.xpath("//USER").each do |user|
      username = user.xpath("./USERNAME/@value").to_s
      email = user.xpath("./EMAILADDRESS/@value").to_s
      map["#{username}"] = email
    end
  rescue
    puts "Parse XML #{xml} error"
  end
  map
end

puts get_email_user_mapping xml
