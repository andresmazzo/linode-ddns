## Introduction
You are looking to implement Dynamic DNS for your cool router which has installed OpenWRT? Continue reading to learn how!

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
I guess we could encapsulate ddns in `/etc/linode-ddns`. Create directory:
`mkdir /etc/linode-ddns`
Copy bash script and config file. Complete vars.
Run script.
Finally, execute cronjob, so script runs automatically 3 times per hour. Use crontab -e, or "Scheduled Tasks" from LuCI, and add the following lines.
```
# Check external IP address, and update Linode's DNS if changed
5,25,45 * * * * /etc/custom/linodedns.sh
```
Your public IP address will be updated no later 20 minutes if it changes!


Thanks and references to: 
- https://baheyeldin.com/articles/technology/linux/using-linode-dynamic-dns-with-openwrt.html
- https://developers.linode.com/api/v4


