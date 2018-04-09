class HomeController < ApplicationController
    def home
        @home = true
        
        # get donation histories
        @donation_histories = DonationHistory.all
        @donation_histories_fYear = DonationHistory.on_or_after(Date.new(Date.today.year-1,10,1)).on_or_before(Date.new(Date.today.year,9,30))
        @donation_sum_fYear = 0

        @cp = DonationHistory.sum_and_count_level("Childrens' Programs")
        @aa = DonationHistory.sum_and_count_level("Annual Appeal")
        @cc = DonationHistory.sum_and_count_level("Commemorative Certificates")
        @dgb =DonationHistory.sum_and_count_level("Discovery Garden")
        @mh = DonationHistory.sum_and_count_level("Memorials & Honoraria")
        @sg = DonationHistory.sum_and_count_level("Sustained Giving")
        @other = DonationHistory.sum_and_count_level("Other")

    
        
        # initialize variables by program
        # @cp = {"sum" => 0, "program" => "Childrens' Programs", "<100" => 0, "100-249"=> 0, 
        #     "250-499" => 0, "500-999" => 0, "1000-2499" => 0, "2500-4999" => 0, "5000-9999" => 0,
        #     ">10000" => 0}
        # @cc = {"sum" => 0, "program" => "Commemorative Certificates", "<100" => 0, "100-249"=> 0, 
        #     "250-499" => 0, "500-999" => 0, "1000-2499" => 0, "2500-4999" => 0, "5000-9999" => 0,
        #     ">10000" => 0}
        # @dgb = {"sum" => 0, "program" => "Discovery Garden Bricks", "<100" => 0, "100-249"=> 0, 
        #     "250-499" => 0, "500-999" => 0, "1000-2499" => 0, "2500-4999" => 0, "5000-9999" => 0,
        #     ">10000" => 0}
        # @mh = {"sum" => 0, "program" => "Memorials & Honoraria", "<100" => 0, "100-249"=> 0, 
        #     "250-499" => 0, "500-999" => 0, "1000-2499" => 0, "2500-4999" => 0, "5000-9999" => 0,
        #     ">10000" => 0}
        # @sg = {"sum" => 0, "program" => "Sustained Giving", "<100" => 0, "100-249"=> 0, 
        #     "250-499" => 0, "500-999" => 0, "1000-2499" => 0, "2500-4999" => 0, "5000-9999" => 0,
        #     ">10000" => 0}
        # @aa = {"sum" => 0, "program" => "Annual Appeal", "<100" => 0, "100-249"=> 0, 
        #     "250-499" => 0, "500-999" => 0, "1000-2499" => 0, "2500-4999" => 0, "5000-9999" => 0,
        #     ">10000" => 0}
        # @other = {"sum" => 0, "program" => "Other", "<100" => 0, "100-249"=> 0, 
        # "250-499" => 0, "500-999" => 0, "1000-2499" => 0, "2500-4999" => 0, "5000-9999" => 0,
        # ">10000" => 0}

        @donations_by_program = [@cp, @cc, @dgb, @mh, @sg, @other]

        def setDonationLevelandProgram(a,p)
            p["sum"] += a
            if a < 100
                p["<100"] += 1
            elsif a >= 100 && a < 249
                p["100-249"] += 1
            elsif a >= 250 && a <= 499
                p["250-499"] += 1
            elsif a >= 500 && a<= 999
                p["500-999"] += 1
            elsif a >=1000 && a <= 2499
                p["1000-2499"] += 1
            elsif a >=2500 && a <= 4999
                p["2500-4999"] += 1
            elsif a >=2500 && a <= 4999
                p["5000-9999"] += 1
            else
                p[">10000"] += 1
            end

        end
        @donation_histories_fYear.each do |h|
            @donation_sum_fYear += h.amount
            # calculate fiscal year donation sums from each donation program for pie chart
            
            if h.donation_program.program == @cp["program"]
                setDonationLevelandProgram(h.amount, @cp)
            elsif h.donation_program.program == @cc["program"]
                setDonationLevelandProgram(h.amount, @cc)
            elsif h.donation_program.program == @dgb["program"]
                setDonationLevelandProgram(h.amount, @dgb)
            elsif h.donation_program.program == @mh["program"]
                setDonationLevelandProgram(h.amount, @mh)
            elsif h.donation_program.program == @sg["program"]
                setDonationLevelandProgram(h.amount, @sg)
            elsif h.donation_program.program == @other["program"]
                setDonationLevelandProgram(h.amount, @aa)
            else
                setDonationLevelandProgram(h.amount, @other)
            end

        end

        @pie_chart_data_set = []
        @bar_chart_data_set = []
        
        @donations_by_program.each do |p|
            m = p['sum']/ @donation_sum_fYear.to_f
            obj = {category:p['program'], measure: m}
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
        end
    
    

    end
end