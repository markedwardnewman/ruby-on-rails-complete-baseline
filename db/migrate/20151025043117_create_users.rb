class CreateUsers < ActiveRecord::Migration
  def change                    #<- determines the change to be made to the database
    create_table :users do |t|  #<- Rails method called create_table to create a table in the database for storing users
                                    # Note how the table name is plural (users), vs the name given to the model (User).
                                    # a model represents a single user, whereas a database table consists of many users.
      t.string :name            #<- a column in the database
      t.string :email           #<- a column in the database

      t.timestamps null: false  #<- creates two magic columns called created_at and updated_at
                                    # used for timestamps that automatically record when a given user is created and updated
    end
  end
end
