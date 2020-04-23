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

After that, we need domain and record id. Why? Because script request API to compare DNS IP with router current Public IP address.

Check at your domain if there is a record "A" pointing to your home IP. Wait, do you know which IP your ISP is giving you?

## Usage
> Install `curl` package, it could be done via LuCI gui or from ssh.

**First Step**
OpenWRT hasn't git installed, but don't worry.
1. Clone repo:
`git clone git@github.com:andresmazzo/linode-ddns.git`
2. Transfer repo via scp:
`scp -r linode-ddns/ your-username@your-router-ip:/etc/`
3. Connect to router via ssh:
`ssh your-username@your-router-ip`
`cd /etc/linode-ddns`
4. Set config file:
`cp vars.conf.example vars.conf`
5. Make scripts executable:
```
chmod +x linode-ddns.sh
chmod +x scripts/get-public-ip.sh
chmod +x scripts/get-dns-ip.sh
chmod +x scripts/update-dns-ip.sh
```
6. Run script:
`./linode-ddns.sh`

Go to LuCI gui at `http://your-ip`. Login, and go to `Status=>System Log`. Scroll and at the end you should see something..

**Final Step**
I guess you are thinking to automate it. We are not going to set a reminder to exec script every day.

Automatically 3 times per hour i think it's fine.

Use crontab -e, or "Scheduled Tasks" from LuCI, and add the following lines.
```
# Check external IP address, and update Linode's DNS if changed
5,25,45 * * * * /etc/linode-ddns/linode-ddns.sh
```
Your public IP address will be updated no later 20 minutes if it changes!


## Troubleshooting

1. _Did you execute the script and a weird error was printed?_

Relax. See `scripts/` directory and try executing one at a time to verify steps.

---
Thanks and references to: 
- https://baheyeldin.com/articles/technology/linux/using-linode-dynamic-dns-with-openwrt.html
- https://developers.linode.com/api/v4


