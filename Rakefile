$LOAD_PATH << File.expand_path('../lib', __FILE__)

require 'pathname'
require 'l10n/localization'

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
    system %{plutil -convert xml1 #{localization.strings} -o #{localization.xstrings}}
  end

  next if localization.code == 'en'

  file localization.strings => Localization['en'].strings do
    in_root do
      system %{bin/rebase #{localization.code}}
    end
  end
end

task :build => localizations.map {|localization| localization.xstrings }

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
  task :install => :build do
    resources = PMM_ROOT+'Resources'

    localizations.each do |localization|
      cp localization.strings, resources+"#{localization.code}.lproj/"
      cp localization.xstrings, resources+"#{localization.code}.lproj/"
    end
  end
end

task :default => :build

file 'lib/l10n/translation_parser.rb' => 'lib/l10n/translation_parser.rl' do |f|
  puts "~ Generating strings file parser"
  system %{ragel -R #{f.prerequisites.first}}
end

namespace :dev do
  desc "Build the development components required to use this project"
  task :build => 'lib/l10n/translation_parser.rb'
end