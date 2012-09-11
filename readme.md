# Goal
Make it really easy to podcast and livestream audio.

# Spec
Push-to-talk audio. 

1. Simple twitter authentication splash screen. (Check)
2. Record simple audio file (record / stop). 
	- Name it.
	- As you enter in details, it's sending in the background.
3. Send to parse. Associate it with the logged in user.
4. Be able to 'log in' to someone's channel
5. Get files as they're recorded to parse and play them. 
6. Modify record button to take files as they're recording, piece them out, and send them to parse. 
7. It automatically scans and 'follows' people you already follow on twitter. ( or gives you the option?)
8. Interact with the Javascript Web App. (Learn javascript with parse?)


TODO:
- Learn about push notifications
	- https://parse.com/apps/pulse--3/push_notifications
	- https://parse.com/docs/ios_guide#push
	- https://parse.com/tutorials/ios-push-notifications (practice this again)
- As you're updating audio
- Add settings for updating / adding email, reseting passwords, etc.
- Make retina difference for tab bar iems (http://app-bits.com/free-icons.html)

Experimental Ideas:

- Exit Strategy: Make it eventually stream live audio (compete with ustream / soundcloud?). Make it a really easy mobile podcasting / live streaming tool 
and sell it for 99 cents.
- Free iOS version. Paid version that integrates with a rails/javascript web app: Profiles, podcasting, analytics, featured tracks, customization, etc.

- Add Geolocation for sound streaming.
- Cocktail party audio streaming.
- Cool Parse Examples: https://parse.com/samples
- Cool open source examples: http://maniacdev.com/2010/06/35-open-source-iphone-app-store-apps-updated-with-10-new-apps/

- Totally different App: Soundtracking Your life: Easily share / promote artists you love.
- Totally different App: Merge StackOverflow and Wikipedia (add point functionality to longform knowledge graphs and tutorials). (Incentivize people to create/share free, open source tutorials).
- Totally different App: Running app that integrates with your music (trainer type deal).
- http://attila.tumblr.com/post/21180235691/ios-tutorial-creating-a-chat-room-using-parse-com
- http://cocoawithlove.com/2011/06/process-of-writing-ios-application.html


1. Appplication controller
init with nib name is the designated initializer. Alloc init calls init with nib name. (When created with code). When view controller loads with view, it loads with nib.
	
View controller will come on screen. Needs to load up view.
	Goes to nib by default. 
	ViewWillLoad happens before this.
	Loadview - Set up here for doing programmatically
	
viewDidLoad
	After it loads up, outlets are connected. 
	ViewdidLoad once it's been loaded. Set yourself as data source and delegate. Post view loading setup.
	
ViewWillAppear
	For making thing load.
	
	
- Add email confirmation / authdata
- Remove email signup. Only sign up through twitter. 
- Fix images for retina display. 
- Be able to see a table view of all your recordings. 
	

// like voxer. but more asynchronous. More boradcast-y, less one-to-one.


Add find people to follow, startup guide, etc. to sidescrolling splash screen.

http://www.cocoacontrols.com/platforms/ios/controls/jtrevealsidebar

http://www.cocoacontrols.com/platforms/ios/controls/center-button-in-tab-bar
// add this center button to the record functionality (look at anypic source code?).

http://www.cocoacontrols.com/platforms/ios/controls/pull-to-refresh-tableview


http://idevrecipes.com/2011/04/14/how-does-the-twitter-iphone-app-implement-side-swiping-on-a-table/
// swipe controls on 

# Monday

Mirror Twitter app, but with audio. 

Make every navigation controller be able to (modally) present the recordVC.


1. Home Screen.

2. Connect Screen

3. Discover (Search via hashtag. Speech to text?)

4. Profile View (modified table view). 



# Questions for Ned
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

1. Audio File (data)
2. Audio object (link)
	- Each one has a user

PFQuery wherekey (user) is equal to…

Create a table (Follow Table), with a following user and followed user. 


1. Create the audio object. 
2. Start saving the audio file
25. When you're done saving, please set the audio object's file in the audio file
3. Happening at the same time as 2.5. Create the meta data VC. 
4. Set the audio Object in the metadata vc. 
5. Let meta data do its thing
6. Update audioobject when save is pressed. 

- Make a profile table view


-AVaudioPlayer can stream

- Touch down action for pressing down.
- Touch up inside for The Release Action.

- Add a mutable array of people that I follow to each parse user.

- Add hash tags / titles to search by for audio recordings.
	- Automatically uses timestamp created at. Can use custom name and hashtags.

Less one to one and more broadcasting. Modify.
	- Add titles to recordings.
		- Hold down to Record, 


Add (page control) sign up page when the program first loads. the first time the user logs in.
http://www.edumobile.org/iphone/iphone-programming-tutorials/pagecontrol-example-in-iphone/

Add a relations table. On one side, you have 


Add the rails app that connects with Parse.