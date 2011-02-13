Plex Media Manager l10n
=======================

This project exists to assist in creating and updating language files. The Plex Media Manager uses the `.xstrings` format, an XML variant of `.strings` format used in Mac OS X development for translating user-displayed strings.

Adding translation strings for new English strings
--------------------------------------------------

Occasionally new strings (or changed strings) will appear as the user interface of the Plex Media Manager changes and gets new features. Let's say you're contributing to the French language file. Here are the steps to add the new translations to your file:

    $ bin/rebase fr
    ~ rebase fr: Adding new translation: "Tasty Burger"

This first step adds the new strings to the French language file, but leaves the translation in English. Next, edit `data/fr.lproj/Localizable.strings` in your favorite text editor to provide the translations for the untranslated strings:

    `"Tasty Burger" = "Burger Savoureux";`

Build the matching `.xstrings` file:

    $ rake build

Then commit the result to a branch, ideally named for the change (i.e. `fr-tasty-burger`), and push it to your Github account, then send a pull request to plexinc-plugins.

Fixing translation strings
--------------------------

If you find a translation that isn't quite right and would like to improve it, first of all: thank you! All you need to do is edit the file that needs to be fixed and then build the matching `.xstrings` file:

    $ rake build

Then commit the result to a branch, ideally named for the change (i.e. `fr-fix-edit-metadata`), and push it to your Github account, then send a pull request to plexinc-plugins.

**More info on testing on your local machine coming soon.**