=====================

=begin 

1 - Get google_drive gem : 

https://github.com/gimite/google-drive-ruby

2 - Tutorial to install google drive_Authorization 

https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md


2.1 - Go the the credentials page : 

https://console.developers.google.com/apis/credentials?pli=1

2.2 - Create a new project or select an existing project

2.3 - Click « create credentials » —> « OAuth Client ID »

2.4 - Choose « Other » for « Application type »

2.5 - Click « create » and take note of the generated client ID and client secret.

2.6 - Activate the Drive API for your project in the Google API console.
https://console.developers.google.com/apis/library?project=scrapemails-192909

2.7 - Create a file config.json which contains the client ID and client secret you got above; 

2.8 - Then you can construct a session object (in your .rb file) by :

session = GoogleDrive::Session.from_config("config.json")

This code will prompt the credential via command line for the first time and save it to config.json. For the second time and later, it uses the saved credential without prompt.

More infos at : https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md

=end


====================== Create a drive.rb file (this part upload on a google spreadsheet) ================


require 'google_drive'
require_relative 'scrap_mairies'
require 'json'
require 'pry'

$data = get_hash

		
		# create a methode that access to the drive and set up the spreadsheet

		def setup_spreadsheet

				session = GoogleDrive::Session.from_config("config.json")
				$ws = session.spreadsheet_by_title("emails").worksheets[0]
 				$ws[1, 1] = "Mairie"
  				$ws[1, 2] = "Adresse mail"
  				$ws.save

		end

		
		# create a methode that get takes the hash and prints it on the google drive spreadsheet
		# by selection the position of the ligne and row ([i,1]) then we increment i in order to go to the next line (on the same row)

		def upload_hash

			# initialize/connect to the google spreadsheet
				setup_spreadsheet
			# give a value of 2 to i in order to increment it later (ex : i += 1)
				i = 2
			# for each email we set it up as a key and by incrementing i we go from one row to the next.
				$data.keys.each do |key|
				$ws[i,1] = key
				$ws[i,2] = $data[$ws[i,1]]  
				i += 1 
			end
  			$ws.save	
		end

# we initialize the method above
upload_hash

======================


the GOOGLE SPREASHEET is the link between those two programs : 

Program 1 : Upload to google spreadsheet (drive.rb) => google Spreadshet <=> Program2 (gmail.rb) => send emails to the emails adresses


======================


====================== Create a gmail.rb file (this part will access the google spreadsheet and send an email to each email adress)===============

# to use this program remeber to replace you config.json file and replace your key for "worksheet_key = "

require 'gmail'
require 'mail'
require 'google_drive'
require 'pry'

#Create a variable worksheet key with the key to access the google spreadsheet (on the related google drive)
# $mail connects to the allowed Gmail Account
worksheet_key = "1sw0YH9W46NtcQ6UXIGWDnOqFUwEPGv4xJ6zlvF65o1g"
$gmail = Gmail.connect("paul.cabernet@gmail.com", "csmartins2017") # this can be changes with your logs


		#Create a methode to access the worksheet (through its keyà) on google drive => Using the Json file to log
		def get_worksheet(worksheet_key)

				$session = GoogleDrive::Session.from_config("config.json")
				$ws = $session.spreadsheet_by_key(worksheet_key).worksheets[0]

		end

		# go through all the line of the column of the worksheet 
		def go_through_all_the_lines(worksheet_key)


				# create an array called data in order to store all the emails
				data = []
				worksheet = get_worksheet(worksheet_key)

				# for each of line of the row we add it into the "data array"

				worksheet.rows.each do |row|

	 			data << row[1].gsub(/[[:space:]]/, '')
 		 end 
    
    			return data
		end

		# send email methode (and the key as variable)

		def send_gmail_to_listing(worksheet_key)


				# first we connect to gmail with the $gmail variable (where our logs are stored)
				$gmail
				#we go through each email adresse 
				# send we send (deliver) an email with subject + body

					go_through_all_the_lines(worksheet_key).each do |email|
						$gmail.deliver do
      			to email
      			subject "SSSSSSubject_text" # write your subject here
      						text_part do 
      			body "HELOOOO" 	#write your message here
      				end
      					end
 		 					end

		end




