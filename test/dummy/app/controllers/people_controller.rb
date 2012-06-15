class PeopleController < ApplicationController

  def new
    @person = Person.new
    @person.save
  end

end
