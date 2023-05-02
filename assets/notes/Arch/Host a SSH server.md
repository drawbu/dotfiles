## On the host

1. Get your IP address (something like 192.168.1.x)
```bash
ip addr
```

2. Install `openssh`
```bash
sudo pacman -Sy openssh
```

3. Allow all clients to use `sshd`
```bash
vim /etc/host.allow
```

```txt
sshd: ALL
```

4. Start `sshd`
```bash
sudo systemctl enable sshd
```

## On the client

Now you just need to connect, and it’s done!
```bash
ssh $USER@$IP
```

`$USER`: The user you want to connect to (ex: `clement` or `root`)
`$IP`: The IP of the machine (ex: `192.168.1.x`)