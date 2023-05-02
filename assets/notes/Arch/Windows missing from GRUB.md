## If `os-prober` detect window

> Updated method: 30 April 2023

To check if `os-prober` detect it (as root)
```bash
os-prober
```

Edit as root grub config:
```bash
vim /etc/default/grub
```

Scroll to the bottom and insert
```bash
GRUB_DISABLE_OS_PROBER=false
```
Save and exit

Now run as root
```bash
update-grub
```