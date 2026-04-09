# Windows Tips & Known Issues

Common problems when running the Spark cluster on Windows with Docker Desktop.

---

## Port Binding Errors on Startup

**Symptom:**
```
Error response from daemon: Ports are not available: exposing port TCP 0.0.0.0:8888 -> 0.0.0.0:0:
listen tcp 0.0.0.0:8888: bind: An attempt was made to access a socket in a way forbidden
by its access permissions.
make: *** [Makefile:30: up] Error 1
```

**Cause:**
Windows Hyper-V dynamically reserves port ranges at boot. Ports like `8888`, `8080`,
`7077` frequently fall inside these reserved ranges — even if no process is using them.
`netstat` shows nothing because no process holds the port — Windows itself blocks it.

**Verify:**
```powershell
netsh interface ipv4 show excludedportrange protocol=tcp
```
If any of the cluster ports appear inside a listed range, that is the cause.

**One-time fix (run once as Administrator after each reboot):**
```powershell
net stop winnat
net start winnat
make up
```

**Permanent fix (run once as Administrator — survives reboots):**
```powershell
net stop winnat
netsh int ipv4 add excludedportrange protocol=tcp startport=4040  numberofports=1
netsh int ipv4 add excludedportrange protocol=tcp startport=7077  numberofports=1
netsh int ipv4 add excludedportrange protocol=tcp startport=8080  numberofports=1
netsh int ipv4 add excludedportrange protocol=tcp startport=8081  numberofports=1
netsh int ipv4 add excludedportrange protocol=tcp startport=8082  numberofports=1
netsh int ipv4 add excludedportrange protocol=tcp startport=8888  numberofports=1
netsh int ipv4 add excludedportrange protocol=tcp startport=18080 numberofports=1
net start winnat
```
After this Windows will never reserve these ports again.

---

## entrypoint.sh: Not Executable After git clone

**Symptom:**
```
standard_init_linux.go: exec user process caused: permission denied
```

**Cause:**
Git on Windows does not preserve Unix executable bits (`chmod +x`).

**Fix:**
```powershell
git add --chmod=+x entrypoint.sh
git commit -m "fix: preserve executable bit for entrypoint.sh"
git push
```
The CI workflow also runs `chmod +x entrypoint.sh` automatically before checking.

---

## CRLF Line Endings Breaking entrypoint.sh

**Symptom:**
```
/entrypoint.sh: line 2: $'\r': command not found
```

**Cause:**
Windows Git converts LF to CRLF on checkout. The `\r` character breaks bash.

**Fix (permanent — add to your global git config):**
```powershell
git config --global core.autocrlf input
```
The Dockerfile also runs `sed -i 's/\r//' /entrypoint.sh` as a second line of defence.

---

## Docker Desktop Out of Memory

**Symptom:**
Workers crash shortly after startup. Spark UI shows executors lost.

**Cause:**
Docker Desktop defaults to 2 GB RAM — not enough for master + 2 workers + notebook.

**Fix:**
Docker Desktop → Settings → Resources → Memory → set to at least **6 GB**.
Recommended: 8 GB if available.

---

## Spark UI Not Reachable at localhost:4040

**Symptom:**
Browser shows "connection refused" at `http://localhost:4040`.

**Cause:**
Port 4040 is only open while a Spark job is actively running.
Between jobs the port closes.

**Fix:**
Run any cell in a notebook to start a Spark session, then open `localhost:4040`.
For persistent history, use the History Server at `http://localhost:18080`.

