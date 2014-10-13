require 'test_helper'
require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'action_view/test_case'

class ActionView::TestCase

  def setup
    @controller = ActionView::TestCase::TestController.new
    @request = @controller.request
    @response = @controller.response
    super
  end

  attr_reader :controller, :request, :response
end

class MassassignmentSecurityForm::FormHelperTest < ActionView::TestCase

  context "form with text_field" do
    subject do 
      form_html = <<-END
      <% def protect_against_forgery?; false; end -%>
      <%= form_tag '/test' do %>
        <%= text_field :person, :first_name %>
      <% end %>
      END
      
      form_html.gsub!("<%= form", "<% form") if Rails.version <= "3.0"
      render :inline => form_html
    end

    should "render massassignment_fields" do
      assert subject.include?(MassassignmentSecurityForm::Config::MASSASSIGNMENT_PARAMS_NAME)
      assert_equal 1, subject.scan(MassassignmentSecurityForm::Config::MASSASSIGNMENT_PARAMS_NAME).count
    end
  end

  context "form_for with text_field" do
    subject do 
      @person = MassassignmentSecurityFormPerson.new
      form_html = <<-END
      <% def protect_against_forgery?; false; end -%>
      <%= form_for @person, :url => '/test' do |f| %>
        <%= f.text_field :first_name %>
      <% end %>
      END
      
      form_html.gsub!("<%= form", "<% form") if Rails.version <= "3.0"
      render :inline => form_html
    end

    should "render massassignment_fields" do
      assert subject.include?(MassassignmentSecurityForm::Config::MASSASSIGNMENT_PARAMS_NAME)
      assert_equal 1, subject.scan(MassassignmentSecurityForm::Config::MASSASSIGNMENT_PARAMS_NAME).count
    end
  end

  def self.form_helper_context(context_name, form_line, columns_hash) 
    context context_name do
      setup do 
        @_form_fields = MassassignmentSecurityForm::MassassignmentColumnsHash.new
        form_line.gsub!("<%= form", "<% form") if Rails.version <= "3.0"
        form_line.gsub!("<%= f.fields_for", "<% f.fields_for") if Rails.version <= "3.0"
        render :inline => form_line
      end

      should "set massassignment_fields" do
        assert !@_form_fields.blank?
        assert_equal columns_hash, @_form_fields.form_columns
      end
    end
  end

  [:text_field, :password_field, :hidden_field, :file_field, :text_area, :check_box,
   :country_select, :date_select, :time_select, :datetime_select].each do |form_helper_name|
    form_helper_context "#{form_helper_name} :person, :first_name", 
      "<%= #{form_helper_name} :person, :first_name %>",
      {'person' => ['first_name']}
  end

  [:search_field, :telephone_field, :phone_field, :url_field, :email_field,
   :number_field, :range_field].each do |form_helper_name|
    form_helper_context "#{form_helper_name} :person, :first_name", 
      "<%= #{form_helper_name} :person, :first_name %>",
      {'person' => ['first_name']}
  end if Rails.version >= '3.0'
    
  form_helper_context "radio_button :person, :salutation", 
    "<%= radio_button :person, :salutation, 'mr' %><%= radio_button :person, :salutation, 'mrs' %>",
    {'person' => ['salutation']}
    
  form_helper_context "collection_select :person, :group_ids", 
    "<%= collection_select :person, :group_ids, {1 => 'admins', 2 => 'test'}, :first, :last %>",
    {'person' => ['group_ids']}
    
  form_helper_context "grouped_collection_select :person, :group_ids", 
    "<%= grouped_collection_select :person, :group_ids, {:groups => {1 => 'admins', 2 => 'test'}}, :last, :first, :first, :last %>",
    {'person' => ['group_ids']}

# FIXME: Find a way to test file_column_field
#  form_helper_context "file_column_field :person, :photo", 
#    "<%= file_column_field 'person', :photo %>",
#    {'person' => ['photo', 'photo_temp']}
    
  form_helper_context "select :person, :group_ids", 
    "<%= select :person, :group_ids, {1 => 'admins', 2 => 'test'} %>",
    {'person' => ['group_ids']}
  
  context "A form_for a person" do 
    context "with fields_for one reflection" do 
      setup do 
        @generated_html = form_for_input <<-END
<%= f.text_field :first_name %>
<%= f.fields_for :seo, MassassignmentSecurityFormPerson.new(:last_name => 'seo') do |seo_form| %>
  <%= seo_form.text_field :first_name %>
<% end %>
END
      end

      should "set massassignment_fields" do
        form_columns = extract_form_columns_from(@generated_html)

        assert !form_columns.blank?
        expected = {'person' => [
          'first_name', 
          {'seo_attributes' => ['first_name']} 
          ]
        }
        assert_equal(expected, form_columns)
      end
    end
  end

  context "A formtastic form for a person" do 
    context "with input :salutation, :select" do 
      setup do 
        @generated_html = formtastic_form_input '<%= f.input :salutation, :as => :select, :collection => ["test"] %>'
      end

      should "set massassignment_fields" do
        form_columns = extract_form_columns_from(@generated_html)

        assert !form_columns.blank?
        assert_equal({'person' => ['salutation']}, form_columns)
      end
    end
    
    context "with input :salutation, :as => :check_boxes" do 
      setup do 
        @generated_html = formtastic_form_input '<%= f.input :salutation, :as => :check_boxes, :collection => ["test", "test2"] %>'
      end

      should "set massassignment_fields" do
        form_columns = extract_form_columns_from(@generated_html)

        assert !form_columns.blank?
        assert_equal({'person' => ['salutation']}, form_columns)
      end
    end
    
    context "with input :terms_of_use, :as => :boolean" do 
      setup do 
        @generated_html = formtastic_form_input '<%= f.input :terms_of_use, :as => :boolean %>'
      end

      should "set massassignment_fields" do
        form_columns = extract_form_columns_from(@generated_html)

        assert !form_columns.blank?
        assert_equal({'person' => ['terms_of_use']}, form_columns)
      end
    end
    
    context "with input :birthday, :as => :date" do 
      setup do 
        @generated_html = formtastic_form_input '<%= f.input :birthday, :as => :date_select %>'
      end

      should "set massassignment_fields" do
        form_columns = extract_form_columns_from(@generated_html)

        assert !form_columns.blank?
        assert_equal({'person' => ['birthday']}, form_columns)
      end
    end
  end

  def extract_form_columns_from(html)
    html_object = Hpricot.parse(html)
    tag = html_object.search("input[@name=#{MassassignmentSecurityForm::Config::MASSASSIGNMENT_PARAMS_NAME}]").first
    encrypted_hash = tag.attributes['value']
    columns_hash = MassassignmentSecurityForm::MassassignmentColumnsHash.parse_from(encrypted_hash)
    columns_hash.form_columns
  end

  def formtastic_form_input(form_line)
    @person = MassassignmentSecurityFormPerson.new
    form_html = <<-END
  <% def protect_against_forgery?; false; end -%>
  <%= semantic_form_for :person, :url => '/create_path' do |f| %>
    <%= f.inputs do %>
      #{form_line}
    <% end %>
  <% end %>
END
    if Rails.version <= '3.0'
      form_html.gsub!('<%= semantic', '<% semantic')
      form_html.gsub!('<%= f.inputs', '<% f.inputs')
      form_html.gsub!(':as => :date_select ', ':as => :date ')
    end
    render :inline => form_html
  end

  def form_for_input(form_line)
    @person = MassassignmentSecurityFormPerson.new
    form_html = <<-END
<% def protect_against_forgery?; false; end -%>
<%= form_for @person, :as => :person, :url => '/test' do |f| %>
  #{form_line}
<% end %>
END
    if Rails.version <= '3.0'
      form_html.gsub!("<%= f.fields_for", "<% f.fields_for")
      form_html.gsub!('<%= form_for', '<% form_for')
      form_html.gsub!('form_for @person, :as => :person', 'form_for :person, @person')
    end
    render :inline => form_html
  end
end
