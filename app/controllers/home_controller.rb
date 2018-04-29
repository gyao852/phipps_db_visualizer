class HomeController < ApplicationController
    def home
        @home = true

        @newGoal = Goal.new
        
        # donation goals from setting cache

        # get donation histories
        @donation_histories = DonationHistory.all
        @donation_histories_fYear = DonationHistory.on_or_after(Date.new(Date.today.year-1,10,1)).on_or_before(Date.new(Date.today.year,9,30))
        @donation_sum_fYear = 0
        @donation_histories_fYear.each do |h|
            @donation_sum_fYear += h.amount
        end




        @cp = DonationProgram.sum_and_count_level("Childrens' Programs")
        @aa = DonationProgram.sum_and_count_level("Annual Appeal")
        @cc = DonationProgram.sum_and_count_level("Commemorative Certificates")
        @dgb= DonationProgram.sum_and_count_level("Discovery Garden")
        @mh = DonationProgram.sum_and_count_level("Memorials & Honoraria")
        @sg = DonationProgram.sum_and_count_level("Sustained Giving")
        @other = DonationProgram.sum_and_count_level("Other")


        @donations_by_program = [@cp, @cc, @dgb, @mh, @sg, @aa, @other]

        @pie_chart_data_set = []
        @bar_chart_data_set = []
        
        @donations_by_program.each do |p|
            m = p['sum'].to_f/ @donation_sum_fYear.to_f
            if p['program']=="Annual Appeal"
                @aa_progress = {sum: p['sum'], goal: Setting.aa_goal, progress:  p['sum'].to_f/ Setting.aa_goal}
            elsif p['program']=="Commemorative Certificates"
                @cc_progress = {sum: p['sum'], goal: Setting.cc_goal, progress:  p['sum'].to_f/ Setting.cc_goal}
            elsif p['program']=="Childrens' Programs"
                @cp_progress = {sum: p['sum'], goal: Setting.cp_goal, progress:  p['sum'].to_f/ Setting.cp_goal}
            elsif p['program']=="Discovery Garden"
                @dg_progress = {sum: p['sum'], goal: Setting.dg_goal, progress:  p['sum'].to_f/ Setting.dg_goal}
            elsif p['program']=="Memorials & Honoraria"
                @mh_progress = {sum: p['sum'], goal: Setting.mh_goal, progress:  p['sum'].to_f/ Setting.mh_goal}
            elsif p['program']=="Sustained Giving"
                @sg_progress = {sum: p['sum'], goal: Setting.sg_goal, progress:  p['sum'].to_f/ Setting.sg_goal}
            else
                goal = nil
            end
            
            obj = {category:p['program'],sum: p['sum'], measure: m}
            
            @pie_chart_data_set.append(obj)
       
            #for each giving level
            lv1 = { category: "<100", group: p['program'], measure: p["<100" ]}
            lv2 = { category: "100-249", group: p['program'], measure: p["100-249"]}
            lv3 = { category: "250-499", group: p['program'], measure: p["250-499"]}
            lv4 = { category: "500-999", group: p['program'], measure: p["500-999"]}
            lv5 = { category: "1000-2499", group: p['program'], measure: p["1000-2499"] }
            lv6 = { category: "2500-4999", group: p['program'], measure: p["2500-4999"] }
            lv7 = { category: "5000-9999", group: p['program'], measure: p["5000-9999"] }
            lv8 = { category: ">10000", group: p['program'], measure: p[">10000"] } 

            @bar_chart_data_set.append(lv1)
            @bar_chart_data_set.append(lv2)
            @bar_chart_data_set.append(lv3)
            @bar_chart_data_set.append(lv4)
            @bar_chart_data_set.append(lv5)
            @bar_chart_data_set.append(lv6)
            @bar_chart_data_set.append(lv7)
            @bar_chart_data_set.append(lv8)


            @upcoming_events = Event.on_or_after(Date.current)
        end
    
    

    end

    # Methods to generate unclean address reports
    def generate_invalid_zips_addresses_report
        UncleanAddress.generate_invalid_zips
        redirect_to reports_path 
    end

    def generate_invalid_addresses_1_report
        UncleanAddress.generate_invalid_address_1
        redirect_to reports_path
    end

    def generate_invalid_state_addresses_report
        UncleanAddress.generate_invalid_states
        redirect_to reports_path
    end

    def generate_invalid_city_addresses_report
        UncleanAddress.generate_invalid_cities
        redirect_to reports_path
    end

    def generate_invalid_country_addresses_report
        UncleanAddress.generate_invalid_countries
        redirect_to reports_path
    end

    # Methods to generate unclean constituent reports
    def generate_invalid_constituents_report
        UncleanConstituent.generate_all_invalid
        redirect_to reports_path
    end


    def generate_no_contact_constituents_report
        UncleanConstituent.generate_no_contact
        redirect_to reports_path
    end

    def generate_invalid_phone_constituents_report
        UncleanConstituent.generate_invalid_phones
        redirect_to reports_path
    end

    def generate_invalid_email_constituents_report
        UncleanConstituent.generate_invalid_emails
        redirect_to reports_path
    end

    def generate_incomplete_name_constituents_report
        UncleanConstituent.generate_incomplete_names
        redirect_to reports_path
    end

    def generate_duplicate_constituents_report
        UncleanConstituent.generate_duplicates
        redirect_to reports_path
    end

    # Methods to functional reports
    def generate_donation_report
        Constituent.generate_donations_report(params[:date])
    end


    def generate_contact_history_report
        Constituent.generate_contact_history_report(params[:date])
    end

    def generate_attendance_report
        @event = Event.find_by(event_id: params[:events][:ids])   
        @event.generate_attendance_report
    end
        

    def reports
        @nav_status = 'reports'
        @events = Event.all.chronological
        #Constituent.generate_donations_report(2.days.ago.to_date)
    end
end