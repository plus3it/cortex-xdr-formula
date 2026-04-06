# Discussion

The following is intended as a quick guide to how to update watchmaker components to support the execution of the Cortex XDR Agent automation. Each "heading" is a relative reference to the file that will need to be updated.


## `.../states/top.sls`:

This file tells watchmaker which formulae to execute. It is divided into a section for each supported `os_family` that can be returned as a SaltStack grain. Currently, only `RedHat` and `Windows` are supported
```yaml
base:
  'G@os_family:RedHat':
    - name-computer
    - scap.content
    - ash-linux.vendor
    - ash-linux.stig
    - ash-linux.iavm
    # Recommend other custom states be inserted here
    - scap.scan
    - cortex-xdr

  'G@os_family:Windows':
    - name-computer
    - pshelp
    - ash-windows.stig
    - ash-windows.iavm
    # Recommend other custom states be inserted here
    - ash-windows.delta
    - scap.scan
    - ash-windows.custom
    - windows-update-agent
    - cortex-xdr
```
To enable this formula's contents to be run when using SaltStack's "high" state, it will be necessary to add:

```yaml
    - cortex-xdr
```

To each `os_family` block (as illustrated above).

## `.../pillar/top.sls`:

This file tells watchmaker which pillar-config files to read into the map of pillar-fetchable infomation. It is divided into a section for each supported `os_family` that can be returned as a SaltStack grain. Currently, only `RedHat` and `Windows` are supported

```yaml
base:
  'G@os_family:RedHat':
    - common.ash-linux
    - common.scap.elx
    - common.opts
    - common.cortex-xdr

  'G@os_family:Windows':
    - common.ash-windows
    - common.netbanner
    - common.scap.windows
    - common.winrepo
    - common.opts
    - common.windows-update-agent
```
To enable this formula's pillar-contents to be read when using SaltStack it will be necessary to add:
```yaml
    - common.cortex-xdr
```
To the `os_family` block for `RedHat`


## `.../pillar/common/winrepo/init.sls`:

This file's contents inform Saltstack's `winrepo` system what "package" names are available and maps versions to installer-locations. Installer-locations may be HTTP(S) or S3 (or equivalent) URIs.

```yaml
scc:
  winrepo:
    versions:
      '5.10':  # example of adding a new version via pillar
        installer: https://watchmaker.cloudarmor.io/repo/spawar/scc/SCC_5.10_Windows_Setup.exe
      '5.7.1':
        installer: https://watchmaker.cloudarmor.io/repo/spawar/scc/SCC_5.7.1_Windows_Setup.exe

cortex-agent:
  winrepo:
    versions:
      '8.8.0.12050':
         installer: 's3://<INSTALLER_REPO_BUCKET>/cortex-xdr/Windows_Agent_Pkg-v88012050._x64.msi'
```

In the above, the `scc:winrepo:versions` content ships with the default project-content for the [`watchmaker-salt-content`](https://github.com/plus3it/watchmaker-salt-content) project. This winrepo content supports the running of the SCC utility on Windows. This content may be replaced, modified or added to. The above shows how to add the `cortex-agent` winrepo content.

The `cortex-agent` token is the key used by the [cortex-xdr/package/win_install.sls](cortex-xdr/package/win_install.sls) to find the corresponding winrepo information. The `versions` key is an object containing the version-number of the Windows Cortex XDR Agent software. The `installer` key is used to tell Saltstack where to download the Cortex XDR Agent's MSI file from.

### Updating

When a new version of the agent is released, the winrepo file will need to be updated. To get the appropriate value for the `versions` and `installer` parameters:

1. Create (as necessary) a new Windows Server host
1. Login to the new Windows Server host as a user with local administrator permissions
1. Install the new Cortex XDR Agent's MSI
1. Open a PowerShell terminal with administrator privileges
1. Use the following powershell command to get the version information from the installed MSI:

    ```powershell
    $paths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )

    Get-ItemProperty $paths |
        Where-Object { $_.DisplayName -like "*Cortex*" } |
        Select-Object DisplayName, DisplayVersion, PSChildName |
        Format-Table -AutoSize
    ```

    This will return output like:

    ```
    DisplayName            DisplayVersion PSChildName
    -----------            -------------- -----------
    Cortex XDR 9.1.0.20768 9.1.0.20768    {65A3EAFF-3926-4858-A5D0-2DD37ED09EF9}

    ```

1. Logout
1. Dispose of the new Windows Server host as appropriate
1. Ready the site's `salt-content.zip` source-files for update.
1. Use the number from the `DisplayVersion` column to add a new version-number key to the `versions` object. Ensure that the new key's `installer` parameter is pointed at the appropriate URI. This will cause the updated content to look like:

    ```yaml
    cortex-agent:
      winrepo:
        versions:
          '8.8.0.12050':
            installer: 's3://<INSTALLER_REPO_BUCKET>/cortex-xdr/Windows_Agent_Pkg-v88012050_x64.msi'
          '9.1.0.20768':
            installer: 's3://<INSTALLER_REPO_BUCKET>/cortex-xdr/Windows_Agent_Pkg-v91020768_x64.msi'
    ```
1. Create a new `salt-content.zip` file
1. Replace the existing `salt-content.zip` file with the new `salt-content.zip` file
