Stalky: The tracking app that does not track you!
=================================================

Stalky is a self-hosted app that helps you keep track of anything you want. Don't let others stalk you, stalk yourself!

You can track sleep, mood, caffeine, antisocial tendencies or anything you can think of. Stalky will then help you make sense of the data by analyzing it and finding interesting stuff in it. And it all runs on your computer, never sending your data to anyone else.

Your data is truly in your hands -- everything is stored as CSVs, so you can open it with your favorite text editor (or your favorite data analysis tool, or a crazy visualization program, or anything). Built for geeks, by a geek!

My secret plan is to integrate this with a few hardware trackers, details TBA. I want to nail down the basics first though, so it will take a while.

I want this!
------------

Requires `python3` and `node`\*. Install these using your package manager.

Type `make run`, open <http://localhost:8500> and enjoy!

Put it on a server behind a reverse proxy such as nginx **with HTTP auth** if you want to use this from multiple devices.

For more details, check [the wiki](https://github.com/AnotherKamila/stalky/wiki/Installation-and-Deployment).

\* Actually, doesn't _really_ require `node` because I have sinned and the compiled file is in the repo. Look [here](https://github.com/AnotherKamila/stalky/wiki/Installation-and-Deployment#i-dont-want-to-install-nodejs) to go without.

### Fun integrations

You can use [IFTTT](https://ifttt.com)'s Webhooks endpoint to get data from just about anywhere. Example: Shout "Hey Google, write down, yoga 3" at your fancy expensive speaker. More details [in the wiki](https://github.com/AnotherKamila/stalky/wiki/Integrations).

Also, it's just HTTP -- it's easy to roll your own!

I like this!
------------

Me too :-D If you want to increase my motivation and therefore the chances that I'll write some code today, you can [say thanks](https://saythanks.io/to/AnotherKamila) or [support me on Liberapay](https://liberapay.com/kamila/donate). Or _you_ can [write code](https://github.com/AnotherKamila/stalky/wiki/Development-Quick-Start)!
