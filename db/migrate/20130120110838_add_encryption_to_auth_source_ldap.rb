class AddEncryptionToAuthSourceLdap < ActiveRecord::Migration
  class AuthSource < ActiveRecord::Base
  end

  def up
    add_column :auth_sources, :encryption, :string, :default => "none", :null => false
    AuthSourceLdap.all do  |auth_source|
      auth_source.encryption = :simple_tls if auth_source.tls
    end
    remove_column :auth_sources, :tls
  end

  def down
    add_column :auth_sources, :tls, :boolean, :default => false, :null => false

    AuthSourceLdap.all do |auth_source|
      if auth_source.encryption == :simple_tls
        auth_source = true
      else
        #because we're removing support for :start_tls, we're losing information. sorry
        auth_source.tls = false
      end
    end
    remove_column :auth_sources, :encryption
  end
end
