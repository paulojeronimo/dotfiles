cp-to-user() {
  local user=$1; shift
  id "$user" &> /dev/null || {
    echo User \"$user\" not found!
    return 1
  }
  local user_home=$(eval echo "~$user")
  for f in "$@"
  do
    [ -f "$f" ] && {
      sudo cp -LR --parents "$f" "$user_home/"
      sudo chown -R $user: "$user_home/$f"
    } || echo File \"$f\" not found!
  done
}
