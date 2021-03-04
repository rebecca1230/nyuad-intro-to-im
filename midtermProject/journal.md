# Journal: Marine Voyage in the Pacific
This game is about travelling in an infinite journey in the Pacific with a Submarine trying to successfully avoid sharks using missiles.

## Output
![](output.gif)

### Feb 19
I still need to figure out what would be an interesting name for the project - might be something like sailing in the Pacific or just boating in Pokhara (amazing place in my home country where you can enjoy boating on lakes with a wonderful view of mountains).

I wanted to give a vibe of ocean/lake to the game. So, I started searching for free music on the web. I finally found a suitable background music called 'Deep Blue' by Benjamin Tissot from [this website.](https://www.bensound.com/royalty-free-music/track/deep-blue)

### Feb 20
I was thinking that the main character of the game would be a boat, so I looked for boat sprites and found something that could fit with other elements. The image is added into the ```images``` folder.

### Feb 21
The game also needs a good background image, so I tried searching for a good marine background. I ended up being satisfied with one, but it might change. I was also wondering how to introduce an enemy to the game. For now, I've thought of bringing the shark every 10 seconds. To do it, I'll probably be using both ```frameRate()``` and ```frameCount``` in Processing. I found an amazing sprite for the shark and tweaked it a little in Photoshop.

### Feb 22
The main character would also have to rotate towards the direction where the boat/ship is supposed to move. So, I reviewed the ```rotate()``` function in Processing to be more familiar with it. At this point, I am rethinking of the main character. Boat sounds childish, why not add an entire ship? But I need to find a good sprite for it, otherwise I might end up creating my own.

### Feb 23
Finally, I have come up with a good idea for the game. I have decided that the main character would be a Submarine that moves underwater and kills sharks that come across its way. It will run infinitely and the score will be added.

### Feb 24
I tried searching for sprites of submarines on the web, but most of them needed payments for use. So, I have decided to create one myself. Here's what I was able to create from Adobe Photoshop.

![](images/submarine.png)

### Feb 25
I also needed to create missiles for the submarine to fire. I think it looks good with the background, but it might change. Here's how it looks at the moment:

![](images/missile.png)

### Feb 26
I have started working on the code today. I had already sketched what classes to make and what variables would they store and how the game flow would look like. So, it was pretty easy creating the basic structure. However, the background looks dull, so I need something to make it interesting. Maybe a parallax effect?

### Feb 27
I have collected some good marine graphics to include on the project. Today, I was able to create a parallax effect in Processing. Quite a tricky one, but it looks super good and it feels like the character would move more smoothly.

### Feb 28
Today, I worked on the main character's movement. It was difficult figuring out how to rotate the submarine towards the mouse position, but a combination of ```pushMatrix()```, ```popMatrix()```, ```translate()```, and ```rotate()``` did the trick. The movement is similar to the game Among Us where you click the position that you want to go, but it'll only be vertical in this game.

### March 1
I managed to add sprite animations to the characters - Submarine, Shark, and Missile. The game looks lively now. Sharks come from a random y-position in the right and approach towards the Submarine. The Submarine has to throw missiles to avoid them and get them out of the way. I also added a Score text which will be increased when a missile hits the shark.

### March 2
I wanted to add something quickly before today's class - when a missile hits the shark, the Shark as well as the Missile gets removed from the ```ArrayList```. This way, the objects disappear from the game per requirement and increment of score is also triggered.

### March 3
I have completed all the work needed to run the game. The Main Menu as well as the Game Over screen looks pretty good. One more feature I realized would be great was - recording high scores. As the game runs infinitely, the player would now have to beat their own score. Fun, right? Also, I had to change a couple of audio files to make the game more interesting (especially background music). Right now, it looks really cool and I'm very much satisfied with the work.

Thank you!
