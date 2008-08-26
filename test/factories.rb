
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

def towwl_fields(options={})
  { :name => 'towwl name',
    :user => find_or_create_user
  }.merge(options)
end
def build_towwl(options={})
  Towwl.new(towwl_fields(options))
end
def create_towwl(options={})
  t = build_towwl(options)
  t.save!
  t
end
  
def item_fields(options={})
  { :text => 'item text',
    :user => find_or_create_user,
    :towwl => options[:towwl] || create_towwl
  }.merge(options)
end
def build_item(options={})
  Item.new(item_fields(options))
end
def create_item(options={})
  i = build_item(options)
  i.save!
  i
end

def command_fields(options={})
  { :action => 'created_towwl',
    :user => find_or_create_user,
    :commandable => build_towwl
  }.merge(options)
end
def build_command(options={})
  Command.new(command_fields(options))
end
def create_command(options={})
  commandable = options[:commandable] || create_towwl
  latest_command_for(commandable)
  # c = build_command(options)
  # c.save!
  # c
end
def latest_command_for(commandable)
  Command.find(:first, :conditions => {:commandable_type => commandable.class.to_s, :commandable_id => commandable.id}, 
    :order => 'created_at DESC')
end
