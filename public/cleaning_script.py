# coding: utf-8

# # Phipps Conservatory Membership Database Cleaning Script
# ### Team members: Ashvin Niruttan, George Yao, Minnie Wu
# ### Last updated: April 12th, 2018

# ### Libraries

# In[815]:


import csv
import pandas as pd
import re
import numpy as np3

from fuzzywuzzy import fuzz
from fuzzywuzzy import process
from pandas_schema import Column, Schema
from pandas_schema.validation import *


# ### Read CSV files

# In[816]:


# Read csv files and place into dataframes
# Constituent Records + Membership Records
cdf = pd.read_csv('public/CMU Team Constituents Export.csv',dtype="str",na_filter=False)
# Donation Records
ddf = pd.read_csv('public/CMU Team Donations Export.csv',dtype="str",na_filter=False)
# Event + Event Attendance Records
edf = pd.read_csv('public/CMU Team Event Attendance Export.csv',dtype="str",na_filter=False)
# Contact History Records
chdf = pd.read_csv('public/CMU Team Contact History Export.csv',dtype="str",na_filter=False)


# In[817]:

# ### Quick look at Database downloads

# #### Constituent/membership Database

# In[818]:


cdf.head(1)


# #### Donation Database

# In[819]:


ddf.head(1)


# #### Event Database

# In[820]:


edf.head(1)


# In[821]:


chdf.head(1)


# ### Additional Dataframes (Global variables)

# In[822]:


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
invalid_zips = pd.DataFrame() # ZIP code not abiding to US/Canadian format
invalid_phones = pd.DataFrame() # Phone number not biding to US/Canadian format
invalid_emails = pd.DataFrame() # Simple e-mail checker for validations
duplicate_records = pd.DataFrame() # ZIP code not abiding to US/Canadian format


# ## 1) Setting up initial database for constituent, address, and membership

# In[823]:


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

# In[824]:


no_contact = ccdf[
    ((ccdf["email_id"] == '') & (ccdf["address_1"] == '')
    & (ccdf[r"phone"] == ''))]

ccdf = ccdf[((ccdf["email_id"] != '') | (ccdf["address_1"] != '')
                                     | (ccdf[r"phone"] != ''))]


# ## 3) Apply cleaning modules

# #### Clean name
#
# Clean the name by capitalizing each part of the name, and remove common invalid characters or phrases

# In[825]:


# Cleans up Name
def clean_name(v):
    cName = v.replace('""','').replace('?','').replace("(no last name given)",'')
    cName = cName.replace("  ",' ').replace('.','').replace('~','').replace("<None Specified>",'')
    cName = cName.replace("UNKNOWN",'')
    if cName != '':
        if any(char.isdigit() for char in cName):
            return "NO NAME"

        cName = cName.title()
        if len(cName.split(' ')) == 1:
            return "ONE WORD"
        return cName
    else:
        return "NO NAME"
ccdf['cname'] = ccdf['name'].apply(clean_name)


# #### Clean Last Name/Organization name
#
# Clean the last name, or the organization's name by capitalizing each part of the name, and removing common special characters

# In[826]:


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

# In[827]:


# Cleans up address
def clean_address(v):
    cadd = v.title()
    if v != '':
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
ccdf['address_1'] = ccdf['address_1'].apply(clean_address)


# In[828]:


''.title()


# #### Clean City
#
# Clean up the city name by simply capitalizing the name.

# In[829]:


# Capitalize City name
def clean_city(v):
    v = v.title()
    if v != '':
        return v.replace('`','')
    if v.isdigit():
        return 'INVALID'
    return v
ccdf['ccity'] = ccdf['city'].apply(clean_city)


# #### Clean State
#
# Cleans up state by replacing any abreviations for US states with the full name.

# In[830]:


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
        'ON': 'Ontario', 'AB': 'Alberta', 'District of Columbia': 'District of Columbia'
}

def clean_state(v):
    if v != '':
        if v in states:
            return states[v]
        return v.title()
    else:
        return ''

# Due to the large number of states that come from international places, this simply cleans up and capitalizes
# given state data, and tries to give the full state address
ccdf['state'] = ccdf['state'].apply(clean_state)



# #### Clean country
#
# Clean up the country name by simply capitalizing the name.

# In[831]:


# Capitalize Country name
def clean_country(v):
    if v != '':
        return v.title()
    else:
        return ''
ccdf['country'] = ccdf['country'].apply(clean_country)


# #### Clean ZIP code
#
# Clean up the zip code by replacing common special characters with their counterpart, and then reporting any invalid zip codes (US and Canadian).

# In[832]:


def clean_zip(v):
# Cleans up zip codes
    global invalid_zips
    if v != '':
        czip = v.replace('`', '1').replace(' ','')
        # If it is not empty, not the US or Canadian ZIP code format then mark as invalid
        if not re.match("^\d{5}(?:[-]\w{4})?|^[A-Z][0-9][A-Z][0-9][A-Z][0-9]$",czip):
            return "INVALID"
        return czip
    else:
        return ''
ccdf['czip'] = ccdf['zip'].apply(clean_zip)


# #### Clean Phone Number
#
# Clean up the phone number by ensuring it is a 10 digit number in the format of (xxx) xxx-xxxx

# In[833]:


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
            cpnum = number_only[0].replace(' ','').replace('/','').replace(',','').replace('.','')
            return "("+cpnum[:3]+")"+" "+cpnum[3:6]+"-"+cpnum[6:11]
        else:
            return "INVALID"


ccdf['cphone'] = ccdf[r'phone'].apply(clean_phone)
ccdf['phone_notes'] = ccdf[r'phone'].apply(get_phone_notes)


# #### Clean e-mail
#
# Clean up the email be replacing common special characters. The regex for e-mail format is relativewly loose, as we could not account for all edge cases of emails.

# In[834]:


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

# In[835]:


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
            if int(date[2])>20: # assuming you are not born prior to 1920
                date[2] = "19"+str(date[2])
            else:
                date[2] = "20"+str(date[2])
        if len(date[2])==1 or len(date[2])==3:
            return ''
        return str(date[2]+"/"+date[0]+"/"+date[1])
    else:
        return ''
def clean_dob(v):
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
            if int(date[2])>20: # assuming you are not born prior to 1920
                date[2] = "19"+str(date[2])
            else:
                date[2] = "20"+str(date[2])
        if len(date[2])==1 or len(date[2])==3: # bith year is 0 wtf?
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
ccdf['dob'] = ccdf['dob'].apply(clean_dob)
# #### Do Not Email

# In[836]:


# Cleans up dates
def clean_dne(v):
    if (v==''):
        v = False
    return v
ccdf['email_id'] = ccdf['email_id'].apply(clean_dne)


# #### Amount

# In[837]:


def clean_amount(v):
    if (v!=""):
        v = v[1:]
    return v


# ### 4) Applying the above cleaning modules to the databases

# In[838]:


# Dataframe containing incomplete names
incomplete_names = ccdf[(ccdf['cname']=="ONE WORD") & (ccdf['constituent_type']=='Individual')
                        | (ccdf['clname']=="BLANK") | (ccdf['clname']=="NO NAME")]
invalid_zips = ccdf[(ccdf['czip']=="INVALID")]
invalid_phones = ccdf[(ccdf['cphone']=="INVALID")]
invalid_emails = ccdf[(ccdf['cemail']=="INVALID")]
ccdf['city'] = ccdf['ccity']


# Removing any incomplete names from the final export
filterNames = incomplete_names['lookup_id'].tolist()
ccdf['x'] = ccdf['lookup_id'].apply(lambda v: v not in filterNames)
ccdf = ccdf[ccdf['x']]
ccdf['name'] = ccdf['cname']
ccdf['last_group'] = ccdf['clname']
ccdf.loc[ccdf.name=='ONE WORD', 'name'] = ccdf['last_group']


# Removing any invalid zips from the final export
filterZips = invalid_zips['lookup_id'].tolist()
ccdf['y'] = ccdf['lookup_id'].apply(lambda v: v not in filterZips)
ccdf = ccdf[ccdf['y']]
ccdf['zip'] = ccdf['czip']

# Removing any invalid phones from the final export
filterPhones = invalid_phones['lookup_id'].tolist()
ccdf['a'] = ccdf['lookup_id'].apply(lambda v: v not in filterPhones)
ccdf = ccdf[ccdf['a']]
ccdf[r'phone'] = ccdf['cphone']

# Removing any invalid emails from the final export
filterEmails = invalid_emails['lookup_id'].tolist()
ccdf['b'] = ccdf['lookup_id'].apply(lambda v: v not in filterEmails)
ccdf = ccdf[ccdf['b']]
ccdf[r'email_id'] = ccdf['cemail']


# ### 5) Reporting potential dupliates

# In[839]:


# a = ccdf[ccdf['email_id'] != '']
# a = a[a['email_id'].duplicated(keep = False)]
# a = a.groupby([r'email_id','title','constituent_type']).size().reset_index(name='Size')

# b = ccdf[ccdf[r'phone'] != '']
# b = b[b[r'phone'].duplicated(keep= False)]
# b = b.groupby([r'phone','title','constituent_type']).size().reset_index(name='Size')

# c = ccdf[ccdf[r'address_1'] != '']
# c = c[c[r'address_1'].duplicated(keep= False)]
# c = c.groupby([r'address_1','title','constituent_type']).size().reset_index(name='Size')

# dup_emails = a['email_id'].tolist()
# dup_phones = b[r'phone'].tolist()
# dup_address = c['address_1'].tolist()


# In[840]:


# potential_duplicates = ccdf.copy()
# potential_duplicates['dup_email'] = potential_duplicates['email_id'].apply(lambda v: v not in dup_emails)
# potential_duplicates = potential_duplicates[potential_duplicates['dup_email']]


# In[841]:


# a = ccdf[ccdf['email_id'] != '']
# a = a[a['email_id'].duplicated(keep = False)]
# a = a.groupby([r'email_id','title','constituent_type']).size().reset_index(name='Size')

# b = ccdf[ccdf[r'phone'] != '']
# b = b[b[r'phone'].duplicated(keep= False)]
# b = b.groupby([r'phone','title','constituent_type']).size().reset_index(name='Size')

# c = ccdf[ccdf[r'address_1'] != '']
# c = c[c[r'address_1'].duplicated(keep= False)]
# c = c.groupby([r'address_1','title','constituent_type']).size().reset_index(name='Size')

# dup_emails = a['email_id'].tolist()
# dup_phones = b[r'phone'].tolist()
# dup_address = c['address_1'].tolist()


# ccdf['y'] = ccdf['lookup_id'].apply(lambda v: v not in filterZips)
# ccdf = ccdf[ccdf['lookup_id'].apply(lambda v: v not in filterZips)]
# ccdf['zip'] = ccdf['czip']

# potential_duplicates = ccdf[ccdf['email_id'] ]


# potential_duplicates = pd.concat([a,b,c]).drop_duplicates().drop_duplicates('lookup_id').reset_index(drop=True)
# potential_duplicates = potential_duplicates.sort_values(by=r'name')
# potential_duplicates.drop(potential_duplicates.iloc[:, 3:5], axis=1,inplace=True)
# potential_duplicates.drop(potential_duplicates.iloc[:, 9:], axis=1,inplace=True)
# potential_duplicates.drop(potential_duplicates.iloc[:, 6:7], axis=1,inplace=True)


# In[842]:


# Needed imports:
from Levenshtein import *
# Looks like it's working, but still slow
def get_closest_match(x, list_strings,fun):
    # fun: the matching method : ratio, wrinkler, ... (cf python-Levenshtein module)
    best_match = None
    highest_ratio = 0
    for current_string in list_strings:
        if highest_ratio!=1:
            current_score = fun(x, current_string)
            if(current_score > highest_ratio):
                highest_ratio = current_score
                best_match = current_string
    #print (x,best_match,highest_ratio)
    return (best_match,highest_ratio)

# the function that matches 2 dataframes (only the idea behind, since too long to write everything
#dicto={'Index':[],'score':[], ...}
def LevRatioMerge(df1,fun):
    global duplicate_names
    global choices
    # Basically loop over df1 with:
    for r in df1.itertuples():
        choices = choices[choices['lookup_id'] != r[1]]
        result=get_closest_match(r[4],choices['name'].tolist(),fun)
        if result[1] > 0.93:
            if(r[4]=='David and Penney Miller'):
                print(result[0])
            duplicate_names.append(r[4])
            duplicate_names.append(result[0])


# In[843]:


# # Constituent has 92866 potential duplicate records
# duplicate_names = []
# test = potential_duplicates
# test = test.head(1000) # 10000 takes 1:27 sec; 20000 takes 5:57 secs; 50,000 38:23s
# test = test.sort_values(by=['name'])
# choices = test.copy()
# LevRatioMerge(test,ratio)
# dupdf = ccdf[ccdf['name'].apply(lambda v: v in duplicate_names)]
# dupdf = dupdf.drop_duplicates('lookup_id')
# ccdf = ccdf[ccdf['name'].apply(lambda v: v not in duplicate_names)].copy()
# #duplicate_names


# ## 4) Seperating data into ERD tables

# #### Creating constituent

# In[844]:


constituent = ccdf.copy()
constituent.drop(constituent.iloc[:, 17:27], axis=1,inplace=True)
constituent.drop(constituent.iloc[:, 10:19], axis=1,inplace=True)
constituent.drop(constituent.iloc[:, 11:21], axis=1,inplace=True)

columns = ['lookup_id','suffix','title','name',
           'last_group','email_id','phone','dob',
           'do_not_email','constituent_type','phone_notes']
constituent = constituent[columns]
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

# In[845]:


address = ccdf.copy()
address.drop(address.iloc[:, 1:10], axis=1,inplace=True)
address.drop(address.iloc[:, 8:31], axis=1,inplace=True)
address = address[address['address_1']!='']
address = address.drop_duplicates('address_1')

# Stripping off any extra white space
address['lookup_id'] = address['lookup_id'].str.strip().str.lstrip()
address['address_1'] = address['address_1'].str.strip().str.lstrip()
address['city'] = address['city'].str.strip().str.lstrip()
address['state'] = address['state'].str.strip().str.lstrip()
address['zip'] = address['zip'].str.strip().str.lstrip()
address['country'] = address['country'].str.strip().str.lstrip()
address['address_type'] = address['address_type'].str.strip().str.lstrip()
address['date_added'] = address['date_added'].str.strip().str.lstrip()


# #### Creating membership_record

# In[846]:


# Copy cdf and make some modifications based on ERD
mdf = ccdf.copy()
# Drop cleaned-up fields from above
mdf.drop(mdf.iloc[:,30:], axis=1, inplace=True)
# Drop phone number notes from membership data frame
mdf.drop(mdf.iloc[:,29:30], axis=1, inplace=True)
# # Drop constituent and address fields from membership data frame
mdf.drop(mdf.iloc[:,1:17], axis=1, inplace=True)

# Split membership data into sub groups based on program
phipps_general = mdf.loc[mdf["membership_scheme"]=='Phipps General Membership'].copy()
phipps_corporate = mdf.loc[mdf["membership_scheme"]=='Phipps Corporate Partnership'].copy()
green_mountain = mdf.loc[mdf["membership_scheme"]=='Green Mountain Membership'].copy()
garden_club = mdf.loc[mdf["membership_scheme"]=='Garden Club Membership'].copy()
non_member = mdf.loc[mdf["membership_scheme"]==''].copy()
obsolete = mdf.loc[(mdf["membership_scheme"]!='Phipps General Membership') &
               (mdf["membership_scheme"]!='Phipps Corporate Partnership') &
               (mdf["membership_scheme"]!='Green Mountain Membership') &
               (mdf["membership_scheme"]!='Garden Club Membership') &
               (mdf["membership_scheme"]!='')].copy()

#Drop unnecessary records pertaining to other membership program renewal dates
phipps_general.drop(phipps_general.iloc[:, 8:11], axis=1, inplace=True)
non_member.drop(non_member.iloc[:, 8:11], axis=1, inplace=True)
phipps_corporate.drop(phipps_corporate.iloc[:, 7:9], axis=1, inplace=True)
phipps_corporate.drop(phipps_corporate.iloc[:, 8:9], axis=1, inplace=True) # Phipps Corporate has only 1 record
green_mountain.drop(green_mountain.iloc[:, 7:8], axis=1, inplace=True)
green_mountain.drop(green_mountain.iloc[:, 8:10], axis=1, inplace=True)

phipps_general = phipps_general.rename(columns={'general_last_renewed': 'last_renewed'})
phipps_corporate = phipps_corporate.rename(columns={'corporate_last_renewed': 'last_renewed'})
green_mountain = green_mountain.rename(columns={'green_last_renewed': 'last_renewed'})
garden_club = garden_club.rename(columns={'garden_last_renewed': 'last_renewed'})
obsolete = obsolete.rename(columns={'general_last_renewed': 'last_renewed'})
non_member = non_member.rename(columns={'general_last_renewed': 'last_renewed'})


# Reordering columns in membership dataframes to the same order as in the Ruby on Rails Application
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
# Removing lookup_id from membership_record
membership_record = membership_record_all.drop(membership_record_all.iloc[:, 0:1], axis=1)
# Dropping duplicates in membership records
membership_record = membership_record.drop_duplicates('membership_id')

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

# In[847]:


constituent_membership_record = membership_record_all.drop(membership_record_all.iloc[:, 2:10],axis=1)
constituent_membership_record = constituent_membership_record.drop_duplicates()
constituent_membership_record['lookup_id'] = constituent_membership_record['lookup_id'].str.strip().str.lstrip()
constituent_membership_record['membership_id'] = constituent_membership_record['membership_id'].str.strip().str.lstrip()


# #### Creating constituent_event

# In[848]:


edf.drop(edf.iloc[:, 7:8], axis=1,inplace=True)
columns = ['lookup_id','event_name','event_id','status','attend','start_date_time','end_date_time']
edf.columns = columns
columns = ['lookup_id','status','attend','start_date_time','end_date_time','event_id','event_name']
edf = edf[columns]
constituent_event = edf.iloc[:,0:3].join(edf.iloc[:,5:6])
constituent_event = constituent_event.drop_duplicates()

constituent_event['lookup_id'] = constituent_event['lookup_id'].str.strip().str.lstrip()
constituent_event['event_id'] = constituent_event['event_id'].str.strip().str.lstrip()
constituent_event['status'] = constituent_event['status'].str.strip().str.lstrip()
constituent_event['attend'] = constituent_event['attend'].str.strip().str.lstrip()


# #### Creating event

# In[849]:


event = edf.iloc[:,3:5].join(edf.iloc[:,5:7])
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

# In[850]:


contact_history = chdf.iloc[:,1:].copy()
contact_history = contact_history.drop(columns=['Name'])
contact_history.columns = ['lookup_id','type','date']
contact_history['date'] = contact_history['date'].apply(clean_Date)
contact_history = contact_history[contact_history['lookup_id'] != "anonymous"] # weird case
contact_history['type'] = contact_history['type'].apply(lambda x: x if x != "" else "Not specified")
contact_history = contact_history.drop_duplicates()

# Approx 9862 duplicate contact_history; may be due to multiple mails/emails on the same day
contact_history['lookup_id'] = contact_history['lookup_id'].str.strip().str.lstrip()
contact_history['type'] = contact_history['type'].str.strip().str.lstrip()
contact_history['date'] = contact_history['date'].str.strip().str.lstrip()


# #### Creating donation_history

# In[852]:


dddf = ddf.iloc[:,1:].copy()
columns =  ['donation_history_id', 'lookup_id','amount','date','payment_method',
            'given_anonymously', 'do_not_acknowledge', 'donation_program_id','program',
            'donation_method','transaction_type']
dddf.columns = columns
dddf = dddf[(dddf["lookup_id"] != "")
                                    & (dddf["lookup_id"] != "anonymous")]
dddf = dddf[dddf['program']!=""]
columns =  ['donation_history_id', 'donation_program_id','lookup_id','amount','date','payment_method',
            'given_anonymously', 'do_not_acknowledge', 'transaction_type','program',
            'donation_method']
dddf = dddf[columns]
donation_history = dddf.iloc[:,0:9].copy()
donation_history['date']=donation_history['date'].apply(clean_Date)
donation_history['amount']=donation_history['amount'].apply(clean_amount)
donation_history = donation_history.drop_duplicates()

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

# In[853]:


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

# #### Creating incomplete_records, incomplete_names, invalid_zips, invalid_phones, invalid_emails, and dupliate records

# In[854]:


no_contact.drop(no_contact.iloc[:,-13:], axis=1,inplace=True)
no_contact['no_contact'] = True
no_contact['phone_notes'] = ''
incomplete_names.drop(incomplete_names.iloc[:,-19:], axis=1,inplace=True)
incomplete_names['incomplete_names'] = True
invalid_zips.drop(invalid_zips.iloc[:,-19:], axis=1,inplace=True)
invalid_zips['invalid_zips'] = True
invalid_phones.drop(invalid_phones.iloc[:,-19:], axis=1,inplace=True)
invalid_phones['invalid_phones'] = True
invalid_emails.drop(invalid_emails.iloc[:,-19:], axis=1,inplace=True)
invalid_emails['invalid_emails'] = True
incomplete_invalid = no_contact.append([incomplete_names,invalid_zips,invalid_phones,invalid_emails])
incomplete_invalid_address = invalid_zips.copy()
columns = ['lookup_id','address_1','city','state','zip','country',
         'address_type', 'date_added', 'constituent_type','do_not_email',
          'dob','email_id','last_group','name', 'phone','suffix','title','invalid_zips']

incomplete_invalid_address = incomplete_invalid_address[columns]
incomplete_invalid_address.drop(incomplete_invalid_address.iloc[:, 8:], axis=1,inplace=True)



incomplete_invalid_constituent = incomplete_invalid.drop(incomplete_invalid.iloc[:,-1:], axis=1,inplace=False)
incomplete_invalid_constituent.drop(incomplete_invalid_constituent.iloc[:,19:20], axis=1,inplace=True)
incomplete_invalid_constituent.drop(incomplete_invalid_constituent.iloc[:,4:6], axis=1,inplace=True)
incomplete_invalid_constituent.drop(incomplete_invalid_constituent.iloc[:,0:3], axis=1,inplace=True)
columns = [ 'lookup_id', 'suffix', 'title', 'name', 'last_group', 'email_id', 'phone',
           'dob', 'do_not_email', 'constituent_type', 'phone_notes',
           'incomplete_names','invalid_emails','invalid_phones','invalid_zips','no_contact']
incomplete_invalid_constituent = incomplete_invalid_constituent[columns]
incomplete_invalid_constituent['incomplete_names'] = incomplete_invalid_constituent['incomplete_names'].fillna(value=False)
incomplete_invalid_constituent['invalid_emails'] = incomplete_invalid_constituent['invalid_emails'].fillna(value=False)
incomplete_invalid_constituent['invalid_phones'] = incomplete_invalid_constituent['invalid_phones'].fillna(value=False)
incomplete_invalid_constituent['invalid_zips'] = incomplete_invalid_constituent['invalid_zips'].fillna(value=False)
incomplete_invalid_constituent['no_contact'] = incomplete_invalid_constituent['no_contact'].fillna(value=False)
incomplete_invalid_constituent['duplicate'] = False # Temporary
incomplete_invalid_constituent['duplicate_lookup_ids'] = np.array('')




# ### 5) Exporting into final databases for ERD

# In[855]:


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


#  ### 6) Validations
#

# #### constituent validations

# In[856]:


# # Edit this more later, but this has the basic regex formulas for the fields for now
# # as a means to validate the values.
# schema = Schema([
#     Column('lookup_id', [LeadingWhitespaceValidation(), TrailingWhitespaceValidation(),
#                          MatchesPatternValidation('^(?!\s*$).+')]),
#     Column('suffix',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation()]),
#     Column('title', [LeadingWhitespaceValidation(), TrailingWhitespaceValidation()]),
#     Column('name',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation()]),
#     Column('last_group',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation()]),
#     Column('email_id', [LeadingWhitespaceValidation(), TrailingWhitespaceValidation(),
#                         MatchesPatternValidation(r'^$|(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)')]),
#     Column('phone',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation(),
#                      MatchesPatternValidation(r'^$|[(][\d]{3}[)]\s[\d]{3}[-][\d]{4}')]),
#     Column('dob',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation(),
#                   MatchesPatternValidation(r'^$|[\d]{4}/[\d]{2}/[\d]{2}')]),
#     Column('do_not_email',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation()]), # make custom validation for boolean?
#     Column('constituent_type',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation(), InListValidation(["Individual", "Organization", "Household"])]),
#     Column('phone_notes',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation()])
# ])
# errors = schema.validate(constituent)
# if len(errors) == 0:
#     print("Validations passed!")
# for error in errors:
#     print(error)
#
#
# # #### constituent_membership_record validations
#
# # In[857]:
#
#
# schema = Schema([
#     Column('lookup_id', [LeadingWhitespaceValidation(), TrailingWhitespaceValidation(),
#                          MatchesPatternValidation('^(?!\s*$).+')]),
#     Column('membership_id',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation(),
#                          MatchesPatternValidation('^(?!\s*$).+')])
#     ])2
# errors = schema.validate(constituent_membership_record)
# if len(errors) == 0:
#     print("Validations passed!")
# for error in errors:
#     print(error)
#
#
# # #### membership_record validations
#
# # In[858]:
#
#
# # Need to find a way to validate the time values
# schema = Schema([
#     Column('membership_id', [LeadingWhitespaceValidation(), TrailingWhitespaceValidation(),
#                          MatchesPatternValidation('^(?!\s*$).+')]),
#     Column('membership_scheme',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation(),
#                          MatchesPatternValidation('^(?!\s*$).+')]),
#     Column('membership_level',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation(),
#                          MatchesPatternValidation('^(?!\s*$).+')]),
#     Column('add_ons',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation()]),
#     Column('membership_level_type',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation()]),
#     Column('membership_status',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation(),
#                          MatchesPatternValidation('^(?!\s*$).+')]),
#     Column('start_date',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation()]),
#     Column('end_date',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation()]),
#     Column('last_renewed',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation()])
#     ])
# errors = schema.validate(membership_record)
# if len(errors) == 0:
#     print("Validations passed!")
# for error in errors:
#     print(error)
#
#
# # #### address validations
#
# # In[859]:
#
#
# # Added common state names for Canada, and DC
# STATES_LIST = ['Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut',
#   'Delaware', 'District of Columbia', 'Florida', 'Georgia', 'Hawaii', 'Idaho', 'Illinois', 'Indiana',
#   'Iowa', 'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota',
#   'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey', 'New Mexico',
#   'New York', 'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island',
#   'South Carolina', 'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington', 'West Virginia',
#   'Wisconsin', 'Wyoming','District Of Columbia','Ontario','British Columbia','Alberta','Nova Scotia',"Puerto Rico",
#   'American Samoa','Armed Forces Europe/Canada/Middle East/Africa',"Armed Forces Pacific",""]
#
#
# # In[860]:
#
#
# schema = Schema([
#     Column('lookup_id', [LeadingWhitespaceValidation(), TrailingWhitespaceValidation(),
#                          MatchesPatternValidation('^(?!\s*$).+')]),
#     Column('address_1',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation(),
#                          MatchesPatternValidation('^$|^(?!\s*$).+')]), # Need to change this, allows case of blank address
#     Column('city',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation(),
#                   MatchesPatternValidation('^$|^[A-Z][a-z]*(\s[A-Z][a-z]*)*')]),
#     Column('state',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation(),
#                   InListValidation(STATES_LIST)]),
#     Column('zip',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation(),
#                  MatchesPatternValidation('^$|^\d{5}(?:[-]\w{4})?|^[A-Z][0-9][A-Z][0-9][A-Z][0-9]$')]),
#     Column('country',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation(),
#                      MatchesPatternValidation('^$|^[A-Z][a-z]*(\s[A-Z][a-z]*)*')]),
#     Column('address_type',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation()]),
#     Column('date_added',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation()])
#     ])
# errors = schema.validate(address)
# if len(errors) == 0:
#     print("Validations passed!")
# for error in errors:
#     print(error)
#
#
# # #### contact_history validations
#
# # In[862]:
#
#
# # Need to find a way to validate the time values
# schema = Schema([
#     Column('lookup_id', [LeadingWhitespaceValidation(), TrailingWhitespaceValidation(),
#                          MatchesPatternValidation('^(?!\s*$).+')]),
#     Column('type',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation(),
#                          InListValidation(['Email','Mail','Not specified','Phone'])]),
#     Column('date',[LeadingWhitespaceValidation(), TrailingWhitespaceValidation()])
#     ])
# errors = schema.validate(contact_history)
# if len(errors) == 0:
#     print("Validations passed!")
# for error in errors:
#     print(error)