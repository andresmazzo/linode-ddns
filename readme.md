## Introduction
You are looking to implement Dynamic DNS to link some cool domain you own to your crazy home? And you have a router with OpenWRT installed? Continue reading to learn how!

There are multiple DDNS Providers with a free option, afraid.org sounds good. But, if you already has a cloud provider who manage your domain, why add one more service? Simplicity is the first rule.

This project implements Linode API V4.

## Requirements
- Linode account
- Router with OpenWRT
- Basic CLI knowledge :P

## Description
Excellent. You have an account. Create a Personal Access Token to be used in Linode API V4.
After that, we need domain and record id. Why? Because script request api to compare dns id with router current id.
Check at your domain if there is a record "A" pointing to your home IP. Wait, do you know which IP your ISP is giving you?

## Usage
> Install `curl` package, it could be done via Luci gui or from ssh.

1. First
OpenWRT hasn't git installed, but don't worry.
Clone repo:
`git clone git@github.com:andresmazzo/linode-ddns.git`
Transfer repo via scp:
`scp -r linode-ddns/ your-username@your-router-ip:/etc/`
Connect to router via ssh:
`ssh your-username@your-router-ip`
`cd /etc/linode-ddns`
Set config file:
`cp vars.conf.example vars.conf`
Make scripts executable:
```
chmod +x linode-ddns.sh
chmod +x scripts/get-public-ip.sh
chmod +x scripts/get-dns-ip.sh
chmod +x scripts/update-dns-ip.sh
```
Run script:
`./linode-ddns.sh`
Go to Luci gui at `http://your-ip`. Login, and go to `Status=>System Log`. Scroll and at the end you should see something..

1. Second
Would be great to automate it, yeah.
Execute cronjob, so script runs automatically 3 times per hour. Use crontab -e, or "Scheduled Tasks" from LuCI, and add the following lines.
```
# Check external IP address, and update Linode's DNS if changed
5,25,45 * * * * /etc/linode-ddns/linode-ddns.sh
```
Your public IP address will be updated no later 20 minutes if it changes!

### Troubleshooting

1. _Did you execute the script and a weird error was printed?_
Relax. See `scripts/` directory and try executing one at a time to verify steps.

---
Thanks and references to: 
- https://baheyeldin.com/articles/technology/linux/using-linode-dynamic-dns-with-openwrt.html
- https://developers.linode.com/api/v4


