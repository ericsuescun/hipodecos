class StaticPagesController < ApplicationController
  def home
  end

  def services
  end

  def whoweare
  end

  def contact
  end

  def help
  end

  def faq
  end

  def results
    redirect_to new_patient_session_path
  end

  def tech
  end

  def portfolio
    @codevals = Codeval.all
  end

  def customers
    @branches = Branch.all
  end

  def science
    
  end

  def news
    
  end

  def welcome_user
  end

  def matriculate
    
  end

end
