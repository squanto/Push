# Todo

- Add (page control) sign up page when the program first loads. the first time the user logs in.
	- http://www.edumobile.org/iphone/iphone-programming-tutorials/pagecontrol-example-in-iphone/
- Make a backbone app that connects with parse. 


## Home View
- Add audio view, a view of the audio with responses. 
	- Has a link to the user (to their profile view)
	- Can play the audio
	- Can respond with other audio

## Connect View Controller

- (Modally) Make a Table view of custom(?) cells. It lists users you connect one on one.
	- When you click the compose button, it takes you to a special record view controller of all the users you follow (start off with picking one to one).
	- When you click a user, it takes you to the conversation view of that user (Navigation controller style)
	- You can reply with audio messages
- Get a push notification when you receive a new private message

### Private Audio Table
(A Parse Table)
- It has an id, a from user, a to user, and an audio object

## Discover View
- Show a table view of the global list of users
	- Be able to click to go to a user's profile

## Profile View
- Make the profile view a scroll view.
- Make the profile view init with the id of a user
- Add a follow button
	- Make the follow button only show when you're not that user
	- Make the follow button toggle
- Add a my broadcasts button / table view cell that pushes a modal view controller of a pf query table view controller, listing out all of my broadcasts
- Add a following button, listing out all of the users I follow. If I click on one of the users in this modal view, it pushes (navigation style) to that user's profile view.
- Add a followers button that modally pushes to a pf query table view of the users that follow. When you click on one of the cells, it takes you to that user's profile.

- On everything that lists the users, be able to asyncronously call to fill out their images. 

## Optional 
- Make a Parse Store.
- Be able to asyncronously call from the home view controller to fill out the cells with the profile picture of the the user.
- Add a custom UITableViewCell with CAAnimations of buttons
- Fix the splash login screen
- Fix the splash login screen logo
- Connect with Twitter
- Find a better background texture
- Make an icon for it.


# Later
- Add hash tags / friend tagging.
- Be able to delete your account
- Be able to 'find friends' though twitter and facebook
- Be able to 