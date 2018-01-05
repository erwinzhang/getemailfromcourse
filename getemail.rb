require 'nokogiri'

current_dir = File.expand_path File.dirname(__FILE__)

all_course_files = Dir[current_dir + "/courses/*.zip"]

target_dirs = []
all_course_files.each do |course|
  target_course_dir = course.split(".zip")[0]
  target_dirs.push target_course_dir
  begin
    `unzip -o #{course} -d #{target_course_dir}`
  rescue
    puts "ERROR: Something wrong with zip file #{course}"
  end
end

def get_email_values xml
  begin
    xml.xpath("//EMAILADDRESS").map {|e| e["value"]}
  rescue
    puts "Parse XML #{xml} error"
  end
end

def get_email_user_mapping xml
  map = {}
  begin
    xml.xpath("//USER").each do |user|
      username = user.xpath("./USERNAME/@value").to_s
      email = user.xpath("./EMAILADDRESS/@value").to_s
      if not email.empty?
        map["#{username}"] = email
      end
    end
  rescue
    puts "Parse XML #{xml} error"
  end
  map
end

user_email_mapping = {}
target_dirs.each do |course|
  datfiles = Dir[course + "/*.dat"] #Get all DAT files
  i = 0
  datfiles.each do |dat|
    dat_detail = File.read(dat).delete("\n")
    xml = Nokogiri::XML(dat_detail)
    begin
      if xml.root.name.to_s.eql?("USERS")
        puts "Course: #{course} user email mapping detail as below:"
        user_email_mapping = get_email_user_mapping xml
        puts user_email_mapping
        break
      end
    rescue
      puts dat + " cannot get root node!"
    end
    i+=1
  end
  if i == datfiles.size
    puts "NO User files in course #{course}"
  end
end

# emails.flatten.uniq.each do |email|
#   puts email
# end

