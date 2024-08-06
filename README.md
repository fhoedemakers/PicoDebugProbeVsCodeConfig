# Debugging C++ code on a Raspberry Pi Pico using the Raspberry Pi Pico Debug probe and Visual Studio Code.

Settings.json and launch.json for [Raspberry Pi Pico Debug Probe](https://www.raspberrypi.com/products/debug-probe/) for debugging C++ code on a Raspberry Pi Pico using the Raspberry Pi Pico Debug Probe in combination with Visual Studio Code.

Tested with Ubuntu Ubuntu 24.04 LTS or later.

## In general

Copy settings.json and launch.json from this repository to the .vscode folder of your Raspberrt Pi Pico C++ Project.

Setup de correct udev settings to connect to probe as non-admin user:

```bash
cd ~
wget https://raw.githubusercontent.com/raspberrypi/openocd/rp2040/contrib/60-openocd.rules
sudo mv 60-openocd.rules /etc/udev/rules.d/
```

then restart wsl from a command prompt:

```cmd
wsl --shutdown
wsl
```

## Windows Subsystem for Linux (WSL) 

When using WSL (Windows Subsystem for Linux) with the probe attached to your usb device you need to do these additional steps:

Install usbipd:  [https://learn.microsoft.com/en-us/windows/wsl/connect-usb](https://github.com/dorssel/usbipd-win) Use an admin command prompt.

```
winget install usbipd
```

In an admin command promt:

```cmd
usbipd list
```

```
PS C:\Users\fhoed> usbipd list
Connected:
BUSID  VID:PID    DEVICE                                                        STATE
1-2    1b1c:1b8e  USB-invoerapparaat                                            Not shared
1-5    2e8a:000c  CMSIS-DAP v2 Interface, Serieel USB-apparaat (COM4)           Attached
1-13   048d:8297  USB-invoerapparaat                                            Not shared
1-14   8087:0029  Intel(R) Wireless Bluetooth(R)                                Not shared
6-2    1b1c:0c23  USB-invoerapparaat                                            Not shared
6-3    1b1c:1b62  USB-invoerapparaat                                            Not shared
7-1    1b1c:0c10  USB-invoerapparaat                                            Not shared
11-4   1b1c:0c17  USB-invoerapparaat                                            Not shared
```

Find the line with 'CMSIS-DAP v2 Interface' and issue this command using the bus id from the above command. For this example i use bus id 1-5


```cmd
usbipd bind --busid 1-5
```

In a non-admin normal command prompt, you can attach the device to WSL:

```cmd
usbipd attach --wsl --busid 1-5
```

In WSL, you can use **lsusb** to see if the device is attached:

```bash
lsusb
```

```
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 002: ID 2e8a:000c Raspberry Pi Debug Probe (CMSIS-DAP)
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
```




> [!NOTE]
> Attaching the device in WSL is not persistent. You can use the SetupPicoProbe.bat as a scheduled task executed at login. (Please change the bus id to the one that is correct for your setting)
