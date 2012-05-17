
class AnalysesController < ApplicationController
  before_filter :init_analysis, :only => [:create, :show, :edit, :update, :destroy]
  before_filter :find_assessment_take, :only => [:show]

  def show
    id = params[:assessment_take_id]
    tb_self = build_table(id,true)
    tb_fb = build_table(id,false)
    #@script = build_charts()
    
    ####CHARTS
    #Chart 1:sort all subcats for Self
    d = ""
    id = []
    iid,dd=table_one_bchart(sort_nopar_total(tb_self),c="#f2faff",n="tb1",take="Self",t="Chart",s="Sorted",left="Points",bg="#ddeeff")
    id+=[iid]
    d+=dd
    #chart 2: sort all subcats for fb
    iid,dd=table_one_bchart(sort_nopar_total(tb_fb),c="#f2faff",n="tb2",take="Feedback",t="Chart",s="Sorted",left="Points",bg="#ddeeff")
    d+=dd
    id+=[iid]
    #sort par cat for self pie-chart
    iid,dd=table_one_pchart(sort_nochild_total(tb_self),c="#ffffff",n="tb3",take="Self",t="Chart",s="Sorted",left="Points",bg="#ddeeff")
    d+=dd
    id+=[iid]
    #sort par cat for fb pie-chart
    iid,dd=table_one_pchart(sort_nochild_total(tb_fb),c="#ffffff",n="tb4",take="Feedback",t="Chart",s="Sorted",left="Points",bg="#ddeeff")
    d+=dd
    id+=[iid]
    #not sorted, child, stacking
    tbs = [nopar(tb_self),nopar(tb_fb)]
    iid,dd=table_stack_bchart(tbs,c="#fefaff",n="tb5",takes=["Self","Feedback"],t="Chart",s="",left="Points",bg="#ffffff")
    d+=dd
    id+=[iid]
    #not sorted, no par, comp similar
    tbs = diff_nopar( tb_self,tb_fb)
    tbs = bot_range_total(tbs)
    #iid,dd = table_one_bchart(tbs,c="#f2faff",n="tb6",take="Self",t="Chart",s="Sorted",left="Points",bg="#ddeeff")
    tbs = [tb_self.select{|r| tbs.select{|o| o[0]==r[0]}.length()>0},tb_fb.select{|r| tbs.select{|o| o[0]==r[0]}.length()>0}]
    iid,dd=table_side_bchart(tbs,c="#fefaff",n="tb6",takes=["Self","Feedback"],t="Chart",s="",left="Points",bg="#ffffff")
    d+=dd
    id+=[iid]
    #7: bar chart, feedback>self(encouraging blind spots)
    tb1 = diff_nopar( tb_self,tb_fb)
    tb2 = top_range_total(tb1)
    tbs3 = [tb_self.select{|r| tb2.select{|o| o[0]==r[0]}.length()>0},tb_fb.select{|r| tb2.select{|o| o[0]==r[0]}.length()>0}]
    tbs3 = [tbs3[0].select{|r| r[4] < tbs3[1].select{|rr| rr[0]==r[0]}[0][4]},tbs3[1].select{|r| r[4] > tbs3[0].select{|rr| rr[0]==r[0]}[0][4]}]
    iid,dd=table_side_bchart(tbs3,c="#fefaff",n="tb7",takes=["Self","Feedback"],t="Chart",s="",left="Points",bg="#ffffff")
    d+=dd
    id+=[iid]
    #8: bar chart, feedback<self(painful blind spots)
    tb1 = diff_nopar( tb_self,tb_fb)
    tb2 = top_range_total(tb1)
    tbs3 = [tb_self.select{|r| tb2.select{|o| o[0]==r[0]}.length()>0},tb_fb.select{|r| tb2.select{|o| o[0]==r[0]}.length()>0}]
    tbs3 = [tbs3[0].select{|r| r[4] > tbs3[1].select{|rr| rr[0]==r[0]}[0][4]},tbs3[1].select{|r| r[4] < tbs3[0].select{|rr| rr[0]==r[0]}[0][4]}]
    iid,dd=table_side_bchart(tbs3,c="#fefaff",n="tb8",takes=["Self","Feedback"],t="Chart",s="",left="Points",bg="#ffffff")
    d+=dd
    id+=[iid]
    ####
    @script = build_charts(id,d)
    
  end
  


	# GET /analysis/1/edit
	def edit
	end

	# POST /analysis
	def create
		update
	end

	# PUT /analysis/1
	def update
		respond_to do |wants|
			if @analysis.update_attributes(params[:analysis])
				flash[:notice] = 'The analysis was successfully saved.'
				wants.html { redirect_to :back }
			else
				wants.html { render :action => "edit" }
			end
		end
	end

	# DELETE /analysis/1
	# DELETE /analysis/1.xml
	def destroy
		@analysis.destroy

		respond_to do |wants|
			wants.html { redirect_to(analysis_url) }
			wants.xml { head :ok }
		end
	end

  private
  
  #HIGHCHARTS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  
  def table_stack_bchart(tbs,c="#eeeeff",n="test",takes=["Self","Feedback"],t="Chart",s="",left="Points",bg="#ffffff")
    d = title(t)
    d+=subtitle(s)
    
    cats=[]
    tbs[0].select{|row| !row[4].nil?}.each do |row|
      cats+=[row[0].name]
    end 
    xa = labels(rotation(-45)+align("right"))+categories(cats)
    d+=xaxis(xa)
    ya = min(0)+title(left)
    
    d+=yaxis(ya)
    l=layout("horizontal")
    l+=backgroundcolor(bg)
    l+= align("left")
    l+= verticalalign("top")
    l+=x(10)
    l+=y(30)
    d+=legend(l)
    d+=tooltip()
    d+=plotoptions(column(pointpadding(0.2)+borderwidth(1)+"      stacking:' normal',\n"))
    
    s=[]
    tbs.each_with_index do |tb,i|
      point = []
      tb.select{|row| !row[4].nil?}.each do |row|
        point+=[row[4]/tbs.length.to_f]
      end
      s+=[name(takes[i])+data(point)]
    end
    
    d+=series(s)
    id,d = build_chart(n,d,"column",c)
    return [id,d]
  end
  
  def table_side_bchart(tbs,c="#eeeeff",n="test",takes=["Self","Feedback"],t="Chart",s="",left="Points",bg="#ffffff")
    d = title(t)
    d+=subtitle(s)
    
    cats=[]
    tbs[0].select{|row| !row[4].nil?}.each do |row|
      cats+=[row[0].name]
    end 
    xa = labels(rotation(-45)+align("right"))+categories(cats)
    d+=xaxis(xa)
    ya = min(0)+title(left)
    
    d+=yaxis(ya)
    l=layout("horizontal")
    l+=backgroundcolor(bg)
    l+= align("left")
    l+= verticalalign("top")
    l+=x(10)
    l+=y(30)
    d+=legend(l)
    d+=tooltip()
    d+=plotoptions(column(pointpadding(0.2)+borderwidth(1)+"\n"))
    
    s=[]
    tbs.each_with_index do |tb,i|
      point = []
      tb.select{|row| !row[4].nil?}.each do |row|
        point+=[row[4]/tbs.length.to_f]
      end
      s+=[name(takes[i])+data(point)]
    end
    
    d+=series(s)
    id,d = build_chart(n,d,"column",c)
    return [id,d]
  end
  
  def backgroundcolor(c)
    return "      backgroundColor: "+c+",\n"
  end
  
  def table_one_pchart(tb,c="#eeeeff",n="test",take="Self",t="Chart",s="",left="Points",bg="#ffffff")
    d = title(t)
    d+=subtitle(s)
    
    cats=[]
    tb.select{|row| !row[4].nil?}.each do |row|
      cats+=[row[0].name]
    end
#     xa = categories(cats)
#     d+=xaxis(xa)
#     ya = min(0)+title(left)
#     d+=yaxis(ya)
    l=layout("vertical")
    l+=backgroundcolor(bg)
    l+= align("left")
    l+= verticalalign("top")
    l+=x(40)
    l+=y(60)
    d+=legend(l)
    d+=tooltip()
    d+=plotoptions(column(pointpadding(0.2)+borderwidth(1)))
    d+="plotOptions: {
         pie: {
            allowPointSelect: true,
            cursor: 'pointer',
            dataLabels: {
               enabled: true,
               formatter: function() {
                  if (this.y > 5) return this.point.name;
               },
               color: 'black',
               style: {
                  font: '13px Trebuchet MS, Verdana, sans-serif'
               }
            }
         }
      },
"
    
    point = []
    tb.select{|row| !row[4].nil?}.each do |row|
      point+=[[row[0].name,row[4]]]
    end
    
    
    s = [name(take)+data(point)]
    
    d+=series(s)
    id,d = build_chart(n,d,"pie",c)
    return [id,d]
  end
  
  def table_one_bchart(tb,c="#eeeeff",n="test",take="Self",t="Chart",s="",left="Points",bg="#ffffff")
    d = title(t)
    d+=subtitle(s)
    
    cats=[]
    tb.select{|row| !row[4].nil?}.each do |row|
      cats+=[row[0].name]
    end 
    xa = labels(rotation(-45)+align("right"))+categories(cats)
    d+=xaxis(xa)
    ya = min(0)+title(left)
    
    d+=yaxis(ya)
    l=layout("vertical")
    l+=backgroundcolor(bg)
    l+= align("left")
    l+= verticalalign("top")
    l+=x(70)
    l+=y(60)
    d+=legend(l)
    d+=tooltip()
    d+=plotoptions(column(pointpadding(0.2)+borderwidth(1)))
    
    point = []
    tb.select{|row| !row[4].nil?}.each do |row|
      point+=[row[4]]
    end
    
    s = [name(take)+data(point)]
    
    d+=series(s)
    id,d = build_chart(n,d,"column",c)
    return [id,d]
  end
  
  def build_charts(ids,data)  #[[id,id,id,id],"data;datta;data"]
    ret = ""
    ids.each do |id|
      ret += "  var "+id+";\n"
    end
    ret += "$(document).ready(function() {\n"+data+"});\n"
    return ret
  end
  
  def build_chart(id,data,type,c="#eeeeff")
    ret = id+" = new Highcharts.Chart({\n"
    ret += "  chart: {\n"+backgroundcolor(c)+"\n   renderTo: '"+id+"',\n    defaultSeriesType:'"+type+"'\n  },\n"
    ret += data+"\n});\n"
    return [id,ret]
  end
  
  def title(t)
    ret ="    title: {\n"+text(t)+"    },\n"
    return ret
  end
  
   def labels(t)
    ret ="    labels: {\n"+t+"    },\n"
    return ret
  end
  
  def subtitle(t)
    ret ="    subtitle: {\n"+text(t)+"    },\n"
    return ret
  end
  
  def xaxis(data)
    ret = "  xAxis: {\n"+data+"  },\n"
    return ret
  end
  
  def categories(cats)
    ret = "    categories: [\n"
    cats.each do |cat|
      ret+= "      '"+cat+"',\n"
    end
    ret +="    ],\n"
    return ret
  end
  
  def min(num)
    return "    min: "+num.to_s+",\n"
  end
  
  def layout(num)
    return "    layout: '"+num.to_s+"',\n"
  end
  
  def backgroundcolor(num)
    return "    backgroundColor: '"+num+"',\n"
  end
  
  def align(num)
    return "    align: '"+num.to_s+"',\n"
  end
  
  def verticalalign(num)
    return "    verticalAlign: '"+num.to_s+"',\n"
  end
  
  def x(num)
    return "    x: "+num.to_s+",\n"
  end
  
  def y(num)
    return "    y: "+num.to_s+",\n"
  end
  
  def yaxis(data)
    ret = "  yAxis: {\n"+data+"  },\n"
    return ret
  end
  
  def text(t)
    ret = "      text: '"+t+"',\n"
    return ret
  end
  
  def legend(data)
    ret = "  legend: {\n"+data+"  },\n"
    return ret
  end
  
  def tooltip()
    ret = "  tooltip: {
         formatter: function() {
            return ''+
               this.x +': '+ this.y +' Points';
         }
      },
"
    return ret
  end
  
  def column(data)
    "column: {\n"+data+"\n         }"
  end
  
  def data(ar)
    ret = "        data: "
    ret += _data_recursive(ar)
    ret += "\n"
  end
  
  def _data_recursive(ar)
    ret = "["
    ar.each do |a|
      if a.class==Fixnum or a.class==Float
        ret+=a.to_s+", "
      elsif a.class == String
        ret += "'"+a+"',"
      elsif a.class==Array
        ret += _data_recursive(a)
      end
    end
    ret +="],"
    return ret
  end
  
  def name(n)
    return "         name: '"+n+"',\n"
  end
  
  def series(ar)
    ret = "           series: ["
    ar.each do |a|
      ret += "{"+a+"},\n"
    end
    ret += "],"
    return ret 
  end
  
  def plotoptions(opt)
    return "plotOptions: {"+opt+"},\n"
  end
  
  def pointpadding(n)
    return "         pointPadding: '"+n.to_s()+"',\n"
  end
  def borderwidth(n)
    return "         borderWidth: '"+n.to_s()+"',\n"
  end
  def type(n)
    return "         type: '"+n+"',\n"
  end
  
  def rotation(n)
    return "         rotation: "+n.to_s()+",\n"
  end
    
  
  
#   def build_charts()
#     script = "<script>"
#     script+= "var chart1;"
#     script += "$(document).ready(function() {"
#     
#     chart = "chart1 = new Highcharts.Chart({"
#     chart += "chart: { renderTo: 'chart-container-1',defaultSeriesType: 'bar'},"
#     
#     
#     chart += "})"
#     script += chart
#     
#     script += "})<script>"
#   end  
  
  #SORTING CODE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  def sort_nopar_total(tb)
    return tb.select{|row| !row[0].has_child?}.select{|row| !row[4].nil?}.sort{|a,b| a[4]<=>b[4]}
  end
  
  def nopar(tb)
    return tb.select{|row| !row[0].has_child?}.select{|row| !row[4].nil?}
  end
  
  def sort_nochild_total(tb)
    return tb.select{|row| row[1]==0}.sort{|a,b| a[4]<=>b[4]}
  end
  
  def diff_nopar(tb1,tb2)
    #returns the differential score and drops all parent categories
    #return is tb1 with only the score section changed
    tmp = nopar(tb1).zip(nopar(tb2))
    ret = []
    tmp.each_with_index do |row,i|
      val1,val2=[0,0]
      r1,r2 = row
      val1 = r1[4] if !r1[4].nil?
      val2 = r2[4] if !r2[4].nil?
      #r1[4] = (val1-val2).abs()   #THIS BREAKS DUE TO RUBY INTERPRETER REFERENCE VS COPY BUG
      rr1 = r1[0..3]
      rr1 << (val1-val2).abs()
      ret << rr1
    end
    return ret
  end
  
  def top_range_total(tb)
    #returns all categories with the highest values in the range
    min,max = nil,nil
    tb.each do |row|
      if !row[4].nil?
        if min.nil? or max.nil?
          min=row[4]
          max=row[4]
        else
          min=row[4] if row[4]<min
          max=row[4] if row[4]>max
        end
      end
    end
#     range = max-min
#     if range == 0
#       range = 100
#     end
#     range = range*0.2
    range = 10
    return tb.select{|r| !r[4].nil?}.select{|r| r[4]>=10}
    #return tb.select{|r| !r[4].nil?}.select{|r| r[4]>(max-range)}
  end
  
  def bot_range_total(tb)
    #
    min,max = nil,nil
    tb.each do |row|
      if !row[4].nil?
        if min.nil? or max.nil?
          min=row[4]
          max=row[4]
        else
          min=row[4] if row[4]<min
          max=row[4] if row[4]>max
        end
      end
    end
#     range = max-min
#     if range == 0
#       range = 100
#     end
#     range = range*0.2
    range = 10
    return tb.select{|r| !r[4].nil?}.select{|r| r[4]<10}
    #return tb.select{|r| !r[4].nil?}.select{|r| r[4]<(min+range)}
  end
  
  
  #/SORTING CODE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  
  def init_analysis
    @assessment = Assessment.find(params[:assessment_id])
    if @assessment.analysis.nil?
      @analysis = Analysis.new
      @analysis.assessment_id = @assessment.id
    else
      @analysis = @assessment.analysis
    end
  end

  def find_assessment_take
    @assessment_take = AssessmentTake.find(params[:assessment_take_id])
  end

end