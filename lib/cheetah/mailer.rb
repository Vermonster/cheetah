module Cheetah
  class Mailer

    UNSUB_REASON = {
      'a'	=> 'abuse complaint',
      'b'	=> 'persistent bounces',
      'd'	=> 'deleted via admin interface',
      'e'	=> 'email to remove address (from mailing)',
      'i'	=> 'request via api',
      'k'	=> 'bulk unsubscribe',
      'r'	=> 'request in reply to mailing',
      'w'	=> 'web-based unsubscribe (link from mailing)',
    }

    attr_reader :messenger, :options

    # options hash example (all fields are required, except whitelist_filter):
    # {
    #   :host             => 'ebm.cheetahmail.com'
    #   :username         => 'foo_api_user'
    #   :password         => '12345'
    #   :aid              => '67890'                  # the 'affiliate id'
    #   :whitelist_filter => //                       # if set, emails will only be sent to addresses which match this pattern
    #   :enable_tracking  => true                     # determines whether cheetahmail will track the sending of emails for analytics purposes
    #   :messenger        => Cheetah::ResqueMessenger
    # }
    def initialize(options)
      @messenger = Messenger.new(options)
    end

    def send_email(eid, email, params = {})
      params.merge!(
        eid: eid.to_s,
        email: email
      )

      messenger.send_message('/ebm/ebmtrigger1', params)
    end

    def mailing_list_update(email, params = {})
      params.merge!(
        email: email
      )

      messenger.send_message('/api/setuser1', params)
    end

    def mailing_list_email_change(email, new_email)
      params = {
        email: email,
        newemail: new_email
      }

      messenger.send_message('/api/setuser1', params)
    end

  end
end
