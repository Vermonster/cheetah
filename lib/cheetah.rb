require 'cheetah/exception'
require 'cheetah/message'
Dir["cheetah/messenger/**/*.rb"].each {|f| require f}

module Cheetah

  # determines if and how to send based on configuration
  def self.send(message)
    if CM_WHITELIST_FILTER and params['email'] =~ CM_WHITELIST_FILTER
      params['test'] = "1" if CM_ENABLE_TRACKING
      CM_MESSENGER.instance.send(message)
    else
      log "[SUPPRESSED due to whitelist] request to path '#{path}' with params #{params.inspect}"
    end
  end

  ##############################################################################
  public # ok, something to see here :)
  ##############################################################################

  def self.send_email(eid, email, params = {})
    path = "/ebm/ebmtrigger1"
    params['eid']   = eid
    params['email'] = email
    self.send(Message.new(path, params))
  end

  def self.mailing_list_update(sub_id, email, params = {})
    path = "/api/setuser1"
    params['sub']   = sub_id
    params['email'] = email
    params['a']     = 1 # this makes it so that the subscriptions passed in the call are used as the users complete set of subscriptions
    self.send(Message.new(path, params))
  end

  def self.mailing_list_email_change(oldemail, newemail)
    path = "/api/setuser1"
    params             = {}
    params['email']    = oldemail
    params['newemail'] = newemail
    self.send(Message.new(path, params))
  end

  # This returns a users information as it appears in Cheetah's database.
  # No use yet for this as of now, other than for testing.
  # Also, it's unfinished.
  def self.get_user(email)
    raise "not implemented yet!"
    path = "/api/getuser1"
    params          = {}
    params['email'] = email
    self.send(Message.new(path, params))
  end
end
