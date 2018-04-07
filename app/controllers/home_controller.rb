class HomeController < ApplicationController
    def home
        @home = true
        
        # get donation histories
        @donation_histories = DonationHistory.all
        @donation_histories_fYear = DonationHistory.on_or_after(Date.new(Date.today.year,10,1)).on_or_after(Date.new(Date.today.year+1,9,30))
        @donation_sum_fYear = 0
        
        # initialize variables by program
        @cp = {"sum" => 0, "program" => "Children' Programs", "<100" => 0, "100-249"=> 0, 
            "250-449" => 0, "550-999" => 0, "1000-2499" => 0, "2500-4999" => 0, "5000-9999" => 0,
            "10000+" => 0}
        @cc = {"sum" => 0, "program" => "Commemorative Certificates", "<100" => 0, "100-249"=> 0, 
            "250-449" => 0, "550-999" => 0, "1000-2499" => 0, "2500-4999" => 0, "5000-9999" => 0,
            "10000+" => 0}
        @dgb = {"sum" => 0, "program" => "Discovery Garden Bricks", "<100" => 0, "100-249"=> 0, 
            "250-449" => 0, "550-999" => 0, "1000-2499" => 0, "2500-4999" => 0, "5000-9999" => 0,
            "10000+" => 0}
        @mh = {"sum" => 0, "program" => "Memorials & Honoraria", "<100" => 0, "100-249"=> 0, 
            "250-449" => 0, "550-999" => 0, "1000-2499" => 0, "2500-4999" => 0, "5000-9999" => 0,
            "10000+" => 0}
        @sg = {"sum" => 0, "program" => "Sustained Giving", "<100" => 0, "100-249"=> 0, 
            "250-449" => 0, "550-999" => 0, "1000-2499" => 0, "2500-4999" => 0, "5000-9999" => 0,
            "10000+" => 0}
        @aa = {"sum" => 0, "program" => "Annual Appeal", "<100" => 0, "100-249"=> 0, 
            "250-449" => 0, "550-999" => 0, "1000-2499" => 0, "2500-4999" => 0, "5000-9999" => 0,
            "10000+" => 0}
        @other = {"sum" => 0, "program" => "Other", "<100" => 0, "100-249"=> 0, 
        "250-449" => 0, "550-999" => 0, "1000-2499" => 0, "2500-4999" => 0, "5000-9999" => 0,
        "10000+" => 0}

        @donation_histories_fYear.each do |h|
            # calculate fiscal year donation sums from each donation program for pie chart
            @donation_sum_fYear += h.amount
            if h.donation_program.program == @cp["program"]
                @cp["sum"] += amount
            elsif h.donation_program.program == @cc["program"]
                @cc["sum"] += amount
            elsif h.donation_program.program == @dgb["program"]
                @dgb["sum"] += amount
            elsif h.donation_program.program == @mh["program"]
                @mh["sum"] += amount
            elsif h.donation_program.program == @sg["program"]
                @sg["sum"] += amount
            elsif h.donation_program.program == @other["program"]
                @aa["sum"] += amount  
            else
                @other["sum"] += amount
            end
            


        end
    end
end