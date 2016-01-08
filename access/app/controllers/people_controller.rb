class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy]
  before_filter :authorize!, except: [:create, :new, :verify_email]
  # GET /people
  # GET /people.json
  def index
    @people = Person.all
  end

  # GET /people/1
  # GET /people/1.json
  def show
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  # POST /people.json
  def create
    invalid_flag = false
    @person = Person.new(person_params)
    begin
      @person.alternative_emails, new_mails = parse_alternative_emails(@person, params[:alternative_emails])
    rescue ActiveRecord::RecordNotSaved
      @person.errors.add(params[:alternative_emails], "invalid alternative e-mail.")
      invalid_flag = true
    end
    respond_to do |format|
      if @person.save && !invalid_flag
        UserMailer.new_user_registration_confirmation(@person).deliver_later
        @person.alternative_emails.each { |alt_mail| UserMailer.new_alt_mail_confirmation(alt_mail).deliver_later }
        session[:user_id] = @person.id # login as the user after they have been created
        format.html { redirect_to @person, notice: 'Person was successfully created.' }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update
    @scientific_fields = ScientificField.all
    @positions = Position.all
    invalid_flag = false
    begin
      @person.alternative_emails, new_mails = parse_alternative_emails(@person, params[:alternative_emails])
    rescue ActiveRecord::RecordNotSaved
      @person.errors.add(:alternative_emails, "invalid alternative e-mail.")
      invalid_flag = true
    end
    respond_to do |format|
      if @person.update(person_params) && !invalid_flag
        new_mails.each { |alt_mail| UserMailer.new_alt_mail_confirmation(alt_mail).deliver_later }
        format.html { redirect_to @person, notice: 'Person was successfully updated.' }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person.destroy
    respond_to do |format|
      format.html { redirect_to people_url, notice: 'Person was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def verify_email
    flag = false
    flag ||= verify_main_email
    flag ||= verify_alternative_email
    if !flag
      flash[:error] = 'Token not recognized'
      redirect_to root_url
    end
  end

  private
    def verify_main_email
      user = Person.find_by_verification_token(params[:token])
      if user
        user.activate_email
        redirect_to root_url, notice: 'Your e-mail has been confirmed'
        return true
      else
        return false
      end
    end

    def verify_alternative_email
      user, mail = Person.find_by_alt_verification_token(params[:token])
      if user
        mail.activate_email
        redirect_to root_url, notice: 'Your e-mail has been confirmed'
        return true
      else
        return false
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:first_name, :last_name, :first_name_latin, :last_name_latin, :email,
                                     :position_id, :scientific_field_id, :alternative_emails,
                                     :organization_id, :phone_number
      )
    end

    def parse_alternative_emails(person, alternative_emails_unparsed)
      if person.nil?
        alternative_emails = []
      else
        alternative_emails = person.alternative_emails
      end
      emails = alternative_emails_unparsed.split
      emails_to_add = emails - (alternative_emails.map {|email_obj| email_obj.email})
      emails_to_del = (alternative_emails.map {|email_obj| email_obj.email}) - emails
      emails_to_del.each do |email|
        AlternativeEmail.find_by_email(email).delete()
      end
      alternative_emails = alternative_emails - emails_to_del
      emails_to_add.each do |email|
        alternative_emails << AlternativeEmail.new(email: email)
      end
      return alternative_emails, emails_to_add
    end

    def authorize!
      super
      if @person && (@person != current_user) && (!TmpAdmin.is_admin?(current_user))
        redirect_to people_url, alert: "#{I18n.t 'controllers.authorization.not_authorized'}"
      end
    end
end
