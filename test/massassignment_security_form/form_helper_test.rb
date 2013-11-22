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
      p subject
      assert subject.include?(MassassignmentSecurityForm::Config::MASSASSIGNMENT_PARAMS_NAME)
    end
  end

#  def self.form_helper_context(context_name, form_line, columns_hash) 
#    context context_name do
#      setup do 
#        @_form_fields = MassassignmentSecurityForm::MassassignmentColumnsHash.new
#        render :inline => form_line
#      end
#
#      should "set massassignment_fields" do
#        assert_not @_form_fields.blank?
#        assert_equal(columns_hash, @_form_fields.form_columns)
#      end
#    end
#  end
#
#  [:text_field, :password_field, :hidden_field, :file_field, :text_area, :check_box,
#   :country_select, :date_select, :time_select, :datetime_select].each do |form_helper_name|
#    form_helper_context "#{form_helper_name} :person, :first_name", 
#      "<%= #{form_helper_name} :person, :first_name %>",
#      {'person' => ['first_name']}
#  end
#    
#  form_helper_context "radio_button :person, :salutation", 
#    "<%= radio_button :person, :salutation, 'mr' %><%= radio_button :person, :salutation, 'mrs' %>",
#    {'person' => ['salutation']}
#    
#  form_helper_context "collection_select :person, :group_ids", 
#    "<%= collection_select :person, :group_ids, {1 => 'admins', 2 => 'test'}, :first, :last %>",
#    {'person' => ['group_ids']}
#    
#  form_helper_context "grouped_collection_select :person, :group_ids", 
#    "<%= grouped_collection_select :person, :group_ids, {:groups => {1 => 'admins', 2 => 'test'}}, :last, :first, :first, :last %>",
#    {'person' => ['group_ids']}
#
## FIXME: Find a way to test file_column_field
##  form_helper_context "file_column_field :person, :photo", 
##    "<%= file_column_field 'person', :photo %>",
##    {'person' => ['photo', 'photo_temp']}
#    
#  form_helper_context "select :person, :group_ids", 
#    "<%= select :person, :group_ids, {1 => 'admins', 2 => 'test'} %>",
#    {'person' => ['group_ids']}
#
#  context "A formtastic form for a person" do 
#    context "with input :salutation, :select" do 
#      setup do 
#        @generated_html = formtastic_form_input '<%= f.input :salutation, :as => :select, :collection => ["test"] %>'
#      end
#
#      should "set massassignment_fields" do
#        form_columns = extract_form_columns_from(@generated_html)
#
#        assert_not form_columns.blank?
#        assert_equal({'person' => ['salutation']}, form_columns)
#      end
#    end
#    
#    context "with input :salutation, :as => :check_boxes" do 
#      setup do 
#        @generated_html = formtastic_form_input '<%= f.input :salutation, :as => :check_boxes, :collection => ["test", "test2"] %>'
#      end
#
#      should "set massassignment_fields" do
#        form_columns = extract_form_columns_from(@generated_html)
#
#        assert_not form_columns.blank?
#        assert_equal({'person' => ['salutation']}, form_columns)
#      end
#    end
#    
#    context "with input :terms_of_use, :as => :boolean" do 
#      setup do 
#        @generated_html = formtastic_form_input '<%= f.input :terms_of_use, :as => :boolean %>'
#      end
#
#      should "set massassignment_fields" do
#        form_columns = extract_form_columns_from(@generated_html)
#
#        assert_not form_columns.blank?
#        assert_equal({'person' => ['terms_of_use']}, form_columns)
#      end
#    end
#    
#    context "with input :birthday, :as => :date" do 
#      setup do 
#        @generated_html = formtastic_form_input_profile '<%= f.input :birthday, :as => :date %>'
#      end
#
#      should "set massassignment_fields" do
#        form_columns = extract_form_columns_from(@generated_html)
#
#        assert_not form_columns.blank?
#        assert_equal({'online_campus_profile' => ['birthday']}, form_columns)
#      end
#    end
#  end
#
#  def extract_form_columns_from(html)
#    html_object = Hpricot.parse(html)
#    tag = html_object.search("input[@name=#{MassassignmentSecurityForm::Config::MASSASSIGNMENT_PARAMS_NAME}]").first
#    encrypted_hash = tag.attributes['value']
#    columns_hash = MassassignmentSecurityForm::MassassignmentColumnsHash.parse_from(encrypted_hash)
#    columns_hash.form_columns
#  end
#
#  def formtastic_form_input(form_line)
#    @person = Person.new
#    render :inline => <<-END
#  <% def protect_against_forgery?; false; end -%>
#  <% semantic_form_for @person, :url => '/create_path' do |f| %>
#    <% f.inputs do %>
#      #{form_line}
#    <% end %>
#  <% end %>
#END
#  end
#
#  def formtastic_form_input_profile(form_line)
#    @online_campus_profile = OnlineCampusProfile.new
#    render :inline => <<-END
#  <% def protect_against_forgery?; false; end -%>
#  <% semantic_form_for @online_campus_profile, :url => '/create_path' do |f| %>
#    <% f.inputs do %>
#      #{form_line}
#    <% end %>
#  <% end %>
#END
#  end
end