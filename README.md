# Haval F7 CarPlay CarLife

> Note: This code is just for testing purposes! If there is any issue with copyright, please let me know and I will remove it.

This code helps you hack the QNX system of Haval F7 and update it so that it supports CarPlay and CarLife.

The CarPlay version is taken from V1.00.13.200714RA.iso.

It only works with QNX system version V1.00.13.200723TAWR.

## How to update?

Before you start, make sure your USB drive is formatted as FAT32.

```bash
tar -czvf install.tar.gz base

cp update.iso /path/to/usb
cp fyupdate.sh /path/to/usb
cp install.tar.gz /path/to/usb
cp qnx-update.confirm /path/to/usb

```
Insert the USB drive and wait for the upgrade screen to appear.

Click the upgrade button only once (you will hear a click).

Wait for the car's system to restart automatically before removing the USB drive.

After the car's system restarts, the update will be completed.

## How to use?

Hold the voice button to switch modes (iPod -> Carbit -> Carlife -> Carplay -> iPod...).

Hold the M button to start the Now mode, and hold it again for 3 seconds to restart.

>Note: This code has not been tested. If you encounter any issues, please let me know.

If you want to restore the system, use the `base` and `fyupdate.sh` files in the `backup` folder.
