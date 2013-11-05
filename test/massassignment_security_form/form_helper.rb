require 'test_helper'
require File.join(File.dirname(__FILE__), '..', 'test_helper')

class ActiveSql::ConditionTest < ActiveSupport::TestCase

  def self.should_find_a_person_with_first_name(first_name)
    should "find a person with first_name '#{first_name}'" do 
      person = FactoryGirl.create :active_sql_person, :first_name => first_name
      assert subject.include?(person)
    end
  end
  
  def self.should_not_find_a_person_with_first_name(first_name)
    should "not find a person with first_name '#{first_name}'" do 
      person = FactoryGirl.create :active_sql_person, :first_name => first_name
      assert !subject.include?(person)
    end
  end

  def self.should_find_a_person_with_birthday(birthday)
    should "find a person with birthday'#{birthday}'" do 
      person = FactoryGirl.create :active_sql_person, :birthday => birthday
      assert subject.include?(person)
    end
  end
  
  def self.should_not_find_a_person_with_birthday(birthday)
    should "not find a person with birthday '#{birthday}'" do 
      person = FactoryGirl.create :active_sql_person, :birthday => birthday
      assert !subject.include?(person)
    end
  end

  context "A condition for all persons first_name starts_with 'chris'" do 
    subject do
      ActiveSqlPerson.by_active_sql_condition_scope do |person|
        person.first_name.starts_with 'chris'
      end
    end

    should_not_raise_an_error
    should_find_a_person_with_first_name 'Christian'
    should_find_a_person_with_first_name 'christoph'
    should_not_find_a_person_with_first_name 'Martina'
    should_not_find_a_person_with_first_name 'Schris'
  end

  context "A condition for all persons first_name starts_not_with 'chris'" do 
    subject do
      ActiveSqlPerson.by_active_sql_condition_scope do |person|
        person.first_name.starts_not_with 'chris'
      end
    end

    should_not_raise_an_error
    should_not_find_a_person_with_first_name 'Christian'
    should_not_find_a_person_with_first_name 'christoph'
    should_find_a_person_with_first_name 'Martina'
    should_find_a_person_with_first_name 'Schris'
  end

  context "A condition for all persons first_name ends_with 'tian'" do 
    subject do
      ActiveSqlPerson.by_active_sql_condition_scope do |person|
        person.first_name.ends_with 'tian'
      end
    end

    should_not_raise_an_error
    should_find_a_person_with_first_name 'Christian'
    should_not_find_a_person_with_first_name 'Martina'
    should_not_find_a_person_with_first_name 'Tiane'
  end
  
  context "A condition for all persons first_name ends_not_with 'tian'" do 
    subject do
      ActiveSqlPerson.by_active_sql_condition_scope do |person|
        person.first_name.ends_not_with 'tian'
      end
    end

    should_not_raise_an_error
    should_not_find_a_person_with_first_name 'Christian'
    should_find_a_person_with_first_name 'Martina'
    should_find_a_person_with_first_name 'Tiane'
  end

  context "A condition for all persons first_name includes 'rist'" do 
    subject do
      ActiveSqlPerson.by_active_sql_condition_scope do |person|
        person.first_name.includes 'rist'
      end
    end

    should_not_raise_an_error
    should_find_a_person_with_first_name 'Christian'
    should_find_a_person_with_first_name 'Rista'
    should_find_a_person_with_first_name 'Christ'
    should_not_find_a_person_with_first_name 'Martina'
  end

  context "A condition for all persons first_name includes not 'rist'" do 
    subject do
      ActiveSqlPerson.by_active_sql_condition_scope do |person|
        person.first_name.includes_not 'rist'
      end
    end

    should_not_raise_an_error
    should_not_find_a_person_with_first_name 'Christian'
    should_not_find_a_person_with_first_name 'Rista'
    should_not_find_a_person_with_first_name 'Christ'
    should_find_a_person_with_first_name 'Martina'
  end

  context "A condition for all persons first_name is 'Christian'" do 
    subject do
      ActiveSqlPerson.by_active_sql_condition_scope do |person|
        person.first_name == 'Christian'
      end
    end

    should_not_raise_an_error
    should_find_a_person_with_first_name 'Christian'
    should_find_a_person_with_first_name 'christian'
    should_not_find_a_person_with_first_name 'Martina'
  end

  context "A condition for all persons first_name is not 'Christian'" do 
    subject do
      ActiveSqlPerson.by_active_sql_condition_scope do |person|
        person.first_name.is_not 'Christian'
      end
    end

    should_not_raise_an_error
    should_not_find_a_person_with_first_name 'Christian'
    should_not_find_a_person_with_first_name 'christian'
    should_find_a_person_with_first_name 'Martina'
  end
  
  context "A condition for all persons birthday is lower_than Date.today" do 
    subject do
      ActiveSqlPerson.by_active_sql_condition_scope do |person|
        person.birthday < Date.today
      end
    end

    should_not_raise_an_error
    should_find_a_person_with_birthday Date.yesterday
    should_not_find_a_person_with_birthday Date.today
    should_not_find_a_person_with_birthday Date.tomorrow
  end
  
  context "A condition for all persons birthday is lower_than_or_equal Date.today" do 
    subject do
      ActiveSqlPerson.by_active_sql_condition_scope do |person|
        person.birthday <= Date.today
      end
    end

    should_not_raise_an_error
    should_find_a_person_with_birthday Date.yesterday
    should_find_a_person_with_birthday Date.today
    should_not_find_a_person_with_birthday Date.tomorrow
  end
  
  context "A condition for all persons birthday is greater_than_or_equal Date.today" do 
    subject do
      ActiveSqlPerson.by_active_sql_condition_scope do |person|
        person.birthday >= Date.today
      end
    end

    should_not_raise_an_error
    should_not_find_a_person_with_birthday Date.yesterday
    should_find_a_person_with_birthday Date.today
    should_find_a_person_with_birthday Date.tomorrow
  end
  
  context "A condition for all persons birthday is greater_than Date.today" do 
    subject do
      ActiveSqlPerson.by_active_sql_condition_scope do |person|
        person.birthday > Date.today
      end
    end

    should_not_raise_an_error
    should_not_find_a_person_with_birthday Date.yesterday
    should_not_find_a_person_with_birthday Date.today
    should_find_a_person_with_birthday Date.tomorrow
  end
  
  context "A condition for all persons birthday is between 1.week.ago and Date.today" do 
    subject do
      ActiveSqlPerson.by_active_sql_condition_scope do |person|
        person.birthday.between 1.week.ago.to_date, Date.today
      end
    end

    should_not_raise_an_error
    should_not_find_a_person_with_birthday 1.week.ago.to_date.yesterday
    should_find_a_person_with_birthday 1.week.ago.to_date
    should_find_a_person_with_birthday Date.today
    should_not_find_a_person_with_birthday Date.tomorrow
  end
  
  context "A condition for all persons birthday is not between 1.week.ago and Date.today" do 
    subject do
      ActiveSqlPerson.by_active_sql_condition_scope do |person|
        person.birthday.not_between 1.week.ago.to_date, Date.today
      end
    end

    should_not_raise_an_error
    should_find_a_person_with_birthday 1.week.ago.to_date.yesterday
    should_not_find_a_person_with_birthday 1.week.ago.to_date
    should_not_find_a_person_with_birthday Date.today
    should_find_a_person_with_birthday Date.tomorrow
  end

  context "A condition for all organisations with count of 2 employees" do 
    subject do 
      ActiveSqlOrganisation.by_active_sql_condition_scope do |organisation|
        organisation.count {|org| org.employees.first_name } == 2
      end
    end

    should_not_raise_an_error

    should "find an organisation with 2 employees" do 
      organisation = FactoryGirl.create :active_sql_organisation
      FactoryGirl.create :active_sql_person, :active_sql_organisation => organisation
      FactoryGirl.create :active_sql_person, :active_sql_organisation => organisation

      assert subject.include?(organisation)
    end

    should "not find an organisation with 1 employee" do 
      organisation = FactoryGirl.create :active_sql_organisation
      FactoryGirl.create :active_sql_person, :active_sql_organisation => organisation

      assert !subject.include?(organisation)
    end

    should "not find an organisation with 3 employees" do 
      organisation = FactoryGirl.create :active_sql_organisation
      FactoryGirl.create :active_sql_person, :active_sql_organisation => organisation
      FactoryGirl.create :active_sql_person, :active_sql_organisation => organisation
      FactoryGirl.create :active_sql_person, :active_sql_organisation => organisation

      assert !subject.include?(organisation)
    end
  end
  
  context "A condition for all organisations with max of employees birthday 10.years.ago" do 
    subject do 
      ActiveSqlOrganisation.by_active_sql_condition_scope do |organisation|
        organisation.max {|org| org.employees.birthday } == 10.years.ago.to_date
      end
    end

    should_not_raise_an_error

    should "find an organisation with an employee with birthday 10.years.ago" do 
      organisation = FactoryGirl.create :active_sql_organisation
      FactoryGirl.create :active_sql_person, :active_sql_organisation => organisation, :birthday => 10.years.ago.to_date

      assert subject.include?(organisation)
    end

    should "find an organisation with an employee with birthday 10 years ago and one with birthday 11 years ago" do 
      organisation = FactoryGirl.create :active_sql_organisation
      FactoryGirl.create :active_sql_person, :active_sql_organisation => organisation, :birthday => 10.years.ago.to_date
      FactoryGirl.create :active_sql_person, :active_sql_organisation => organisation, :birthday => 11.years.ago.to_date

      assert subject.include?(organisation)
    end

    should "not find an organisation with an employee with birthday 10 years ago and one with birthday 9 years ago" do 
      organisation = FactoryGirl.create :active_sql_organisation
      FactoryGirl.create :active_sql_person, :active_sql_organisation => organisation, :birthday => 10.years.ago
      FactoryGirl.create :active_sql_person, :active_sql_organisation => organisation, :birthday => 9.years.ago

      assert !subject.include?(organisation)
    end

    should "not find an organisation without employees" do 
      organisation = FactoryGirl.create :active_sql_organisation

      assert !subject.include?(organisation)
    end
  end
  
  context "A condition for all organisations with min of employees birthday 10.years.ago" do 
    subject do 
      ActiveSqlOrganisation.by_active_sql_condition_scope do |organisation|
        organisation.min {|org| org.employees.birthday } == 10.years.ago.to_date
      end
    end

    should_not_raise_an_error

    should "find an organisation with an employee with birthday 10.years.ago" do 
      organisation = FactoryGirl.create :active_sql_organisation
      FactoryGirl.create :active_sql_person, :active_sql_organisation => organisation, :birthday => 10.years.ago.to_date

      assert subject.include?(organisation)
    end

    should "not find an organisation with an employee with birthday 10 years ago and one with birthday 11 years ago" do 
      organisation = FactoryGirl.create :active_sql_organisation
      FactoryGirl.create :active_sql_person, :active_sql_organisation => organisation, :birthday => 10.years.ago.to_date
      FactoryGirl.create :active_sql_person, :active_sql_organisation => organisation, :birthday => 11.years.ago.to_date

      assert !subject.include?(organisation)
    end

    should "find an organisation with an employee with birthday 10 years ago and one with birthday 9 years ago" do 
      organisation = FactoryGirl.create :active_sql_organisation
      FactoryGirl.create :active_sql_person, :active_sql_organisation => organisation, :birthday => 10.years.ago.to_date
      FactoryGirl.create :active_sql_person, :active_sql_organisation => organisation, :birthday => 9.years.ago.to_date

      assert subject.include?(organisation)
    end

    should "not find an organisation without employees" do 
      organisation = FactoryGirl.create :active_sql_organisation

      assert !subject.include?(organisation)
    end
  end

  def self.should_find_person(first_name, last_name)
    should "find person #{first_name} #{last_name}" do 
      person = FactoryGirl.create :active_sql_person, :first_name => first_name, :last_name => last_name 

      assert subject.include?(person)
    end
  end
  
  def self.should_not_find_person(first_name, last_name)
    should "not find person #{first_name} #{last_name}" do 
      person = FactoryGirl.create :active_sql_person, :first_name => first_name, :last_name => last_name 

      assert !subject.include?(person)
    end
  end
  
  context "A conditon with or-and-groups for ActiveSqlPerson with specfic names " do 
    subject do 
      ActiveSqlPerson.by_active_sql_condition_scope(:sql_join => :or) do |person|
        person.first_name(:and) do |first_name|
          first_name.ends_with 'ian'
          first_name.starts_with 'Chris'
        end
        person.last_name(:and) do |last_name|
          last_name.ends_with 'horn'
          last_name.starts_with 'Eich'
        end
      end
    end

    should_not_raise_an_error

    should_find_person('Christian', 'Eichhorn') 
    should_not_find_person('Marco', 'Emrich') 
    should_find_person('Christian', 'Emrich') 
    should_find_person('Marco', 'Eichhorn') 
  end
  
  context "A conditon with and-or-groups for ActiveSqlPerson with specfic names " do 
    subject do 
      ActiveSqlPerson.by_active_sql_condition_scope(:sql_join => :and) do |person|
        person.first_name(:or) do |first_name|
          first_name == 'Christian'
          first_name == 'Marco'
        end
        person.last_name(:or) do |last_name|
          last_name ==  'Eichhorn'
          last_name ==  'Emrich'
        end
      end
    end

    should_not_raise_an_error

    should_find_person('Christian', 'Eichhorn') 
    should_find_person('Marco', 'Emrich') 
    should_find_person('Christian', 'Emrich') 
    should_find_person('Marco', 'Eichhorn') 
    should_not_find_person('Marc', 'Eichhorn') 
    should_not_find_person('Christian', 'Remolt') 
  end

  def self.should_find_an_organisation_with_employee(first_name, last_name)
    should "find an organisation with employee #{first_name} #{last_name}" do 
      organisation = FactoryGirl.create :active_sql_organisation
      FactoryGirl.create :active_sql_person, :first_name => first_name, :last_name => last_name, 
        :active_sql_organisation => organisation

      assert subject.include?(organisation)
    end
  end
  
  def self.should_not_find_an_organisation_with_employee(first_name, last_name)
    should "find an organisation with employee #{first_name} #{last_name}" do 
      organisation = FactoryGirl.create :active_sql_organisation
      FactoryGirl.create :active_sql_person, :first_name => first_name, :last_name => last_name, 
        :active_sql_organisation => organisation

      assert !subject.include?(organisation)
    end
  end

  context "A conditon with or-and-groups for ActiveSqlOrganisation which employees has specfic names " do 
    subject do 
      ActiveSqlOrganisation.by_active_sql_condition_scope(:sql_join => :or) do |org|
        org.employees(:and) do |employee|
          employee.first_name == 'Christian'
          employee.last_name == 'Eichhorn'
        end
        org.employees(:and) do |employee|
          employee.first_name == 'Marco'
          employee.last_name == 'Emrich'
        end
      end
    end

    should_not_raise_an_error

    should_find_an_organisation_with_employee('Christian', 'Eichhorn')
    should_find_an_organisation_with_employee('Marco', 'Emrich')
    should_not_find_an_organisation_with_employee('Christian', 'Emrich')
  end
  
  context "A conditon with and-or-groups for ActiveSqlOrganisation which employees has specfic names " do 
    subject do 
      ActiveSqlOrganisation.by_active_sql_condition_scope(:sql_join => :and) do |org|
        org.employees(:or) do |employee|
          employee.first_name == 'Christian'
          employee.last_name == 'Eichhorn'
        end
        org.employees(:or) do |employee|
          employee.first_name == 'Marco'
          employee.last_name == 'Emrich'
        end
      end
    end

    should_not_raise_an_error

    should_not_find_an_organisation_with_employee 'Christian', 'Eichhorn'
    should_not_find_an_organisation_with_employee 'Marco', 'Emrich'
    should_find_an_organisation_with_employee 'Christian', 'Emrich'
    should_find_an_organisation_with_employee 'Marco', 'Eichhorn'
  end
  
  context "Condition for has_many association;" do 
    context "ActiveSqlOrganisation condition for employees with specific last_name" do 
      subject do 
        ActiveSqlOrganisation.by_active_sql_condition_scope do |org|
          org.employees.last_name.include 'hor'
        end
      end

      should_not_raise_an_error

      should "not find an organisation with one employee which last_name is 'Emrich'" do 
        person = FactoryGirl.create :active_sql_person, :last_name => 'Emrich'
        organisation = FactoryGirl.create :active_sql_organisation, :employees => [person]

        assert !subject.include?(organisation)
      end
      
      should "find an organisation with one employee which last_name is 'Eichhorn'" do 
        person = FactoryGirl.create :active_sql_person, :last_name => 'Eichhorn'
        organisation = FactoryGirl.create :active_sql_organisation, :employees => [person]

        assert subject.include?(organisation)
      end
    end
  end

  context "Condition for has_many through belongs_to association;" do 
    context "Condition for colleagues with specific name " do 
      subject do 
        ActiveSqlPerson.by_active_sql_condition_scope do |person|
          person.colleagues.last_name == 'Eichhorn'
        end
      end

      should_not_raise_an_error

      should "find employee Remolt which has a colleague Eichhorn" do 
        organisation = FactoryGirl.create :active_sql_organisation
        employee = FactoryGirl.create :active_sql_person, :last_name => 'Remolt', :active_sql_organisation => organisation
        colleage = FactoryGirl.create :active_sql_person, :last_name => 'Eichhorn', :active_sql_organisation => organisation
        
        assert subject.include?(employee)
      end

      should "not find employee Eichhorn which has a colleague Remolt" do 
        organisation = FactoryGirl.create :active_sql_organisation
        colleague = FactoryGirl.create :active_sql_person, :last_name => 'Remolt', :active_sql_organisation => organisation
        employee = FactoryGirl.create :active_sql_person, :last_name => 'Eichhorn', :active_sql_organisation => organisation

        assert !subject.include?(employee)
      end
    end
  end
  
  context "Condition for has_many through has_one association;" do 
    context "ActiveSqlOrganisation condition for active_sql_notebooks_from_head with specific number" do 
      subject do 
        ActiveSqlOrganisation.by_active_sql_condition_scope do |org|
          org.active_sql_notebooks_from_head.number.ends_with '789'
        end
      end

      should_not_raise_an_error

      should "find an organisation which head has a notebook with number 123456789" do 
        notebook = FactoryGirl.create :active_sql_notebook, :number => '123456789'
        person = FactoryGirl.create :active_sql_person, :active_sql_notebook => notebook
        organisation = FactoryGirl.create :active_sql_organisation, :head => person

        assert subject.include?(organisation)
      end
      
      should "not find an organisation which head has a notebook with number 456789123" do 
        notebook = FactoryGirl.create :active_sql_notebook, :number => '456789123'
        person = FactoryGirl.create :active_sql_person, :active_sql_notebook => notebook
        organisation = FactoryGirl.create :active_sql_organisation, :head => person

        assert !subject.include?(organisation)
      end
      
      should "not find an organisation which employee has a notebook with number 123456789" do 
        notebook = FactoryGirl.create :active_sql_notebook, :number => '123456789'
        organisation = FactoryGirl.create :active_sql_organisation
        FactoryGirl.create :active_sql_person, :active_sql_notebook => notebook, 
          :active_sql_organisation => organisation

        assert !subject.include?(organisation)
      end
    end
  end
  
  context "Condition for has_many through has_many association;" do 
    context "ActiveSqlOrganisation condition for active_sql_notebooks_from_employees with specific number" do 
      subject do 
        ActiveSqlOrganisation.by_active_sql_condition_scope do |org|
          org.active_sql_notebooks_from_employees.number.ends_with '789'
        end
      end

      should_not_raise_an_error

      should "not find an organisation which head has a notebook with number 123456789" do 
        notebook = FactoryGirl.create :active_sql_notebook, :number => '123456789'
        person = FactoryGirl.create :active_sql_person, :active_sql_notebook => notebook
        organisation = FactoryGirl.create :active_sql_organisation, :employees => [person]

        assert subject.include?(organisation)
      end
      
      should "find an organisation which employee has a notebook with number 123456789" do 
        notebook = FactoryGirl.create :active_sql_notebook, :number => '123456789'
        organisation = FactoryGirl.create :active_sql_organisation
        FactoryGirl.create :active_sql_person, :active_sql_notebook => notebook, 
          :active_sql_organisation => organisation

        assert subject.include?(organisation)
      end
    end
  end
  
  context "Condition for has_many as polymorphic association;" do 
    context "Condition for persons which are paying_partners of a notebook name " do 
      subject do 
        ActiveSqlPerson.by_active_sql_condition_scope do |person|
          person.paid_active_sql_notebooks.number.includes '789'
        end
      end

      should_not_raise_an_error
      
      should "find a person which is paying_partner of a notebook with number 123456789" do 
        person = FactoryGirl.create :active_sql_person
        notebook = FactoryGirl.create :active_sql_notebook, :number => '123456789', :paying_partner => person

        assert subject.include?(person)
      end
      
      should "not find a person which is paying_partner of a notebook with number 123456" do 
        notebook = FactoryGirl.create :active_sql_notebook, :number => '123456'
        person = FactoryGirl.create :active_sql_person, :paid_active_sql_notebooks => [notebook]

        assert !subject.include?(person)
      end
    end
  end
  
  context "Condition for belongs_to association;" do 
    context "Condition for persons which are employees of an organisation with specific name" do 
      subject do 
        ActiveSqlPerson.by_active_sql_condition_scope do |person|
          person.active_sql_organisation.name == 'test_name'
        end
      end

      should_not_raise_an_error
      
      should "find a person which is a employee of 'test_name' organisation" do 
        organisation = FactoryGirl.create :active_sql_organisation, :name => 'test_name'
        person = FactoryGirl.create :active_sql_person, :active_sql_organisation => organisation

        assert subject.include?(person)
      end
      
      should "not find a person which is a employee of 'other' organisation" do 
        organisation = FactoryGirl.create :active_sql_organisation, :name => 'other'
        person = FactoryGirl.create :active_sql_person, :active_sql_organisation => organisation

        assert !subject.include?(person)
      end
    end
  end
  
  context "Condition for belongs_to polymorphic association;" do 
    context "Condition for notebooks which has a paying_partner with specific last_name" do 
      subject do 
        ActiveSqlNotebook.by_active_sql_condition_scope do |notebook|
          notebook.paying_partner(:is => ActiveSqlPerson).last_name == 'Eichhorn'
        end
      end

      should_not_raise_an_error
      
      should "find a notebook which paying_partner is a person with last_name 'Eichhorn'" do 
        person = FactoryGirl.create :active_sql_person, :last_name => 'Eichhorn'
        notebook = FactoryGirl.create :active_sql_notebook, :paying_partner => person

        assert subject.include?(notebook)
      end
      
      should "not find a notebook which paying_partner is a person with last_name 'other_name'" do 
        person = FactoryGirl.create :active_sql_person, :last_name => 'other_name'
        notebook = FactoryGirl.create :active_sql_notebook, :paying_partner => person

        assert !subject.include?(notebook)
      end
    end
  end
  
  context "Condition for has_one association;" do 
    context "Condition for organisations which head has a specific last_name" do 
      subject do 
        ActiveSqlOrganisation.by_active_sql_condition_scope do |organisation|
          organisation.head.last_name == 'Eichhorn'
        end
      end

      should_not_raise_an_error

      should "find an organisation which head has a last_name 'Eichhorn'" do 
        person = FactoryGirl.create :active_sql_person, :last_name => 'Eichhorn'
        organisation = FactoryGirl.create :active_sql_organisation, :head => person

        assert subject.include?(organisation)
      end

      should "not find an organisation which head has a last_name 'other_last_name'" do 
        person = FactoryGirl.create :active_sql_person, :last_name => 'other_last_name'
        organisation = FactoryGirl.create :active_sql_organisation, :head => person

        assert !subject.include?(organisation)
      end
    end
  end
  
  context "Condition for has_and_belongs_to_many association;" do 
    context "Condition for people which have a call_number" do 
      subject do 
        ActiveSqlPerson.by_active_sql_condition_scope do |person|
          person.active_sql_call_numbers.number.starts_with '0911'
        end
      end

      should_not_raise_an_error

      should "find a person with call_number '09111234567'" do 
        call_number = FactoryGirl.create :active_sql_call_number, :number => '09111234567'
        person = FactoryGirl.create :active_sql_person
        person.active_sql_call_numbers << call_number

        assert subject.include?(person)
      end

      should "not find a person with call_number '19111234567'" do 
        call_number = FactoryGirl.create :active_sql_call_number, :number => '19111234567'
        person = FactoryGirl.create :active_sql_person
        person.active_sql_call_numbers << call_number

        assert !subject.include?(person)
      end
    end
  end

  context "Given 3 organisations with different names;" do 
    setup do 
      @organisation_siemens = FactoryGirl.create :active_sql_organisation, :name => 'Siemens'
      @organisation_which_name_is_nil = FactoryGirl.create :active_sql_organisation, :name => nil
      @organisation_which_name_is_empty = FactoryGirl.create :active_sql_organisation, :name => ''
    end

    context "condition for name is_not_nil" do 
      subject do 
        ActiveSqlOrganisation.by_active_sql_condition_scope do |org|
          org.name.is_not_nil
        end
      end

      should_not_raise_an_error

      should "not find @organisation_which_name_is_nil" do 
        assert !subject.include?(@organisation_which_name_is_nil)
      end

      should "find @organisation_which_name_is_empty" do 
        assert subject.include?(@organisation_which_name_is_empty)
      end

      should "find @organisation_siemens" do 
        assert subject.include?(@organisation_siemens)
      end
    end

    context "condition for name is_not_blank" do 
      subject do 
        ActiveSqlOrganisation.by_active_sql_condition_scope do |org|
          org.name.is_not_blank
        end
      end

      should_not_raise_an_error

      should "not find @organisation_which_name_is_nil" do 
        assert !subject.include?(@organisation_which_name_is_nil)
      end

      should "not find @organisation_which_name_is_empty" do 
        assert !subject.include?(@organisation_which_name_is_empty)
      end

      should "find @organisation_siemens" do 
        assert subject.include?(@organisation_siemens)
      end
    end

    context "condition for name is_not_blank or is_not_nil" do 
      subject do 
        ActiveSqlOrganisation.by_active_sql_condition_scope do |org|
          org.name(:or) do |name|
            name.is_not_blank
            name.is_not_nil
          end
        end
      end

      should_not_raise_an_error

      should "not find @organisation_which_name_is_nil" do
        assert !subject.include?(@organisation_which_name_is_nil)
      end

      should "find @organisation_which_name_is_empty" do 
        assert subject.include?(@organisation_which_name_is_empty)
      end

      should "find @organisation_siemens" do 
        assert subject.include?(@organisation_siemens)
      end
    end

    context "condition for name is_blank" do 
      subject do 
        ActiveSqlOrganisation.by_active_sql_condition_scope do |org|
          org.name.is_blank
        end
      end

      should_not_raise_an_error

      should "find @organisation_which_name_is_nil" do
        assert subject.include?(@organisation_which_name_is_nil)
      end

      should "find @organisation_which_name_is_empty" do 
        assert subject.include?(@organisation_which_name_is_empty)
      end

      should "not find @organisation_siemens" do 
        assert !subject.include?(@organisation_siemens)
      end
    end

    context "condition for name is_blank or 'siemens'" do 
      subject do 
        ActiveSqlOrganisation.by_active_sql_condition_scope do |org|
          org.name(:and) do |name|
            name.is_blank
            name == 'siemens'
          end
        end
      end

      should_not_raise_an_error

      should "not find @organisation_which_name_is_nil" do
        assert !subject.include?(@organisation_which_name_is_nil)
      end

      should "not find @organisation_which_name_is_empty" do 
        assert !subject.include?(@organisation_which_name_is_empty)
      end

      should "not find @organisation_siemens" do 
        assert !subject.include?(@organisation_siemens)
      end
    end
  end

  context "Given 3 people with call_numbers of the same organisation;" do 
    setup do 
      @other_organisation = FactoryGirl.create :active_sql_organisation
      @employee_of_other_organisation = FactoryGirl.create :active_sql_person, :active_sql_organisation => @other_organisation
      
      @organisation = FactoryGirl.create :active_sql_organisation
      @employee_1 = FactoryGirl.create :active_sql_person, :active_sql_organisation => @organisation
      @employee_2 = FactoryGirl.create :active_sql_person, :active_sql_organisation => @organisation
      FactoryGirl.create :active_sql_call_number, :number => '123456789', 
        :active_sql_people => [@employee_1, @employee_2]
      
      @employee_3 = FactoryGirl.create :active_sql_person, :active_sql_organisation => @organisation
      FactoryGirl.create :active_sql_call_number, :number => '98754321', 
        :active_sql_people => [@employee_3]
    end

    context "Condition for find all persons which colleagues have the same call_number" do 
      subject do 
        ActiveSqlPerson.by_active_sql_condition_scope do |person|
          person.colleagues.active_sql_call_numbers.number.included_in(
            person.collect {|per| per.active_sql_call_numbers.number(:custom_sort => {:id => 'ASC'}) })
        end
      end

      should_not_raise_an_error

      should "not find @employee_of_other_organisation" do 
        assert !subject.include?(@employee_of_other_organisation)
      end

      should "not find @employee_3" do 
        assert !subject.include?(@employee_3)
      end

      should "find @employee_1 and @employee_2" do 
        assert subject.include?(@employee_1)
        assert subject.include?(@employee_2)
      end
    end
  end

  context "Given a has_many through reflection with specific foreign_keys" do 
    subject do 
      cond = ActiveSql::Condition.new( :klass => BlogUser )
      cond.blog_posts
    end

    should "return the specfic foreign_key of the through_reflection on #association_foreign_key" do 
      assert_equal 'post_id', subject.send(:association_foreign_key)
    end
  end

  context "Given a has_many through reflection with specific foreign_keys for reverse" do 
    subject do 
      cond = ActiveSql::Condition.new( :klass => BlogPost )
      cond.blog_users
    end

    should "return the specfic foreign_key of the through_reflection on #association_foreign_key" do 
      assert_equal 'user_id', subject.send(:association_foreign_key)
    end
  end

  context "Given a by_scope condition" do 
    context "with nil" do 
      subject do 
        ActiveSqlOrganisation.by_active_sql_condition_scope do |organisation|
          organisation.employees.by_scope nil
        end
      end

      should "raise an error" do 
        assert_raise(ActiveSql::ScopeError) { subject }
      end
    end
    
    context "with an other object" do 
      subject do 
        ActiveSqlOrganisation.by_active_sql_condition_scope do |organisation|
          organisation.employees.by_scope ActiveSqlPerson.new
        end
      end

      should "raise an error" do 
        assert_raise(ActiveSql::ScopeError) { subject }
      end
    end
    
    context "for an Model-Class" do
      setup do 
        @organisation_without_employees = FactoryGirl.create :active_sql_organisation
        @organisation_with_employees = FactoryGirl.create :active_sql_organisation

        FactoryGirl.create :active_sql_person, :last_name => 'Test-Name', 
          :active_sql_organisation => @organisation_with_employees
      end

      subject do 
        ActiveSqlOrganisation.by_active_sql_condition_scope do |organisation|
          organisation.employees.by_scope ActiveSqlPerson
        end
      end

      should "not raise an error" do 
        assert_nothing_raised { subject }
      end

      should "find organisation_with_employees" do 
        assert subject.include? @organisation_with_employees
      end

      should "not find organisation_without_employees" do 
        assert !subject.include?(@organisation_without_employees)
      end
    end
    
    context "for a scope" do
      setup do 
        @organisation_without_employees = FactoryGirl.create :active_sql_organisation
        @organisation_with_employee__test_name = FactoryGirl.create :active_sql_organisation
        @organisation_with_employee__max = FactoryGirl.create :active_sql_organisation
        @organisation_with_employee__hans = FactoryGirl.create :active_sql_organisation

        FactoryGirl.create :active_sql_person, :last_name => 'Test-Name', 
          :active_sql_organisation => @organisation_with_employee__test_name

        FactoryGirl.create :active_sql_person, :last_name => 'Mustermann', :first_name => 'Max',
          :active_sql_organisation => @organisation_with_employee__max
        
          FactoryGirl.create :active_sql_person, :last_name => 'Mustermann', :first_name => 'Hans',
          :active_sql_organisation => @organisation_with_employee__hans
      end

      subject do 
        scope = ActiveSqlPerson.by_active_sql_condition_scope do |person|
          person.last_name == 'Mustermann'
        end

        scope = scope.by_active_sql_condition_scope do |person|
          person.first_name == 'Max'
        end

        ActiveSqlOrganisation.by_active_sql_condition_scope do |organisation|
          organisation.employees.by_scope scope
        end
      end

      should "not raise an error" do 
        assert_nothing_raised { subject }
      end

      should "find organisation_with_employee__max" do 
        assert subject.include? @organisation_with_employee__max
      end

      should "not find organisation_with_employee__test_name" do 
        assert !subject.include?(@organisation_with_employee__test_name)
      end

      should "not find organisation_with_employee__test_hans" do 
        assert !subject.include?(@organisation_with_employee__hans)
      end

      should "not find organisation_without_employees" do 
        assert !subject.include?(@organisation_without_employees)
      end
    end
  end
end
