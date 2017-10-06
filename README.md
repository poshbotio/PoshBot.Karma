[![Build status](https://ci.appveyor.com/api/projects/status/t6gwm860cyifajor?svg=true)](https://ci.appveyor.com/project/devblackops/poshbot-karma)

# PoshBot.Karma

A simple [PoshBot](https://github.com/poshbotio/PoshBot) plugin to grant or take away karma from people.

## Install Module

To install the module from the [PowerShell Gallery](https://www.powershellgallery.com/):

```
PS C:\> Install-Module -Name PoshBot.Karma -Repository PSGallery
```

## Install Plugin

To install the plugin from within PoshBot:

```
!install-plugin --name poshbot.karma
```

## Commands

- leaderboard
- @\<username>++
- @\<username>--

## Usage

```
 Good job! @joeuser++


http://media1.giphy.com/media/o0vwzuFwCGAFO/giphy-downsized.gif
```

```
!giphy --search squirrel --number 2

http://media0.giphy.com/media/jn5jcY94IP6VO/giphy-downsized.gif
http://media.giphy.com/media/X4sbcP4xNXTY4/giphy-tumblr.gif
```

```
!giphy --trending

http://media3.giphy.com/media/lYevwCwCSlfIA/giphy-downsized.gif
```
