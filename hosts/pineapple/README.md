This is a server used exclusivelly for Headscale (custom auth server for Tailscale).

Currently hosted on a Contabo VPS.

Setup guide:
```sh
ssh root@ip_address
# if it works, great, now lets logout

ssh-copy-id root@ip_address
# copy the keys (if we don't we'll be disconnected by the script)

ssh root@ip_address
curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect > nixos-infect.sh
# now remove the `mv -v /boot /boot.bak` thing and only left the right thing (cp -a ..)

cat nixos-infect.sh | NIX_CHANNEL=nixos-23.05 bash -x
# wait for reboot

# install your derivation
# don't forget to set a password for your user/root while you'll logged as root
# as the script remove the root password lol
```
