| GitHub Actions | PSGallery | License |
|-----------------|----------------|-----------|---------|
[![GitHub Actions Status][github-actions-badge]][github-actions-build] | [![PowerShell Gallery][psgallery-badge]][psgallery] | [![License][license-badge]][license]

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

- **\<thing>++**

  Give karma to `<thing>`

- **\<thing>--**

  Remove karma from `<thing`

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

- **!karma show \<thing>**

  Show karma for `<thing>`

- **!karma empty \<thing>**

  Remove **all** karma from `<thing>`

## Usage

```
Good job! @sallysue++
```

```
That's not a nice thing to say @joeuser--
```

[github-actions-badge]: https://github.com/poshbotio/PoshBot.Karma/workflows/CI/badge.svg
[github-actions-build]: https://github.com/poshbotio/PoshBot.Karma/actions
[psgallery-badge]:      https://img.shields.io/powershellgallery/dt/PoshBot.Karma.svg
[psgallery]:            https://www.powershellgallery.com/packages/PoshBot.Karma
[license-badge]:        https://img.shields.io/github/license/poshbotio/PoshBot.Karma.svg
[license]:              https://www.powershellgallery.com/packages/PoshBot.Karma
