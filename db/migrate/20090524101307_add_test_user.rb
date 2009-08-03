class AddTestUser < ActiveRecord::Migration
  def self.up
    User.delete_all

    User.create(
      :login => 'khanku',
      :email => 'khanku@',
      :password => 'khanku',
      :password_confirmation => 'khanku'
    )

  end

  def self.down
    User.delete_all
  end
end

# INSERT INTO "users"
#   ("salt",
#    "created_at",
#    "crypted_password",
#    "remember_token_expires_at",
#    "updated_at",
#    "remember_token",
#    "login",
#    "email")
#   VALUES
#     ('5c46a2527e0340abd4b8f46af07f19bfac5fc226',
#      '2009-05-24 10:12:19',
#      '52bb9fab0567e4c5054cb07dabb1b0cefe12db3d',
#      NULL,
#      '2009-05-24 10:12:19',
#      NULL,
#      'khanku',
#      'khanku@')
