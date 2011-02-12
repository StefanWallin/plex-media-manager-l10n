file 'data/xx-chef.lproj/Localizable.strings' do |f|
  Dir.chdir File.expand_path('..', __FILE__) do
    %x{bin/auto-translate xx-chef vendor/chef}
  end
end

file 'data/xx-chef.lproj/Localizable.xstrings' do |f|
  Dir.chdir File.expand_path('../data/xx-chef.lproj', __FILE__) do
    %x{plutil -convert xml1 Localizable.strings -o Localizable.xstrings}
  end
end

langdirs = Dir.glob(File.expand_path('../data', __FILE__)+'/*.lproj')

langdirs.each do |langdir|
  file "#{langdir}/Localizable.xstrings" => "#{langdir}/Localizable.strings" do
    Dir.chdir langdir do
      %x{plutil -convert xml1 Localizable.strings -o Localizable.xstrings}
    end
  end
end

task :default => langdirs.map {|langdir| "#{langdir}/Localizable.xstrings" }