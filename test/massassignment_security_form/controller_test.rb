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
    
    context "on post :create with valid attributes and with valid MASSASSIGNMENT_PARAM for last_name and birthday" do 
      setup do
        @form_fields = MassassignmentSecurityForm::MassassignmentColumnsHash.new
        @form_fields.add_column 'person', 'last_name'
        @form_fields.add_column 'person', 'birthday'
        
        post :create, :person => {
          :first_name => 'first name',
          :last_name => 'last name',
          'birthday(1i)' => '2013',
          'birthday(2i)' => '7',
          'birthday(3i)' => '11'},
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

      should 'build the person with birthday attribute' do 
        person = assigns(:person)
        assert_equal Date.new(2013, 7, 11), person.birthday
      end

      should 'not build the person with first_name attribute' do 
        person = assigns(:person)
        assert person.first_name.blank?
      end
    end
    
    context "on post :create with valid attributes and with invalid MASSASSIGNMENT_PARAM and nested attributes for one reflection" do 
      setup do
        @form_fields = MassassignmentSecurityForm::MassassignmentColumnsHash.new
        @form_fields.add_column 'person', 'last_name'
        @form_fields.add_nested_column 'person', 'seo_attributes', false, 'last_name'
        
        post :create, :person => {
          :first_name => 'first name',
          :last_name => 'last name',
          :seo_attributes => {
            :first_name => 'first name',
            :last_name => 'last name'}
          },
          MassassignmentSecurityForm::Config::MASSASSIGNMENT_PARAMS_NAME => @form_fields.to_encrypted_string
      end

      should assign_to :person
      should respond_with :created

      should 'create 2 persons' do 
        assert_equal 2, MassassignmentSecurityFormPerson.count
      end

      should 'create the person with last_name and the seo with last_name' do 
        person = assigns(:person)

        assert !person.new_record?
        person.reload

        assert person.first_name.blank?
        assert !person.last_name.blank?

        seo = person.seo
        seo.reload
        assert seo.first_name.blank?
        assert !seo.last_name.blank?
      end
    end
    
    context "on post :create with valid attributes and with invalid MASSASSIGNMENT_PARAM and nested attributes for many reflection" do 
      setup do
        @form_fields = MassassignmentSecurityForm::MassassignmentColumnsHash.new
        @form_fields.add_column 'person', 'last_name'
        @form_fields.add_nested_column 'person', 'employees_attributes', true, 'last_name'
        
        post :create, :person => {
          :first_name => 'first name',
          :last_name => 'last name',
          :employees_attributes => {
            '0' => {
              :first_name => 'first name',
              :last_name => 'last name'},
            '1' => {
              :first_name => 'first name',
              :last_name => 'last name'}
            }
          },
          MassassignmentSecurityForm::Config::MASSASSIGNMENT_PARAMS_NAME => @form_fields.to_encrypted_string
      end

      should assign_to :person
      should respond_with :created

      should 'create 3 persons' do 
        assert_equal 3, MassassignmentSecurityFormPerson.count
      end

      should 'create the person with last_name and the employees with last_name' do 
        person = assigns(:person)

        assert !person.new_record?
        person.reload

        assert person.first_name.blank?
        assert !person.last_name.blank?

        assert !person.employees.empty?
        person.employees.each do |employee|
          employee.reload
          assert employee.first_name.blank?
          assert !employee.last_name.blank?
        end
      end
    end
    
    context "on post :create with valid attributes and with invalid MASSASSIGNMENT_PARAM and nested attributes for many reflection and config is for one reflection" do 
      setup do
        @form_fields = MassassignmentSecurityForm::MassassignmentColumnsHash.new
        @form_fields.add_column 'person', 'last_name'
        @form_fields.add_nested_column 'person', 'employees_attributes', false, 'last_name'
        
        post :create, :person => {
          :first_name => 'first name',
          :last_name => 'last name',
          :employees_attributes => {
            '0' => {
              :first_name => 'first name',
              :last_name => 'last name'},
            '1' => {
              :first_name => 'first name',
              :last_name => 'last name'}
            }
          },
          MassassignmentSecurityForm::Config::MASSASSIGNMENT_PARAMS_NAME => @form_fields.to_encrypted_string
      end

      should assign_to :person
      should respond_with :created

      should 'create 1 persons' do 
        assert_equal 1, MassassignmentSecurityFormPerson.count
      end

      should 'create the person with last_name and no employee' do 
        person = assigns(:person)

        assert !person.new_record?
        person.reload

        assert person.first_name.blank?
        assert !person.last_name.blank?

        assert person.employees.empty?
      end
    end
    
    context "on post :create with valid attributes and with invalid MASSASSIGNMENT_PARAM and nested attributes for one reflection and config is for many reflection" do 
      setup do
        @form_fields = MassassignmentSecurityForm::MassassignmentColumnsHash.new
        @form_fields.add_column 'person', 'last_name'
        @form_fields.add_nested_column 'person', 'employees_attributes', true, 'last_name'
        
        post :create, :person => {
          :first_name => 'first name',
          :last_name => 'last name',
          :seo_attributes => {
            :first_name => 'first name',
            :last_name => 'last name'},
          },
          MassassignmentSecurityForm::Config::MASSASSIGNMENT_PARAMS_NAME => @form_fields.to_encrypted_string
      end

      should assign_to :person
      should respond_with :created

      should 'create 1 person' do 
        assert_equal 1, MassassignmentSecurityFormPerson.count
      end

      should 'create the person with last_name and no seo' do 
        person = assigns(:person)

        assert !person.new_record?
        person.reload

        assert person.first_name.blank?
        assert !person.last_name.blank?

        assert !person.seo
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
