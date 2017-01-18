namespace :go do

  desc "Prints the Go version on the target host"
  task :status do
    on roles(fetch(:go_roles)) do
      info capture(:go, "version")
    end
  end

  task :hook do
    go_install_path = fetch(:go_install_path)
    goroot = fetch(:go_root)
    on roles(fetch(:go_roles)) do
      SSHKit.config.command_map.prefix[:go].unshift "GOROOT=#{go_install_path} GOPATH=#{goroot} PATH=#{go_install_path}/bin:#{goroot}/bin:$PATH"
      fetch(:go_commands_remap).each do |key|
        SSHKit.config.command_map.prefix[key].unshift "GOROOT=#{go_install_path} GOPATH=#{goroot} PATH=#{go_install_path}/bin:#{goroot}/bin:$PATH"
      end
    end
  end

  task :check do
    on roles(fetch(:go_roles)) do
      go_install(fetch(:go_install_path), fetch(:go_version), fetch(:go_source))
      gopath_create(fetch(:go_root))
    end
  end

  task :build do
    on roles(fetch(:go_roles)) do
      goroot = fetch(:go_root)
      pkgpath = fetch(:go_pkg)
      if test "[ -d #{goroot}/src/#{pkgpath} ]"
        execute :rm, "-rf", "#{goroot}/src/#{pkgpath}"
      end
      execute :ln, "-s", release_path, "#{goroot}/src/#{pkgpath}"
      with rack_env: fetch(:rack_env), goroot: fetch(:goroot), path:"#{fetch(:goroot)}/bin:$PATH" do
        within "#{goroot}/src/#{pkgpath}" do
          execute(*fetch(:go_build_cmd))
        end
      end
    end
  end

  def go_install(goroot, version, source)
    if not test "[ -f #{goroot}/bin/go ]"
      info "Downloading #{version}"
      execute :mkdir, "-p", goroot
      execute :curl, "-sSL #{source} | tar xvz --strip-components=1 -C #{goroot}"
    end
  end

  def gopath_create(goroot)
    if not test "[ -d #{goroot} ]"
      info "Create GOROOT folder"
      execute :mkdir, "-p", "#{goroot}/src"
      execute :mkdir, "-p", "#{goroot}/bin"
      execute :mkdir, "-p", "#{goroot}/pkg"
    end
    pkgpath = fetch(:go_pkg).split("/")
    pkgpath.pop
    if not test "[ -d #{goroot}/src/#{pkgpath.join("/")} ]"
      info "Create package folder in GOROOT"
      execute :mkdir, "-p", "#{goroot}/src/#{pkgpath.join("/")}"
    end
  end
end

Capistrano::DSL.stages.each do |stage|
  after stage, 'go:hook'
end
after 'deploy:check', 'go:check'

namespace :load do
  task :defaults do
    set :go_install_path, -> { ::File.join("~/.gos", fetch(:go_version)) }
    set :go_version, "go1.7.4"
    set :go_roles,   :all
    set :go_archive, "https://storage.googleapis.com/golang/VERSION.linux-amd64.tar.gz"

    set :go_root,   -> { ::File.join(shared_path, fetch(:go_version)) }
    set :go_source, -> { fetch(:go_archive).sub("VERSION", fetch(:go_version)) }
    set :go_build_cmd, "go build"
    set :go_commands_remap, []
  end
end
