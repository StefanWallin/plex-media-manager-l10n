require 'pathname'
require File.expand_path('../lib/l10n', __FILE__)

ROOT = Pathname(File.expand_path('..', __FILE__))

def in_root(&block)
  Dir.chdir(ROOT, &block)
end

include L10n

file Localization['xx-chef'].strings => Localization['en'].strings do |f|
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

task :install => :default do
  resources = ROOT.parent+'plex-media-manager/Resources'

  localizations.each do |localization|
    cp localization.strings, resources+"#{localization.code}.lproj/"
    cp localization.xstrings, resources+"#{localization.code}.lproj/"
  end
end