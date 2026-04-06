## cortex-xdr-formula Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this 
project adheres to [Semantic Versioning](http://semver.org/).

### 1.0.1

**Commit Delta**: Change from 1.0.0 release

**Released**: 2026.03.26

**Summary**:

*   Adds ability to install and configure Cortex XDR Agent for Windows-base
    hosts:
    *   Manages installation of Cortex XDR Agent onto Windows Server hosts.
        Requires:
        *   Rehosting of vendor's MSI-based agent-installer (must be a
            standalone MSI, not a ZIP or other compression-type archive)
        *   Generation and self-hosting of SHA256 checksum file for the rehosted
            Vendor MSI

        Rehosting should be to an http(s) or S3 &mdash; or boto3-compatible
        &mdash; storage service

*   Adds CI-testing for Windows Server operating systems
    *   Windows Server 2019[^*]
    *   Windows Server 2022 (manual end-to-end tested with standard/"official"
        AWS AMIs)
    *   Windows Server 2025[^*]

**Notes**:

*   No "clean" (uninstallation/deconfiguration) option for Windows: the
    software's anti-tampering features generally prevent implementing this
    capability

### 1.0.0

**Commit Delta**: N/A

**Released**: 2025.11.12

**Summary**:

*   Initial release of capability:
    *   Manages installation of Cortex XDR Agent onto Red Hat Enterprise
        Linux and related distros. Requires rehosting of vendor's:
        *   Cortex XDR Agent version. Rehosted agent should be downloaded from
            vendor's site and stored as a TGZ-archive. Archive should contain
            the agent RPM and agent's configuration file
        *   Cortex XDR Agent RPM's signing-key. Rehosted RPM signing-key should
            be a plain text signature file or encapsulated within a ZIP-archive

        Rehosting should be to an http(s) or S3 &mdash; or boto3-compatible
        &mdash; storage service
    *   Manages installtion of Cortex XDR Agent's configuration file and
        associated setting fo SELinux file labels
    *   Ensures that Linux systemd service is running and enabled
    *   Optionally, can ensure clean shutdown and removal of service components.
        When called:
        * Shuts down the `traps_pmd` systemd-managed service
	* Cleans out and removes the `/etc/panw` directory
	* Uninstalls the `cortex-agent` RPM
    *   Adds CI-testing for Red Hat Enterprise Linux 8 and 9 (and related
        distros: Alma, Rocky and Oracle Enterprise Linux)[^**]

[^*]: CI mocking only
[^**]: CI mocking only for all EL8 distros; CI-mocking for EL 9 distros; manual end-to-end testing on Alma Linux 9 (using AWS)
