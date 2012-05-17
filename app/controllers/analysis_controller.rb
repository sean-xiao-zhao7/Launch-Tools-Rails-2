class AnalysisController < ApplicationController
  def show
    id = params[:id]
    atable = ans_table(params[:id])
    cats = cat(id)
    a = average(atable)
    s = sum(atable)
    n = num(atable)
    atable.each_with_index do|r,i|
      r << s[i]<< n[i] << a[i]
    end
    @table=atable
    
    @h = high(@table)
    @l = low(@table)
    
    @r = @h-@l
    @lr = round_up(@l+(@r*0.2))
    @hr = (@h-(@r*0.2)).to_i
    
    @cl = cat_low(@table,@lr)
    @ch = cat_high(@table,@hr)
    
    
  end
  
  private
  
  def cat_low(table,lr)
    ret = []
    table.each do |row|
      if ((row[5]<=lr)if row[5].class==Fixnum)
        ret << row[0]
      end
    end
    return ret
  end
  
  def cat_high(table,hr)
    ret = []
    table.each do |row|
      if ((row[5]>=hr)if row[5].class==Fixnum)
        ret << row[0]
      end
    end
    return ret
  end
  
  def round_up(n)
    if n%1==0
      return n
    end
    return (n+1).to_i
  end
  
  def high(table)
    h = -1000000
    table.each do |r|
      if ((r[5]>h) if r[5].class==Fixnum)
        h = r[5]
      end
    end
    if h == -1000000
      h=nil
    end
    return h
  end
  
  def low(table)
    l = 1000000
    table.each do |row|
      if ((row[5]<l)if row[5].class==Fixnum)
        l=row[5]
      end
    end
    if l == 1000000
      l=nil
    end
    return l
  end
  
  def num(table) #return the number of entries
        new = []
    table.each do |row|
      ln = 0
      row[2].each do |o|
        (ln+=1) if o[0].class==Fixnum
      end
      new << ln#row[2].length
    end
    return new
  end
  
  def sum(table)
    new = []
    table.each do |row|
      a = 0
      row[2].each do |o|
        (a+=o[0])if o[0].class==Fixnum
      end
      new << a
    end
    return new
  end
  
  def average(table)
    new = []
    table.each do |row|
      if row[2].length == 0
        avg = nil
      else
        avg = 0
      end
      n =0
      row[2].each do |o|
        if ((!o[0].zero?) if o[0].class==Fixnum)
          avg+=o[0]
          n+=1
        end
      end
      if !avg.nil?
        if avg.zero?
          avg=nil
        end
      end
      (avg =avg/n) if !avg.nil?
      new << avg
    end
    return new
  end
  
  def cat(id)
    #Format = [[Cat,child,[]],...]
    #get data:
    at = AssessmentTake.find(id)
    a = at.assessment
    cats = at.assessment.categories
    #find all parents and childs:
    child_cats = []
    parent_cats = []
    cats.each do |cat|
      if !cat.parent_id.nil?
        child_cats = child_cats | [cat]
        parent_cats = parent_cats | [cat.parent]
        cats = cats - [cat.parent]
        cats = cats -[cat]
      end
    end
    #sort parent and child cats:
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
    #create final cat table:
    table = []
    cats.each do |c|
      table = table | [[c,0,[]]]
    end
    table = table | parent_child_cats
    return table
  end
  
  def ans_table(id)
    #Format = [[Cat,child,[[val,text,link],...]],...]
    #get data:
    at = AssessmentTake.find(id)
    a = at.assessment
    cats = at.assessment.categories
    #find all parents and childs:
    child_cats = []
    parent_cats = []
    cats.each do |cat|
      if !cat.parent_id.nil?
        child_cats = child_cats | [cat]
        parent_cats = parent_cats | [cat.parent]
        cats = cats - [cat.parent]
        cats = cats -[cat]
      end
    end
    #sort parent and child cats:
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
    #create final cat table:
    table = []
    cats.each do |c|
      table = table | [[c,0,[]]]
    end
    table = table | parent_child_cats
    #add the questions to table
    a.questions.each do |q|
      if q.question_type.name == "Rate"
        table.detect{|cat| cat[0] == q.category}[2]<<[at.answers.detect{|a| a.question == q}.value,q.content,nil]
      elsif q.question_type.name == "Choose-one"
        ans = at.answers.detect{|a| a.question == q}
        ans = q.McOptions.find(ans.value)
        cc = q.category
        if !ans.category.nil?
          cc = ans.category
        end
        hover = q.content + ":<br/>answer:<br/>"+ans.content
        table.detect{|cat| cat[0] == cc}[2]<<[ans.value,hover,nil]
      elsif q.question_type.name == "Text"
        text = at.answers.detect{|a| a.question == q}.text
        hover = q.content+":<br/>answer:<br/>"+text
        table.detect{|cat| cat[0] == q.category}[2]<<["T",hover,nil]
      elsif q.question_type.name == "Choose-many"
        cc = q.category
        val = q.value#nil#val = q.value #todo, add value to questions
        len = q.McOptions.length
        ans = at.answers.detect{|a| a.question == q}
        nv= ans.num
        val = ((val / nv) unless nv.zero?) unless val.nil?
        q.McOptions.each_with_index do |mc,pos|
          if ans.get(len-1-pos)
            if !mc.category.nil?
              cc = mc.category
            end
            if !mc.value.nil?#val.nil?
              val = mc.value
            end
            table.detect{|cat| cat[0] == cc}[2]<<[val,q.content,nil]
          end
        end
      end
    end
    return table
  end
  
  
end
