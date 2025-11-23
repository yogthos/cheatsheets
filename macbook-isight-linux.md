Getting the built-in "FaceTime HD" (iSight) camera to work on a MacBook Pro 12,1 (Early 2015) running Linux is a known challenge.

The reason it doesn't work out of the box is that this specific model uses a proprietary Broadcom PCIe interface (PCI ID `14e4:1570`) rather than a standard USB connection. The standard Linux drivers don't support it, so you must compile a specific driver called `facetimehd`.

Since Zorin OS 18 has not been released yet (the latest is Zorin OS 17), I have provided instructions compatible with **Zorin OS 16 and 17** (and other Ubuntu-based systems).

Here is the step-by-step guide to fixing this.

### Step 1: Install Necessary Tools

First, open your **Terminal** (Ctrl+Alt+T) and install the software needed to build drivers and download files.

```bash
sudo apt update
sudo apt install git curl build-essential linux-headers-$(uname -r) libssl-dev checkinstall kmod
```

### Step 2: Extract the Apple Firmware

The driver needs a proprietary firmware file from Apple to function. You cannot download this file directly; you must use a tool to extract it from an Apple driver update.

1.  Clone the firmware tool repository:

    ```bash
    cd ~/Downloads
    git clone https://github.com/patjak/facetimehd-firmware.git
    ```

2.  Enter the folder and run the extraction tool (this will download the necessary files from the internet automatically):

    ```bash
    cd facetimehd-firmware
    make
    ```

3.  Install the firmware to the correct system folder:

    ```bash
    sudo make install
    ```

### Step 3: Install the Driver (bcwc\_pcie)

Now that the firmware is in place, you need to install the actual driver that talks to the camera.

1.  Go back to your Downloads folder:

    ```bash
    cd ~/Downloads
    ```

2.  Clone the driver repository:

    ```bash
    git clone https://github.com/patjak/bcwc_pcie.git
    ```

3.  Enter the folder, compile, and install:

    ```bash
    cd bcwc_pcie
    make
    sudo make install
    ```

4.  Update your system's module list and load the new driver:

    ```bash
    sudo depmod
    sudo modprobe facetimehd
    ```

### Step 4: Verify It Works

The camera should now be active. You can test it immediately:

1.  Open an app like **Cheese** or **Zoom**.
2.  If it doesn't appear immediately, **restart your computer**.

### Important Note on Updates

Because this is a manual driver installation, **System Updates (Kernel updates)** may break the camera in the future.
If your camera stops working after running an update, simply open your terminal and run these commands again to rebuild the driver for the new kernel:

```bash
cd ~/Downloads/bcwc_pcie
make
sudo make install
sudo modprobe facetimehd
```

### Troubleshooting

If the camera still does not work after a reboot, check if the driver is loaded by running this command:

```bash
lsmod | grep facetimehd
```
