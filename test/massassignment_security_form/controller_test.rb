require 'test_helper'
require File.join(File.dirname(__FILE__), '..', 'test_helper')

class MassassignmentSecurityForm::ControllerTest < ActionController::TestCase
  class MassassignmentSecurityFormPeopleController < ApplicationController
    def create
      @person = MassassignmentSecurityFormPerson.new params[:person]
      if @person.save
        render :inline => 'success', :status => :created
      else
        render :inline => 'failure', :status => :accepted
      end
    end
  end

  self.controller_class = MassassignmentSecurityFormPeopleController

  def teardown
    MassassignmentSecurityForm::Config.remove_not_allowed_massassignment_fields = false
    super
  end

  context 'MassassignmentSecurityForm::Config.remove_not_allowed_massassignment_fields = true' do
    setup do 
      MassassignmentSecurityForm::Config.remove_not_allowed_massassignment_fields = true
    end
    
    context "on post :create with valid attributes and without MASSASSIGNMENT_PARAM" do 
      setup do
        post :create, :person => {
          :first_name => 'first name',
          :last_name => 'last name'}
      end

      should assign_to :person
      should respond_with :accepted

      should 'not create a person' do 
        assert MassassignmentSecurityFormPerson.count.zero?
      end

      should 'build the person without attributes' do 
        person = assigns(:person)
        assert person.first_name.blank?
        assert person.last_name.blank?
      end
    end
    
    context "on post :create with valid attributes and with invalid MASSASSIGNMENT_PARAM" do 
      setup do
        @form_fields = MassassignmentSecurityForm::MassassignmentColumnsHash.new
        @form_fields.add_column 'person', 'last_name'
        
        post :create, :person => {
          :first_name => 'first name',
          :last_name => 'last name'},
          MassassignmentSecurityForm::Config::MASSASSIGNMENT_PARAMS_NAME => @form_fields.to_encrypted_string[0..-10]
      end

      should assign_to :person
      should respond_with :accepted

      should 'not create a person' do 
        assert MassassignmentSecurityFormPerson.count.zero?
      end

      should 'build the person without attributes' do 
        person = assigns(:person)
        assert person.first_name.blank?
        assert person.last_name.blank?
      end
    end
    
    context "on post :create with valid attributes and with valid MASSASSIGNMENT_PARAM for last_name" do 
      setup do
        @form_fields = MassassignmentSecurityForm::MassassignmentColumnsHash.new
        @form_fields.add_column 'person', 'last_name'
        
        post :create, :person => {
          :first_name => 'first name',
          :last_name => 'last name'},
          MassassignmentSecurityForm::Config::MASSASSIGNMENT_PARAMS_NAME => @form_fields.to_encrypted_string
      end

      should assign_to :person
      should respond_with :created

      should 'create a person' do 
        assert_equal 1, MassassignmentSecurityFormPerson.count
      end

      should 'build the person with last_name attribute' do 
        person = assigns(:person)
        assert_equal 'last name', person.last_name
      end

      should 'not build the person with first_name attribute' do 
        person = assigns(:person)
        assert person.first_name.blank?
      end
    end
  end

  context 'MassassignmentSecurityForm::Config.remove_not_allowed_massassignment_fields = false' do
    setup do 
      MassassignmentSecurityForm::Config.remove_not_allowed_massassignment_fields = false
    end
    
    context "on post :create with valid attributes and without MASSASSIGNMENT_PARAM" do 
      setup do
        post :create, :person => {
          :first_name => 'first name',
          :last_name => 'last name'}
      end

      should assign_to :person
      should respond_with :created

      should 'create a person' do 
        assert_equal 1, MassassignmentSecurityFormPerson.count
      end

      should 'build the person with attributes' do 
        person = assigns(:person)
        assert_equal 'first name', person.first_name
        assert_equal 'last name', person.last_name
      end
    end
  end
end
