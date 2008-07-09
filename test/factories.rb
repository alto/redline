require 'factory_girl'

Factory.define :user do |user|
  user.login 'dude'
  user.email 'dude@test.com'
  user.password 'password'
  user.password_confirmation 'password'
end

Factory.define :person do |person|
  # person.name 'person name'
end
