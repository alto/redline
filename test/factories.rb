
def user_fields(login='dude')
  { :login                  => login,
    :url_slug               => login,
    :email                  => "#{login}@test.com",
    :password               => 'password',
    :password_confirmation  => 'password',
  }
end
def build_user(options={})
  User.new((options[:login].nil? ? user_fields : user_fields(options[:login])).merge(options))
end
def create_user(options={})
  u = build_user(options)
  u.save!
  u
end
def create_active_user(options={})
  u = create_user(options)
  u.activate
  u
end
def find_or_create_user(options={})
  User.find_by_login(options[:login] || 'dude') || create_user(options)
end

def site_fields(options={})
  { :url => 'http://factory.com',
  }.merge(options)
end
def build_site(options={})
  Site.new(site_fields(options))
end
def create_site(options={})
  s = build_site(options)
  s.save!
  s
end

def person_fields(options={})
  { :name => 'person name',
  }.merge(options)
end
def build_person(options={})
  Person.new(person_fields(options))
end
def create_person(options={})
  s = build_person(options)
  s.save!
  s
end

def claim_fields(options={})
  { :site => create_site,
    :user => find_or_create_user
  }.merge(options)
end
def build_claim(options={})
  Claim.new(claim_fields(options))
end
def create_claim(options={})
  c = build_claim(options)
  c.save!
  c
end

def naming_fields(options={})
  { :site => create_site,
    :name => 'person name',
    :user => find_or_create_user
  }.merge(options)
end
def build_naming(options={})
  Naming.new(naming_fields(options))
end
def create_naming(options={})
  c = build_naming(options)
  c.save!
  c
end

def command_fields(options={})
  { :action => 'added_claim',
    :user => find_or_create_user,
    :commandable => build_claim
  }.merge(options)
end
def build_command(options={})
  Command.new(command_fields(options))
end
def create_command(options={})
  commandable = options[:commandable] || create_claim
  latest_command_for(commandable)
end
def latest_command_for(commandable)
  Command.find(:first, :conditions => {:commandable_type => commandable.class.to_s, :commandable_id => commandable.id}, 
    :order => 'created_at DESC')
end
