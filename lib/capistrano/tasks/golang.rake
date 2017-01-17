namespace :go do

  desc "Prints the Go version on the target host"
  task :status do
    on roles(fetch(:go_roles)) do
      info capture(:go, "version")
    end
  end

  task :hook do
    goroot = fetch(:go_root)
    on roles(fetch(:go_roles)) do
      SSHKit.config.command_map.prefix[:go].unshift "GOROOT=#{goroot} PATH=#{goroot}/bin:$PATH"
    end
  end

  task :check do
    on roles(fetch(:go_roles)) do
      go_install(fetch(:go_root), fetch(:go_version), fetch(:go_source))
    end
  end

  def go_install(goroot, version, source)
    if not test "[ -f #{goroot}/bin/go ]"
      info "Downloading #{version}"
      execute :mkdir, "-p", goroot
      execute :curl, "-sSL #{source} | tar xvz --strip-components=1 -C #{goroot}"
    end
  end

end

Capistrano::DSL.stages.each do |stage|
  after stage, 'go:hook'
end
after 'deploy:check', 'go:check'

namespace :load do
  task :defaults do
    set :go_install_path, "~/.gos"
    set :go_version, "go1.7.4"
    set :go_roles,   :all
    set :go_archive, "https://storage.googleapis.com/golang/VERSION.linux-amd64.tar.gz"

    set :go_root,   -> { File.join(fetch(:go_install_path), fetch(:go_version)) }
    set :go_source, -> { fetch(:go_archive).sub("VERSION", fetch(:go_version)) }
  end
end
