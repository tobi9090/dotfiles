#! usr/bin/bash
username=$(id -u -n 1000)
# slet Test !!!!!!!!!!!
dir_config_src=/home/$username/dotfiles/config
dir_config_dest=/home/$username/.config
filename="$1"
declare -A file_map=(
  ["lazygit"]="$dir_config_dest"
  ["mpv"]="$dir_config_dest"
  ["neofetch"]="$dir_config_dest"
  ["qimgv"]="$dir_config_dest"
  ["yazi"]="$dir_config_dest"
  [".oh-my-bash"]="$dir_config_dest"
  ["alacritty"]="$dir_config_dest"
  ["awesome"]="$dir_config_dest"
  ["btop"]="$dir_config_dest"
  ["nitrogen"]="$dir_config_dest"
  ["nvim"]="$dir_config_dest"
  ["rofi"]="$dir_config_dest"
  ["tmux"]="$dir_config_dest"
  [".bashrc"]="home/$username"
)

update_file() {
  local file="$1"
  if [[ -z "${file_map[$file]}" ]]; then
    echo "File does not exist: $file"
    return 1
  fi

  if [ -e "${dir_config_src}/$file" ]; then
      cp -r "${dir_config_src}/$file" ${file_map[$file]}
      echo "Updated: $file"
  fi

}

update_all() {
  for key in "${!file_map[@]}"; do
    dest=${file_map[$key]}
    if [ -e "${dir_config_src}/$key" ]; then
      cp -r "${dir_config_src}/$key" ${file_map[$key]}
      echo "Updated: $key"
    else
      echo "File does not exist: $key"
    fi
  done
}

case $filename in

  "--all")
    update_all
    ;;

  "--list")
    echo "Available files: ${!file_map[@]}"
    ;;

  *)
    if [[ -n "${file_map[$filename]}" && -e "${dir_config_src}/$filename" ]]; then
      update_file "$filename"
    else
      echo "File does not exist: $filename"
      echo "Available files: ${!file_map[@]}"
    fi
  ;;
esac
