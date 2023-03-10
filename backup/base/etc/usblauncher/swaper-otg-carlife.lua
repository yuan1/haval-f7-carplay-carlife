CONFIG_DIR = "/base/etc/usblauncher/";
function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

------------------------------------------------------------------------------

	USB_CLASS_DEVICE = 0x00
	USB_CLASS_AUDIO = 0x01
		USB_AUDIO_PROTOCOL_CONTROL = 0x01
		USB_AUDIO_PROTOCOL_STREAMING = 0x02
		USB_AUDIO_PROTOCOL_MIDI_STREAMING = 0x03
	USB_CLASS_COMMS = 0x02
		USB_COMMS_SUBCLASS_DIRECT_LINE = 0x01
		USB_COMMS_SUBCLASS_MODEM = 0x02
		USB_COMMS_SUBCLASS_TELEPHONE = 0x03
		USB_COMMS_SUBCLASS_MULTICHANNEL = 0x04
		USB_COMMS_SUBCLASS_CAPI_CONTROL = 0x05
		USB_COMMS_SUBCLASS_ETHERNET = 0x06
		USB_COMMS_SUBCLASS_ATM = 0x07
		USB_COMMS_SUBCLASS_WIRELESS_HANDSET = 0x08
		USB_COMMS_SUBCLASS_DEVICE_MGMT = 0x09
		USB_COMMS_SUBCLASS_MOBILE_DIRECT_LINE = 0x0a
		USB_COMMS_SUBCLASS_OBEX = 0x0b
		USB_COMMS_SUBCLASS_NCM  = 0x0d
		USB_COMMS_SUBCLASS_ETHERNET_EMULATION = 0x0c
			USB_COMMS_PROTOCOL_ETHERNET_EMULATION = 0x07
	USB_CLASS_HID = 0x03
		USB_HID_SUBCLASS_NONE = 0x00
			USB_HID_PROTOCOL_NONE = 0x00
			USB_HID_PROTOCOL_KEYBOARD = 0x01
			USB_HID_PROTOCOL_MOUSE = 0x02
		USB_HID_SUBCLASS_BOOTINTERFACE = 0x01
	USB_CLASS_PHYSICAL = 0x05
	USB_CLASS_IMAGING = 0x06
		USB_IMAGING_SUBCLASS_STILL = 0x01
			USB_IMAGING_STILL_PROTOCOL_PTP = 0x01
	USB_CLASS_PRINTER = 0x07
	USB_CLASS_MASS_STORAGE = 0x08
	USB_CLASS_HUB = 0x09
		USB_HUB_PROTOCOL_FULL = 0x00
		USB_HUB_PROTOCOL_HI_SINGLE_TT = 0x01
		USB_HUB_PROTOCOL_HI_MULTIPLE_TT = 0x02
	USB_CLASS_CDC_DATA = 0x0a
	USB_CLASS_SMART_CARD = 0x0b
	USB_CLASS_CONTENT_SECURITY = 0x0d
	USB_CLASS_VIDEO = 0x0e
	USB_CLASS_DIAGNOSTIC = 0xdc
	USB_CLASS_WIRELESS = 0xe0
		USB_WIRELESS_SUBCLASS_RADIO = 0x01
			USB_WIRELESS_PROTOCOL_BLUETOOTH_PI = 0x01
			USB_WIRELESS_PROTOCOL_UWB_RCI = 0x02
			USB_WIRELESS_PROTOCOL_RNDIS = 0x03
		USB_WIRELESS_SUBCLASS_ADAPTER = 0x02
			USB_WIRELESS_PROTOCOL_HOST_WIRE = 0x01
			USB_WIRELESS_PROTOCOL_DEVICE_WIRE = 0x02
			USB_WIRELESS_PROTOCOL_DEVICE_WIRE_ISOCHRONOUS = 0x03
	USB_CLASS_MISC = 0xef
	USB_CLASS_APPSPEC = 0xef
		USB_APPSPEC_SUBCLASS_FIRMWARE_UPDATE = 0x01
			USB_APPSPEC_PROTOCOL_FIRMWARE_UPDATE = 0x01
		USB_APPSPEC_SUBCLASS_IRDA_BRIDGE = 0x02
			USB_APPSPEC_PROTOCOL_IRDA_BRIDGE = 0x00
		USB_APPSPEC_SUBCLASS_TEST_MEASURE = 0x03
			USB_APPSPEC_PROTOCOL_TMC = 0x00
			USB_APPSPEC_PROTOCOL_USB488 = 0x01
	USB_CLASS_VENDOR_SPECIFIC = 0xff

------------------------------------------------------------------------------

peripheral_descriptors = {
	busno = 0,
	devno = 1,
	vendor_id = 0xabcd,
	product_id = 0x4321,
	configuration_name = "Configuration description",
	serial_number = "1234567890ABC",
	device_class = 0x00, -- Independent per interface
	device_subclass = 0,
	device_protocol = 0,
	max_packet_size0 = 64,
	manufacturer = "Manufacturer name",
	product = "Product name",
	interfaces = {
		{
			interface_class = USB_CLASS_MASS_STORAGE,
			interface_subclass = 0,
			interface_protocol = 0,
			interface_name = "Mass storage interface",
		},
		{
			interface_class = USB_CLASS_COMMS,
			interface_subclass = USB_COMMS_SUBCLASS_NCM,
			interface_protocol = 0,
			interface_name = "NCM interface",
		},
		{
			interface_class = USB_CLASS_HID,
			interface_subclass = 0x0,
			interface_protocol = 0,
			interface_name = "HID interface",
		}
	},
};

Host_Stack = {
	cmd  = 'io-usb -c -d ehci-mx28 ioport=0x02184100,irq=75,phy=0x020c9000';
	path = '/dev/io-usb/io-usb';
}

dofile '/etc/usblauncher/iap2.lua'
dofile '/etc/usblauncher/iap2ncm.lua'
dofile '/etc/usblauncher/umass.lua'

Device_Stack = {
	cmd  = 'io-usb-dcd -d mx6sabrelite-ci ioport=0x02184000,irq=75,vbus_enable';
	path = '/dev/io-usb/io-usb-dcd';
	descriptors = { iap2, iap2ncm, umass };
	-- The time, in milliseconds, to wait for the iPod acting as USB host to configure
	-- the QNX target. The timeout only applies to the RoleSwap_AppleDevice and
	-- RoleSwap_DigitaliPodOut use cases where the iPod is the USB host.
	timeout = 2000;
	-- The number of times to try accessing Device_Stack.path before giving up.
	connect_tries = 60;
	-- The time, in milliseconds, to wait before trying again when Device_Stack.path is not yet ready.
	-- Decreasing the polling delay can speed up completion of starting the Device_Stack.
	connect_poll = 1000;
}

-- peripheral
device(peripheral_descriptors.vendor_id, peripheral_descriptors.product_id) {
	class(USB_CLASS_MASS_STORAGE) {
		driver"devu-umass_client-block -s /dev/io-usb/io-usb-dcd  -l lun=0,devno=1,iface=0,fname=/dev/hd1";
	};
	class(USB_CLASS_COMMS, USB_COMMS_SUBCLASS_NCM) {
		start"echo Communications interface $(iface)";
	};
	class(USB_CLASS_HID) {
		start"echo HID interface $(iface)";
	}
}

-- To use only when the iPod is the USB host (after USB role swapping)
device(0x1234, 0xfff1) { -- these should match the USB descriptors presented to the USB host, the iPod
	class(USB_CLASS_VENDOR_SPECIFIC, 0xF0, 0x0) {
-- you may need to change the i2c addr= and path= to match your particular board configuration
		--driver"mm-ipod -d iap2,config=/etc/mm/iap2.cfg,probe,ppsdir=/pps/services/multimedia/iap2 -a i2c,addr=0x11,path=/dev/i2c4,speed=32000,variant20c -t usbdevice,path=/dev/io-usb/io-usb-dcd -l /dev/shmem/iap2.log -vvvvvv";
		--start "/base/etc/usblauncher/setup_carplay.sh";
		
		start "/base/fyapps/bins/setup_carlife.sh";
		removal"/base/fyapps/bins/clear_carlife.sh";
	};
-- To use only when the iPhone is the USB host for CarPlay (DigitaliPodOut)
	class(USB_CLASS_COMMS, USB_COMMS_SUBCLASS_NCM, 0x00) {
		--start"echo need to mount devnp-usbdnet.so";
		--removal"echo need to destroy ncm interface";
        start"/etc/usblauncher/startncm.sh";
		removal"/etc/usblauncher/stopncm.sh";
	}
}

device(0x1234, 0xfff2) { -- these should match the USB descriptors presented to the USB host, the iPod
	class(USB_CLASS_VENDOR_SPECIFIC, 0xF0, 0x0) {
-- you may need to change the i2c addr= and path= to match your particular board configuration
		--driver"mm-ipod -d iap2,config=/etc/mm/iap2.cfg,probe,ppsdir=/pps/services/multimedia/iap2 -a i2c,addr=0x11,path=/dev/i2c4,speed=32000,variant20c -t usbdevice,path=/dev/io-usb/io-usb-dcd -l /dev/shmem/iap2.log -vvvvvv";
		--start "/base/etc/usblauncher/setup_carplay.sh";
		
		start "/base/fyapps/bins/setup_carlife.sh";
		removal"/base/fyapps/bins/clear_carlife.sh";
	};
-- To use only when the iPhone is the USB host for CarPlay (DigitaliPodOut)
	class(USB_CLASS_COMMS, USB_COMMS_SUBCLASS_NCM, 0x00) {
		--start"echo need to mount devnp-usbdnet.so";
		--removal"echo need to destroy ncm interface";
        start"/etc/usblauncher/startncm.sh";
		removal"/etc/usblauncher/stopncm.sh";
	}
}
skip_devices = {
    device(0x0424, 0xec00);
    device(0x0eef, 0x0001);  -- eGalax Inc. USB TouchController
    device(0x0e0f, 0x0003)
}

foreach (skip_devices) {
    Ignore;  -- don't even attach to these devices
}

char_devices = {
    device(0x0557, 0x2008);  -- ATEN_232A/GUC_232A
    device(0x2478, 0x2008);  -- TRIPP LITE U2009-000-R
    device(0x9710, 0x7720);  -- MOSCHIP 7720
    device(0x0403, 0x6001);  -- FTDI 8U232AM
    device(0x1199, 0x0120);  -- Sierra AirCard U595
    device(0x0681, 0x0040);  -- Siemens HC25
    device(0x1bc7, 0x1003);  -- Telit UC864E
    device(0x067b, 0x2303);  -- Prolific
}

foreach (char_devices) {
    driver"devc-serusb -d vid=$(vendor_id),did=$(product_id),busno=$(busno),devno=$(devno)";
}

-- basic options for devb-umass
DISK_OPTS  = "cam cache,quiet blk cache=1m,vnode=384,auto=none,delwri=2:2,rmvto=none,noatime disk name=umass cdrom name=umasscd";
--UMASS_OPTS = "umass priority=21";
UMASS_OPTS = "umass path=/dev/io-usb/io-usb,priority=21";

UMASS_OVERRIDES_FILE = CONFIG_DIR .. "umass.lua";
if file_exists(UMASS_OVERRIDES_FILE) then
	print("usblauncher: Including umass overrides in " .. UMASS_OVERRIDES_FILE);
	dofile (UMASS_OVERRIDES_FILE);
end

-- table of specific MSC devices that can't handle Microsoft descriptor queries
-- By specifying the vid/did, the rule is tried before any generic rules
known_msc = {
	device(0x0781, 0x5567);	-- SanDisk Cruzer Blade
}

foreach (known_msc) {
	driver"devb-umass $(DISK_OPTS) $(UMASS_OPTS),vid=$(vendor_id),did=$(product_id),busno=$(busno),devno=$(devno),iface=$(iface),ign_remove";
}

-- QNX Apple Interface
device(0x05fc, 0xff01) {
    driver"i2c-qui --u99";
};
-- USB Test Mode
product(0x1A0A, 0x0104) {
	start "/base/etc/usblauncher/usb_test_mode.sh";
}


-- iPod

product(0x05AC, 0x1200, 0x12FF) {
--    RoleSwap_DigitaliPodOut;
	RoleSwap_AppleDevice;
--    iAP2;
--    Probe_iAP2;
    class(USB_CLASS_AUDIO, USB_AUDIO_PROTOCOL_CONTROL) {
--        inc_usr_spec_id = unique"/fs/ipod";  -- does rsrcdbmgr_devno_attach
        driver"io-audio -dipod busno=$(busno),devno=$(devno),cap_name=ipod-$(busno)-$(devno)";
    };
    class(USB_CLASS_HID) {
--      driver"io-fs-media -dipod,transport=usb:busno=$(busno):devno=$(devno):audio=/dev/snd/ipod-$(busno)-$(devno),darates=+8000:11025:12000:16000:22050:24000,playback,acp=i2c:addr=0x11:path=/dev/i2c99,fnames=short,config=/etc/mm/ipod.cfg,stalk=500";
--      driver"io-fs-media -dipod,transport=usb:busno=$(busno):devno=$(devno):audio=/dev/snd/ipod-$(busno)-$(devno),darates=+8000:11025:12000:16000:22050:24000,playback,acp=i2c:addr=0x11:path=/dev/i2c4:speed=32000:variant20c,fnames=short,config=/etc/mm/ipod.cfg,stalk";
        custom = function(obj)
	    -- you may need to change the i2c addr= and path= to match your particular board configuration
	    if obj.EXTRA and obj.EXTRA:find('iap::2') then
	        -- for iAP2
		-- return "mm-ipod -diap2,config=/etc/mm/iap2_ipod.cfg,probe,ppsdir=/pps/services/multimedia/iap2-$(busno)-$(devno) -ai2c,addr=0x11,path=/dev/i2c4,speed=32000,variant20c -tusbhost,busno=$(busno),devno=$(devno),path=/dev/io-usb/io-usb,audio=/dev/snd/ipod-$(busno)-$(devno)";
		--return "echo this is apple devices which support iAP2";
		else
		-- for iAP1
		-- return "io-fs-media -dipod,pps=/pps/services/multimedia/iap1-$(busno)-$(devno),transport=usb:busno=$(busno):devno=$(devno):path=/dev/io-usb/io-usb:audio=/dev/snd/ipod-$(busno)-$(devno),darates=+8000:11025:12000:16000:22050:24000,playback,acp=i2c:addr=0x11:path=/dev/i2c4:speed=32000:variant20c,fnames=short,config=/etc/mm/ipod.cfg";
		--return "/base/fyapps/bins/closemodule";
		--return "mm-ipod -diap2,config=/etc/mm/iap2_ipod.cfg,ppsdir=/pps/services/multimedia/iap2-$(busno)-$(devno) -ai2c,addr=0x11,path=/dev/i2c4,speed=32000,variant20c -tusbhost,busno=$(busno),devno=$(devno),path=/dev/io-usb/io-usb,audio=/dev/snd/ipod-$(busno)-$(devno)";
	    end
	end;
	driver"$(custom)";
    };
    class(USB_CLASS_AUDIO, USB_AUDIO_PROTOCOL_STREAMING) {
	    Ignore;
    };
};


--
-- generic MTP rule should proceed generic MSC (mass storage) rule so that it is tried first.
--
-- generic MTP rule

device() {
    ms_desc("MTP") {
        driver"io-fs-media -dpfs,device=$(busno):$(devno):$(iface)";
    };
};

-- generic mass storage rule

device() {
    class(USB_CLASS_MASS_STORAGE) {
        driver"devb-umass $(DISK_OPTS) $(UMASS_OPTS),vid=$(vendor_id),did=$(product_id),busno=$(busno),devno=$(devno),iface=$(iface),ign_remove,mpoll=250:40";
    };
};

-- MirrorLink NCM device rule

device() {
    class(USB_CLASS_COMMS, USB_COMMS_SUBCLASS_NCM) {
        driver"/scripts/vncdiscovery/usb-device-attached.sh $(vendor_id) $(product_id) $(busno) $(devno)";
    };
};

------------------------------------------------------------------------------

if verbose >= 3 then
    table.dump(new_conf)
    table.dump(new_conf.flags)
    show_config()
end

