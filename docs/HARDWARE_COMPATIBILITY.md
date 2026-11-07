# Hardware Center — Compatibility and Adapter Strategy

## Goal

Use supported external hardware to turn an Android tablet into a portable network and industrial diagnostics workstation. Support is adapter-, chipset-, Android-build- and tablet-specific.

## Initial adapter families

| Adapter family | Intended use | Key dependency |
|---|---|---|
| USB-C Gigabit Ethernet | Wired LAN tests | Android kernel/interface support and USB host |
| USB-C 2.5GbE | Higher-speed LAN tests | Chipset driver, Android support and app API visibility |
| USB-UART (FTDI/CP210x/CH340) | Serial console | Supported USB serial library/driver and chipset |
| USB-RS232 | Legacy device console | USB-UART chipset and correct electrical interface |
| USB-RS485 | Modbus RTU and field buses | USB serial support, transceiver and bus wiring |
| USB-C hub with PD | Attach multiple peripherals and power | Hub/PD negotiation and tablet power budget |
| USB-CAN | CAN diagnostics | Vendor SDK, driver and supported protocol stack |
| USB WLAN | Advanced Wi-Fi testing | Usually requires chipset/driver/privilege support; not assumed |

## Compatibility states

- **Supported:** enumerated, permission granted, required interface/driver works, protocol test passes on a documented device.
- **Limited:** some functions work; exact limitations are listed.
- **Detected only:** USB identity is visible but no usable transport has been verified.
- **Unsupported:** known incompatibility or missing required driver/API.
- **Unknown:** not yet tested.

Never infer support from vendor/product ID alone.

## Android implementation

- Check USB host feature and API availability.
- Enumerate devices, interfaces and endpoints through Android USB Host APIs.
- Request permission only when the user connects/opens a device.
- Claim/release interfaces safely and handle detach broadcasts.
- Avoid claiming a USB interface already used by another driver.
- Use dedicated libraries or vendor SDKs for serial/CAN/proprietary hardware.
- Keep all blocking reads/writes off the UI thread.
- Handle timeouts, cancellation, disconnect, malformed frames and insufficient power.
- Provide a manual compatibility report: tablet model, Android version/build, adapter vendor/product IDs, chipset, app version and test result.

## Ethernet specifics

Android may use a USB Ethernet adapter at system level without exposing all interface controls to an ordinary app. Validate what can be read on the target device: link state, negotiated speed, interface name, IP configuration, counters and routing. Do not promise packet capture, monitor mode, arbitrary interface configuration or raw Ethernet access unless separately proven.

## Power and physical safety

- Show USB connection and power limitations when known.
- Warn that hubs and power-hungry adapters may need external power.
- Do not connect general-purpose USB adapters directly to mains or hazardous circuits.
- For electrical measurement integrations, require an isolated, purpose-built, rated instrument and a validated manufacturer protocol.
- Clearly identify whether a value is read from Android, an adapter, an external instrument or entered manually.

## Test matrix

For every supported adapter, record:
- tablet model and USB-C/OTG behavior
- Android version and security patch
- adapter manufacturer, model, chipset and VID/PID
- hub/PD arrangement and power source
- permission and attach/detach behavior
- transport/protocol test and observed limitations
- regression result after Android/app updates
