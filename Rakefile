module VIM
  Dirs = %w[ autoload bundle janus_bundle janus_bundle/janus_themes/colors ]
end

directory "tmp"
VIM::Dirs.each do |dir|
  directory(dir)
end

def vim_plugin_task(name, repo=nil, type=nil)
  cwd = File.expand_path("../", __FILE__)
  dir = File.expand_path("tmp/#{name}")
  bundle_target = File.expand_path("janus_bundle/#{name}")
  subdirs = VIM::Dirs

  namespace(name) do
    if repo
      file dir => "tmp" do
        if repo =~ /git$/
          sh "git clone #{repo} #{dir}"

        elsif repo =~ /download_script/
          if filename = `curl --silent --head #{repo} | grep attachment`[/filename=(.+)/,1]
            filename.strip!
            sh "curl #{repo} > tmp/#{filename}"
          else
            raise ArgumentError, 'unable to determine script type'
          end

        elsif repo =~ /(tar|gz|vba|zip|vim)$/
          filename = File.basename(repo)
          sh "curl #{repo} > tmp/#{filename}"

        else
          raise ArgumentError, 'unrecognized source url for plugin'
        end

        case filename
        when /zip$/
          sh "unzip -o tmp/#{filename} -d #{dir}"

        when /tar\.gz$/
          dirname  = File.basename(filename, '.tar.gz')

          sh "tar zxvf tmp/#{filename}"
          sh "mv #{dirname} #{dir}"

        when /vim(\.gz)?$/
          if filename =~ /gz$/
            sh "gunzip -f tmp/#{filename}"
            filename = File.basename(filename, '.gz')
          end

          if type
            mkdir_p "#{dir}/#{type}"
            sh "mv tmp/#{filename} #{dir}/#{type}/"
          else
            raise ArgumentError, "When downloading a raw vim file, a type (plugin, syntax, etc) must be specified."
          end

        when /vba(\.gz)?$/
          if filename =~ /gz$/
            sh "gunzip -f tmp/#{filename}"
            filename = File.basename(filename, '.gz')
          end

          # TODO: move this into the install task
          mkdir_p dir
          lines = File.readlines("tmp/#{filename}")
          current = lines.shift until current =~ /finish$/ # find finish line

          while current = lines.shift
            # first line is the filename (possibly followed by garbage)
            # some vimballs use win32 style path separators
            path = current[/^(.+?)(\t\[{3}\d)?$/, 1].gsub '\\', '/'

            # then the size of the payload in lines
            current = lines.shift
            num_lines = current[/^(\d+)$/, 1].to_i

            # the data itself
            data = lines.slice!(0, num_lines).join

            # install the data
            Dir.chdir dir do
              mkdir_p File.dirname(path)
              File.open(path, 'w'){ |f| f.write(data) }
            end
          end
        end
      end

      task :pull => dir do
        if repo =~ /git$/
          Dir.chdir dir do
            sh "git pull"
          end
        end
      end

      task :install => [:pull] + subdirs do
        mkdir_p bundle_target
        sh "cp -rf #{dir}/* #{bundle_target}/"
        Dir.chdir bundle_target do
          yield if block_given?
        end
      end
    else
      task :install => subdirs do
        yield if block_given?
      end
    end
  end

  desc "Install #{name} plugin"
  task name do
    puts
    puts "*" * 40
    puts "*#{"Installing #{name}".center(38)}*"
    puts "*" * 40
    puts
    Rake::Task["#{name}:install"].invoke
  end
  task :default => name
end

def skip_vim_plugin(name)
  Rake::Task[:default].prerequisites.delete(name)
end

vim_plugin_task "pathogen.vim" do
  file 'pathogen.vim' => 'autoload' do
    sh "curl https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim > autoload/pathogen.vim"
  end
end

vim_plugin_task "ack.vim",          "git://github.com/mileszs/ack.vim.git"
vim_plugin_task "color-sampler",    "git://github.com/vim-scripts/Color-Sampler-Pack.git"
vim_plugin_task "conque",           "http://conque.googlecode.com/files/conque_1.1.tar.gz"
vim_plugin_task "fugitive",         "git://github.com/tpope/vim-fugitive.git"
vim_plugin_task "git",              "git://github.com/tpope/vim-git.git"
vim_plugin_task "haml",             "git://github.com/tpope/vim-haml.git"
vim_plugin_task "indent_object",    "git://github.com/michaeljsmith/vim-indent-object.git"
vim_plugin_task "javascript",       "git://github.com/pangloss/vim-javascript.git"
vim_plugin_task "jslint",           "git://github.com/hallettj/jslint.vim.git"
vim_plugin_task "nerdtree",         "git://github.com/wycats/nerdtree.git"
vim_plugin_task "nerdcommenter",    "git://github.com/ddollar/nerdcommenter.git"
vim_plugin_task "surround",         "git://github.com/tpope/vim-surround.git"
vim_plugin_task "taglist",          "git://github.com/vim-scripts/taglist.vim.git"
vim_plugin_task "vividchalk",       "git://github.com/tpope/vim-vividchalk.git"
vim_plugin_task "solarized",        "git://github.com/altercation/vim-colors-solarized.git"
vim_plugin_task "supertab",         "git://github.com/ervandew/supertab.git"
vim_plugin_task "cucumber",         "git://github.com/tpope/vim-cucumber.git"
vim_plugin_task "textile",          "git://github.com/timcharper/textile.vim.git"
vim_plugin_task "rails",            "git://github.com/tpope/vim-rails.git"
vim_plugin_task "rspec",            "git://github.com/taq/vim-rspec.git"
vim_plugin_task "zoomwin",          "git://github.com/vim-scripts/ZoomWin.git"
# snipmate is no longer maintained and the replacement project tries to do too much
vim_plugin_task "snipmate",         "git://github.com/mikbe/snipmate.vim.git"
vim_plugin_task "markdown",         "git://github.com/tpope/vim-markdown.git"
vim_plugin_task "align",            "git://github.com/tsaleh/vim-align.git"
vim_plugin_task "unimpaired",       "git://github.com/tpope/vim-unimpaired.git"
vim_plugin_task "searchfold",       "git://github.com/vim-scripts/searchfold.vim.git"
vim_plugin_task "endwise",          "git://github.com/tpope/vim-endwise.git"
vim_plugin_task "irblack",          "git://github.com/wgibbs/vim-irblack.git"
vim_plugin_task "vim-coffee-script","git://github.com/kchmck/vim-coffee-script.git"
vim_plugin_task "syntastic",        "git://github.com/scrooloose/syntastic.git"
vim_plugin_task "puppet",           "git://github.com/ajf/puppet-vim.git"
vim_plugin_task "scala",            "git://github.com/bdd/vim-scala.git"
vim_plugin_task "gist-vim",         "git://github.com/mattn/gist-vim.git"
vim_plugin_task "delimitMate",      "git://github.com/Raimondi/delimitMate.git"
vim_plugin_task "vim-ruby-runner",  "git://github.com/henrik/vim-ruby-runner.git"
vim_plugin_task "L9",               "git://github.com/vim-scripts/L9.git"
vim_plugin_task "FuzzyFinder",      "git://github.com/vim-scripts/FuzzyFinder.git"

vim_plugin_task "command_t",        "http://s3.wincent.com/command-t/releases/command-t-1.2.1.vba" do
  Dir.chdir "ruby/command-t" do
    if File.exists?("/usr/bin/ruby1.8") # prefer 1.8 on *.deb systems
      sh "/usr/bin/ruby1.8 extconf.rb"
    elsif File.exists?("/usr/bin/ruby") # prefer system rubies
      sh "/usr/bin/ruby extconf.rb"
    elsif `rvm > /dev/null 2>&1` && $?.exitstatus == 0
      sh "rvm system ruby extconf.rb"
    end
    sh "make clean && make"
  end
end

vim_plugin_task "janus_themes" do
  # custom version of railscasts theme
  File.open(File.expand_path("../janus_bundle/janus_themes/colors/railscasts+.vim", __FILE__), "w") do |file|
    file.puts <<-VIM.gsub(/^ +/, "").gsub("<SP>", " ")
      runtime colors/railscasts.vim
      let g:colors_name = "railscasts+"

      set fillchars=vert:\\<SP>
      set fillchars=stl:\\<SP>
      set fillchars=stlnc:\\<SP>
      hi  StatusLine guibg=#cccccc guifg=#000000
      hi  VertSplit  guibg=#dddddd
      hi  RubyAccess guifg=#f8f800
    VIM
  end
  public
  # custom version of jellybeans theme
  File.open(File.expand_path("../janus_bundle/janus_themes/colors/jellybeans+.vim", __FILE__), "w") do |file|
    file.puts <<-VIM.gsub(/^      /, "")
      runtime colors/jellybeans.vim
      let g:colors_name = "jellybeans+"

      hi  VertSplit    guibg=#888888
      hi  StatusLine   guibg=#cccccc guifg=#000000
      hi  StatusLineNC guibg=#888888 guifg=#000000
      hi  RubyAccess   guifg=#e8e800
    VIM
  end
end

vim_plugin_task "molokai" do
  sh "curl https://github.com/mrtazz/molokai.vim/raw/master/colors/molokai.vim > janus_bundle/janus_themes/colors/molokai.vim"
end

vim_plugin_task "mustache" do
  FileUtils.mkdir_p "janus_bundle/mustache/syntax"
  FileUtils.mkdir_p "janus_bundle/mustache/ftdetect"

  sh "curl https://github.com/defunkt/mustache/raw/master/contrib/mustache.vim > janus_bundle/mustache/syntax/mustache.vim"

  File.open(File.expand_path('../janus_bundle/mustache/ftdetect/mustache.vim', __FILE__), 'w') do |file|
    file << "au BufNewFile,BufRead *.mustache        setf mustache"
  end
end

vim_plugin_task "arduino","git://github.com/vim-scripts/Arduino-syntax-file.git" do
  FileUtils.mkdir_p "ftdetect"
  File.open(File.expand_path('../janus_bundle/arduino/ftdetect/arduino.vim', __FILE__), 'w') do |file|
    file << "au BufNewFile,BufRead *.pde             setf arduino"
  end
end

vim_plugin_task "vwilight" do
  sh "curl https://gist.github.com/raw/796172/724c7ca237a7f6b8d857c4ac2991cfe5ffb18087/vwilight.vim > janus_bundle/janus_themes/colors/vwilight.vim"
end

import 'janus_load.local' if File.exist?('janus_load.local')

if File.exists?(janus = File.expand_path("~/.janus.rake"))
  puts "Loading your custom rake file"
  import(janus)
end

desc "Update the documentation"
task :update_docs do
  puts "Updating VIM Documentation..."
  system "vim -e -s <<-EOF\n:helptags ~/.vim/doc\n:quit\nEOF"
end

desc "link vimrc to ~/.vimrc"
task :link_vimrc do
  %w[ vimrc gvimrc ].each do |file|
    dest = File.expand_path("~/.#{file}")
    unless File.exist?(dest)
      ln_s(File.expand_path("../#{file}", __FILE__), dest)
    end
  end
end

task :clean do
  rm_r "tmp" if File.exist?('tmp')
  rm_r "janus_bundle" if File.exist?('janus_bundle')
end

desc "Pull the latest"
task :pull do
  system "git pull"
end

task :default => [
  :update_docs,
  :link_vimrc
]

desc "Clear out all build artifacts and rebuild the latest Janus"
task :upgrade => [:clean, :pull, :default]

