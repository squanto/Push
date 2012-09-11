# Goal
Make it really easy to podcast / livestream audio.

# Spec
Push-to-talk audio. 

Mirror the Twitter iOS app, but with audio instead. Diverge accordingly.  

1. Modify login to copy twitter's web login.
	- Remove twitter auth(??), add email auth and auto-parse verification. 
2. Make it hold to record + send to parse in the background as I send metadata (Instagram interview style). (check)
	- Send to parse. Associate it with the logged in user. (check)
4. Be able to 'log in' to someone's channel
	- Create a table (Follow Table), with a following user and followed user. 
5. Get files as they're recorded to parse and play them. 

6. Modify record button to take files as they're recording, piece them out, and send them to parse. 

7. There's a setting to connect your twitter and let it scan for people you follow to follow here (two simple pfqueries + custom twitter auth).
	- It automatically scans and 'follows' people you already follow on twitter. ( or gives you the option?)
	- Add them as a tabl view (http://24.media.tumblr.com/tumblr_m2qlr7H9Yk1qzff5uo2_1280.png).
	- https://parse.com/docs/ios_guide#twitter-users (this)

8. Interact with the Javascript(backbone/ember) Web App. (Learn javascript with parse?)
	- Start off with the landing screen. Check out: (http://www.blip.me/broadcast/).


# TODO:
- Add settings for updating / adding email, reseting passwords, etc.
	
1. Make pretty.
- Fix images / icons for retina display (check)
- Fix Splash logo for retina display
- Add Page control the first time you sign up.

- Add email confirmation / authdata
	

// like voxer. but more asynchronous. More boradcast-y, less one-to-one.


Add find people to follow, startup guide, etc. to sidescrolling splash screen.

http://www.cocoacontrols.com/platforms/ios/controls/center-button-in-tab-bar
// add this center button to the record functionality (look at anypic source code?).

http://www.cocoacontrols.com/platforms/ios/controls/pull-to-refresh-tableview

http://idevrecipes.com/2011/04/14/how-does-the-twitter-iphone-app-implement-side-swiping-on-a-table/
// swipe controls on 


# Ned Notes
## Questins
- Record, stop, and send? or hold to record?
- How best to add options to a recording. 
- Loading my Tab bar items where I load them. 
- Record VC.m, line 100-110.
- Discover functionality. (?!?)
	- How does search do its animation to a search view controller. 
	- Add search to table view (??)
	- Add Diretions for geotagged sounds (like a virtual tour throughout a city).
- discovery VC line 40-50.
- Sliding UITableView while first responder is selected. 
- Sending the file in the background as users update metadata (??)
- Parse one to many relationships. 
- Parse many to many relationships (hashtags).

-http://stackoverflow.com/questions/409259/having-a-uitextfield-in-a-uitableviewcell (??)
- Swipe the table to the left for options on recordings (??).
- How to organize recent searches (as it's own table in Parse with User => search => timestamp)(??).

## Notes
1. Appplication controller
init with nib name is the designated initializer. Alloc init calls init with nib name. (When created with code). When view controller loads with view, it loads with nib.
	
2. View controller will come on screen. Needs to load up view.
	Goes to nib by default. 
	ViewWillLoad happens before this.
	Loadview - Set up here for doing programmatically
	
3. viewDidLoad
	After it loads up, outlets are connected. 
	ViewdidLoad once it's been loaded. Set yourself as data source and delegate. Post view loading setup.
	
4. ViewWillAppear
	For making thing load.

1. Audio File (data)
2. Audio object (link)
	- Each one has a user

PFQuery wherekey (user) is equal to…


1. Create the audio object. 
2. Start saving the audio file
25. When you're done saving, please set the audio object's file in the audio file
3. Happening at the same time as 2.5. Create the meta data VC. 
4. Set the audio Object in the metadata vc. 
5. Let meta data do its thing
6. Update audioobject when save is pressed. 

- Make a profile table view

- Make My Meta-Data VC Use a table view (http://stackoverflow.com/questions/409259/having-a-uitextfield-in-a-uitableviewcell).

-AVaudioPlayer can stream

- Touch down action for pressing down.
- Touch up inside for The Release Action.

- Add a mutable array of people that I follow to each parse user.

- Add hash tags / titles to search by for audio recordings.
	- Automatically uses timestamp created at. Can use custom name and hashtags.

Less one to one and more broadcasting. Modify.
	- Add titles to recordings.


Add (page control) sign up page when the program first loads. the first time the user logs in.
http://www.edumobile.org/iphone/iphone-programming-tutorials/pagecontrol-example-in-iphone/

Add a relations table. On one side, you have 


Add the rails app that connects with Parse.



# Similiar Products in the Market
- Soundcloud
- Twitter
- Blip.me
- Voxer

# Experimental Ideas:

- Exit Strategy: Make it eventually stream live audio (compete with ustream / soundcloud?). Make it a really easy mobile podcasting / live streaming tool 
and sell it for 99 cents.
- Free iOS version. Paid version for podcasters (?)
	- that integrates with a rails/javascript web app: Profiles, podcasting, analytics, featured tracks, customization, etc.

- Add Geolocation for sound streaming.
	- Part of the discovery, add local rooms (listen to all boradcasts from SOMA).
- Cocktail party audio streaming.
- Cool Parse Examples: https://parse.com/samples
- Cool open source examples: http://maniacdev.com/2010/06/35-open-source-iphone-app-store-apps-updated-with-10-new-apps/

# Left Field

http://www.cocoacontrols.com/platforms/ios/controls/svsegmentedcontrol


http://www.cocoacontrols.com/platforms/ios/controls/mbprogresshud


- Totally different App: Soundtracking Your life: Easily share / promote artists you love.
- Totally different App: Merge StackOverflow and Wikipedia (add point functionality to longform knowledge graphs and tutorials). (Incentivize people to create/share free, open source tutorials).
- Totally different App: Running app that integrates with your music (trainer type deal).
- http://attila.tumblr.com/post/21180235691/ios-tutorial-creating-a-chat-room-using-parse-com
- http://cocoawithlove.com/2011/06/process-of-writing-ios-application.html


### Signup
Make this custom (Don't use parse auto login). Make this a table view of different cells (like adding a new contact). When you click on the photo, it modally presents options (to import from twitter, choose a photo, take a photo, or cancel).
1. Username (with @)
2. full name
3. Email
4. Password
5. Photo 

OR

Twitter / facebook.


# Progress Map
## Monday

- Make every navigation controller be able to (modally) present the recordVC. (check)
	1. Home Screen.
	2. Connect Screen
	3. Discover (Search via hashtag. Speech to text?)
	4. Profile View (modified table view). 


## Tuesday

- Be able to see a table view of all your recordings. (Parse auto-pull-to-refresh-and-query).

- Make the discovery search bar modally present a new view controller. (check)

- Be able to search for, discover, and follow new users. 

## Wednesday

## Thursday
- http://www.iosdevnotes.com/tag/uipagecontrol/, add 

## Friday

## Saturday

## Sunday

# Monday
- Submit To the App Store
