require 'pathname'
require File.expand_path('../lib/l10n', __FILE__)

ROOT = Pathname(File.expand_path('..', __FILE__))
PMM_ROOT = ROOT.parent+'plex-media-manager'

def in_root(&block)
  Dir.chdir(ROOT, &block)
end

include L10n

file Localization['xx-chef'].strings => Localization['en'].strings do
  in_root do
    system %{bin/auto-translate xx-chef vendor/chef}
  end
end

localizations = Localization.all

localizations.each do |localization|
  file localization.xstrings => localization.strings do
    %x{plutil -convert xml1 #{localization.strings} -o #{localization.xstrings}}
  end
end

task :default => localizations.map {|localization| localization.xstrings }

if PMM_ROOT.exist?
  desc "Update the English strings from plex-media-manager"
  task :update do
    Dir.chdir(PMM_ROOT) do
      puts "~ Updating English strings"
      system %{genstrings -o Resources/en.lproj -s CPLocalizedString *.j */*.j}

      Dir.chdir(PMM_ROOT+'Resources/en.lproj') do
        system %{iconv -f utf-16 -t utf-8 Localizable.strings > Localizable.strings.utf8 && mv Localizable.strings.utf8 Localizable.strings}
        cp "Localizable.strings", Localization['en'].strings
      end
    end
  end

  desc "Install the .strings and .xstrings into plex-media-manager"
  task :install => :default do
    resources = PMM_ROOT+'Resources'

    localizations.each do |localization|
      cp localization.strings, resources+"#{localization.code}.lproj/"
      cp localization.xstrings, resources+"#{localization.code}.lproj/"
    end
  end
end