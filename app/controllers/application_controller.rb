# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  before_filter { |c| Authorization.current_user = c.current_user }

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  layout proc{ |c| c.request.xhr? ? false : "application" } # Allows Ajax responds to not use the default layouts

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  #form: row[category,child,data[],[points,total],score]
  #data: entry["q_type", q#,q_content, answers[]]
  #answers: 
    #Text         ["display",[nil,nil],["hover",...]]
    #Rate         ["display",[val#,total#],["hover"]]
    #Choose-one   ["display",[val#,total#],value,[select#],["options",...]]
    #Choose-many  ["display",[val#,total#],value,[select#,...],["options",...]]
    
  def build_table(at_id,parent=true) #will build a table of all data that is needed using a 
                         #common format used by results(slelf and fb), and all analysis methods
    #find raw data:
    at = AssessmentTake.find(at_id)
    a = at.assessment
    cats = at.assessment.categories
    #find if category is parent or child
    child_cats = []
    parent_cats = []
    cats.each do |cat|
      if !cat.parent_id.nil? #if has a parent, place the child, then place the parent
        child_cats = child_cats | [cat]
        parent_cats = parent_cats | [cat.parent]
        cats = cats - [cat.parent]
        cats = cats -[cat]
      end
    end
    #sort and group categories by child/parents
    parent_child_cats = []
    parent_cats.each do |pc|
      parent_child_cats = parent_child_cats | [[pc,0,[]]]
      child_cats.each do |cc|
        if cc.parent == pc
          parent_child_cats = parent_child_cats |[[cc,1,[]]]
          child_cats = child_cats - [cc]
        end
      end
    end
    #Finalize table with single cats then parent/child cats
    table = []
    cats.each do |c|
      table = table | [[c,0,[]]]
    end
    table = table | parent_child_cats
    
    #begin sorting questions into categories
    if parent
      a.questions.each do |q|
        entry = [q.question_type.name,q.position.to_s,q.content]
        if q.question_type.name == "Rate"
          value = at.answers.detect{|a| a.question == q}.value
          if value.nil?
            show = "N/A"
          else
            show =  value.to_s#+"/10"
          end
          hover = "<div class='hover_result'><table><thead><th>"+q.position.to_s+".</th></thead>"
          hover += "<tr><td>"+q.content + "</td></tr>"
          hover += "<tr class='score'><td>"+show+"/10</td></tr></table></div>"
          display = [show,hover]
          stats = [value,10]
          
          entry<<[show,[value,10],[show+"/10"]]
          #entry = [display,stats]
          
          table.detect{|cat| cat[0] == q.category}[2]<< entry
        elsif q.question_type.name == "Choose-one"
          ans = at.answers.detect{|a| a.question == q}
          
          hover = "<div class='hover_result'><table><thead><th>"+q.position.to_s+".</th></thead>"
          hover += "<tr><td>"+q.content + "</td></tr>"
          cc = q.category
          
          if q.McOptions.all.length >0:
            l = q.McOptions.all.sort{|a,b| b.value<=>a.value}
            total = l[0].value
          else
            total = nil
          end
          if ans.value.nil?
            show = "N/A"
            value = nil
            total = nil
          else
            mc = q.McOptions.find(ans.value)
            
            if !mc.category.nil?
              cc = mc.category
            end
            value = mc.value
            show = value.to_s#+"/"+total.to_s
            #hover += mc.content
            
          end
          if cc.nil? and q.McOptions.all.length >0: #hack to get a category if none are available
            cc = q.McOptions.first().category
          end
          
          opt = []
          sel = []
          q.McOptions.each_with_index do |o,i|
            opt << o.content
            if o.id == ans.value
              sel<<[i]
            end
          end
          
          display = [show,hover]
          stats = [value,total]
          
          entry << [show,[value,total],sel,opt]
          #entry = [display,stats]
          
          table.detect{|cat| cat[0] == cc}[2]<< entry
        elsif q.question_type.name == "Text"
          text = at.answers.detect{|a| a.question == q}.text
          show = "T"
          hover = "<div class='hover_result'><table><thead><th>"+q.position.to_s+".</th></thead>"
          hover += "<tr><td>"+q.content + "</td></tr>"
          hover +="<tr class='answers'><td>"+text.to_s()+"</td></tr>"
          hover += "</table></div>"
          display = [show, hover]
          entry<<["T",[nil,nil],[text]]
          #entry = [display,[nil,nil]]
          table.detect{|cat| cat[0] == q.category}[2]<< entry
        elsif q.question_type.name == "Choose-many"
          cc = q.category
          total = q.value
          len = q.McOptions.length
          ans = at.answers.detect{|a| a.question == q}
          if ans.nil?
            flash[:error]= "Error while processing answers... this assessment take was not created properly..."
            break
          end
          nv= ans.num
          value = ((total / nv) unless nv.zero?) unless total.nil?
          show = value.to_s#+"/"+total.to_s
          show_zero = "0"#+"/"+total.to_s
          hover = "<div class='hover_result'><table><thead><th>"+q.position.to_s+".</th></thead>"
          hover += "<tr><td>"+q.content + "</td></tr>"
          hover += "<tr class='score'><td>"+ value.to_s() +"/"+total.to_s() +"</td></tr>"
          val = value.to_s() +"/"+total.to_s()
          val_zero = "0/"+total.to_s()
          sel = []
          opt = []
          q.McOptions.each_with_index do |mc,pos|
            opt<< mc.content
            if ans.get(len-1-pos)
              sel<< pos
            end
          end
          hover +="</table></div>"
          q.McOptions.each_with_index do |mc,pos|
            if !mc.category.nil?
              cc = mc.category
            end
            if !mc.value.nil?
              value = mc.value
            end
            
            if ans.get(len-1-pos)
              entry<< [show,[value,total],val,sel,opt]
              table.detect{|cat| cat[0] == cc}[2] << entry
            else
              entry<<[show_zero,[0,total],val_zero,sel,opt]
              table.detect{|cat| cat[0] == cc}[2] << entry
            end
          end
        end
      end #Done adding answers to table for parent takes
      
    else #feedback takes, add questions
      a.questions.each do |q|
        entry = [q.question_type.name,q.position.to_s,q.content]
        if q.question_type.name == "Rate"
          value = nil
          total = nil
          at.feedback_takes.each do |fb|
            fa = fb.answers.detect{|a| a.question == q}.value
            if !fa.nil?
              if value.nil?
                value = fa
                total = 10
              else
                value+=fa
                total+=10
              end
            end
          end
          if value.nil?
            show = "N/A"
            hovshow = show
          else
            v1 = (value.to_f/total)*10
            if v1%1==0
              v1 = v1.to_i.to_s
            else
              v1 = ("%.1f"%v1).to_s
            end
            show = v1#+"/10"
            hovshow = v1+"/10"
          end
          hover = "<div class='hover_result'><table><thead><th>"+q.position.to_s+".</th></thead>"
          hover += "<tr><td>"+q.content + "</td></tr>"
          hover += "<tr class='score'><td>"+ hovshow+"</td></tr>"
          hover += "</table>"
          display = [show,hover]
          stats = [value,total]
          #entry = [display,stats]
          val = nil
          val = (value.to_f/total)*10 if !value.nil? and !(total==0)
          entry<<[show,[val,10],[show+"/10"]]
          table.detect{|cat| cat[0] == q.category}[2]<< entry
        elsif q.question_type.name == "Choose-one"
          
          cc = q.category
          value = nil
          if q.McOptions.all.length >0:
            tl = q.McOptions.all.sort{|a,b| b.value<=>a.value}[0].value
          else
            tl = nil
          end
          total = nil
          at.feedback_takes.each do |fb|
            ans = fb.answers.detect{|a| a.question == q}
            if !ans.value.nil?
              mc = q.McOptions.find(ans.value)
              if value.nil?
                value = mc.value
                total = tl
              else
                value+=mc.value
                (total+=tl)if !tl.nil?
              end
            end
          end
          if !value.nil? and !total.nil? and !tl.nil?
            v1 = (value.to_f/total)*tl
            if v1%1==0
              v1 = v1.to_i.to_s
            else
              v1 = ("%.1f"%v1).to_s
            end
            show = v1#+"/"+tl.to_s
            hovshow = v1.to_s() +"/"+tl.to_s()
          else
            show = "N/A"
            hovshow=show
          end
          hover = "<div class='hover_result'><table><thead><th>"+q.position.to_s+".</th></thead>"
          hover += "<tr><td>"+q.content + "</td></tr>"
          hover+="<tr class='score'><td>"+ hovshow +"</td></tr>"
          opt = []
          sel=[]
          q.McOptions.each_with_index do |o,i|
            opt<< o.content
          end
          if cc.nil? and q.McOptions.all.length >0: #hack to get a category if none are available
            cc = q.McOptions.first().category
          end          
          display = [show,hover]
          stats = [value,total]
          #entry = [display,stats]
          val = nil
          val=(value.to_f/total)*tl if !value.nil? and !(total==0)
          entry << [show,[val,total],sel,opt]
          table.detect{|cat| cat[0] == cc}[2]<< entry
        elsif q.question_type.name == "Text"
          show = "T"
          hover = "<div class='hover_result'><table><thead><th>"+q.position.to_s()+".</th></thead>"
          hover += "<tr><td>"+q.content + "</td></tr>"
          txt = []
          at.feedback_takes.each do |fb|
            text = fb.answers.detect{|a| a.question==q}.text
            if ((text.length>0)if !text.nil?)
              txt<< text
              hover +="<tr class='answers'><td>"+text+"</td></tr>"
            end
          end
          hover += "</table></div>"
          display = [show, hover]
          #entry = [display,[nil,nil]]
          entry<<[show,[nil,nil],txt]
          table.detect{|cat| cat[0] == q.category}[2]<< entry
        elsif q.question_type.name == "Choose-many"
          cc= q.category
          len = q.McOptions.length
          total = 0
          tl = q.value
          hover = "<div class='hover_result'><table><thead><th>"+q.position.to_s()+".</th></thead>"
          hover += "<tr><td>"+q.content + "</td></tr>"
          hover += "<tr class='score'><td>"+ "N/A" +"</td></tr>"
          opt=[]
          q.McOptions.each do |mc|
            opt<< mc.content
          end
          hover += "</table></div>"
          at.feedback_takes.each do |fb|
            if !fb.answers.detect{|a| a.question=q}.nil?
              total+=tl
            end
          end
          if total == 0
            total = nil
            q.McOptions.each do |mc|
              cc = mc.category
              entry<< ["N/A",[nil,nil],"N/A",[],opt]
              if !cc.nil?
                table.detect{|cat| cat[0] == cc}[2]<< entry
              end
            end
          else
            q.McOptions.each_with_index do |mc,pos|
              cc = mc.category if !mc.category.nil?
              value = 0
              at.feedback_takes.each do |fb|
                fba = fb.answers.detect{|a| a.question=q}
                if !fba.value.nil?
                  nv = fba.num
                  v = 0
                  v = (q.value / nv) unless nv.zero?
                  if fba.get(len-1-pos)
                    value += v
                  end
                end
              end
              v1 = (value.to_f/total)*tl
              if v1%1==0
                v1 = v1.to_i.to_s
              else
                v1 = ("%.1f"%v1).to_s
              end
              show = v1#+"/"+tl.to_s
              hover = "<div class='hover_result'><table><thead><th>"+q.position.to_s()+".</th></thead>"
              hover += "<tr><td>"+q.content + "</td></tr>"
              hover += "<tr class='score'><td>"+ v1+"/"+tl.to_s() +"</td></tr>"
              q.McOptions.each do |mc|
                hover += "<tr class='answers'><td>"+mc.content+"</td></tr>"
              end
              hover += "</table></div>"
              val = v1+"/"+tl.to_s()
              sel=[]
              if !cc.nil?
                val = nil
                val = (value.to_f/total)*tl if !value.nil? and !(total==0)
                entry<< [show,[val,total],val,sel,opt]
                table.detect{|cat| cat[0] == cc}[2]<< entry
              end
            end
          end
        end
      end #Done adding answers to table for fb takes
    end
    
    
    
    
    #Add sum/total and points to table
    par = nil
    
    table.each_with_index do |row,i|
      par = i if row[0].has_child?
      total = 0
      sum = 0
      row[2].each do |entry|
          (sum+=entry[3][1][0]) if !entry[3][1][0].nil?
        (total+=entry[3][1][1]) if !entry[3][1][1].nil?
      end
      if total == 0
        sum = nil
        total = nil
      end
      table[i] <<[sum,total]
      avg = nil
      if !sum.nil? and !total.nil? and total > 0
        avg = sum*100/total
      end
      table[i] << avg
      if !par.nil? and row[1]==1 and !table[i][3][1].nil?
        if !table[par][3][0].nil?
          table[par][3][0] +=table[i][3][0] 
          table[par][3][1] +=table[i][3][1]
        else
          table[par][3][0] = table[i][3][0] 
          table[par][3][1] = table[i][3][1]
        end
        table[par][4]=table[par][3][0]*100/table[par][3][1]
      end
    end
    return table
    
  end ##End of build table

  def current_user
    @current_user ||= current_user_session && current_user_session.user
  end


  # app/controllers/application.rb
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user

  def user_is(role)

    if current_user
      cur_role = current_user.role
      if role == 'Admin' && cur_role == 'Admin'
      elsif role == 'User' && (cur_role == 'User' || cur_role =='Admin')
      elsif role == 'Anonymous'

      else
        flash[:error] = "You require the "+role+" role to do that."
        redirect_to "/"
      end
    else
      if role != 'Anonymous'
        redirect_to new_user_session_url
      end
    end
  end

  # Set Page Titles
  def set_title(title)
    @title = title
  end

  private

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def require_no_user
      if current_user
        store_location
        flash[:error] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    def logged_out
    end

    def logged_user
      unless current_user
        store_location
        flash[:error] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def logged_admin
      if current_user
        if current_user.role == "Admin"
        else
          flash[:error] = "you must be admin"
          redirect_to "/"
        end
      else
        flash[:error] ="you must be logged in"
        redirect_to new_user_session_url
      end
    end

  protected

    def permission_denied
      flash[:error] = "Sorry, you are not allowed to access that page."
      redirect_to root_url
    end
  
end