class TransactionsController < ApplicationController
	before_filter :find_transaction, :only => [:show, :edit, :update, :confirm, :destroy]
  protect_from_forgery :except => [:paypal_notification, :paypal_return]

	# GET /transactions
	# GET /transactions.xml
	def index
	@transactions = current_user.transactions

		respond_to do |wants|
			wants.html # index.html.erb
			wants.xml { render :xml => @transactions }
		end
	end

	# GET /transactions/1
	# GET /transactions/1.xml
	def show
		respond_to do |wants|
			wants.html # show.html.erb
			wants.xml { render :xml => @transaction }
		end
	end

  # Purchase Methods
  # type, user_id, group_id, gift_email, tokens, cost, token, transaction_id, params, status, created_at, updated_at, group_name, assessment_id

  def purchase_tokens
    transaction = Transaction.new(params[:transaction])
    transaction.transaction_type = 'Group'
    transaction.user = current_user
    transaction.cost = transaction.tokens * APP_CONFIG[:assessments_cost]
    transaction.status = 'Awaiting Payment'

    save_and_confirm_transaction(transaction)
  end

  # type, user_id, group_id, gift_email, tokens, cost, token, transaction_id, params, status, created_at, updated_at, group_name, assessment_id
  def purchase_assessment
    transaction = Transaction.new
    transaction.transaction_type = 'Assessment'
    transaction.assessment = Assessment.find(params[:assessment_id])
    transaction.cost = APP_CONFIG[:assessments_cost]
    transaction.status = 'Awaiting Payment'
    transaction.user = current_user

    save_and_confirm_transaction(transaction)
  end

  def purchase_gift

  end

	# GET /transactions/new
	# GET /transactions/new.xml
	def new
    @transaction = Transaction.new
    @user = current_user

		respond_to do |wants|
			wants.html # new.html.erb
			wants.xml { render :xml => @transaction }
		end
	end

	# GET /transactions/1/edit
	def edit
	end

	# POST /transactions
	# POST /transactions.xml
	def create
		@transaction = Transaction.new(params[:transaction])
    @transaction.user = current_user
    # TODO: Cost needs to be dynamic
    @transaction.cost = @transaction.points
    @transaction.status = 'Awaiting Payment'
#-form_tag "https://www.sandbox.paypal.com/cgi-bin/webscr" do
#  = hidden_field_tag :cmd, "_s-xclick"
#  = hidden_field_tag :encrypted, @transaction.paypal_encrypted(paypal_notification_url(:secret => "test"), paypal_notification_url(:secret => "test"))
#  = submit_tag "Checkout"
#
		respond_to do |wants|
			if @transaction.save
        # Redirect to the payment confirmation page
				#wants.html { redirect_to @transaction.paypal_url(paypal_return_url, paypal_notification_url(:secret => @transaction.token)) }
        wants.html { redirect_to confirm_transaction_path(@transaction) }
        #paypal_return_url
				#wants.xml { render :xml => @transaction, :status => :created, :location => @transaction }
			else
				wants.html { render :action => "new" }
				wants.xml { render :xml => @transaction.errors, :status => :unprocessable_entity }
			end
		end
	end

  # To confirm the purchase and pay using paypal
  # The view for this page contains the paypal purchase buttons.
  def confirm
  end

  # Called only by paypal_notification
	def update
		respond_to do |wants|
			if @transaction.update_attributes(params[:transaction])
				flash[:notice] = 'transaction was successfully updated.'
				wants.html { redirect_to(@transaction) }
				wants.xml { head :ok }
			else
				wants.html { render :action => "edit" }
				wants.xml { render :xml => @transaction.errors, :status => :unprocessable_entity }
			end
		end
  end

  def paypal_notification
    update_transaction(params)
    render :nothing => true
  end

  def paypal_return
    
    transaction = Transaction.find_by_transaction_id(params[:tx]) if params[:tx]
    if transaction
      if transaction.status == 'Completed'

        flash[:success] = "Your purchase was successfully processed."
        transaction.status = "Processed by LAUNCH" # Change status so we don't process this transaction twice.'
        transaction.save

        case transaction.transaction_type
          when 'Assessment'
            # Create an assessment for the user and redirect them back to their dashboard
            assessment = transaction.assessment
            assessment.make_assessment_take(transaction.user)

            redirect_to :root

          when 'Group'
            group = transaction.group
            group.activated = true if !group.activated
            if group.tokens
              # If group tokens is not nil
              group.tokens += transaction.tokens
            else
              group.tokens = transaction.tokens
            end
            group.save

            # Activate the group membership if needed
            membership = Membership.find_by_group_id_and_user_id(group.id, current_user.id)
            membership.activate if current_user.active_membership != membership

            redirect_to manage_group_path(transaction.group)

          when 'Gift'

          else
            redirect_to transactions_path
        end

      elsif ['Canceled_Reversal','Denied','Expired','Failed','Pending','Processed','Refunded','Reversed','Voided'].include?(transaction.status)
        flash[:error] = "There has been a complication with processing your transaction - please contact support for assistance."
        redirect_to :root
      end

    else
      # Do Nothing
      flash[:success] = "Thank you for your payment. Your transaction has been completed, and a receipt for your purchase has been emailed to you. Please wait while we receive information from paypal. This may take upto 30 seconds."
    end

    #flash[:success] = "Thank you for your purchase! Your payment was successfully received. Please wait while we receive details from paypal"
    #redirect_to transactions_path
  end

  def update_transaction(params)
    transaction = Transaction.find_by_token(params[:secret])
    transaction.params = params
    # Don't let the transaction id be changed for a transaction
    transaction.transaction_id = params[:txn_id] if !transaction.transaction_id 

    if transaction.status != "Completed" && params[:payment_status] == "Completed" && params[:mc_gross] == "%.2f" % transaction.cost.to_s
      # Give the user the LAUNCH Points purchased
      # current_user.points(@transaction.group).add(@transaction.points)

      case transaction.transaction_type

        when 'Assessment'
#         # Do Nothing - this is handled on return

        when 'Group'
          # Do Nothing - this is handled on return

        when 'Gift'
          # Create an assessment token for the user receiving the gift

        else
          # Do Nothing

      end

      transaction.status = "Completed"
    end

    transaction.status = params[:payment_status]
    transaction.save          
  end

	# DELETE /transactions/1
	# DELETE /transactions/1.xml
	def destroy
		@transaction.destroy if @transaction.status != 'Completed'

		respond_to do |wants|
      flash[:success] = "Transaction successfully cancelled."
			wants.html { redirect_to(transactions_url) }
			wants.xml { head :ok }
		end
	end

	private

		def find_transaction
			@transaction = Transaction.find(params[:id])
    end

    def save_and_confirm_transaction(transaction)
      if transaction.save
        # Redirect to the payment confirmation page
        redirect_to confirm_transaction_path(transaction)
      else
        flash[:error] = "There was a problem trying to create the transaction. Please contact support."
        redirect_to :back
      end
    end

end