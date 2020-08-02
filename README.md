# 📡 docker-direwolf
A multi-platform image for running [Direwolf] for APRS projects

## Installing
### Docker
`docker pull w2bro/direwolf`

### Kubernetes
```shell
helm repo add w2bro https://radio-charts.w2bro.dev
helm install w2bro/direwolf
```

## Environment Variables

| Variable    | Required | Description |
|-------------|-----------|-------------|
| `CALLSIGN`  | Yes | Your callsign & SSID, example `N0CALL-10` |
| `PASSCODE`  | Yes | Passcode for igate login, [find passcode here] |
| `LATITUDE`  | Yes | Latitude for PBEACON, example `42^37.14N` |
| `LONGITUDE` | Yes | Longitude for PBEACON, example `071^20.83W` |
| `COMMENT`   | No  | Override PBEACON default comment, do not use the `~` character |
| `SYMBOL`    | No  | APRS symbol for PBEACON, defaults to `igate` |
| `IGSERVER`  | No  | Override with the APRS server for your region, default for North America `noam.aprs2.net` |
| `ADEVICE`   | No  | Override Direwolf's ADEVICE for digipeater, default is `stdin null` for receive-only igate |
| `FREQUENCY` | No  | Override `rtl_fm` input frequency, default `144.39M` North America APRS |
| `DW_STANDALONE` | No | Set to any value to disable rtl_fm, useful in digipeater applications. Must also set `ADEVICE` |

## Example Usage

### Kubernetes
Example deployment to run on a [k3s] Raspberry Pi node with a RTL-SDR Blog v3 dongle plugged into one of the USB ports

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: aprs-igate
  namespace: ham-radio
spec:
  replicas: 1
  selector:
    matchLabels:
      app: aprs-igate
  template:
    metadata:
      labels:
        app: aprs-igate
    spec:
      nodeName: homelab-pi4b-node-attic-2
      containers:
      - name: direwolf
        image: w2bro/direwolf
        imagePullPolicy: Always
        securityContext:
          privileged: true
        env:
        - name: CALLSIGN
          value: N0CALL-10
        - name: PASSCODE
          value: "12345"
        - name: FREQUENCY
          value: 144.39M
        - name: LATITUDE
          value: 42^37.14N
        - name: LONGITUDE
          value: 071^20.83W
        volumeMounts:
        - mountPath: /dev/bus/usb/001/004
          name: rtl
      volumes:
      - name: rtl
        hostPath:
          path: /dev/bus/usb/001/004
```
[Direwolf]: https://github.com/wb2osz/direwolf
[find passcode here]: https://w2b.ro/tools/aprs-passcode/
[k3s]: https://k3s.io
