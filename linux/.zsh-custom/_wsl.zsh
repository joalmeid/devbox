# These customizations are only added when running under Windows Subsystem for Linux
# Under WSL, /proc/sys/kernel/osrelease looks something like: 4.4.0-43-Microsoft

if [ -d /proc/sys/kernel ] && grep -q Microsoft /proc/sys/kernel/osrelease; then

  # Aliases
  alias explorer="explorer.exe"
  alias minecraft-server="docker run -d --rm -p 25565:25565 -p 25575:25575 -e EULA=TRUE -e ONLINE_MODE=FALSE -v 'C:\\temp\\minecraftdata':/data itzg/minecraft-server"

  # I should blog more often
  function blog() {
    if type code > /dev/null; then
      pushd ~/code/noelbundick/noelbundick-hugo
      code . </dev/null &>/dev/null & disown
      popd
    fi
  } >/dev/null

  function wslexpose() {
    echo "@echo off\r\nwsl.exe $1 %*" > /mnt/c/tools/wsl/$1.bat
  }

  # Don't 'nice' background jobs (https://github.com/Microsoft/BashOnWindows/issues/1838)
  unsetopt BG_NICE

  # Fire up the socat <-> npiperelay for Docker on launch
  if [[ ! -a /var/run/docker.sock ]]; then
    (sudo docker-relay &)
  fi

  # Use Windows path for Go
  export GOPATH=/mnt/c/code/go

  # Run Linux containers by default
  export DOCKER_DEFAULT_PLATFORM=linux

  # Convert the scratch path on Linux to a Windows path for VS Code
  function scratch-hook() {
    local FILE=$1
    echo $(wslpath -w $(readlink -f $FILE) | sed -e 's/\\/\\\\\\\\/g')
  }

fi
