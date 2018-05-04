
# coding: utf-8

# # Phipps Conservatory Membership Database Cleaning Script
# ### Team members: Ashvin Niruttan, George Yao, Minnie Wu
# ### Last updated: April 12th, 2018

# ### Libraries

# In[895]:


import csv
import pandas as pd
import re
import numpy as np

# ### Read CSV files

# In[713]:


# Read csv files and place into dataframes
# Constituent Records + Membership Records
cdf = pd.read_csv('public/CMU Team Constituents Export.csv',dtype="str",na_filter='')
# Donation Records
ddf = pd.read_csv('public/CMU Team Donations Export.csv',dtype="str",na_filter='')
# Event + Event Attendance Records
edf = pd.read_csv('public/CMU Team Event Attendance Export.csv',dtype="str",na_filter='')
# Contact History Records
chdf = pd.read_csv('public/CMU Team Contact History Export.csv',dtype="str",na_filter='')

# ### Additional Dataframes (Global variables)

# In[902]:


# Dataframes for each membership scheme/type
# NOTE: There are some records that are not a member, or have more than one type/scheme of membership
phipps_general = pd.DataFrame()
phipps_corporate = pd.DataFrame()
green_mountain = pd.DataFrame()
garden_club = pd.DataFrame()
non_member = pd.DataFrame()
obsolete = pd.DataFrame()

# Dataframes for invalid records (Name, ZIP, phone, emails, Duplicates)
no_contact = pd.DataFrame() # No way of contact
incomplete_names = pd.DataFrame() # No First name, or last name
invalid_addresses_1 = pd.DataFrame()
invalid_cities = pd.DataFrame() # City is not a string
invalid_states = pd.DataFrame() # State is not a string
invalid_country = pd.DataFrame() # State is not a string
invalid_zips = pd.DataFrame() # ZIP code not abiding to US/Canadian format
invalid_phones = pd.DataFrame() # Phone number not biding to US/Canadian format
invalid_emails = pd.DataFrame() # Simple e-mail checker for validations
duplicate_records = pd.DataFrame() # ZIP code not abiding to US/Canadian format


# ## 1) Setting up initial database for constituent, address, and membership
print ("Reached line 64, entered python.")
# In[903]:


# ccdf will be the copy used to create future dataframes
ccdf = cdf.copy()

# Adding additional columns for constituent and membership
ccdf['phone_notes'] = ""
ccdf['add_ons'] = ""

# Removing inital columne: BUSINESSPROCESSOUTPUT_PKID from all future copies
ccdf = ccdf.drop(ccdf.columns[0], axis=1)

# Initialize nan values with blank values
ccdf.replace(np.nan, '', regex=True);

# Replace the column values with reflected as in the database.
columns = [ 'lookup_id', 'suffix', 'title', 'name', 'last_group', 'constituent_type','phone', 'dob',
           'do_not_email', 'email_id', 'address_1', 'city', 'state', 'zip', 'country','address_type',
           'date_added','membership_id', 'membership_level', 'membership_level_type',
           'membership_scheme', 'end_date', 'start_date','general_last_renewed', 'green_last_renewed',
           'corporate_last_renewed', 'garden_last_renewed','membership_status', 'add_ons', 'phone_notes'
            ]
ccdf.columns = columns


# ## 2) Flag and remove records with no names, or name but no mailing and email address

# In[904]:


no_contact = ccdf[
    ((ccdf["email_id"] == '') & (ccdf["address_1"] == '')
    & (ccdf[r"phone"] == '')) & (ccdf['lookup_id'] != 'anonymous')]

ccdf = ccdf[(ccdf['lookup_id']=='anonymous') | ((ccdf["email_id"] != '') | (ccdf["address_1"] != '')
                                     | (ccdf[r"phone"] != ''))]


# ## 3) Apply cleaning modules

# #### Clean name
#
# Clean the name by capitalizing each part of the name, and remove common invalid characters or phrases

# In[905]:


# Cleans up Name
def clean_name(v):
    cName = v.replace('""','').replace('?','').replace("(no last name given)",'')
    cName = cName.replace("  ",' ').replace('.','').replace('~','').replace("<None Specified>",'')
    cName = cName.replace("UNKNOWN",'')
    if cName != '':
        if any(char.isdigit() for char in cName):
            return "NO NAME"

        cName = cName.title()
        if (len(cName.split(' ')) == 1) and cName[0]!='Anonymous':
            return "ONE WORD"
        return cName
    else:
        return "NO NAME"
ccdf['cname'] = ccdf['name'].apply(clean_name)


# #### Clean Last Name/Organization name
#
# Clean the last name, or the organization's name by capitalizing each part of the name, and removing common special characters

# In[906]:


# Cleans up Last name/organization
def clean_last_Name(v):
    clname = v.replace('""','').replace('?','').replace(".",'').replace('  ',' ').replace('-','').replace("(no last name given)",'')
    clname = clname.title()
    if clname == '':
        return "BLANK"
    else:
        return clname
ccdf['clname'] = ccdf['last_group'].apply(clean_last_Name)


# #### Clean Address
#
# Clean up the address of a record by replacing any address abbreviations with it's respective full word, getting rid of any special characters or double spaces.

# In[907]:


# Cleans up address
def clean_address(v):
    cadd = v.title()
    if v != '':
        if v.isdigit():
            return "INVALID"
        cadd = cadd.replace('-','').replace('\n', ' ').replace('\r', '').replace('  ',' ')
        cadd = re.sub(r"Ave[\s \. ,]+", "Avenue", cadd)
        cadd = re.sub(r"Ave\Z", "Avenue", cadd)

        cadd = re.sub(r"Dr[\s \. ,]+", "Drive", cadd)
        cadd = re.sub(r"Dr\Z", "Drive", cadd)

        cadd = re.sub(r"St[\s \. ,]+", "Street", cadd)
        cadd = re.sub(r"St\Z", "Street", cadd)

        cadd = re.sub(r"Apt[\s \. ,]?", "Apartment", cadd)
        cadd = re.sub(r"Blvd[\s \. ,]?", "Boulevard", cadd)
        cadd = re.sub(r"Rd[\s \. ,]?", "Road", cadd)

        cadd = re.sub(r"W[\s \. , $]+|W$", "West ", cadd)
        cadd = re.sub(r"N[\s \. , $]+|N$", "North ", cadd)
        cadd = re.sub(r"E[\s \. , $]+|E$", "East ", cadd)
        cadd = re.sub(r"S[\s \. , $]+|S$", "South ", cadd)
        return cadd
    else:
        return "POTENTIAL INVALID"
ccdf['caddress_1'] = ccdf['address_1'].apply(clean_address)


# #### Clean City
#
# Clean up the city name by simply capitalizing the name.

# In[908]:


# Capitalize City name
def clean_city(v):
    v = v.title()
    if v != '':
        if v.isdigit():
            return 'INVALID'
        return v.replace('`','').replace('<','')
    return v # should be '' if reached
ccdf['ccity'] = ccdf['city'].apply(clean_city)


# #### Clean State
#
# Cleans up state by replacing any abreviations for US states with the full name.

# In[909]:


# Convert state abreviation to full name
states = {
        'AK': 'Alaska','AL': 'Alabama','AR': 'Arkansas',
        'AS': 'American Samoa','AZ': 'Arizona','CA': 'California','CO': 'Colorado','CT': 'Connecticut',
        'DC': 'District of Columbia','DE': 'Delaware','FL': 'Florida','GA': 'Georgia','GU': 'Guam','HI': 'Hawaii',
        'IA': 'Iowa','ID': 'Idaho','IL': 'Illinois','IN': 'Indiana','KS': 'Kansas','KY': 'Kentucky',
        'LA': 'Louisiana','MA': 'Massachusetts','MD': 'Maryland','ME': 'Maine','MI': 'Michigan',
        'MN': 'Minnesota','MO': 'Missouri','MP': 'Northern Mariana Islands','MS': 'Mississippi','MT': 'Montana',
        'NA': 'National','NC': 'North Carolina','ND': 'North Dakota','NE': 'Nebraska','NH': 'New Hampshire',
        'NJ': 'New Jersey','NM': 'New Mexico','NV': 'Nevada','NY': 'New York','OH': 'Ohio','OK': 'Oklahoma',
        'OR': 'Oregon','PA': 'Pennsylvania','PR': 'Puerto Rico','RI': 'Rhode Island','SC': 'South Carolina',
        'SD': 'South Dakota','TN': 'Tennessee','TX': 'Texas','UT': 'Utah','VA': 'Virginia','VI': 'Virgin Islands',
        'VT': 'Vermont','WA': 'Washington','WI': 'Wisconsin','WV': 'West Virginia','WY': 'Wyoming',
        'AB': 'Alberta', 'BC': 'British Columbia', 'MB': 'Manitoba',
        'NB': 'New Brunswick', 'NL': 'Newfoundland & Labrador' , 'NS': 'Nova Scotia','NT': 'Northwest Territories',
        'ON': 'Ontario','YT': 'Yukon','SK': 'Saskatchewan', 'PE': 'Prince Edward Island', 'NU': 'Nunavut',
        'PQ':'Québec','QC':'Québec'
}

def clean_state(v):
    if v != '':
        v = v.replace('  ','')
        if v.isdigit():
            return "INVALID"
        if v in states:
            return states[v]
        return v.title()
    return v # should be '' if reached

# Due to the large number of states that come from international places, this simply cleans up and capitalizes
# given state data, and tries to give the full state address
ccdf['cstate'] = ccdf['state'].apply(clean_state)



# #### Clean country
#
# Clean up the country name by simply capitalizing the name.

# In[910]:


# Capitalize Country name
def clean_country(v):
    if v != '':
        if v.isdigit():
            return 'INVALID'
        return v.title()
    return v
ccdf['ccountry'] = ccdf['country'].apply(clean_country)


# #### Clean ZIP code
#
# Clean up the zip code by replacing common special characters with their counterpart, and then reporting any invalid zip codes (US and Canadian).

# In[911]:


def clean_zip(v):
# Cleans up zip codes
    global invalid_zips
    if v != '':
        czip = v.replace('`', '1')
        # If it is not empty, not the US or Canadian ZIP code format then mark as invalid
        if not re.match("^\d{5}(?:[-]\w{4})?|^[A-Z][0-9][A-Z][0-9][A-Z][0-9]$",czip):
            return "INVALID"
        return czip
    else:
        return v
ccdf['czip'] = ccdf['zip'].apply(clean_zip)


# #### Clean Phone Number
#
# Clean up the phone number by ensuring it is a 10 digit number in the format of (xxx) xxx-xxxx

# In[912]:


# Retrieves any extra phone number notes
def get_phone_notes(v):
    cpnum = v.replace('*','').replace('  ', '').replace('(', '').replace(')', '').replace('-', '').replace('+1','').replace('`', '1').replace('+1', '1').replace('no phone number','')
    if len(cpnum) <= 0:
        return v
    # Removes country code or a leading space
    if cpnum[0]=="1" or cpnum[0] == " ":
        cpnum = cpnum[1:]
    if len(cpnum) == 10:
        v = ""
        return v
    else:
        notes_only = re.split(r'[\d]{3}[\s . , /]?[\d]{3}[\s . , /]?[\d]{4}[, / . \s]?', cpnum)
        if notes_only is not None and len(notes_only)>1:
            v = notes_only[1]
            return v
        v = ""
    return v

# Cleans up phone numbers, should be in (xxx) xxx-xxxx format
def clean_phone(v):
    global invalid_phones
    cpnum = v.replace('*','').replace('  ', '').replace('(', '').replace(')', '').replace('-', '').replace('+1','').replace('`', '1').replace('+1', '1').replace('no phone number','')

    if len(cpnum) <= 0:
        return ""
    if cpnum == 'no phone number':
        return ""

    # Removes country code or a leading space
    if cpnum[0]=="1" or cpnum[0] == " ":
        cpnum = cpnum[1:]

    # If the phone number doesn't match the US/Candadian phone number format
    if not re.match("[\d]{3}[\s . , /]?[\d]{3}[\s . , /]?[\d]{4}[, / . \s]?([\w\s]+)?",cpnum):
        return "INVALID"

    # If the number of digits is 10 (excluding space(s))
    # Previous regex should've caught all non phone numbers
    if len(cpnum) == 10:
        cpnum = cpnum.replace(" ",'')
        return "("+cpnum[:3]+")"+" "+cpnum[3:6]+"-"+cpnum[6:]
    else:
        number_only = re.match(r'[\d]{3}[\s . , /]?[\d]{3}[\s . , /]?[\d]{4}[, / . \s]?', cpnum)
        if number_only is not None:
            cpnum = number_only.group(0).replace(' ','').replace('/','').replace(',','').replace('.','')
            #cpnum = number_only[0].replace(' ','').replace('/','').replace(',','').replace('.','')
            return "("+cpnum[:3]+")"+" "+cpnum[3:6]+"-"+cpnum[6:11]
        else:
            return "INVALID"


ccdf['cphone'] = ccdf[r'phone'].apply(clean_phone)
ccdf['phone_notes'] = ccdf[r'phone'].apply(get_phone_notes)


# #### Clean e-mail
#
# Clean up the email be replacing common special characters. The regex for e-mail format is relativewly loose, as we could not account for all edge cases of emails.

# In[913]:


def clean_email(v):
# Cleans common email mistakes
    global invalid_emails
    if v != '':
        cemail = v.replace('/', '').replace(' ', '').replace('.con','.com')
        if not re.match("^$|(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)",cemail):
            v = "INVALID"
            return v
        v = cemail
    return v
ccdf['cemail'] = ccdf['email_id'].apply(clean_email)


# #### Dates
# Clean the expiration date by removing the 11:59 PM on certain records

# In[914]:


# Cleans up dates
def clean_Date(v):
    if (v!="" and v is not None):
        v = v.split()[0]
        date = v.split("/")
        if date[0] == "00" or date[0] == "0":
            date[0] = "01"
        if len(date[0]) == 1:
            date[0] = "0" + date[0]
        if date[1] == "00" or date[1] == "0":
            date[1] = "01"
        if len(date[1]) == 1:
            date[1] = "0" + date[1]
        if len(date[2])==2:
            if int(date[2])>20:
                date[2] = "19"+str(date[2])
            else:
                date[2] = "20"+str(date[2])
        if len(date[2])==1 or len(date[2])==3:
            return ''
        return str(date[2]+"/"+date[0]+"/"+date[1])
    else:
        return ''

ccdf['end_date'] = ccdf['end_date'].apply(clean_Date)
ccdf['start_date'] = ccdf['start_date'].apply(clean_Date)
ccdf['general_last_renewed'] = ccdf['general_last_renewed'].apply(clean_Date)
ccdf['green_last_renewed'] = ccdf['green_last_renewed'].apply(clean_Date)
ccdf['corporate_last_renewed'] = ccdf['corporate_last_renewed'].apply(clean_Date)
ccdf['garden_last_renewed'] = ccdf['garden_last_renewed'].apply(clean_Date)
ccdf['date_added'] = ccdf['date_added'].apply(clean_Date)
ccdf['dob'] = ccdf['dob'].apply(clean_Date)


# #### Do Not Email

# In[915]:


# Cleans up dates
def clean_dne(v):
    if (v==''):
        v = ''
    return v
ccdf['email_id'] = ccdf['email_id'].apply(clean_dne)


# #### Amount

# In[916]:


def clean_amount(v):
    if (v!=""):
        v = v[1:]
    return v


# ### 4) Applying the above cleaning modules to the databases

# In[917]:


# Dataframe containing incomplete names
incomplete_names = ccdf[(ccdf['cname']=="ONE WORD") & (ccdf['constituent_type']=='Individual')
                        | (ccdf['clname']=="BLANK") | (ccdf['clname']=="NO NAME")]

invalid_addresses_1 = ccdf[(ccdf['caddress_1']=="INVALID")
                           | ((ccdf['caddress_1']=='POTENTIAL INVALID')
                              & (ccdf['ccity'] != '') & (ccdf['cstate'] != '')
                              & (ccdf['czip'] != '') & (ccdf['ccountry'] != '' ))]
invalid_cities = ccdf[(ccdf['ccity']=="INVALID")]
invalid_states = ccdf[(ccdf['cstate']=="INVALID")]
invalid_zips = ccdf[(ccdf['czip']=="INVALID")]
invalid_countries = ccdf[(ccdf['ccountry']=="INVALID")]
invalid_phones = ccdf[(ccdf['cphone']=="INVALID")]
invalid_emails = ccdf[(ccdf['cemail']=="INVALID")]

# Removing any incomplete names from the final export
filterNames = incomplete_names['lookup_id'].tolist()
ccdf['x'] = ccdf['lookup_id'].apply(lambda v: v not in filterNames)
ccdf = ccdf[ccdf['x']]
ccdf['name'] = ccdf['cname']
ccdf['last_group'] = ccdf['clname']
ccdf.loc[ccdf.name=='ONE WORD', 'name'] = ccdf['last_group']

# Removing any invalid addresses from the final export
filterAddresses = invalid_addresses_1['lookup_id'].tolist()
ccdf['y'] = ccdf['lookup_id'].apply(lambda v: v not in filterAddresses)
ccdf = ccdf[ccdf['y']]
ccdf['address_1'] = ccdf['caddress_1']

# Removing any invalid cities from the final export
filterCities = invalid_cities['lookup_id'].tolist()
ccdf['z'] = ccdf['lookup_id'].apply(lambda v: v not in filterCities)
ccdf = ccdf[ccdf['z']]
ccdf['city'] = ccdf['ccity']

# Removing any invalid states from the final export
filterStates = invalid_states['lookup_id'].tolist()
ccdf['a'] = ccdf['lookup_id'].apply(lambda v: v not in filterStates)
ccdf = ccdf[ccdf['a']]
ccdf['state'] = ccdf['cstate']

# Removing any invalid zips from the final export
filterZips = invalid_zips['lookup_id'].tolist()
ccdf['b'] = ccdf['lookup_id'].apply(lambda v: v not in filterZips)
ccdf = ccdf[ccdf['b']]
ccdf['zip'] = ccdf['czip']

# Removing any invalid countries from the final export
filterCountries = invalid_zips['lookup_id'].tolist()
ccdf['c'] = ccdf['lookup_id'].apply(lambda v: v not in filterCountries)
ccdf = ccdf[ccdf['c']]
ccdf['country'] = ccdf['ccountry']

# Removing any invalid phones from the final export
filterPhones = invalid_phones['lookup_id'].tolist()
ccdf['d'] = ccdf['lookup_id'].apply(lambda v: v not in filterPhones)
ccdf = ccdf[ccdf['d']]
ccdf[r'phone'] = ccdf['cphone']

# Removing any invalid emails from the final export
filterEmails = invalid_emails['lookup_id'].tolist()
ccdf['e'] = ccdf['lookup_id'].apply(lambda v: v not in filterEmails)
ccdf = ccdf[ccdf['e']]
ccdf[r'email_id'] = ccdf['cemail']


# ## 4) Seperating data into ERD tables

# #### Creating constituent

# In[918]:


constituent = ccdf.copy()
constituent.drop(constituent.iloc[:, 30:], axis=1,inplace=True)
constituent.drop(constituent.iloc[:, 10:29], axis=1,inplace=True)

columns = ['lookup_id','suffix','title','name',
           'last_group','email_id','phone','dob',
           'do_not_email','constituent_type','phone_notes']
constituent = constituent[columns]
constituent.loc[constituent.name == 'Mary C Mccormick', 'lookup_id'] = "0001" # hardcoded to avoid conflict
constituent = constituent.drop_duplicates('lookup_id')




# Stripping off any extra white space
constituent['lookup_id'] = constituent['lookup_id'].str.strip().str.lstrip()
constituent['suffix'] = constituent['suffix'].str.strip().str.lstrip()
constituent['title'] = constituent['title'].str.strip().str.lstrip()
constituent['name'] = constituent['name'].str.strip().str.lstrip()
constituent['last_group'] = constituent['last_group'].str.strip().str.lstrip()
constituent['email_id'] = constituent['email_id'].str.strip().str.lstrip()
constituent['phone'] = constituent['phone'].str.strip().str.lstrip()
constituent['dob'] = constituent['dob'].str.strip().str.lstrip()
constituent['constituent_type'] = constituent['constituent_type'].str.strip().str.lstrip()
constituent['phone_notes'] = constituent['phone_notes'].str.strip().str.lstrip()


# #### Creating address

# In[919]:


address = ccdf.copy()
address.drop(address.iloc[:, 1:10], axis=1,inplace=True)
address.drop(address.iloc[:, 8:], axis=1,inplace=True)
# Stripping off any extra white space
address['lookup_id'] = address['lookup_id'].str.strip().str.lstrip()
address['address_1'] = address['address_1'].str.strip().str.lstrip()
address['city'] = address['city'].str.strip().str.lstrip()
address['state'] = address['state'].str.strip().str.lstrip()
address['zip'] = address['zip'].str.strip().str.lstrip()
address['country'] = address['country'].str.strip().str.lstrip()
address['address_type'] = address['address_type'].str.strip().str.lstrip()
address['date_added'] = address['date_added'].str.strip().str.lstrip()

# The last two steps
address = address[(address['address_1']!='')]
address = address.drop_duplicates('address_1')


# #### Creating membership_record

# In[920]:


# Copy cdf and make some modifications based on ERD
mdf = ccdf.copy()
# Drop cleaned-up fields from above
mdf.drop(mdf.iloc[:,29:], axis=1, inplace=True)
mdf.drop(mdf.iloc[:,1:17], axis=1, inplace=True)

# Split membership data into sub groups based on program
phipps_general = mdf.loc[mdf["membership_scheme"]=='Phipps General Membership'].copy()
phipps_corporate = mdf.loc[mdf["membership_scheme"]=='Phipps Corporate Partnership'].copy()
green_mountain = mdf.loc[mdf["membership_scheme"]=='Green Mountain Membership'].copy()
garden_club = mdf.loc[mdf["membership_scheme"]=='Garden Club Membership'].copy()
obsolete = mdf.loc[(mdf["membership_scheme"]!='Phipps General Membership') &
               (mdf["membership_scheme"]!='Phipps Corporate Partnership') &
               (mdf["membership_scheme"]!='Green Mountain Membership') &
               (mdf["membership_scheme"]!='Garden Club Membership') &
               (mdf["membership_scheme"]!='')].copy()

#Drop unnecessary records pertaining to other membership program renewal dates
phipps_general.drop(phipps_general.iloc[:, 8:11], axis=1, inplace=True)
phipps_corporate.drop(phipps_corporate.iloc[:, 10:11], axis=1, inplace=True)
phipps_corporate.drop(phipps_corporate.iloc[:, 7:8], axis=1, inplace=True) # Phipps Corporate has only 1 record
green_mountain.drop(green_mountain.iloc[:, 9:11], axis=1, inplace=True)
green_mountain.drop(green_mountain.iloc[:, 7:8], axis=1, inplace=True)
obsolete.drop(obsolete.iloc[:,8:11], axis=1, inplace=True)
phipps_general = phipps_general.rename(columns={'general_last_renewed': 'last_renewed'})
phipps_corporate = phipps_corporate.rename(columns={'corporate_last_renewed': 'last_renewed'})
green_mountain = green_mountain.rename(columns={'green_last_renewed': 'last_renewed'})
garden_club = garden_club.rename(columns={'garden_last_renewed': 'last_renewed'})
obsolete = obsolete.rename(columns={'general_last_renewed': 'last_renewed'})
columns = ['lookup_id','membership_id', 'membership_scheme', 'membership_level',
           'add_ons', 'membership_level_type', 'membership_status',
           'start_date','end_date', 'last_renewed']
phipps_general = phipps_general[columns]

phipps_corporate = phipps_corporate[columns]
green_mountain = green_mountain[columns]
garden_club = garden_club[columns]
obsolete = obsolete[columns]

# Combining all membership types together
membership_record_all = pd.concat([phipps_general,phipps_corporate,green_mountain,garden_club],ignore_index=True)
# Dropping duplicates in membership records
membership_record = membership_record_all.drop_duplicates('membership_id').copy()

# Stripping off any extra white space
membership_record['membership_id'] = membership_record['membership_id'].str.strip().str.lstrip()
membership_record['membership_scheme'] = membership_record['membership_scheme'].str.strip().str.lstrip()
membership_record['membership_level'] = membership_record['membership_level'].str.strip().str.lstrip()
membership_record['add_ons'] = membership_record['add_ons'].str.strip().str.lstrip()
membership_record['membership_level_type'] = membership_record['membership_level_type'].str.strip().str.lstrip()
membership_record['membership_status'] = membership_record['membership_status'].str.strip().str.lstrip()
membership_record['start_date'] = membership_record['start_date'].str.strip().str.lstrip()
membership_record['end_date'] = membership_record['end_date'].str.strip().str.lstrip()
membership_record['last_renewed'] = membership_record['last_renewed'].str.strip().str.lstrip()


# #### Creating constituent_membership_record

# In[921]:


constituent_membership_record = membership_record_all.drop(membership_record_all.iloc[:, 2:10],axis=1)
constituent_membership_record = constituent_membership_record.drop_duplicates()
constituent_membership_record['lookup_id'] = constituent_membership_record['lookup_id'].str.strip().str.lstrip()
constituent_membership_record['membership_id'] = constituent_membership_record['membership_id'].str.strip().str.lstrip()


# #### Creating constituent_event

# In[922]:


edf.drop(edf.iloc[:, 0:1], axis=1,inplace=True)
edf.columns = ['lookup_id','event_name','event_id','status','attend','start_date_time', 'end_date_time']
columns = ['lookup_id','event_id','status','attend','event_name','start_date_time','end_date_time']
edf = edf[columns]
constituent_event = edf.iloc[:,0:4]
constituent_event = constituent_event.drop_duplicates()

constituent_event['lookup_id'] = constituent_event['lookup_id'].str.strip().str.lstrip()
constituent_event['event_id'] = constituent_event['event_id'].str.strip().str.lstrip()
constituent_event['status'] = constituent_event['status'].str.strip().str.lstrip()
constituent_event['attend'] = constituent_event['attend'].str.strip().str.lstrip()


# #### Creating event

# In[923]:


event = edf.iloc[:,1:2].join(edf.iloc[:,4:7])
event = event[['event_id','event_name','start_date_time','end_date_time']]
event = event[event['event_id']!=""]
event = event.drop_duplicates()
event['start_date_time'] = event['end_date_time'].apply(clean_Date)
event['end_date_time'] = event['end_date_time'].apply(clean_Date)


event['event_id'] = event['event_id'].str.strip().str.lstrip()
event['event_name'] = event['event_name'].str.strip().str.lstrip()
event['start_date_time'] = event['start_date_time'].str.strip().str.lstrip()
event['end_date_time'] = event['end_date_time'].str.strip().str.lstrip()


# #### Creating contact_history

# In[924]:


contact_history = chdf.iloc[:,1:].copy()
contact_history = contact_history.drop(columns=['Name'])
contact_history.columns = ['lookup_id','contact_type','date']
contact_history['date'] = contact_history['date'].apply(clean_Date)
contact_history = contact_history[contact_history['contact_type']!='']
contact_history = contact_history[contact_history['date']!='']
contact_history = contact_history.drop_duplicates()

# Approx 9862 duplicate contact_history; may be due to multiple mails/emails on the same day
contact_history['lookup_id'] = contact_history['lookup_id'].str.strip().str.lstrip()
contact_history['contact_type'] = contact_history['contact_type'].str.strip().str.lstrip()
contact_history['date'] = contact_history['date'].str.strip().str.lstrip()


# #### Creating donation_history

# In[925]:


dddf = ddf.iloc[:,1:].copy()
columns =  ['donation_history_id', 'lookup_id','amount','date','payment_method',
            'given_anonymously', 'do_not_acknowledge', 'donation_program_id','program',
            'donation_method','transaction_type']
dddf.columns = columns
dddf.loc[dddf.lookup_id == '', 'lookup_id'] = "anonymous"
dddf = dddf[dddf['lookup_id']!=""] #just in case
dddf = dddf[dddf['program']!=""]
columns =  ['donation_history_id', 'donation_program_id','lookup_id','amount','date','payment_method',
            'given_anonymously', 'do_not_acknowledge', 'transaction_type','program',
            'donation_method']
dddf = dddf[columns]
donation_history = dddf.iloc[:,0:9].copy()



donation_history['date']=donation_history['date'].apply(clean_Date)
donation_history['amount']=donation_history['amount'].apply(clean_amount)
#donation_history = donation_history.drop_duplicates()

donation_history['donation_history_id'] = donation_history['donation_history_id'].str.strip().str.lstrip()
donation_history['donation_program_id'] = donation_history['donation_program_id'].str.strip().str.lstrip()
donation_history['lookup_id'] = donation_history['lookup_id'].str.strip().str.lstrip()
donation_history['amount'] = donation_history['amount'].str.strip().str.lstrip()
donation_history['date'] = donation_history['date'].str.strip().str.lstrip()
donation_history['payment_method'] = donation_history['payment_method'].str.strip().str.lstrip()
donation_history['given_anonymously'] = donation_history['given_anonymously'].str.strip().str.lstrip()
donation_history['do_not_acknowledge'] = donation_history['do_not_acknowledge'].str.strip().str.lstrip()
donation_history['transaction_type'] = donation_history['transaction_type'].str.strip().str.lstrip()


# #### Creating donation_program

# In[926]:


donation_program = dddf.iloc[:,1:2].join(dddf.iloc[:,9:10])
# I dropped any records whose program name is not specified; maybe later can change this to a default value
donation_program = donation_program[donation_program['program']!=""]
donation_program = donation_program.drop_duplicates()

def clean_program_name(v):
    full_name = v.split(" \ ")
    return full_name[len(full_name)-1]
donation_program['program'] = donation_program['program'].apply(clean_program_name)

donation_program['donation_program_id'] = donation_program['donation_program_id'].str.strip().str.lstrip()
donation_program['program'] = donation_program['program'].str.strip().str.lstrip()


# ### 5) Reporting potential dupliates

# In[927]:
print ("Reached line 744, just before duplicate algorithm.")

# Needed imports:
from Levenshtein import *
# Looks like it's working, but still slow
def get_closest_match(x, y, df_choices,fun,index):
    # fun: the matching method : ratio, wrinkler, ... (cf python-Levenshtein module)
    list_strings = df_choices['name'].tolist()
    list_lookupIDs = df_choices['lookup_id'].tolist()
    list_compare = df_choices[df_choices.columns[index]].tolist()
    best_match = None
    highest_ratio = 0
    best_match_id = 0
    for i in range(0,len(list_strings)):
        if y == list_compare[i]:
            current_string = list_strings[i]
            if highest_ratio != 1:
                current_score = fun(x, current_string)
                if (current_score > highest_ratio):
                    highest_ratio = current_score
                    best_match = current_string
                    best_match_id = list_lookupIDs[i]
    return (best_match,highest_ratio,best_match_id)

# the function that matches 2 dataframes (only the idea behind, since too long to write everything
#dicto={'Index':[],'score':[], ...}
def LevRatioMerge(df1,fun,index):
    global duplicate_names
    global choices
    # Basically loop over df1 with:
    for r in df1.itertuples():
        choices = choices[choices['lookup_id'] != r[1]]
        result = get_closest_match(r[4],r[index+1],choices,fun,index)
        if result[1] > 0.93:
            if r[1] in duplicate_names:
                duplicate_names[r[1]].append(result[2])
            else:
                duplicate_names[r[1]] = [result[2]]
            if result[2] in duplicate_names:
                duplicate_names[result[2]].append(r[1])
            else:
                duplicate_names[result[2]] = [r[1]]
            #print(r[1],result[2],r[4],result[0],r[index])


# In[928]:


duplicate_names = {}
dup_ind_mr = ccdf[(ccdf['constituent_type']=='Individual') & ((ccdf['title'] == 'Mr.') | (ccdf['title'] == ''))].drop_duplicates('lookup_id')

dup_ind_mr_email = dup_ind_mr[dup_ind_mr['email_id'] != '']
dup_ind_mr_email = dup_ind_mr_email[dup_ind_mr_email['email_id'].duplicated(keep = False)]
dup_ind_mr_phone = dup_ind_mr[dup_ind_mr[r'phone'] != '']
dup_ind_mr_phone = dup_ind_mr_phone[dup_ind_mr_phone[r'phone'].duplicated(keep = False)]
dup_ind_mr_address = dup_ind_mr[dup_ind_mr['address_1'] != '']
dup_ind_mr_address = dup_ind_mr_address[dup_ind_mr_address['address_1'].duplicated(keep = False)]

pot_dup = dup_ind_mr_email.sort_values(by=['name'])
choices = pot_dup.copy()
LevRatioMerge(pot_dup,ratio,9)

pot_dup = dup_ind_mr_phone.sort_values(by=['name'])
choices = pot_dup.copy()
LevRatioMerge(pot_dup,ratio,6)

pot_dup = dup_ind_mr_address.sort_values(by=['name'])
choices = pot_dup.copy()
LevRatioMerge(pot_dup,ratio,10)

dup_ind_mrs = ccdf[(ccdf['constituent_type']=='Individual') & ((ccdf['title'] == 'Mrs.') | (ccdf['title'] == ''))].drop_duplicates('lookup_id')

dup_ind_mrs_email = dup_ind_mrs[dup_ind_mrs['email_id'] != '']
dup_ind_mrs_email = dup_ind_mrs_email[dup_ind_mrs_email['email_id'].duplicated(keep = False)]
dup_ind_mrs_phone = dup_ind_mrs[dup_ind_mrs[r'phone'] != '']
dup_ind_mrs_phone = dup_ind_mrs_phone[dup_ind_mrs_phone[r'phone'].duplicated(keep = False)]
dup_ind_mrs_address = dup_ind_mrs[dup_ind_mrs['address_1'] != '']
dup_ind_mrs_address = dup_ind_mrs_address[dup_ind_mrs_address['address_1'].duplicated(keep = False)]

pot_dup = dup_ind_mrs_email.sort_values(by=['name'])
choices = pot_dup.copy()
LevRatioMerge(pot_dup,ratio,9)

pot_dup = dup_ind_mrs_phone.sort_values(by=['name'])
choices = pot_dup.copy()
LevRatioMerge(pot_dup,ratio,6)

pot_dup = dup_ind_mrs_address.sort_values(by=['name'])
choices = pot_dup.copy()
LevRatioMerge(pot_dup,ratio,10)

dup_organization = ccdf[ccdf['constituent_type']=='Organization'].drop_duplicates('lookup_id')

dup_organization_email = dup_organization[dup_organization['email_id'] != '']
dup_organization_email = dup_organization_email[dup_organization_email['email_id'].duplicated(keep = False)]
dup_organization_phone = dup_organization[dup_organization[r'phone'] != '']
dup_organization_phone = dup_organization_phone[dup_organization_phone[r'phone'].duplicated(keep = False)]
dup_organization_address = dup_organization[dup_organization['address_1'] != '']
dup_organization_address = dup_organization_address[dup_organization_address['address_1'].duplicated(keep = False)]

pot_dup = dup_organization_email.sort_values(by=['name'])
choices = pot_dup.copy()
LevRatioMerge(pot_dup,ratio,9)

pot_dup = dup_organization_phone.sort_values(by=['name'])
choices = pot_dup.copy()
LevRatioMerge(pot_dup,ratio,6)

pot_dup = dup_organization_address.sort_values(by=['name'])
choices = pot_dup.copy()
LevRatioMerge(pot_dup,ratio,10)

dup_house = ccdf[ccdf['constituent_type']=='Household'].drop_duplicates('lookup_id')

dup_house_email = dup_house[dup_house['email_id'] != '']
dup_house_email = dup_house_email[dup_house_email['email_id'].duplicated(keep = False)]
dup_house_phone = dup_house[dup_house[r'phone'] != '']
dup_house_phone = dup_house_phone[dup_house_phone[r'phone'].duplicated(keep = False)]
dup_house_address = dup_house[dup_house['address_1'] != '']
dup_house_address = dup_house_address[dup_house_address['address_1'].duplicated(keep = False)]

pot_dup = dup_house_email.sort_values(by=['name'])
choices = pot_dup.copy()
LevRatioMerge(pot_dup,ratio,9)

pot_dup = dup_house_phone.sort_values(by=['name'])
choices = pot_dup.copy()
LevRatioMerge(pot_dup,ratio,6)

pot_dup = dup_house_address.sort_values(by=['name'])
choices = pot_dup.copy()
LevRatioMerge(pot_dup,ratio,10)

for key in duplicate_names:
    duplicate_names[key] = list(set(duplicate_names[key]))


# #### Creating incomplete_records, incomplete_names, invalid_zips, invalid_phones, invalid_emails, and dupliate records

# In[929]:

print ("Reached line 885, just after duplicate algorithm.")
# Creating a df that houses all duplicates
final_duplicate = ccdf.copy()

final_duplicate['duplicate_lookup_ids'] = ''
for key in duplicate_names:
    final_duplicate.loc[final_duplicate['lookup_id'] == key, 'duplicate_lookup_ids'] = '.'.join(duplicate_names[key])
final_duplicate = final_duplicate[final_duplicate['duplicate_lookup_ids'] !='']
final_duplicate = final_duplicate.drop_duplicates('lookup_id')
final_duplicate.drop(final_duplicate.iloc[:,17:-1], axis=1,inplace=True)
final_duplicate['duplicate'] = True

# Creating a df of records with no contact (as in, no addr, email or phone)
no_contact.drop(no_contact.iloc[:,-13:], axis=1,inplace=True)
no_contact['no_contact'] = True
no_contact = no_contact[no_contact['lookup_id']!='anonymous']
no_contact['phone_notes'] = ''

# Creating a df of records with incomplete names
incomplete_names.drop(incomplete_names.iloc[:,-19:], axis=1,inplace=True)
incomplete_names['incomplete_names'] = True

# Creating a df of records with invalid addresses
invalid_addresses_1.drop(invalid_addresses_1.iloc[:,-19:], axis=1,inplace=True)
invalid_addresses_1['incomplete_addresses_1'] = True

# Creating a df of records with invalid cities
invalid_cities.drop(invalid_cities.iloc[:,-19:], axis=1,inplace=True)
invalid_cities['incomplete_cities'] = True

# Creating a df of records with invalid states
invalid_states.drop(invalid_states.iloc[:,-19:], axis=1,inplace=True)
invalid_states['incomplete_states'] = True

# Creating a df of records with invalid zips
invalid_zips.drop(invalid_zips.iloc[:,-19:], axis=1,inplace=True)
invalid_zips['invalid_zips'] = True

# Creating a df of records with invalid countries
invalid_country.drop(invalid_country.iloc[:,-19:], axis=1,inplace=True)
invalid_country['incomplete_countries'] = True

# Creating a df of records with invalid phones
invalid_phones.drop(invalid_phones.iloc[:,-19:], axis=1,inplace=True)
invalid_phones['invalid_phones'] = True

# Creating a df of records with invalid emails
invalid_emails.drop(invalid_emails.iloc[:,-19:], axis=1,inplace=True)
invalid_emails['invalid_emails'] = True

incomplete_invalid = no_contact.append([incomplete_names,invalid_phones,
                                        invalid_emails,final_duplicate,
                                        invalid_cities, invalid_states,
                                        invalid_zips,invalid_country,invalid_addresses_1])
columns = ['lookup_id','address_1','city','state','zip','country',
           'address_type', 'date_added', 'incomplete_addresses_1', 'incomplete_cities', 'incomplete_states',
           'incomplete_countries','invalid_zips', 'suffix','title', 'name', 'last_group', 'email_id','phone',
           'dob','do_not_email','duplicate','constituent_type','phone_notes', 'incomplete_names',
           'invalid_emails', 'invalid_phones', 'no_contact','duplicate_lookup_ids', 'membership_id',
           'membership_level','membership_level_type']
incomplete_invalid = incomplete_invalid[columns]
columns = ['lookup_id','address_1','city','state','zip','country',
           'address_type', 'date_added', 'invalid_address_1', 'invalid_cities', 'invalid_states',
           'invalid_countries','invalid_zips', 'suffix','title', 'name', 'last_group', 'email_id','phone',
           'dob','do_not_email','duplicate','constituent_type','phone_notes', 'incomplete_names',
           'invalid_emails', 'invalid_phones', 'no_contact','duplicate_lookup_ids', 'membership_id',
           'membership_level','membership_level_type']
incomplete_invalid.columns = columns
incomplete_invalid_address = incomplete_invalid.copy()
incomplete_invalid_address.drop(incomplete_invalid_address.iloc[:,13:],axis=1,inplace=True)
incomplete_invalid_address['invalid_address_1'] = incomplete_invalid_address['invalid_address_1'].fillna(value='')
incomplete_invalid_address['invalid_cities'] = incomplete_invalid_address['invalid_cities'].fillna(value='')
incomplete_invalid_address['invalid_states'] = incomplete_invalid_address['invalid_states'].fillna(value='')
incomplete_invalid_address['invalid_countries'] = incomplete_invalid_address['invalid_countries'].fillna(value='')
incomplete_invalid_address['invalid_zips'] = incomplete_invalid_address['invalid_zips'].fillna(value='')



incomplete_invalid_constituent = incomplete_invalid.copy()
incomplete_invalid_constituent.drop(incomplete_invalid_constituent.iloc[:,29:],axis=1,inplace=True)
incomplete_invalid_constituent.drop(incomplete_invalid_constituent.iloc[:,1:13],axis=1,inplace=True)
incomplete_invalid_constituent['incomplete_names'] = incomplete_invalid_constituent['incomplete_names'].fillna(value='')
incomplete_invalid_constituent['invalid_emails'] = incomplete_invalid_constituent['invalid_emails'].fillna(value='')
incomplete_invalid_constituent['invalid_phones'] = incomplete_invalid_constituent['invalid_phones'].fillna(value='')
incomplete_invalid_constituent['no_contact'] = incomplete_invalid_constituent['no_contact'].fillna(value='')
incomplete_invalid_constituent['duplicate'] = incomplete_invalid_constituent['duplicate'].fillna(value='')
incomplete_invalid_constituent['duplicate_lookup_ids'] = incomplete_invalid_constituent['duplicate_lookup_ids'].fillna(value='')

print ("Reached line 973, just before exports.")
# ### 5) Exporting into final databases for ERD

# In[930]:

constituent_membership_record.to_csv('public/'+'constituent_membership_record.csv', index=False)
constituent.to_csv('public/'+'constituent.csv', index=False)
address.to_csv('public/'+'address.csv', index=False, date_format='%Y/%m/%d')
membership_record.to_csv('public/'+'membership_record.csv', index=False)
contact_history.to_csv('public/'+'contact_history.csv', index=False)
donation_history.to_csv('public/'+'donation_history.csv', index=False)
donation_program.to_csv('public/'+'donation_program.csv', index=False)
constituent_event.to_csv('public/'+'constituent_event.csv', index=False)
event.to_csv('public/'+'event.csv', index=False)
incomplete_invalid_address.to_csv('public/'+'incomplete_invalid_address.csv', index=False)
incomplete_invalid_constituent.to_csv('public/'+'incomplete_invalid_constituent.csv', index=False)

print ("Reached line 990, just after exports.")
