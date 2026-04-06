cortex-xdr-formula
==================

A SaltStack formula designed to install and configure the [Cortex XDR](https://docs-cortex.paloaltonetworks.com/p/XDR) client-agent (from [Palo Alto Networks](https://www.paloaltonetworks.com/)) on hosts running an Enterprise Linux (Red Hat, CentOS, Alma, Rocky, etc) or Windows-based operating system.

Note: it has only been end-to-end tested on:

* Windows Server 2022
* RHEL 9 derivatives (specifically Alma Linux 9.7)

It is primarily expected that this formula will be run via [P3](https://www.plus3it.com/)'s "[watchmaker](https://watchmaker.readthedocs.io/en/stable/)" framework.

This formula expects to install the Cortex XDR agent using site-hosted installation files:
* For Linux-based installation-targets, it is further expected that:
    * The installation-RPM will be contained within a GZIP'ed, TAR-file. This file will typically be created throught the Cortex XDR server and made available for install via:
    * The installation-RPM's signing-key will be hosted as a stand-alone file. This file may be a ZIP archive or a bare file (preferably with the file-type suffix `.asc`)
* For Windows-based installation-targets, the installation file will need to be a MicroSoft Installer (MSI) file

These files may be downloaded from:
* An anonymous-fetch HTTP(S) URL
* S3 bucket accessible from installation-target EC2s
* Any other S3-type hosting-source supported by Python's Boto3 module

This formula's actions are configurable throug a SaltStack [pillar](https://docs.saltproject.io/en/latest/topics/tutorials/pillar.html).

## Available States

-   [cortex-xdr](#cortex-xdr)
-   [cortex-xdr.clean](#cortex-xdr.clean)
-   [cortex-xdr.package](#cortex-xdr.package)
-   [cortex-xdr.service](#cortex-xdr.service)

### cortex-xdr

Executes the `package` and `service` states to install and enable the Cortex XDR agent.

### `cortex-xdr.clean`

The `clean` state will remove all Cortex XDR agent components that are managed by this formula.

This capability is only supported on Linux-based targets. Windows-based installations have "anti-tamper" features that prevent uninstallation.

### `cortex-xdr.package`

The `package` state ensures the Cortex XDR agent software is installed.

### `cortex-xdr.service`

The `service` state ensures the Cortex XDR agent service is running and enabled.

## Formula Activation

When enabled through `watchmaker`, the formula-contents will typically be installed at `/srv/watchmaker/salt/formulas/cortex-xdr-formula` on Linux-based installation-targets and `"C:\Watchmaker\Salt\srv\Formulas\cortex-xdr-formula` on Windows-based installation-targets. These contents will then be _activated_ by inclusion in the SaltStack minion configuration-file's `file_roots:base:` configuration-stanza.


## Configuration via Pillar

Linux- and Windows-based installation-targets have different Pillar content-requirements:

* For Linux-base installation-targets, the only _required_ configuration settings are the archive source URL and its source hash, i.e. `package:archive:source` and `package:archive:source_hash`. Those Pillar-keys' values are specific to the environment where this formula is used.
* For Windows-based installation-targets, no configuration settings are required[^1]

All other settings (look through the project sls files for the string `salt.pillar.get`) are optional. The formula sets reasonable, sane defaults for optional settings.

All settings must be located in the Salt Pillar, within the `cortex-xdr:lookup` dictionary. When executed through watchmaker, the typical location for this file will be `/srv/watchmaker/salt/pillar/common/cortex-xdr/init.sls` (Linux) or `C:\Watchmaker\Salt\srv\Pillar\common\cortex-xdr\init.sls` (Windows).

Note: the `pillar.example` file in this project's root-directory contains basic infomation similar to that enumerated in the following sub-sections.


### `cortex-xdr:lookup:enterprise_linux:archive:source`

URL to the Cortex XDR agent archive-file.

>**Required**: `True`

**Example**:

```yaml
---
cortex-xdr:
  lookup:
    enterprise_linux:
      archive:
        source:  https://<ARCHIVE_SERVER_FQDN>/<PATH_TO_ARCHIVE_FILE>
```


### `cortex-xdr:lookup:enterprise_linux:archive:source_hash`

URL to the Cortex XDR agent archive-file's validation hash-file.

>**Required**: `True`

```yaml
---
cortex-xdr:
  lookup:
    enterprise_linux:
      archive:
        source_hash: https://<ARCHIVE_SERVER_FQDN>/<PATH_TO_ARCHIVE_FILE>.SHA256
```

### `cortex-xdr:lookup:enterprise_linux:archive:rpm_name`

Name of the RPM contained within the installation-archive file (Not currently used)

>**Required**: `False`

```yaml
---
cortex-xdr:
  lookup:
    enterprise_linux:
      archive:
        rpm_name: cortex-8.9.0.137291.rpm
```

### `cortex-xdr:lookup:enterprise_linux:service_name`

The systemd service-unit name: this allows overriding the default, `traps_pmd.service` set in the `cortex-xdr/parameters/defaults.yaml` file. This pillar-item is not typically used, currently. It exists mainly to support the eventuality that the product-owners opt to change the name systemd service's unit-name.

>**Required**: `False`

```yaml
---
cortex-xdr:
  lookup:
    enterprise_linux:
      service_name: traps_pmd.service
```

## Standalone Execution

Once the Pillar contents are in place and the formula has been activated, the formula-contents may be executed through `watchmaker` by issuing a command like:

**Linux:**
```bash
# /usr/local/bin/watchmaker \
  --log-level debug \
  --log-dir=/var/log/watchmaker \
  -s cortex-xdr
```

**Windows:**
```
$wamArgs = @(
  "--log-level", "debug",
  "--log-dir=C:\Watchmaker\Logs",
  "-c", "C:/Watchmaker/TEMP/config.yaml",
  "-s", "None",
  "-n"
)

& watchmaker @wamArgs
```
The above makes use of splatting[^2] and the "call" operator, `&`[^3].

It may also be equivalently-executed directly through Saltstack by executing something like:

**Linux:**
```bash
/usr/bin/salt-call \
  --local \
  --retcode-passthrough \
  --no-color \
  --config-dir /opt/watchmaker/salt \
  --log-file /var/log/watchmaker/salt_call.debug.log \
  --log-file-level debug \
  --log-level error \
  --out quiet \
  --return local state.sls cortex-xdr
```

**Windows:**
```
$saltArgs = @(
  "--local",
  "--retcode-passthrough",
  "--no-color",
  "--config-dir", "C:\Watchmaker\Salt\conf",
  "--log-file", "C:\Watchmaker\Logs\salt_call.debug.log",
  "--log-file-level", "debug",
  "--log-level", "error",
  "--out", "quiet",
  "--return",
  "local",
  "state.sls",
  "cortex-xdr"
)
# Run all of the saltstack formulae
& "C:\Program Files\Salt Project\Salt\salt-call.exe" @saltArgs
```

The above is how `watchmaker` invokes it. This invocation method causes the formula's activities to be logged to the `/var/log/watchmaker/salt_call.debug.log` file (Linux) or the `C:\Watchmaker\Logs\salt_call.debug.log` file (Windows).

# Other Configuration/Execution

If not using a watchmaker-based configuration-setup, more-generic, pure-Saltstack configuration and execution will be required. This method is outside the scope of this documentation.

[^1]: The windows-based installer uses SaltStack's [winrepo](https://docs.saltproject.io/en/latest/topics/windows/windows-package-manager.html) capability. This formula expects that something like the [P3 watchmaker-salt-content](https://github.com/plus3it/watchmaker-salt-content) project will be used to properly set up the winrepo content.
[^2]: "Splatting" can provide greater reliability when passing more-complex arguments via PowerShell
[^3]: When invoking through powershell, it's recommended to prefix the command with the `&` "operator" (see: [Vendor DOcumentation](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.5#call-operator-))
