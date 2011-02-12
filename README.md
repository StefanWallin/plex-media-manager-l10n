Plex Media Manager l10n
=======================

This project exists to assist in creating and updating language files. The Plex Media Manager uses the `.xstrings` format, an XML variant of `.strings` format used in Mac OS X development for translating user-displayed strings.

Updating an existing language file
----------------------------------

If you are maintaining a language file (let's say French) and you'd like to provide translation strings for new & untranslated strings, first rebase your language file on the English one:

    $ bin/rebase fr
    ~ rebase fr: Adding new translation: "Tasty Burger"

Then, in `data/fr.lproj/Localizable.strings` edit the right side of the `Tasty Burger` translation to the proper French translation:

    `"Tasty Burger" = "Burger Savoureux";`

Then commit this to a branch, ideally named for the change (i.e. `fr-tasty-burger`), and push it to your Github account, then send a pull request to plexinc-plugins.

**More info on testing on your local machine coming soon.**