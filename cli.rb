require 'launchy'

print 'Email: '
email = gets.chomp
user = User.create(email: email)
begin
  print '(C)reate  or (V)isit Shortened URL: '
  action = gets.chomp
  raise "Invalid Input" unless action.casecmp('C') == 0 || action.casecmp('V') == 0
rescue
  retry
end

if action.casecmp('C') == 0
  print 'Long URL: '
  long_url = gets.chomp
  short_url = ShortenedUrl.make_shortened_url(user, long_url)
  short_url.save
  puts "Generated this sweet, short URL for you: #{short_url.short_url}"
else
  print 'Short URL: '
  url = gets.chomp
  short_url = ShortenedUrl.find_by(short_url: url)
  puts "Sending you away to: #{short_url.long_url}. Don't come back!"
  Launchy.open(short_url.long_url)
end
