[![Build status](https://ci.appveyor.com/api/projects/status/t6gwm860cyifajor?svg=true)](https://ci.appveyor.com/project/devblackops/poshbot-karma)

# PoshBot.Karma

A simple [PoshBot](https://github.com/poshbotio/PoshBot) plugin to managing karma.

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

- **!karma**

  Show the top 5 karma holders

- **!karma best**

  Show the top 5 karma holders

- **!karma best 10**

  Show the top 10 karma holders

- **!karma worst**

  Show the worst 5 karma holders

- **!karma worst 10**

  Show the worst 10 karma holders

- **!karma \<thing>**

  Show karma for `<thing>`

- **!karma empty \<thing>**

  Remove **all** karma from `<thing>`

- **\<thing>++**

  Give karma to `<thing>`

- **\<thing>--**

  Remove karma from `<thing`

## Usage

```
Good job! @sallysue++
```

```
That's not a nice thing to say @joeuser--
```
