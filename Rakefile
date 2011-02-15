$LOAD_PATH << File.expand_path('../lib', __FILE__)

require 'pathname'
require 'l10n/localization'
require 'l10n/ui'

ROOT = Pathname(File.expand_path('..', __FILE__))
PMM_ROOT = ROOT.parent+'plex-media-manager'

def in_root(&block)
  Dir.chdir(ROOT, &block)
end

include L10n

localizations = Localization.all
default_localization = Localization['en']

file Localization['xx-chef'].strings => default_localization.strings do
  in_root do
    system %{bin/auto-translate xx-chef vendor/chef}
    UI.abort "Unable to auto-translate Swedish Chef strings. Perhaps vendor/chef is compiled for the wrong architecture?" unless $?.success?
  end
end

localizations.each do |localization|
  file localization.xstrings => localization.strings do
    UI.status %{Updating XML for #{localization.code}}
    system %{plutil -convert xml1 #{localization.strings} -o #{localization.xstrings}}
    UI.abort "Unable to convert #{localization.strings} to XML. Is plutil installed?" unless $?.success?
  end

  next if localization == default_localization

  file localization.strings => default_localization.strings do
    in_root do
      system %{bin/rebase #{localization.code}}
      UI.abort "Unable to rebase #{localization.code}" unless $?.success?
    end
  end
end

task :build => localizations.map {|localization| localization.xstrings }

task :status do
  UI.run_pager

  localizations.each do |localization|
    next if localization == default_localization

    untranslated = []
    localization.data.each {|t| untranslated << t if t.original == t.translated }

    percent_translated = ((localization.data.size-untranslated.size).to_f/localization.data.size*100).to_i
    percent_string = "#{percent_translated}%"

    percent_color = (percent_translated < 50) ? :red :
                    (percent_translated < 90) ? :yellow :
                                                :green

    UI.status %{#{UI.cyan localization.code}: #{UI.color percent_color, "#{percent_string} translated"}#{", remaining:" if untranslated.any?}}

    if untranslated.any?
      UI.puts

      untranslated.each do |t|
        UI.puts t, ''
      end
    end
  end
end

if PMM_ROOT.exist?
  desc "Update the English strings from plex-media-manager"
  task :update do
    Dir.chdir(PMM_ROOT) do
      UI.status "Updating English strings"
      system %{genstrings -o Resources/#{default_localization.code}.lproj -s CPLocalizedString *.j */*.j}
      UI.abort "genstrings failed to run. Is plex-media-manager set up properly with genstrings installed?" unless $?.success?

      Dir.chdir(PMM_ROOT+"Resources/#{default_localization.code}.lproj") do
        system %{iconv -f utf-16 -t utf-8 Localizable.strings > Localizable.strings.utf8 && mv Localizable.strings.utf8 Localizable.strings}
        cp "Localizable.strings", default_localization.strings
      end
    end
  end

  desc "Install the .strings and .xstrings into plex-media-manager"
  task :install => :build do
    resources = PMM_ROOT+'Resources'

    localizations.each do |localization|
      target = resources+"#{localization.code}.lproj"
      target.mkpath

      cp localization.strings, target
      cp localization.xstrings, target
    end
  end
end

task :default => :build

file 'lib/l10n/translation_parser.rb' => 'lib/l10n/translation_parser.rl' do |f|
  UI.status "Generating strings file parser"
  system %{ragel -R #{f.prerequisites.first}}
end

namespace :dev do
  desc "Build the development components required to use this project"
  task :build => 'lib/l10n/translation_parser.rb'
end
