require 'rails_helper'

RSpec.describe User, type: :model do

  before(:each) do
    @user = User.new(
      first_name: 'Ftest',
      last_name: 'Ltest',        
      email: 'test@test.com',
      password: 'password',
      password_confirmation: 'password'    )

  end   

  describe 'Validations' do

    it 'is invalid if email is missing' do
      @user.email = nil
      expect(@user).to be_invalid
    end

    it 'is invalid if first_name is missing' do
      @user.first_name = nil
      expect(@user).to be_invalid 
    end

    it 'is invalid if last_name is missing' do
      @user.last_name = nil
      expect(@user).to be_invalid 
    end

    it 'is invalid if password and password_confirmation are missmatch' do
      @user.password_confirmation = 'wrong_password'
      expect(@user).to be_invalid 
    end    

    it 'is invalid if the email is not unique' do
      ori_user = User.new(
                  first_name: 'ori',
                  last_name: 'ori', 
                  email: 'test@test.comx', 
                  password: 'password', 
                  password_confirmation: 'password'
                )
      ori_user.save
      dup_user = User.new(
                  first_name: 'dup',
                  last_name: 'dup', 
                  email: 'Test@test.comx', 
                  password: 'password', 
                  password_confirmation: 'password'
                )
      dup_user.validate
      expect(dup_user.errors.messages[:email].to_s).to include('has already been taken')
    end

    it 'is invalid if password length less than 4 characters ' do
      @user.password = '123'
      expect(@user).to be_invalid
    end 

  end

  describe '.authenticate_with_credentials' do

    it 'should not pass with invalid credentials' do
      auth_user = User.new(
        first_name: 'Fname',
        last_name: 'Lname',
        email: 'tst@tst.com',
        password: 'password',
        password_confirmation: 'password'
      )
      auth_user.save

      user = User.authenticate_with_credentials('tst@tst.com', 'wrong_password')
      expect(user).to be(nil)
    end    

    it 'should log the user in if email case is different' do
      auth_user = User.new(
        first_name: 'Fname',
        last_name: 'Lname',
        email: 'tst@tst.com',
        password: 'password',
        password_confirmation: 'password'
      )
      auth_user.save
      expect(auth_user).to eq(User.authenticate_with_credentials('TST@tst.com', 'password'))
    end    
  
    it 'should pass even with white spaces in email' do
      auth_user = User.new(
        first_name: 'Fname',
        last_name: 'Lname',
        email: 'tst@tst.com',
        password: 'password',
        password_confirmation: 'password'
      )
      auth_user.save
      expect(auth_user).to eq(User.authenticate_with_credentials(' tst@tst.com ', 'password'))
    end   

  end

end